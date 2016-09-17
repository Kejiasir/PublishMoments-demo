//
//  NSTimer+Extension.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/9/7.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

- (void)pause {
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    [self setFireDate:[NSDate date]];
}

@end
