//
//  UIBarButtonItem+Extension.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  @param title      按钮标题
 *  @param titleColor 标题颜色
 *  @param target     按钮响应目标
 *  @param action     按钮响应事件
 *  @return 返回自定义的barButtonItem
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title
                            titleColor:(UIColor *)titleColor
                                target:(id)target
                                action:(SEL)action;
/**
 *  @param normalImg      正常的按钮图片
 *  @param highlightedImg 高亮的按钮图片
 *  @param target         按钮响应目标
 *  @param action         按钮响应事件
 *  @return 返回自定义的barButtonItem
 */
+ (instancetype)barButtonItemWithNormalImg:(NSString *)normalImg
                            HighlightedImg:(NSString *)highlightedImg
                                    target:(id)target
                                    action:(SEL)action;
@end
