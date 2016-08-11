//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoNavigationViewController.h"
#import "MLSelectPhotoPickerGroupViewController.h"
#import "MLSelectPhotoCommon.h"
#import "MLSelectPhotoAssets.h"

@interface MLSelectPhotoPickerViewController ()
@property (nonatomic , weak) MLSelectPhotoPickerGroupViewController *groupVc;
@end

@implementation MLSelectPhotoPickerViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}

#pragma mark - init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self createNavigationController];
    }
    return self;
}

- (void)createNavigationController {
    MLSelectPhotoPickerGroupViewController *groupVc = [[MLSelectPhotoPickerGroupViewController alloc] init];
    MLSelectPhotoNavigationViewController *nav = [[MLSelectPhotoNavigationViewController alloc] initWithRootViewController:groupVc];
    nav.view.frame = self.view.bounds;
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    self.groupVc = groupVc;
}

#pragma mark - Setter方法
- (void)setSelectPickers:(NSArray *)selectPickers {
    _selectPickers = selectPickers;
    self.groupVc.selectAsstes = selectPickers;
}

- (void)setStatus:(PickerViewShowStatus)status {
    _status = status;
    self.groupVc.status = status;
}

- (void)setMaxCount:(NSInteger)maxCount {
    if (maxCount <= 0) return;
    _maxCount = maxCount;
    self.groupVc.maxCount = maxCount;
}

- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker {
    _topShowPhotoPicker = topShowPhotoPicker;
    self.groupVc.topShowPhotoPicker = topShowPhotoPicker;
}

- (void)setDelegate:(id<ZLPhotoPickerViewControllerDelegate>)delegate{
    _delegate = delegate;
    self.groupVc.delegate = delegate;
}

#pragma mark - 展示控制器
- (void)showPickerVc:(UIViewController *)vc {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        [weakVc presentViewController:self animated:YES completion:nil];
    }
}

#pragma mark - 通过传入一个图片对象（MLSelectPhotoAssets/ALAsset）获取一张缩略图
+ (UIImage *)getImageWithObj:(id)imageObj {
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    } else if ([imageObj isKindOfClass:[ALAsset class]]){
        @autoreleasepool {
            ALAsset *asset = (ALAsset *)imageObj;
            return [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        }
    } else if ([imageObj isKindOfClass:[MLSelectPhotoAssets class]]){
        return [imageObj originImage];
    }
    return image;
}

#pragma mark - 添加通知
- (void)addNotification{
    // 监听异步done通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:PICKER_TAKE_DONE object:nil];
    });
}

#pragma mark - 监听通知
- (void)done:(NSNotification *)note {
    NSArray *selectArray =  note.userInfo[@"selectAssets"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(pickerViewControllerDoneAsstes:)]) {
            [self.delegate pickerViewControllerDoneAsstes:selectArray];
        } else if (self.callBack) {
            self.callBack(selectArray);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
