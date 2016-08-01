//
//  YYNavigationController.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYNavigationController.h"

@interface YYNavigationController ()

@end

@implementation YYNavigationController

+ (void)initialize {
    NSLog(@"------");
    [self setupNavBarTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setupNavBarTheme];
    [self preferredStatusBarStyle];
    NSLog(@"===========");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

+ (void)setupNavBarTheme {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBarTintColor:ColorFromRGB(45, 46, 50)];
    [navBar setTranslucent:YES];
//    [navBar setTitleTextAttributes:@{NSFontAttributeName:CustomFontName(18),
//                                     NSForegroundColorAttributeName:[UIColor whiteColor]}];
    /*
     UIBarStyleDefault          = 0,
     UIBarStyleBlack            = 1,
     UIBarStyleBlackOpaque      = 1,//已过时, 使用UIBarStyleBlack
     UIBarStyleBlackTranslucent = 2,//已过时, 使用UIBarStyleBlack和设置半透明的属性为YES
     */
    [navBar setBarStyle:UIBarStyleBlack];
    [navBar setBackgroundColor:[UIColor blackColor]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end