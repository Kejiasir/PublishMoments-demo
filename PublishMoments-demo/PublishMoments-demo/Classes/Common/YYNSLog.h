//
//  YYNSLog.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#ifndef YYNSLog_h
#define YYNSLog_h

#import <Foundation/Foundation.h>
#import <asl.h>

#ifdef DEBUG
 #define YYLog(...) NSLog(__VA_ARGS__)
#else
 #define YYLog(...)
#endif

#define THIS_FILE [(@"" __FILE__) lastPathComponent]

#define  NSLog(fmt,...) _NSLog((@"%@:第%d行 %s " fmt), THIS_FILE, __LINE__, __FUNCTION__, ##__VA_ARGS__)

#define _NSLog(fmt,...) {                                               \
    do {                                                                \
        NSString *str = [NSString stringWithFormat:fmt, ##__VA_ARGS__]; \
        printf("%s\n",[str UTF8String]);                                \
        asl_log(NULL, NULL, ASL_LEVEL_NOTICE, "%s", [str UTF8String]);  \
    } while(0);                                                         \
}

#endif /* YYNSLog_h */
