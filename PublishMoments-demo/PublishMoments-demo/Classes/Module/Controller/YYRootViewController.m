//
//  YYRootViewController.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYRootViewController.h"
#import "YYEditViewController.h"
#import "YYNavigationController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AVFoundation/AVFoundation.h>
#import "MLSelectPhotoBrowserViewController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"

@interface YYRootViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation YYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Moments";
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *fixedSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -10;
    UIBarButtonItem *rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithNormalImg:@"fav_fileicon_pic90"
                                 HighlightedImg:@"fav_fileicon_pic90"
                                         target:self
                                         action:@selector(rightBarButtonClick)];
    [self.navigationItem setRightBarButtonItems:@[fixedSpace,rightBarButtonItem]];
}

- (void)rightBarButtonClick {
    [[[YYActionSheet alloc] initWithTitle:nil clickedAtIndex:^(NSInteger index) {
        if (index == 0) {
            [self.view showMessageWithText:@"哈哈哈,没有小视频"];
        } else if (index == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                if (![self checkCamera]) {
                    [[[UIAlertView alloc] initWithTitle:@"相机不可用"
                                                message:@"请在 设置 -> 隐私 -> 相机 中开启权限"
                                               delegate:self
                                      cancelButtonTitle:@"我知道了"
                                      otherButtonTitles:nil] show];
                } else {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [picker setDelegate:self];
                    //[picker setAllowsEditing:YES];
                    [self presentViewController:picker animated:YES completion:nil];
                }
            }
        } else if (index == 2) {
            if (![self checkPhotoLibrary]) {
                [[[UIAlertView alloc] initWithTitle:@"相册不可用"
                                            message:@"请在 设置 -> 隐私 -> 相片 中开启权限"
                                           delegate:self
                                  cancelButtonTitle:@"我知道了"
                                  otherButtonTitles:nil] show];
            } else {
                MLSelectPhotoPickerViewController *pickerVc = [MLSelectPhotoPickerViewController new];
                [pickerVc setMaxCount:MAXPICTURECOUNT];
                [pickerVc setStatus:PickerViewShowStatusCameraRoll];
                [pickerVc showPickerVc:self];
                __weak typeof(self) weakSelf = self;
                [pickerVc setCallBack:^(NSArray *assets) {
                    [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                        UIImage *photo = [MLSelectPhotoPickerViewController getImageWithObj:asset];
                        [weakSelf.photos addObject:photo];
                    }];
                    [weakSelf presentViewController];
                }];
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"小视频",@"拍照",@"从手机相册选择",nil] show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        NSString *imageType = picker.allowsEditing?
    UIImagePickerControllerEditedImage:
        UIImagePickerControllerOriginalImage;
        UIImage *image = [info objectForKey:imageType];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            [self.photos addObject:image];
        }
        __weak typeof(self) weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf presentViewController];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// 保存图片到相册中
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存成功");
    }
}

#pragma mark -
- (BOOL)checkCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted || authorStatus == AVAuthorizationStatusDenied) {
        // 相机不可用
        return NO;
    }
    return YES;
}

- (BOOL)checkPhotoLibrary {
    //ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    switch ([ALAssetsLibrary authorizationStatus]) {
        case ALAuthorizationStatusNotDetermined: // 用户尚未作出关于此应用程序的选择
        case ALAuthorizationStatusRestricted:    // 此应用无法访问照片数据,如家长限制
        case ALAuthorizationStatusDenied:        // 用户已拒绝此应用访问相册数据
            break;
        case ALAuthorizationStatusAuthorized:    // 用户已授权该应用可以访问照片数据
            return YES;
    }
    return NO;
}

- (void)presentViewController {
    __weak typeof(self) weakSelf = self;
    YYEditViewController *editVC = [[YYEditViewController alloc] init];
    editVC.photoArray = weakSelf.photos;
    YYNavigationController *navigationVC = [[YYNavigationController alloc] initWithRootViewController:editVC];
    [weakSelf presentViewController:navigationVC animated:YES completion:^{
    }];
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

@end
