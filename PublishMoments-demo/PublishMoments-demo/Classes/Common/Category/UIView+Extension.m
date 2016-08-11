//
//  UIView+Extension.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x {
    CGRect org = self.frame;
    org.origin.x = x;
    self.frame = org;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect org = self.frame;
    org.origin.y = y;
    self.frame  = org;
}
- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setW:(CGFloat)w {
    CGRect frm = self.frame;
    frm.size.width = w;
    self.frame = frm;
}
- (CGFloat)w {
    return self.size.width;
}

- (void)setH:(CGFloat)h {
    CGRect frm = self.frame;
    frm.size.height = h;
    self.frame = frm;
}
- (CGFloat)h {
    return self.size.height;
}

- (void)setSize:(CGSize)size {
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}
- (CGSize)size {
    return self.bounds.size;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY {
    return self.center.y;
}

- (void)showMessageWithText:(NSString *)text {
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.text = text;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.frame = CGRectMake(0, 0, 100, 80);
    [alertLabel sizeToFit];
    alertLabel.w += 50;
    alertLabel.h = 50;
    alertLabel.x = (self.w - alertLabel.w) * 0.5;
    alertLabel.y = (self.h - alertLabel.h) * 0.5;
    alertLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0];
    alertLabel.layer.cornerRadius = 10.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:alertLabel];
    
    [UIView animateWithDuration:1.5 animations:^{
        alertLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [alertLabel removeFromSuperview];
    }];
}

@end
