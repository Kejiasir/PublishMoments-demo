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
#import "YYInfiniteLoopView.h"
#import "YYTestViewController.h"

@interface YYRootViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *titles;
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
    [self addLoopView];
}

#pragma mark -
- (void)addLoopView {
    YYInfiniteLoopView *loopView = [[YYInfiniteLoopView alloc]
                                    initWithImageUrls:self.imageUrls
                                    titles:self.titles
                                    didSelectedImage:^(NSInteger index) {
                                        [self didSelectedImageWithIndex:index];
                                    }];
    [loopView setPageIndicatorColor:[UIColor orangeColor]];
    [loopView setCurrentPageIndicatorColor:[UIColor magentaColor]];
    [loopView setFrame:CGRectMake(0, 0, self.view.w, self.view.h * 0.35)];
    [self.tableView setTableHeaderView:loopView];
}

- (void)didSelectedImageWithIndex:(NSInteger)index {
    YYTestViewController *testVC = [[YYTestViewController alloc] init];
    UIColor *bgColor = nil;
    switch (index) {
            case 0:
            testVC.title = @"第一张图";
            bgColor = [UIColor orangeColor];
            break;
            case 1:
            testVC.title = @"第二张图";
            bgColor = [UIColor brownColor];
            break;
            case 2:
            testVC.title = @"第三张图";
            bgColor = [UIColor greenColor];
            break;
            case 3:
            testVC.title = @"第四张图";
            bgColor = [UIColor magentaColor];
            break;
        default:
            testVC.title = @"testVC";
            bgColor = [UIColor whiteColor];
            break;
    }
    testVC.view.backgroundColor = bgColor;
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark -
- (void)rightBarButtonClick {
    [[[YYActionSheet alloc] initWithTitle:nil clickedAtIndex:^(NSInteger index) {
        if (index == 0) {
            [self.view showMessageWithText:@"hahaha, No Sight"];
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
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sight",@"Take Photo",@"Choose from Photos",nil] show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        NSString *imageType = picker.allowsEditing?
    UIImagePickerControllerEditedImage:
        UIImagePickerControllerOriginalImage;
        UIImage *image = [UIImage fixOrientation:[info objectForKey:imageType]];
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


// 保存照片到相册中
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存照片成功");
    }
}

#pragma mark -
- (BOOL)checkCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)checkPhotoLibrary {
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    if (authorStatus == ALAuthorizationStatusNotDetermined ||
        authorStatus == ALAuthorizationStatusRestricted ||
        authorStatus == ALAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
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

- (NSArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = @[@"http://img2.91.com/uploads/allimg/150106/59-1501061H225-53.jpg",
                       @"http://img1.91.com/uploads/allimg/150106/59-1501061GR6-51.jpg",
                       @"http://img2.91.com/uploads/allimg/150319/59-1503191P412-50.jpg",
                       @"http://img3.91.com/uploads/allimg/150304/59-1503041S553-50.jpg",
                       @"http://img1.91.com/uploads/allimg/150304/59-1503041SS0.jpg"];
    }
    return _imageUrls;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"第一张图, ( ⊙ o ⊙ )啊！O(∩_∩)O哈哈~",
                    @"第二张图, ( ⊙ o ⊙ )啊！O(∩_∩)O哈哈~",
                    @"第三张图, ( ⊙ o ⊙ )啊！O(∩_∩)O哈哈~",
                    @"第四张图, ( ⊙ o ⊙ )啊！O(∩_∩)O哈哈~",
                    @"第五张图, ( ⊙ o ⊙ )啊！O(∩_∩)O哈哈~"];
    }
    return _titles;
}
@end
