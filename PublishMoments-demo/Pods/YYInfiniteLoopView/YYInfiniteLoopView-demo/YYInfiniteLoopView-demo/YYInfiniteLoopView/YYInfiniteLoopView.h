//
//  YYInfiniteLoopView.h
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
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

/// 过渡动画类型
typedef NS_ENUM(NSUInteger, InfiniteLoopViewAnimationType) {
    InfiniteLoopViewAnimationTypeNone,          // 默认,不设置
    InfiniteLoopViewAnimationTypeFade,          // 交叉淡化过渡
    InfiniteLoopViewAnimationTypeMoveIn,        // 新视图移到旧视图上面
    InfiniteLoopViewAnimationTypePush,          // 新视图把旧视图推出去
    InfiniteLoopViewAnimationTypeReveal,        // 将旧视图移开,显示下面的新视图
    /* 以下是私有API,慎用,可能不能通过应用审核 */
    InfiniteLoopViewAnimationTypePageCurl,              // 向上翻页
    InfiniteLoopViewAnimationTypePageUnCurl,            // 向下翻页
    InfiniteLoopViewAnimationTypeOglFlip,               // 平面翻转
    InfiniteLoopViewAnimationTypeCube,                  // 立体翻转
    InfiniteLoopViewAnimationTypeSuckEffect,            // 收缩抽离
    InfiniteLoopViewAnimationTypeRippleEffect,          // 水波动效
    InfiniteLoopViewAnimationTypeCameraIrisHollowOpen,  // 镜头快门开
    InfiniteLoopViewAnimationTypeCameraIrisHollowClose  // 镜头快门关
};

/// 过渡动画方向
typedef NS_ENUM(NSUInteger, InfiniteLoopViewAnimationDirection) {
    InfiniteLoopViewAnimationDirectionRight, // 向右
    InfiniteLoopViewAnimationDirectionLeft,  // 向左
    InfiniteLoopViewAnimationDirectionTop,   // 向上
    InfiniteLoopViewAnimationDirectionBottom // 向下
};

@interface YYInfiniteLoopView : UIView
/** 代理属性 */
@property (nonatomic, weak) id<YYInfiniteLoopViewDelegate> delegate;
/** 是否开启自动轮播, 默认开启 */
@property (nonatomic, assign, getter=isAutoPlayer) BOOL autoPlayer;
/** 占位图片, 默认没有 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 定时器时间, 默认3.0s */
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
/** 枚举, 用于设置自动播放时的过渡动画, 默认没有动画 */
@property (nonatomic, assign) InfiniteLoopViewAnimationType animationType;
/** 枚举, 用于设置自动播放时的过渡动画方向, 默认向右 */
@property (nonatomic, assign) InfiniteLoopViewAnimationDirection animationDirection;
/** 过渡动画的执行时长, 默认1.0s */
@property (nonatomic, assign) CFTimeInterval animationDuration;
/** 是否隐藏标题, 默认为NO, 如果设置YES, pageControl 位置默认居中 */
@property (nonatomic, assign, getter=isHideTitleLabel) BOOL hideTitleLabel;
/** 是否隐藏蒙版, 默认为YES */
@property (nonatomic, assign, getter=isHideCover) BOOL hideCover;
/** 蒙版的颜色, 默认为黑色, alpha值0.3 */
@property (nonatomic, strong) UIColor *coverColor;

/**
 *  类方法初始化
 *  @param imageUrls     图片URL数组, 不能为nil
 *  @param titles        图片标题数组, 可以传nil
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

