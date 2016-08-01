//
//  YYRootViewController.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYRootViewController.h"
#import "YYEditViewController.h"

@interface YYRootViewController ()

@end

@implementation YYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"首页";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -10;
    UIBarButtonItem *rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithNormalImg:@"fav_fileicon_pic90"
                                 HighlightedImg:@"fav_fileicon_pic90"
                                         target:self
                                         action:@selector(RightBarButtonClick)];
    [self.navigationItem setRightBarButtonItems:@[fixedSpace,rightBarButtonItem]];
}

- (void)RightBarButtonClick {
    [[[YYActionSheet alloc] initWithTitle:nil clickedAtIndex:^(NSInteger index) {
        if (index == 0) {
            NSLog(@"小视频");
        } else if (index == 1) {
            NSLog(@"拍照");
            YYEditViewController *editVC = [[YYEditViewController alloc] init];
            [self.navigationController pushViewController:editVC animated:YES];
        } else if (index == 2) {
            NSLog(@"从手机相册选择");
            YYEditViewController *editVC = [[YYEditViewController alloc] init];
            [self.navigationController pushViewController:editVC animated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"小视频",@"拍照",@"从手机相册选择",nil] show]; 
}



@end
