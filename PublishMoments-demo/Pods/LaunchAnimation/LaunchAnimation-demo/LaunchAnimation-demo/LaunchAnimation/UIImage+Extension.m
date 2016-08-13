//
//  UIImage+Extension.m
//  LaunchAnimation-demo
//
//  Created by Arvin on 16/8/12.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)getLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait"; // Horizontal "Landscape"
    NSString *launchImage = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

+ (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect {
    CGRect clipFrame = rect;
    CGImageRef refImage = CGImageCreateWithImageInRect(image.CGImage, clipFrame);
    UIImage *newImage = [UIImage imageWithCGImage:refImage];
    CGImageRelease(refImage);
    return newImage;
}

@end
