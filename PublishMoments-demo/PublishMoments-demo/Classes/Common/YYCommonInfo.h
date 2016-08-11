//
//  YYCommonInfo.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#ifndef YYCommonInfo_h
#define YYCommonInfo_h

/***** 最大照片数 *****/
#define MAXPICTURECOUNT  9 

/***** 自定义字体 *****/
#define CustomFontName(s) [UIFont fontWithName:@"Monaco" size:s]

/***** 自定义颜色 *****/
#define ColorFromHexStr(hexStr) ColorFromHexAlpha(hexStr, 1)
#define ColorFromHexAlpha(hexStr,a) [UIColor colorWithHexString:(hexStr) alpha:(a)]
#define ColorFromRGB(r, g, b) ColorFromRGBA(r, g, b, 1)
#define ColorFromRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define ColorFromRandom [UIColor colorWithRed:((arc4random()%256)/255.0) green:((arc4random()%256)/255.0) blue:((arc4random()%256)/255.0) alpha:1]

#endif /* YYCommonInfo_h */
