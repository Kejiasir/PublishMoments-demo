//
//  YYEditViewController.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYEditViewController.h"
#import "YYTextView.h"
#import "YYPhotosView.h"
#import "YYBottomView.h"
#import <AssetsLibrary/ALAsset.h>
#import <AVFoundation/AVFoundation.h>
#import "MLSelectPhotoBrowserViewController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"

@interface YYEditViewController ()<UIScrollViewDelegate,UITextViewDelegate,UIAlertViewDelegate,YYPhotosViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) YYTextView   *textView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YYPhotosView *photosView;
@property (nonatomic, strong) YYBottomView *bottomView;
//@property (nonatomic, assign) NSInteger imgHeight;
@end

@implementation YYEditViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithTitle:@"Cancel" target:self action:@selector(cancelBtnClick)];
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithTitle:@"Send" target:self action:@selector(sendBtnClick)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard) name:hideKeyboardNotification object:nil];
    [self setupSubView];
}

- (void)setupSubView {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.photosView];
    [self.scrollView addSubview:self.bottomView];
}

- (void)hideKeyboard {
    [self.textView endEditing:YES];
}

//- (void)setPhotoArray:(NSMutableArray *)photoArray {
//    _photoArray = photoArray;
//    NSLog(@"%@",photoArray);
//}

#pragma mark -
- (void)sendBtnClick {
    UIImage *compressImg = nil;
    for (NSInteger i = 0; i < [self.photoArray count]; i++) {
        NSData *imageData = UIImageJPEGRepresentation(self.photoArray[i], 0.5);
        UIImage *newImage = [UIImage imageWithData:imageData];
        compressImg = [UIImage compressSourceImage:newImage
                                       targetWidth:[UIScreen mainScreen].bounds.size.width];
        NSLog(@"压缩比例前:%@",newImage);
        NSLog(@"压缩比例后:%@",compressImg);
    }
    // 上传服务器
    // 完成后移除数组的所有Object
    //[self.photoArray removeAllObjects];
    [self.view showMessageWithText:@"send"];
}

- (void)cancelBtnClick {
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"Discard the changes?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Leave", nil] show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self.textView isFirstResponder]) {
            [self.textView endEditing:YES];
        }
        [self.photoArray removeAllObjects];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[_textView class]]) {
        //[self.textView becomeFirstResponder];
    } else {
        [self.textView endEditing:YES];
    }
}

#pragma mark - viewWillLayoutSubviews
- (void)viewWillLayoutSubviews {
    [self.photosView setFrame:
     CGRectMake(0, CGRectGetMaxY(_textView.frame), self.view.w, _photosView.imageMaxHeight + 8)];
    [self.bottomView setNeedsLayout];
    [self.bottomView setFrame:CGRectMake(0, CGRectGetMaxY(_photosView.frame), self.view.w, 154.5)];
    if (![self.photoArray count]) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}

#pragma mark - YYPhotosViewDelegate
//- (void)photosViewWithImageMaxHeight:(NSInteger)imgHeight {
//    if (![self.photoArray count]) {
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    } else {
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//    }
//    if (self.imgHeight != imgHeight) {
//        [self.photosView setFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), self.view.w, imgHeight+8)];
//    }
//    self.imgHeight = imgHeight;
//}

- (void)photosView:(YYPhotosView *)photosView withImgCount:(NSInteger)imgCount {
    if ([self.textView isFirstResponder]) {
        [self.textView endEditing:YES];
    }
    [[[YYActionSheet alloc] initWithTitle:nil clickedAtIndex:^(NSInteger index) {
        if (index == 0) {
            [self photoPick:index imgCount:0];
        } else if (index == 1) {
            [self photoPick:index imgCount:imgCount];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择",nil] show];
}

- (void)photoPick:(NSInteger)index imgCount:(NSInteger)imgCount {
    if (index == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (![self checkCamera]) {
                [[[UIAlertView alloc] initWithTitle:@"相机不可用"
                                            message:@"请在 设置 -> 隐私 -> 相机 中开启权限"
                                           delegate:self
                                  cancelButtonTitle:@"我知道了"
                                  otherButtonTitles:nil] show];
            } else {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                [picker setDelegate:self];
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    } else if (index == 1) {
        __weak typeof(self) weakSelf = self;
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        [pickerVc setMaxCount:MAXPICTURECOUNT - imgCount];
        [pickerVc setStatus:PickerViewShowStatusCameraRoll];
        [pickerVc showPickerVc:self];
        [pickerVc setCallBack:^(NSArray *assets) {
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *photo = [MLSelectPhotoPickerViewController getImageWithObj:asset];
                [weakSelf.photoArray addObject:photo];
                [weakSelf.photosView addImages:weakSelf.photoArray];
            }];
        }];
    }
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
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.photoArray addObject:image];
            [self.photosView addImages:self.photoArray];
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

- (void)bottomViewBtnClick:(NSInteger)type {
    if (type == BtnTypeLocation) {
        [self.view showMessageWithText:@"location"];
    } else if (type == BtnTypeMention) {
        [self.view showMessageWithText:@"mention"];
    } else if (type == BtnTypeWhoLook) {
        [self.view showMessageWithText:@"wholook"];
    }
}

#pragma mark -
- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        [_textView setFrame:CGRectMake(0, 0, self.view.w, 110)];
        _textView.placeHolder = @"Say something...";
        _textView.textColor = ColorFromRGB(51, 51, 51);
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placeHolderColor = [UIColor lightGrayColor];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 3, 0, 0);
        _textView.alwaysBounceVertical = YES;
        [_textView becomeFirstResponder];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = ColorFromRGB(245, 245, 245);
        [_scrollView setFrame:CGRectMake(0, 0, self.view.w, self.view.h)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.view.w, self.view.h);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (YYPhotosView *)photosView {
    if (!_photosView) {
        _photosView = [[YYPhotosView alloc] init];
        _photosView.delegate = self;
        _photosView.imgCountRow = 4;
        _photosView.backgroundColor = [UIColor whiteColor];
        [_photosView setFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), self.view.w, 0)];
        [_photosView addImages:self.photoArray];
    }
    return _photosView;
}

- (YYBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [YYBottomView bottomView];
        __weak typeof(self) weakSele = self;
        _bottomView.block = ^(NSInteger type) {
            [weakSele bottomViewBtnClick:type];
        };
        //NSLog(@"%@",NSStringFromCGRect(_photosView.frame));
    }
    return _bottomView;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
