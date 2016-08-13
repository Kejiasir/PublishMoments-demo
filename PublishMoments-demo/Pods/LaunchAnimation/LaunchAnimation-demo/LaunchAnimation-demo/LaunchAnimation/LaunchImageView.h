//
//  LaunchImageView.h
//  LaunchAnimation-demo
//
//  Created by Arvin on 16/8/12.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnimationType) {
    AnimationTypeUpAndDown,
    AnimationTypeLeftAndRight,
    AnimationTypeUpDownAndLeftRight
};

@interface LaunchImageView : UIView
/**
 *  initialization method
 *
 *  @param frame          setting frame
 *  @param aAnimationType animation type
 *  @param aDuration      animation duration
 *
 *  @return return current object
 */
- (instancetype)initWithFrame:(CGRect)frame
                animationType:(AnimationType)aAnimationType
                     duration:(CGFloat)aDuration;
@end
