//
//  UIImage+Extension.h
//  LaunchAnimation-demo
//
//  Created by Arvin on 16/8/12.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)getLaunchImage;
+ (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect;
@end
