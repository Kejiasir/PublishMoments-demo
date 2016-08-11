//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  ZLPhotoPickerAssetsViewController.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-12.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSelectPhotoCommon.h"
#import "MLSelectPhotoPickerGroupViewController.h"

@class MLSelectPhotoPickerGroup;
@interface MLSelectPhotoPickerAssetsViewController : UIViewController

@property (nonatomic, assign) NSInteger maxCount;
// 置顶展示图片
@property (assign, nonatomic) BOOL topShowPhotoPicker;
// 需要记录选中的值的数据
@property (strong, nonatomic) NSArray *selectPickerAssets;
@property (nonatomic, assign) PickerViewShowStatus status;
@property (nonatomic, strong) MLSelectPhotoPickerGroup *assetsGroup;
@property (weak, nonatomic) MLSelectPhotoPickerGroupViewController *groupVc;

@end
