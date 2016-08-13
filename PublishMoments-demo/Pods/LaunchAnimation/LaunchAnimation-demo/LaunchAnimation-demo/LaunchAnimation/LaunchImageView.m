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

@implementation LaunchImageView

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
                animationType:(AnimationType)aAnimationType
                     duration:(CGFloat)aDuration {
    if (self = [super initWithFrame:frame]) {
        UIImage *launchImage = [UIImage getLaunchImage];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:frame];
        if (aAnimationType == AnimationTypeUpAndDown) {
            [self upAndDownLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeLeftAndRight) {
            [self leftAndRightLaunchImage:launchImage duration:aDuration];
        } else if (aAnimationType == AnimationTypeUpDownAndLeftRight) {
            [self upDownAndLeftRightLaunchImage:launchImage duration:aDuration];
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

#pragma mark -
- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
