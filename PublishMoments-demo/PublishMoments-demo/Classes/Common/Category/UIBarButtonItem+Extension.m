//
//  UIBarButtonItem+Extension.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)barButtonItemWithNormalImg:(NSString *)normalImg HighlightedImg:(NSString *)highlightedImg target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.backgroundColor = [UIColor greenColor];
    UIImage *norImage = [UIImage imageNamed:normalImg];
    [button setImage:norImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImg] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = CGRectMake(0, 0, norImage.size.width, norImage.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
