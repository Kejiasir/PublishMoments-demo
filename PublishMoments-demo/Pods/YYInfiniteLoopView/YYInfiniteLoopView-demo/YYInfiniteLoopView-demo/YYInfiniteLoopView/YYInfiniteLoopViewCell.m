//
//  YYInfiniteLoopViewCell.m
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYInfiniteLoopViewCell.h"
#import "UIImageView+WebCache.h"

@interface YYInfiniteLoopViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YYInfiniteLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setImageUrl:(NSURL *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:imageUrl
                      placeholderImage:self.placeholderImg
                               options:SDWebImageRetryFailed];
}

- (void)setPlaceholderImg:(UIImage *)placeholderImg {
    _placeholderImg = placeholderImg;
}

@end

