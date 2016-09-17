//
//  UIButton+Extension.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/9/7.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@interface UIButton ()
@property (nonatomic, copy) void (^btnBlock) (UIButton *button);
@end

@implementation UIButton (Extension)

- (void)setBtnBlock:(void (^)(UIButton *))btnBlock {
    objc_setAssociatedObject(self, @selector(btnBlock), btnBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *))btnBlock {
    return objc_getAssociatedObject(self, @selector(btnBlock));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(btnBlock1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnBlock1:(UIButton *)button {
    if (self.btnBlock) {
        self.btnBlock(button);
    }
}

@end
