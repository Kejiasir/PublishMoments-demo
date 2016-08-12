//
//  YYBottomView.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/5.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClick)(UIButton *button);

typedef NS_ENUM(NSUInteger, BtnType) {
    BtnTypeLocation,
    BtnTypeMention,
    BtnTypeWhoLook
};

@interface YYBottomView : UIView
+ (instancetype)bottomView;
@property (nonatomic, copy) btnClick block;
@end
