//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  MLSelectPhotoBrowserViewController.m
//  MLSelectPhoto
//
//  Created by 张磊 on 15/4/23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "MLSelectPhotoBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+MLExtension.h"
#import "MLSelectPhotoPickerBrowserPhotoScrollView.h"
#import "MLSelectPhotoCommon.h"
#import "UIImage+MLTint.h"

// 分页控制器的高度
static NSInteger ZLPickerColletionViewPadding = 10;
static NSString *_cellIdentifier = @"collectionViewCell";

@interface MLSelectPhotoBrowserViewController ()
<UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UIButton *deleleBtn;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIToolbar *toolBar;

// 是否是编辑模式
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isShowShowSheet;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *deletePhotos;
@property (strong, nonatomic) NSMutableDictionary *deleteAssets;

@end

@implementation MLSelectPhotoBrowserViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_REFRESH_DONE object:nil userInfo:@{@"assets":self.doneAssets}];
    self.navigationController.navigationBar.hidden = NO;
    self.toolBar.hidden = NO;
}

#pragma mark - Setter方法
- (void)setDoneAssets:(NSMutableArray *)doneAssets {
    _doneAssets = doneAssets;
    [self refreshAsset];
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    _deletePhotos = photos.mutableCopy;
    [self reloadData];
}

- (void)setSheet:(UIActionSheet *)sheet {
    _sheet = sheet;
    if (!sheet) {
        self.isShowShowSheet = NO;
    }
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    if (isEditing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleleBtn];
    }
}

- (void)setPageLabelPage:(NSInteger)page {
    self.title = [NSString stringWithFormat:@"%zd / %zd",page + 1, self.deletePhotos.count];
}

#pragma mark - 初始化底部ToorBar
- (void)setupToorBar {
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.barTintColor = UIColorFromRGB(0xF9F9F9); // 0x333333
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    // 底部ToorBar约束
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 弹簧视图 右视图
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    toorBar.items = @[fiexItem,rightItem];
}

#pragma mark -
- (void)refreshAsset {
    for (NSInteger i = 0; i < self.photos.count; i++) {
        MLSelectPhotoAssets *asset = [self.photos objectAtIndex:i];
        if ([self.doneAssets containsObject:asset]) {
            [self.deleteAssets setObject:@(YES) forKey:[NSString stringWithFormat:@"%zd",i]];
        }
    }
    NSInteger count = self.doneAssets.count;
    [self.doneBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
    if(count > 0) {
        [self.doneBtn setTitle:[NSString stringWithFormat:@"完成(%zd)",count] forState:UIControlStateNormal];
    }
    self.doneBtn.enabled = (count > 0);
    if([[self.deleteAssets allValues] count] == 0 || [self.deleteAssets valueForKeyPath:[NSString stringWithFormat:@"%ld",(self.currentPage)]] == nil){
        [self.deleleBtn setImage:[[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked")] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
    } else {
        [self.deleleBtn setImage:[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked") ] forState:UIControlStateNormal];
    }
}

- (void)deleteAsset {
    NSString *currentPage = [NSString stringWithFormat:@"%ld",self.currentPage];
    if (!(self.deletePhotos.count > self.currentPage)) {
        return;
    }
    NSUInteger maxCount = (self.maxCount < 0) ? KPhotoShowMaxCount : self.maxCount;
    if([[self.deleteAssets allValues] count] == 0 || [self.deleteAssets valueForKeyPath:[NSString stringWithFormat:@"%ld",(self.currentPage)]] == nil){
        if (self.doneAssets.count >= self.maxCount) {
            [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%zd张相片",maxCount] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
            return ;
        }
        [self.deleteAssets setObject:@(YES) forKey:currentPage];
        [self.deleleBtn setImage:[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked") ] forState:UIControlStateNormal];
        [self.doneAssets addObject:[self.deletePhotos objectAtIndex:self.currentPage]];
    } else {
        [self.doneAssets removeObject:[self.deletePhotos objectAtIndex:self.currentPage]];
        [self.deleleBtn setImage:[[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked") ] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [self.deleteAssets removeObjectForKey:currentPage];
    }
    NSInteger count = self.doneAssets.count;
    [self.doneBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
    if (count > 0) {
        [self.doneBtn setTitle:[NSString stringWithFormat:@"完成(%zd)",count] forState:UIControlStateNormal];
    }
    self.doneBtn.enabled = (count > 0);
}

#pragma mark - reloadData
- (void)reloadData {
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, self.collectionView.contentOffset.y);
    // 添加自定义View
    [self setPageLabelPage:self.currentPage];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if (self.photos.count) {
        cell.backgroundColor = [UIColor clearColor];
        MLSelectPhotoAssets *photo = self.deletePhotos[indexPath.item];
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        MLSelectPhotoPickerBrowserPhotoScrollView *scrollView =  [[MLSelectPhotoPickerBrowserPhotoScrollView alloc] init];
        if (self.sheet || self.isShowShowSheet == YES) {
            scrollView.sheet = self.sheet;
        }
        scrollView.backgroundColor = [UIColor clearColor];
        // 为了监听单击photoView事件
        scrollView.frame = [UIScreen mainScreen].bounds;
        scrollView.photoScrollViewDelegate = self;
        scrollView.photo = photo;
        [cell.contentView addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return cell;
}

#pragma mark - MLSelectPhotoPickerBrowserPhotoScrollView
// 单击图片时触发
- (void)pickerPhotoScrollViewDidSingleClick:(MLSelectPhotoPickerBrowserPhotoScrollView *)photoScrollView {
    [self.view setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    //[UIView animateWithDuration:0.25 animations:^{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
    if (self.isEditing) {
        self.toolBar.hidden = !self.toolBar.isHidden;
    }
    //}];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.ml_width) + 0.5);
    if([[self.deleteAssets allValues] count] == 0 || [self.deleteAssets valueForKeyPath:[NSString stringWithFormat:@"%zd",(currentPage)]] == nil){
        [self.deleleBtn setImage:[[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked")] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
    } else {
        [self.deleleBtn setImage:[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked") ] forState:UIControlStateNormal];
    }
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];
}

#pragma mark - Action
- (void)done {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.doneAssets}];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.view.ml_size.width + ZLPickerColletionViewPadding, self.view.ml_size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.ml_width + ZLPickerColletionViewPadding,self.view.ml_height) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-ZLPickerColletionViewPadding)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        if (self.isEditing) {
            // 初始化底部ToorBar
            [self setupToorBar];
        }
    }
    return _collectionView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
        rightBtn.layer.cornerRadius = 5.0f;
        rightBtn.layer.masksToBounds = YES;
        rightBtn.frame = CGRectMake(0, 0, 64, 32);
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [rightBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:ColorFromRGBA(255, 255, 255, 0.6) forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UIButton *)deleleBtn {
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setImage:[[UIImage imageNamed:MLSelectPhotoSrcName(@"AssetsPickerChecked")] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
        deleleBtn.frame = CGRectMake(0, 0, 30, 30);
        [deleleBtn addTarget:self action:@selector(deleteAsset) forControlEvents:UIControlEventTouchUpInside];
        self.deleleBtn = deleleBtn;
    }
    return _deleleBtn;
}

- (NSMutableDictionary *)deleteAssets {
    if (!_deleteAssets) {
        _deleteAssets = [NSMutableDictionary dictionary];
    }
    return _deleteAssets;
}

#pragma mark -
- (void)dealloc {
    self.isShowShowSheet = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
