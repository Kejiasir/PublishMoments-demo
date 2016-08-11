//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  ZLAssets.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-3.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "MLSelectPhotoAssets.h"

@interface MLSelectPhotoAssets ()
/**
 *  自己定义的Image，拍照可以用
 */
@property (strong,nonatomic) UIImage *customImage;
@property (strong,nonatomic) ALAsset *asset;
@end

@implementation MLSelectPhotoAssets

+ (instancetype)photoAssetsWithImage:(UIImage *)image{
    if (![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    MLSelectPhotoAssets *photoAsset = [[MLSelectPhotoAssets alloc] init];
    photoAsset.customImage = image;
    return photoAsset;
}

+ (instancetype)photoAssetsWithAsset:(ALAsset *)asset{
    if (![asset isKindOfClass:[ALAsset class]]) {
        return nil;
    }
    
    MLSelectPhotoAssets *photoAsset = [[MLSelectPhotoAssets alloc] init];
    photoAsset.asset = asset;
    return photoAsset;
}

- (UIImage *)thumbImage{
    return self.customImage ?: [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
}

- (UIImage *)originImage{
    return self.customImage ?: [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
}

- (BOOL)isVideoType{
    if (self.customImage) {
        return NO;
    }
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

- (NSURL *)assetURL{
    if (self.customImage) {
        return nil;
    }
    return [[self.asset defaultRepresentation] url];
}

@end
