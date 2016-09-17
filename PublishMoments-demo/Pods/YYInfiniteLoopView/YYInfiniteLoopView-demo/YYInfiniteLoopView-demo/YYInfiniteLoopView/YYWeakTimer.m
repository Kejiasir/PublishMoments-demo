//
//  YYWeakTimer.m
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYWeakTimer.h"

@interface YYWeakTimer ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation YYWeakTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo {
    
    YYWeakTimer *weakTimer = [[YYWeakTimer alloc] init];
    weakTimer.target = aTarget;
    weakTimer.selector = aSelector;
    weakTimer.timer = [NSTimer scheduledTimerWithTimeInterval:ti
                                                       target:weakTimer
                                                     selector:@selector(fire:)
                                                     userInfo:userInfo
                                                      repeats:yesOrNo];
    return weakTimer.timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                      block:(TimerHandler)block
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo {
    
    return [self scheduledTimerWithTimeInterval:ti
                                         target:self
                                       selector:@selector(timerBlock:)
                                       userInfo:@[[block copy],userInfo]
                                        repeats:yesOrNo];
}

- (void)fire:(NSTimer *)timer {
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

+ (void)timerBlock:(NSArray *)userInfo {
    TimerHandler block = [userInfo firstObject];
    if (block) {
        block([userInfo lastObject]);
    }
}

- (void)dealloc {
    //NSLog(@"%s",__func__);
}

@end

