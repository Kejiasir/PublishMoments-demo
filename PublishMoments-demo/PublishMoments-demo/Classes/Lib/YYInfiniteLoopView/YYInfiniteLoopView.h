//
//  YYInfiniteLoopView.h
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/8/30.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYInfiniteLoopView;
@protocol YYInfiniteLoopViewDelegate <NSObject>

@optional
/// 代理方法, 获得当前点击的图片索引
- (void)infiniteLoopView:(YYInfiniteLoopView *)infiniteLoopView
        didSelectedImage:(NSInteger)selectedImageIndex;
@end

/// 选中的图片索引, Block回调方式
typedef void(^didSelectedImage)(NSInteger index);

/// 标题标签的位置
typedef NS_ENUM(NSUInteger, InfiniteLoopViewTitlePosition) {
    InfiniteLoopViewTitlePositionBottom, // 底部
    InfiniteLoopViewTitlePositionTop     // 顶部
};

/// PageControl 的位置
typedef NS_ENUM(NSUInteger, InfiniteLoopViewPagePosition) {
    InfiniteLoopViewPagePositionCenter, // 居中
    InfiniteLoopViewPagePositionLeft,   // 居左
    InfiniteLoopViewPagePositionRight   // 居右
};

@interface YYInfiniteLoopView : UIView
/** 代理属性 */
@property (nonatomic, weak) id<YYInfiniteLoopViewDelegate> delegate;
/** 是否开启自动轮播, 默认开启 */
@property (nonatomic, assign, getter=isAutoPlayer) BOOL autoPlayer;
/** 占位图片, 默认没有 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 定时器时间, 默认3s */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/** 标题和分页索引的背景颜色, 默认黑色, alpha值0.4 */
@property (nonatomic, strong) UIColor *bgViewColor;
/** 标题的字体尺寸, 默认14px */
@property (nonatomic, strong) UIFont *titleTextFont;
/** 标题的字体颜色, 默认白色 */
@property (nonatomic, strong) UIColor *titleTextColor;
/** 分页索引图片, 默认不设置 */
@property (nonatomic, strong) UIImage *pageImage;
/** 当前分页索引的图片, 默认不设置 */
@property (nonatomic, strong) UIImage *currentPageImage;
/** 分页索引的颜色, 默认白色 */
@property (nonatomic, strong) UIColor *pageIndicatorColor;
/** 当前分页索引的颜色, 默认蓝色 */
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;
/** 标题展示的位置, 默认为底部 */
@property (nonatomic, assign) InfiniteLoopViewTitlePosition titlePosition;
/** PageControl 展示的位置, 当设置标题位置为Top时, 此设置才有效, 默认居中 */
@property (nonatomic, assign) InfiniteLoopViewPagePosition pagePosition;
/** 是否隐藏标题, 默认为NO, 如果设置YES, pageControl 位置默认居中 */
@property (nonatomic, assign, getter=isHideTitleLabel) BOOL hideTitleLabel;
/** 是否隐藏蒙版, 默认为YES */
@property (nonatomic, assign, getter=isHideCover) BOOL hideCover;

/**
 *  类方法初始化
 *  @param imageUrls     图片URL数组, 不可为nil
 *  @param titles        图片标题数组
 *  @param selectedImage block 回调, 获取选中的图片索引
 *
 *  @return 返回当前对象
 */
+ (instancetype)infiniteLoopViewWithImageUrls:(NSArray<NSString *> *)imageUrls
                                       titles:(NSArray<NSString *> *)titles
                             didSelectedImage:(didSelectedImage)selectedImage;
/// 实例方法初始化, 参数同上
- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imageUrls
                           titles:(NSArray<NSString *> *)titles
                 didSelectedImage:(didSelectedImage)selectedImage;


@end
