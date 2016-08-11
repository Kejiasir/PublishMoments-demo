//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  ZLPhotoPickerAssetsViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-12.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoPickerGroup.h"
#import "MLSelectPhotoPickerDatas.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoPickerCollectionView.h"
#import "MLSelectPhotoPickerCollectionViewCell.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "UIView+MLExtension.h"
#import "MLSelectPhotoPickerFooterCollectionReusableView.h"

static CGFloat CELL_ROW         = 4;  // 每行照片数
static CGFloat CELL_MARGIN      = 4;  // 照片列间距
static CGFloat CELL_LINE_MARGIN = 3;  // 照片行间距
static CGFloat TOOLBAR_HEIGHT   = 44; // toolbar高度

static NSString *const _cellIdentifier = @"cell";
static NSString *const _footerIdentifier = @"FooterView";
static NSString *const _identifier = @"toolBarThumbCollectionViewCell";

#define DoneBtnTitle [NSString stringWithFormat:@"完成(%zd)",count]

@interface MLSelectPhotoPickerAssetsViewController ()
<ZLPhotoPickerCollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIButton *previewBtn;
// Datas
@property (assign, nonatomic) NSUInteger privateTempMaxCount;
// 记录选中的assets
@property (strong, nonatomic) NSMutableArray *selectAssets;
@property (nonatomic, strong) MLSelectPhotoPickerCollectionView *collectionView;

@end

@implementation MLSelectPhotoPickerAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.bounds = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化按钮
    [self setupButtons];
    // 初始化底部ToorBar
    [self setupToorBar];
    // 添加通知
    [self addNotificaticon];
}

#pragma mark - 初始化底部ToorBar
- (void)setupToorBar {
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 左视图 中间弹簧 右视图
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.previewBtn];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    toorBar.items = @[leftItem,fiexItem,rightItem];
}

#pragma mark - Setter方法
-(void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    if (!_privateTempMaxCount) {
        if (maxCount) {
            _privateTempMaxCount = maxCount;
        } else {
            _privateTempMaxCount = KPhotoShowMaxCount;
        }
    }
    if (self.selectAssets.count == maxCount){
        maxCount = 0;
    } else if (self.selectPickerAssets.count - self.selectAssets.count > 0) {
        maxCount = _privateTempMaxCount;
    }
    if (!maxCount && !self.selectAssets.count) {
        maxCount = KPhotoShowMaxCount;
    }
    self.collectionView.maxCount = maxCount;
}

- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker {
    _topShowPhotoPicker = topShowPhotoPicker;
    if (topShowPhotoPicker) {
        NSMutableArray *reSortArray= [[NSMutableArray alloc] init];
        for (id obj in [self.collectionView.dataArray reverseObjectEnumerator]) {
            [reSortArray addObject:obj];
        }
        MLSelectPhotoAssets *mlAsset = [[MLSelectPhotoAssets alloc] init];
        [reSortArray insertObject:mlAsset atIndex:0];
        self.collectionView.status = ZLPickerCollectionViewShowOrderStatusTimeAsc;
        self.collectionView.topShowPhotoPicker = topShowPhotoPicker;
        self.collectionView.dataArray = reSortArray;
        [self.collectionView reloadData];
    }
}

- (void)setAssetsGroup:(MLSelectPhotoPickerGroup *)assetsGroup {
    if (!assetsGroup.groupName.length) return;
    _assetsGroup = assetsGroup;
    self.title = assetsGroup.groupName;
    // 获取Assets
    [self setupAssets];
}

- (void)setSelectPickerAssets:(NSArray *)selectPickerAssets {
    // 去掉重复的Piker
    NSSet *set = [NSSet setWithArray:selectPickerAssets];
    _selectPickerAssets = [set allObjects];
    for (MLSelectPhotoAssets *assets in selectPickerAssets) {
        if ([assets isKindOfClass:[MLSelectPhotoAssets class]]) {
            [self.selectAssets addObject:assets];
        }
    }
    self.collectionView.lastDataArray = nil;
    self.collectionView.isRecoderSelectPicker = YES;
    self.collectionView.selectAsstes = self.selectAssets;
    self.collectionView.doneAsstes = self.selectAssets;
    NSInteger count = self.selectAssets.count;
    if(count > 0) {
        [self.doneBtn setTitle:DoneBtnTitle forState:UIControlStateNormal];
    }
    self.doneBtn.enabled = (count > 0);
    self.previewBtn.enabled = (count > 0);
}

#pragma mark - 初始化所有的组
- (void)setupAssets {
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray *assetsM = [NSMutableArray array];
    [[MLSelectPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            MLSelectPhotoAssets *zlAsset = [MLSelectPhotoAssets photoAssetsWithAsset:asset];
            [assetsM addObject:zlAsset];
        }];
        weakSelf.collectionView.dataArray = assetsM;
    }];
}

#pragma mark - 预览照片
// 预览选中的照片
- (void)preview {
    MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
    [browserVc setValue:@(YES) forKeyPath:@"isEditing"];
    browserVc.maxCount = self.collectionView.maxCount;
    browserVc.photos = self.selectAssets;
    browserVc.doneAssets = self.selectAssets;
    [self.navigationController pushViewController:browserVc animated:YES];
}

#pragma mark - 添加通知
- (void)addNotificaticon {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:PICKER_REFRESH_DONE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preview:) name:PICKER_PUSH_BROWSERPHOTO object:nil];
}

#pragma mark - 监听通知
- (void)refresh:(NSNotification *)noti {
    self.selectAssets = noti.userInfo[@"assets"];
    [self.collectionView.selectsIndexPath removeAllObjects];
    self.collectionView.selectAsstes = noti.userInfo[@"assets"];
    self.collectionView.doneAsstes = noti.userInfo[@"assets"];
    [self.collectionView reloadData];
    
    NSInteger count = 0;
    if (self.collectionView.selectAsstes.count < self.selectAssets.count) {
        count = self.collectionView.selectAsstes.count;
    } else {
        count = self.selectAssets.count;
    }
    [self.doneBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
    if(count > 0) {
        [self.doneBtn setTitle:DoneBtnTitle forState:UIControlStateNormal];
    }
    self.doneBtn.enabled = (count > 0);
    self.previewBtn.enabled = (count > 0);
}

// 预览所有的照片
- (void)preview:(NSNotification *)noti {
    MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
    browserVc.maxCount = self.collectionView.maxCount;
    browserVc.currentPage = [noti.userInfo[@"currentPage"] integerValue];
    [browserVc setValue:@(YES) forKeyPath:@"isEditing"];
    browserVc.photos = self.collectionView.dataArray;
    browserVc.doneAssets = noti.userInfo[@"selectAssets"];
    [self.navigationController pushViewController:browserVc animated:YES];
}

#pragma mark - ZLPhotoPickerCollectionViewDelegate
// 选择相片时会触发
- (void)pickerCollectionViewDidSelected:(MLSelectPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(MLSelectPhotoAssets *)deleteAssets {
    if (self.selectPickerAssets.count == 0) {
        self.selectAssets = [NSMutableArray arrayWithArray:pickerCollectionView.selectAsstes];
    } else if (deleteAssets == nil){
        [self.selectAssets addObject:[pickerCollectionView.selectAsstes lastObject]];
    }
    
    if (self.selectPickerAssets.count || deleteAssets) {
        MLSelectPhotoAssets *asset = [pickerCollectionView.lastDataArray lastObject];
        if (deleteAssets){
            asset = deleteAssets;
        }
        
        NSInteger selectAssetsCurrentPage = -1;
        NSInteger count = self.selectAssets.count;
        for (NSInteger i = 0; i < count; i++) {
            MLSelectPhotoAssets *photoAsset = self.selectAssets[i];
            if([[[[asset.asset defaultRepresentation] url] absoluteString] isEqualToString:[[[photoAsset.asset defaultRepresentation] url] absoluteString]]){
                selectAssetsCurrentPage = i;
                break;
            }
        }
        if ((count > selectAssetsCurrentPage) && (selectAssetsCurrentPage >= 0)) {
            if (deleteAssets) {
                [self.selectAssets removeObjectAtIndex:selectAssetsCurrentPage];
            }
            [self.collectionView.selectsIndexPath removeObject:@(selectAssetsCurrentPage)];
            [self.doneBtn setTitle:DoneBtnTitle forState:UIControlStateNormal];
        }
        // 刷新下最小的页数
        self.maxCount = self.selectAssets.count + (_privateTempMaxCount - self.selectAssets.count);
        [self.doneBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
        if(count > 0) {
            [self.doneBtn setTitle:DoneBtnTitle forState:UIControlStateNormal];
        }
        self.doneBtn.enabled = (self.selectAssets.count > 0);
        self.previewBtn.enabled = (self.selectAssets.count > 0);
    } else {
        NSInteger count = 0;
        if (pickerCollectionView.selectAsstes.count < self.selectAssets.count) {
            count = pickerCollectionView.selectAsstes.count;
        } else {
            count = self.selectAssets.count;
        }
        if(count > 0) {
            [self.doneBtn setTitle:DoneBtnTitle forState:UIControlStateNormal];
        }
        self.doneBtn.enabled = (count > 0);
        self.previewBtn.enabled = (count > 0);
    }
}

#pragma mark - ZLPhotoPickerCollectionViewDelegate
// 点击拍照就会调用
- (void)pickerCollectionViewDidCameraSelect:(MLSelectPhotoPickerCollectionView *)pickerCollectionView {
    if (self.selectAssets.count >= KPhotoShowMaxCount) {
        [self.view showMessageWithText:[NSString stringWithFormat:@"选择的相片不能大于%zd张",KPhotoShowMaxCount]];
        return ;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
        ctrl.delegate = self;
        ctrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ctrl animated:YES completion:nil];
    } else {
        NSLog(@"请在真机使用!");
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 处理
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        [self.selectAssets addObject:image];
        NSInteger count = self.selectAssets.count;
        if(count > 0) {
            [self.doneBtn setTitle:DoneBtnTitle forState:UIControlStateNormal];
        }
        self.previewBtn.enabled = (count > 0);
        self.doneBtn.enabled = (count > 0);
        
        // 刷新当前相册
        if (isCameraAutoSavePhoto) {
            if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                NSLog(@"MLSelectPhoto : 保存成功");
            }else{
                NSLog(@"MLSelectPhoto : 没有用户权限,保存失败");
            }
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"请在真机使用!");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 开启异步通知
- (void)done {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.selectAssets}];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (MLSelectPhotoPickerCollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat cellW = (self.view.w - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(self.view.w, TOOLBAR_HEIGHT);
        
        MLSelectPhotoPickerCollectionView *collectionView = [[MLSelectPhotoPickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        // 照片时间状态(升序/降序)
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        collectionView.status = ZLPickerCollectionViewShowOrderStatusTimeAsc;
        [collectionView registerClass:[MLSelectPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        // 底部显示照片数的View
        //[collectionView registerClass:[MLSelectPhotoPickerFooterCollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier];

        collectionView.contentInset = UIEdgeInsetsMake(CELL_LINE_MARGIN, 0, -40, 0);
        collectionView.collectionViewDelegate = self;
        [self.view insertSubview:collectionView belowSubview:self.toolBar];
        self.collectionView = collectionView;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
        // 水平方向约束
        NSString *widthVfl = @"H:|-3-[collectionView]-3-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
        // 垂直方向约束
        NSString *heightVfl = @"V:|-0-[collectionView]-44-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
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

- (UIButton *)previewBtn {
    if (!_previewBtn) {
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        previewBtn.enabled = YES;
        previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        previewBtn.frame = CGRectMake(0, 0, 45, 45);
        [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [previewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
        self.previewBtn = previewBtn;
    }
    return _previewBtn;
}

- (NSMutableArray *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}

#pragma mark 初始化按钮
- (void)setupButtons {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

#pragma mark -
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 赋值给上一个控制器
    self.groupVc.selectAsstes = self.selectAssets;
}

@end
