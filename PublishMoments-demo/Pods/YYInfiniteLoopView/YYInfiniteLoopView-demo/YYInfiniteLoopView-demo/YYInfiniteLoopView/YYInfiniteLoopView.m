//
//  YYInfiniteLoopView.m
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYInfiniteLoopView.h"
#import "YYInfiniteLoopViewCell.h"
#import "YYInfiniteLoopViewLayout.h"
#import "YYConfigured.h"
#import "YYWeakTimer.h"

@interface YYInfiniteLoopView ()<UICollectionViewDelegate, UICollectionViewDataSource>
/// 图片标题数组
@property (nonatomic, strong) NSArray *titles;
/// 图片URL数组
@property (nonatomic, strong) NSArray *imageUrls;
/// 选中的图片索引
@property (nonatomic, copy) void(^didSelectedImage)(NSInteger index);
/// UICollectionView
@property (nonatomic, strong) UICollectionView *collectionView;
/// 标题和分页索引的背景
@property (nonatomic, strong) UIImageView *backgroundView;
/// 分页指示控件
@property (nonatomic, strong) UIPageControl *pageControl;
/// 图片标题标签
@property (nonatomic, strong) UILabel *titleLabel;
/// 蒙版视图, alpha值为0.3
@property (nonatomic, strong) UIView *coverView;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 转场动画
@property (nonatomic, strong) CATransition *animation;
@end

@implementation YYInfiniteLoopView

#pragma mark - Life Cycle
+ (instancetype)infiniteLoopViewWithImageUrls:(NSArray<NSString *> *)imageUrls
                                       titles:(NSArray<NSString *> *)titles
                             didSelectedImage:(didSelectedImage)selectedImage {
    return [[YYInfiniteLoopView alloc] initWithImageUrls:imageUrls
                                                  titles:titles
                                        didSelectedImage:selectedImage];
}

- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imageUrls
                           titles:(NSArray<NSString *> *)titles
                 didSelectedImage:(didSelectedImage)selectedImage {
    if (self = [super init]) {
        NSAssert(imageUrls != nil, @"Image URL array can not be null...");
        [self setTitles:titles];
        [self setImageUrls:imageUrls];
        [self setDidSelectedImage:selectedImage];
        [self.titleLabel setText:[self.titles firstObject]];
        [self.pageControl setNumberOfPages:[self.imageUrls count]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.imageUrls count] > 1) {
                [self.collectionView scrollToItemAtIndexPath:
                 [NSIndexPath indexPathForItem:[self.imageUrls count] inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionLeft
                                                    animated:NO];
                [self addTimer];
            }
        });
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupAllSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        [self setupAllSubView];
    }
    return self;
}


#pragma mark -
- (void)initialization {
    [self setHideCover:YES];
    [self setAutoPlayer:YES];
    [self setTimeInterval:3.0f];
    [self setHideTitleLabel:NO];
    [self setCoverColor:RGBACOLOR(0, 0, 0, .3f)];
    [self setBgViewColor:RGBACOLOR(0, 0, 0, .4f)];
    [self setTitleTextColor:[UIColor whiteColor]];
    [self setTitleTextFont:[UIFont systemFontOfSize:14]];
    [self setPageIndicatorColor:[UIColor whiteColor]];
    [self setCurrentPageIndicatorColor:[UIColor blueColor]];
    [self setAnimationDuration:1.0f];
    [self setAnimationType:InfiniteLoopViewAnimationTypeNone];
    [self setAnimationDirection:InfiniteLoopViewAnimationDirectionRight];
}

- (void)setupAllSubView {
    
    /// UICollectionView
    [self addSubview:self.collectionView = ({
        self.collectionView = [[UICollectionView alloc]
                               initWithFrame:CGRectZero
                               collectionViewLayout:[YYInfiniteLoopViewLayout new]];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setBackgroundColor:RGBCOLOR(243, 243, 245)];
        [self.collectionView registerClass:[YYInfiniteLoopViewCell class]
                forCellWithReuseIdentifier:CellIdentifier];
        self.collectionView;
    })];
    
    /// 添加一层蒙版
    [self addSubview:self.coverView = ({
        self.coverView = [[UIView alloc] init];
        [self.coverView setHidden:self.hideCover];
        [self.coverView setUserInteractionEnabled:NO];
        [self.coverView setBackgroundColor:self.coverColor];
        self.coverView;
    })];
    
    /// 标题和分页索引的背景
    [self addSubview:self.backgroundView = ({
        self.backgroundView = [[UIImageView alloc] init];
        [self.backgroundView setHidden:self.hideTitleLabel];
        [self.backgroundView setBackgroundColor:self.bgViewColor];
        [self.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
        [self.backgroundView setClipsToBounds:YES];
        self.backgroundView;
    })];
    
    /// 标题标签
    [self addSubview:self.titleLabel = ({
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:self.titleTextFont];
        [self.titleLabel setHidden:self.hideTitleLabel];
        [self.titleLabel setTextColor:self.titleTextColor];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        self.titleLabel;
    })];
    
    /// 分页索引控件
    [self addSubview:self.pageControl = ({
        self.pageControl = [[UIPageControl alloc] init];
        [self.pageControl setHidesForSinglePage:YES];
        [self.pageControl setPageIndicatorTintColor:self.pageIndicatorColor];
        [self.pageControl setCurrentPageIndicatorTintColor:self.currentPageIndicatorColor];
        self.pageControl;
    })];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat spacing = 3;
    CGFloat bgViewH = 30;
    CGFloat self_width = self.bounds.size.width;
    CGFloat bgViewY = self.bounds.size.height - bgViewH;
    CGFloat pageControlW = [self.imageUrls count] == 1 ? 0 :
    [self.pageControl sizeForNumberOfPages:self.imageUrls.count].width;
    
    [self.collectionView setFrame:self.bounds];
    [self.coverView setFrame:self.bounds];
    // 标题置顶
    if (self.titlePosition == InfiniteLoopViewTitlePositionTop) {
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.backgroundView setFrame:CGRectMake(0, 0, self_width, bgViewH)];
        [self.titleLabel setFrame:CGRectMake(margin * .5, 0, self_width - margin, bgViewH)];
        
        CGFloat pageControlX = .0f;
        if (self.pagePosition == InfiniteLoopViewPagePositionCenter) {
            pageControlX = (self_width - pageControlW) * .5;
        } else if (self.pagePosition == InfiniteLoopViewPagePositionLeft) {
            pageControlX = margin * .5;
        } else if (self.pagePosition == InfiniteLoopViewPagePositionRight) {
            pageControlX = self_width - pageControlW - margin;
        }
        [self.pageControl setFrame:CGRectMake(pageControlX, bgViewY, pageControlW, bgViewH)];
    } else {
        [self.backgroundView setFrame:CGRectMake(0, bgViewY, self_width, bgViewH)];
        [self.titleLabel setFrame:CGRectMake(margin * .5, bgViewY, self_width - margin - pageControlW - ([self.imageUrls count]>1?spacing:0), bgViewH)];
        [self.pageControl setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + spacing, bgViewY, pageControlW, bgViewH)];
    }
    if (self.hideTitleLabel) {
        [self.pageControl setFrame:CGRectMake((self_width - pageControlW) * .5, bgViewY, pageControlW, bgViewH)];
    }
}

#pragma mark - Timer Method
- (void)addTimer {
    if (!_autoPlayer) return;
    [self removeTimer];
    __weak typeof(self) weakSele = self;
    self.timer = [YYWeakTimer
                  scheduledTimerWithTimeInterval:self.timeInterval
                  target:self
                  block:^(id userInfo) {
                      [weakSele nextImage];
                  } userInfo:@"" repeats:YES];
}

- (void)removeTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        [self setTimer:nil];
    }
}

- (void)nextImage {
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    NSInteger offsetX = self.collectionView.frame.size.width * (page + 1);
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (!(self.animationType == InfiniteLoopViewAnimationTypeNone)) {
        [self.collectionView.layer addAnimation:self.animation forKey:@"animationKey"];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(infiniteLoopView:didSelectedImage:)]) {
        [self.delegate infiniteLoopView:self didSelectedImage:indexPath.item % [self.imageUrls count]];
    }
    if (self.didSelectedImage != nil) {
        self.didSelectedImage(indexPath.item % [self.imageUrls count]);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageUrls count] * ([self.imageUrls count] == 1 ? 1 : [self.imageUrls count]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYInfiniteLoopViewCell *infiniteLoopViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    infiniteLoopViewCell.placeholderImg = self.placeholderImage;
    infiniteLoopViewCell.imageUrl = self.imageUrls[indexPath.row % [self.imageUrls count]];
    return infiniteLoopViewCell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scroll_W = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + scroll_W * .5) / scroll_W;
    [self.pageControl setCurrentPage:page % [self.imageUrls count]];
    [self.titleLabel setText:self.titles[[self.pageControl currentPage]]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidStop:(UIScrollView *)scrollView{
    NSInteger offset = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (offset == 0 || offset == ([self.collectionView numberOfItemsInSection:0] - 1)) {
        offset = [self.imageUrls count] - (offset == 0 ? 0 : 1);
        scrollView.contentOffset = CGPointMake(offset * scrollView.bounds.size.width, 0);
    }
}

#pragma mark - Setter Method
- (void)setBgViewColor:(UIColor *)bgViewColor {
    _bgViewColor = bgViewColor;
    [self.backgroundView setBackgroundColor:bgViewColor];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    [self.titleLabel setTextColor:titleTextColor];
}

- (void)setTitleTextFont:(UIFont *)titleTextFont {
    _titleTextFont = titleTextFont;
    [self.titleLabel setFont:titleTextFont];
}

- (void)setPageImage:(UIImage *)pageImage {
    _pageImage = pageImage;
    [self.pageControl setValue:pageImage forKey:@"_pageImage"];
    [self.pageControl setPageIndicatorTintColor:[UIColor clearColor]];
}

- (void)setCurrentPageImage:(UIImage *)currentPageImage {
    _currentPageImage = currentPageImage;
    [self.pageControl setValue:currentPageImage forKey:@"_currentPageImage"];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor clearColor]];
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor {
    _pageIndicatorColor = pageIndicatorColor;
    [self.pageControl setPageIndicatorTintColor:pageIndicatorColor];
}

- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor {
    _currentPageIndicatorColor = currentPageIndicatorColor;
    [self.pageControl setCurrentPageIndicatorTintColor:currentPageIndicatorColor];
}

- (void)setHideTitleLabel:(BOOL)hideTitleLabel {
    _hideTitleLabel = hideTitleLabel;
    [self.titleLabel setHidden:hideTitleLabel];
    [self.backgroundView setHidden:hideTitleLabel];
}

- (void)setHideCover:(BOOL)hideCover {
    _hideCover = hideCover;
    [self.coverView setHidden:hideCover];
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    [self.coverView setBackgroundColor:coverColor];
}

- (void)setAnimationType:(InfiniteLoopViewAnimationType)animationType {
    _animationType = animationType;
    switch (animationType) {
        case InfiniteLoopViewAnimationTypeFade:
            [self.animation setType:kCATransitionFade];
            break;
        case InfiniteLoopViewAnimationTypeMoveIn:
            [self.animation setType:kCATransitionMoveIn];
            break;
        case InfiniteLoopViewAnimationTypePush:
            [self.animation setType:kCATransitionPush];
            break;
        case InfiniteLoopViewAnimationTypeReveal:
            [self.animation setType:kCATransitionReveal];
            break;
        case InfiniteLoopViewAnimationTypePageCurl:
            [self.animation setType:@"pageCurl"];
            break;
        case InfiniteLoopViewAnimationTypePageUnCurl:
            [self.animation setType:@"pageUnCurl"];
            break;
        case InfiniteLoopViewAnimationTypeOglFlip:
            [self.animation setType:@"oglFlip"];
            break;
        case InfiniteLoopViewAnimationTypeCube:
            [self.animation setType:@"cube"];
            break;
        case InfiniteLoopViewAnimationTypeSuckEffect:
            [self.animation setType:@"suckEffect"];
            break;
        case InfiniteLoopViewAnimationTypeRippleEffect:
            [self.animation setType:@"rippleEffect"];
            break;
        case InfiniteLoopViewAnimationTypeCameraIrisHollowOpen:
            [self.animation setType:@"cameraIrisHollowOpen"];
            break;
        case InfiniteLoopViewAnimationTypeCameraIrisHollowClose:
            [self.animation setType:@"cameraIrisHollowClose"];
            break;
        default:
            break;
    }
}

- (void)setAnimationDirection:(InfiniteLoopViewAnimationDirection)animationDirection {
    _animationDirection = animationDirection;
    switch (animationDirection) {
        case InfiniteLoopViewAnimationDirectionRight:
            [self.animation setSubtype:kCATransitionFromRight];
            break;
        case InfiniteLoopViewAnimationDirectionLeft:
            [self.animation setSubtype:kCATransitionFromLeft];
            break;
        case InfiniteLoopViewAnimationDirectionTop:
            [self.animation setSubtype:kCATransitionFromTop];
            break;
        case InfiniteLoopViewAnimationDirectionBottom:
            [self.animation setSubtype:kCATransitionFromBottom];
            break;
        default:
            break;
    }
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    [self.animation setDuration:animationDuration];
}

#pragma mark -
- (CATransition *)animation {
    if (!_animation) {
        _animation = [CATransition animation];
        [_animation setDuration:self.animationDuration];
        [_animation setFillMode:kCAFillModeForwards];
        [_animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    }
    return _animation;
}

- (void)dealloc {
    [self removeTimer];
}

@end

