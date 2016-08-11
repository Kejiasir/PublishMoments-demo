//
//  YYPhotosView.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/4.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPhotosView;
@protocol YYPhotosViewDelegate <NSObject>

@optional
/**
 *  YYPhotosViewDelegate代理方法
 *  @param photosView YYPhotosView
 *  @param imgCount   已有选择的照片数
 */
- (void)photosView:(YYPhotosView *)photosView withImgCount:(NSInteger)imgCount;
/**
 *  代理返回高度
 *  @param imgHeight 选择图片后PhotosView的高度
 */
- (void)photosViewWithImageMaxHeight:(NSInteger)imgHeight;
@end

@interface YYPhotosView : UIView
/**
 *  每行展示的照片数
 */
@property (nonatomic, assign) NSInteger imgCountRow;
/**
 *  所有图片的最大高度
 */
@property (nonatomic, assign) CGFloat imageMaxHeight;
/**
 *  代理属性
 */
@property (nonatomic, weak) id<YYPhotosViewDelegate> delegate;
/**
 *  添加图片
 *  @param image 图片数组
 */
- (void)addImages:(NSMutableArray *)images;

@end
