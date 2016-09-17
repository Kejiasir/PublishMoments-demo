//
//  YYWeakTimer.h
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerHandler)(id userInfo);

@interface YYWeakTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                      block:(TimerHandler)block
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo;
@end

