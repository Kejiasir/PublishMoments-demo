//
//  YYConfigured.h
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#ifndef YYConfigured_h
#define YYConfigured_h

/// YYInfiniteLoopViewCell 重用标识符
static NSString *const CellIdentifier = @"LayoutCellIdentifier";
/// RGB颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f \
                                           green:(g)/255.0f \
                                            blue:(b)/255.0f \
                                           alpha:(a)]
#define RGBCOLOR(r,g,b) RGBACOLOR(r, g, b, 1.0f)

#endif /* YYConfigured_h */
