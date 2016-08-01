//
//  YYCommonInfo.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#ifndef YYCommonInfo_h
#define YYCommonInfo_h

/***** 屏幕宽高 *****/
#define Screen_Width [UIScreen mainScreen] bounds].size.width;
#define Screen_Height [UIScreen mainScreen] bounds].size.height;

/***** 颜色相关 *****/
#define ColorFromHexStr(hexStr) ColorFromHexAlpha(hexStr, 1)
#define ColorFromHexAlpha(hexStr,a) [UIColor colorWithHexString:(hexStr) alpha:(a)]
#define ColorFromRGB(r, g, b) ColorFromRGBA(r, g, b, 1)
#define ColorFromRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define ColorFromRandom [UIColor colorWithRed:((arc4random()%256)/255.0) green:((arc4random()%256)/255.0) blue:((arc4random()%256)/255.0) alpha:1]

/***** 自定义字体 *****/
#define CustomFontName(s) [UIFont fontWithName:@"Monaco" size:s]

#endif /* YYCommonInfo_h */
