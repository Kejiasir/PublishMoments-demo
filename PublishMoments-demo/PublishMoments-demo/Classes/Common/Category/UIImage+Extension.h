//
//  UIImage+Extension.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/10.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)compressSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
