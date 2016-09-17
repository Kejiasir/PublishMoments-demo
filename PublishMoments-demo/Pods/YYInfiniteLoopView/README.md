[![Build Status](https://travis-ci.org/Kejiasir/YYInfiniteLoopView-demo.svg?branch=master)](https://travis-ci.org/Kejiasir/YYInfiniteLoopView-demo)
[![CocoaPods](https://img.shields.io/cocoapods/v/YYInfiniteLoopView.svg)](http://cocoadocs.org/docsets/YYInfiniteLoopView)
[![CocoaPods](https://img.shields.io/cocoapods/p/YYInfiniteLoopView.svg)](http://cocoadocs.org/docsets/YYInfiniteLoopView)
[![CocoaPods](https://img.shields.io/cocoapods/l/YYInfiniteLoopView.svg)](https://raw.githubusercontent.com/kejiasir/YYInfiniteLoopView/master/LICENSE)

## 使用UICollectionView封装的无限轮播视图, 使用简单, 提供多种属性自由设置

### 如何集成到您的项目 ?
* 一, 手动安装
  * 将本项目 Clone 或 Download 下来, 将 Demo 工程中的 `YYInfiniteLoopView` 文件夹拷贝到您的项目中
  * 在需要使用的类中导入主头文件 `#import "YYInfiniteLoopView.h"`, 注意是使用双引号的方式import哦
  
* 二, 使用CocoaPods安装
  * 在 Podfile 文件中添加 `pod 'YYInfiniteLoopView', '~> 0.1.0'`
  * 使用终端执行 `pod install` 或 `pod update` 命令, 将自动下载依赖库文件
  * 同样的在需要使用的类中导入主头文件 `#import <YYInfiniteLoopView.h>`, 这里则需使用尖括号的方式

### 注意, 本项目图片下载操作依赖[SDWebImage](https://github.com/rs/SDWebImage), 需自行安装此依赖库

### 0913 更新, Version 0.2.0
 * 新增自动轮播时的过渡动画(默认不开启), 提供12种过渡动画可以选择, 有一部分用到苹果的私有API, 使用请注意, 有可能审核会被拒, 请慎用, 啊哈哈哈...
 * 另外有些动画支持过渡方向选择, 同样提供枚举进行设置, 具体使用可参考示例Demo
 * 可以自由设置过渡动画的执行时间(有些动画的时间请按需调整), 默认1.0s

### 主类的属性说明 :
  * 考虑到在项目中轮播图会有多种不同的展现方式, 所以提供了以下多种属性用来设置, 都有详细的注释说明
```objc
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
```
### 点击图片跳转到对应的控制器, 有两种回调方式, 怎么好用怎么来
  * 第☝️, 使用代理的方式, 只需设置代理, 遵守代理协议 `YYInfiniteLoopViewDelegate`, 实现代理方法即可
```objc
@optional
/// 代理方法, 获得当前点击的图片索引
- (void)infiniteLoopView:(YYInfiniteLoopView *)infiniteLoopView
        didSelectedImage:(NSInteger)selectedImageIndex;
```
  * 第✌️, 使用Block 的方式, 在初始化的同时即可实现点击事件的回调
```objc 
/// 选中的图片索引, Block回调方式
typedef void(^didSelectedImage)(NSInteger index);
```
### 主类的初始化方式 :
  * 按照官方的惯例, 我们同样可以使用 `类方法` 或 `实例方法` 来进行初始化
```objc
/**
 *  类方法初始化
 *  @param imageUrls     图片URL数组, 不能为nil
 *  @param titles        图片标题数组, 可以为nil
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
```
## 使用Example (具体请参考demo项目的使用方法)
### 第一种使用示例, 默认的
```objc
    YYInfiniteLoopView *loopView = [YYInfiniteLoopView
                                    infiniteLoopViewWithImageUrls:self.imageUrls
                                    titles:self.titles
                                    didSelectedImage:^(NSInteger index) {
                                        // 使用代理方法回调时, 这里可以不做任何事情
                                        NSLog(@"%zd",index);
                                    }];
    // 设置代理
    loopView.delegate = self;
    loopView.frame = CGRectMake(0, 0, width, height*0.25);
    self.tableView.tableHeaderView = loopView;
```
### 第二种使用示例, 使用各种设置你想要的
```objc
    // 实例方法初始化
    YYInfiniteLoopView *loopView = [[YYInfiniteLoopView alloc]
                                    initWithImageUrls:self.imageUrls
                                    titles:self.titles
                                    didSelectedImage:^(NSInteger index) { 
                                        // 获得选中的图片索引, 调用方法跳转对应的控制器
                                        [self didSelectedImageWithIndex:index];
                                    }];
    // 是否隐藏蒙版, 默认YES
    loopView.hideCover = NO;
    
    // 是否自动轮播, 默认YES
    loopView.autoPlayer = NO;
    
    // 设置轮播时间, 默认3s
    // loopView.timeInterval = 1.5f;
    
    // 是否隐藏标题, 如果标题数组为nil, 请手动设置隐藏, 默认为NO
    loopView.hideTitleLabel = YES;
    
    // 标题文字的颜色, 默认白色
    // loopView.titleTextColor = [UIColor blueColor];
    
    // 蒙版颜色, 一般保持默认就好, 最多调整下alpha值咯
    // loopView.coverColor = RGBAColor(23, 138, 230, 0.4);
    
    // 标题文字的尺寸, 默认14px
    // loopView.titleTextFont = [UIFont systemFontOfSize:16];
    
    // 设置标题的背景颜色, 默认黑色, alpha值为0.4
    // loopView.bgViewColor = RGBAColor(23, 138, 230, 0.4);
    
    // 以下两个设置pageControl的圆点颜色
    // loopView.pageIndicatorColor = [UIColor yellowColor];
    // loopView.currentPageIndicatorColor = [UIColor magentaColor];
    
    // 以下两个设置pageControl的图片, 用于替代默认的圆点
    loopView.pageImage = [UIImage imageNamed:@"PageControlImage"];
    loopView.currentPageImage = [UIImage imageNamed:@"CurrentPageControlImage"];
    
    // 设置轮播时的占位图, 用于网络状态不好未能及时请求到网络图片时展示
    // loopView.placeholderImage = [UIImage imageNamed:@"PlaceholderImage"];
    
    // 枚举, 设置标题的展示位置, 不设置时默认在底部
    // loopView.titlePosition = InfiniteLoopViewTitlePositionTop;
    
    // 枚举, 设置pageControl的位置, 只有设置标题在顶部时此设置才有效, 默认居中
    // loopView.pagePosition = InfiniteLoopViewPagePositionCenter;
    
    // 过渡动画执行时间
    loopView.animationDuration = 1.5f;
    
    // 过渡动画类型
    loopView.animationType = InfiniteLoopViewAnimationTypeCube;
    
    // 过渡动画方向
    loopView.animationDirection = InfiniteLoopViewAnimationDirectionRight;
    
    // 设置loopView的frame
    loopView.frame = CGRectMake(0, height*0.25+10, width, height*0.25);
    
    [self.scrollView addSubview:loopView];
```
### Screenshot
<img src="001.gif?v=3&s=100" alt="GitHub" title="demo预览效果" width="260" height="480"/>


##License
**InfiniteLoopView 使用 MIT 许可证，详情见 LICENSE 文件**
