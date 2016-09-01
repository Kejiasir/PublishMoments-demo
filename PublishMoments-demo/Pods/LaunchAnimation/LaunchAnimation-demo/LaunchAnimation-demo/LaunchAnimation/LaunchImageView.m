//
//  LaunchImageView.m
//  LaunchAnimation-demo
//
//  Created by Arvin on 16/8/12.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "LaunchImageView.h"
#import "UIImage+Extension.h"

#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAINSCREEN [[UIScreen mainScreen] currentMode].size

@interface LaunchImageView ()
@property (nonatomic, strong) UIImageView *launchImgView;
@end

@implementation LaunchImageView

#pragma mark - Initialization
+ (instancetype)launchImageWithFrame:(CGRect)aFrame
                       animationType:(AnimationType)aAnimationType
                            duration:(CGFloat)aDuration {
    return [[LaunchImageView alloc] initWithFrame:aFrame
                                    animationType:aAnimationType
                                         duration:aDuration];
}

- (instancetype)initWithFrame:(CGRect)aFrame
                animationType:(AnimationType)aAnimationType
                     duration:(CGFloat)aDuration {
    
    if (self = [super initWithFrame:aFrame]) {
        
        UIImage *launchImage = [UIImage getLaunchImage];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:aFrame];
        
        if (aAnimationType == AnimationTypeUpAndDown) {
            [self upAndDownLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeLeftAndRight) {
            [self leftAndRightLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeUpDownAndLeftRight) {
            [self upDownAndLeftRightLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeCurveEaseOut) {
            [self curveEaseOutLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeMovePositionUp) {
            [self movePositionUpLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeMovePositionLeft) {
            [self movePositionLeftLaunchImage:launchImage duration:aDuration];
        }
    }
    return self;
}

#pragma mark - Private Method
- (void)upAndDownLaunchImage:(UIImage *)launchImage duration:(CGFloat)aDuration {
    // top image
    UIImageView *topImageView = [[UIImageView alloc] init];
    [topImageView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT*0.5)];
    CGRect topImgRect = CGRectMake(0, 0, MAINSCREEN.width, MAINSCREEN.height*0.5);
    [topImageView setImage:[UIImage clipImage:launchImage withRect:topImgRect]];
    
    // bottom image
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    [bottomImageView setFrame:CGRectMake(0, HEIGHT*0.5, WIDTH, HEIGHT*0.5)];
    CGRect bottomImgRect = CGRectMake(0, MAINSCREEN.height*0.5, MAINSCREEN.width, MAINSCREEN.height*0.5);
    [bottomImageView setImage:[UIImage clipImage:launchImage withRect:bottomImgRect]];
    
    // add view
    [self addSubview:topImageView];
    [self addSubview:bottomImageView];
    
    // delay animation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:aDuration animations:^{
            CGRect topRect = topImageView.frame;
            topRect.origin.y -= HEIGHT;
            topImageView.frame = topRect;
            
            CGRect bottomRect = bottomImageView.frame;
            bottomRect.origin.y += HEIGHT;
            bottomImageView.frame = bottomRect;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)leftAndRightLaunchImage:(UIImage *)launchImage duration:(CGFloat)aDuration {
    // left image
    UIImageView *leftImgView = [[UIImageView alloc] init];
    [leftImgView setFrame:CGRectMake(0, 0, WIDTH*0.5, HEIGHT)];
    CGRect leftImgRect = CGRectMake(0, 0, MAINSCREEN.width*0.5, MAINSCREEN.height);
    [leftImgView setImage:[UIImage clipImage:launchImage withRect:leftImgRect]];
    
    // right image
    UIImageView *rightImgView = [[UIImageView alloc] init];
    [rightImgView setFrame:CGRectMake(WIDTH*0.5, 0, WIDTH*0.5, HEIGHT)];
    CGRect rightImgRect = CGRectMake(MAINSCREEN.width*0.5, 0, MAINSCREEN.width*0.5, MAINSCREEN.height);
    [rightImgView setImage:[UIImage clipImage:launchImage withRect:rightImgRect]];
    
    // add view
    [self addSubview:leftImgView];
    [self addSubview:rightImgView];
    
    // delay animation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:aDuration animations:^{
            CGRect leftRect = leftImgView.frame;
            leftRect.origin.x -= WIDTH;
            leftImgView.frame = leftRect;
            
            CGRect rightRect = rightImgView.frame;
            rightRect.origin.x += WIDTH;
            rightImgView.frame = rightRect;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)upDownAndLeftRightLaunchImage:(UIImage *)launchImage duration:(CGFloat)aDuration {
    // top left image
    UIImageView *topLeftImgView = [[UIImageView alloc] init];
    [topLeftImgView setFrame:CGRectMake(0, 0, WIDTH*0.5, HEIGHT*0.5)];
    CGRect topLeftImgRect = CGRectMake(0, 0, MAINSCREEN.width*0.5, MAINSCREEN.height*0.5);
    [topLeftImgView setImage:[UIImage clipImage:launchImage withRect:topLeftImgRect]];
    
    // top right image
    UIImageView *topRightImgView = [[UIImageView alloc] init];
    [topRightImgView setFrame:CGRectMake(WIDTH*0.5, 0, WIDTH*0.5, HEIGHT*0.5)];
    CGRect topRightImgRect = CGRectMake(MAINSCREEN.width*0.5, 0, MAINSCREEN.width*0.5, MAINSCREEN.height*0.5);
    [topRightImgView setImage:[UIImage clipImage:launchImage withRect:topRightImgRect]];
    
    // bottom left image
    UIImageView *bottomLeftImgView = [[UIImageView alloc] init];
    [bottomLeftImgView setFrame:CGRectMake(0, HEIGHT*0.5, WIDTH*0.5, HEIGHT*0.5)];
    CGRect bottomLeftImgRect = CGRectMake(0, MAINSCREEN.height*0.5, MAINSCREEN.width*0.5, MAINSCREEN.height*0.5);
    [bottomLeftImgView setImage:[UIImage clipImage:launchImage withRect:bottomLeftImgRect]];
    
    // bottom right image
    UIImageView *bottomRightImgView = [[UIImageView alloc] init];
    [bottomRightImgView setFrame:CGRectMake(WIDTH*0.5, HEIGHT*0.5, WIDTH*0.5, HEIGHT*0.5)];
    CGRect bottomRigthImgRect = CGRectMake(MAINSCREEN.width*0.5, MAINSCREEN.height*0.5, MAINSCREEN.width*0.5, MAINSCREEN.height*0.5);
    [bottomRightImgView setImage:[UIImage clipImage:launchImage withRect:bottomRigthImgRect]];
    
    // add view
    [self addSubview:topLeftImgView];
    [self addSubview:topRightImgView];
    [self addSubview:bottomLeftImgView];
    [self addSubview:bottomRightImgView];
    
    // delay animation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:aDuration animations:^{
            CGRect topLeftImgRect = topLeftImgView.frame;
            topLeftImgRect.origin.x -= WIDTH;
            topLeftImgRect.origin.y -= HEIGHT;
            topLeftImgView.frame = topLeftImgRect;
            
            CGRect topRightImgRect = topRightImgView.frame;
            topRightImgRect.origin.x += WIDTH;
            topRightImgRect.origin.y -= HEIGHT;
            topRightImgView.frame = topRightImgRect;
            
            CGRect bottomLeftImgRect = bottomLeftImgView.frame;
            bottomLeftImgRect.origin.x -= WIDTH;
            bottomLeftImgRect.origin.y += HEIGHT;
            bottomLeftImgView.frame = bottomLeftImgRect;
            
            CGRect bottomRightImgRect = bottomRightImgView.frame;
            bottomRightImgRect.origin.x += WIDTH;
            bottomRightImgRect.origin.y += HEIGHT;
            bottomRightImgView.frame = bottomRightImgRect;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)curveEaseOutLaunchImage:(UIImage *)launchImage duration:(CGFloat)aDuration {
    UIImageView *launchImgView = [[UIImageView alloc] init];
    [launchImgView setImage:launchImage];
    [launchImgView setFrame:self.bounds];
    [self addSubview:launchImgView];
    
    [UIView animateWithDuration:aDuration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [launchImgView setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
        [launchImgView setAlpha:.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
 ========私有API========
 cube 方块
 suckEffect 三角
 rippleEffect 水波抖动
 pageCurl 上翻页
 pageUnCurl 下翻页
 oglFlip 上下翻转
 cameraIrisHollowOpen 镜头快门开
 cameraIrisHollowClose 镜头快门关
 ============================================
 // 转场效果
 CA_EXTERN NSString * const kCATransitionFade
 CA_EXTERN NSString * const kCATransitionMoveIn
 CA_EXTERN NSString * const kCATransitionPush
 CA_EXTERN NSString * const kCATransitionReveal
 // 转场方向
 CA_EXTERN NSString * const kCATransitionFromRight
 CA_EXTERN NSString * const kCATransitionFromLeft
 CA_EXTERN NSString * const kCATransitionFromTop
 CA_EXTERN NSString * const kCATransitionFromBottom
 
 kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
 kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
 kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
 kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地
 */
- (void)movePositionLeftLaunchImage:(UIImage *)launchImage duration:(CGFloat)aDuration {
    [self setLaunchImage:launchImage
                duration:aDuration
       basicAnimaKeyPath:@"position.x"
               fromValue:@(self.launchImgView.center.x)
                 toValue:@(self.launchImgView.center.x-WIDTH)
            functionName:kCAMediaTimingFunctionEaseIn
                  forKey:@"animationX"];
}

- (void)movePositionUpLaunchImage:(UIImage *)launchImage duration:(CGFloat)aDuration {
    [self setLaunchImage:launchImage
                duration:aDuration
       basicAnimaKeyPath:@"position.y"
               fromValue:@(self.launchImgView.center.y)
                 toValue:@(self.launchImgView.center.y-HEIGHT)
            functionName:kCAMediaTimingFunctionEaseOut
                  forKey:@"animationY"];
}

- (void)setLaunchImage:(UIImage *)launchImage
              duration:(CGFloat)aDuration
     basicAnimaKeyPath:(NSString *)keyPath
             fromValue:(id)fromValue
               toValue:(id)toValue
          functionName:(NSString *)functionName
                forKey:(NSString *)key {
    
    [self.launchImgView setImage:launchImage];
    [self.launchImgView setFrame:self.bounds];
    [self addSubview:self.launchImgView];
    
    CABasicAnimation *positionAnima =
    [CABasicAnimation animationWithKeyPath:keyPath];
    [positionAnima setDuration:aDuration];
    [positionAnima setDelegate:self];
    [positionAnima setFromValue:fromValue];
    [positionAnima setToValue:toValue];
    [positionAnima setTimingFunction:
     [CAMediaTimingFunction functionWithName:functionName]];
    [positionAnima setRepeatCount:.0f];
    [positionAnima setRepeatDuration:.0f];
    [positionAnima setAutoreverses:NO];
    [positionAnima setRemovedOnCompletion:YES];
    [positionAnima setFillMode:kCAFillModeForwards];
    [self.launchImgView.layer addAnimation:positionAnima forKey:key];
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}


#pragma mark -
- (UIImageView *)launchImgView {
    if (!_launchImgView) {
        _launchImgView = [[UIImageView alloc] init];
        [_launchImgView setFrame:self.bounds];
    }
    return _launchImgView;
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
