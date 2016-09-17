//
//  YYInfiniteLoopViewLayout.m
//  YYInfiniteLoopView-demo
//
//  Created by Arvin on 16/9/2.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYInfiniteLoopViewLayout.h"

@implementation YYInfiniteLoopViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    if (CGSizeEqualToSize(self.collectionView.bounds.size, CGSizeZero)) {
        return;
    }
    [self.collectionView setBounces:NO];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self setMinimumLineSpacing:.0f];
    [self setMinimumInteritemSpacing:.0f];
    [self setItemSize:self.collectionView.bounds.size];
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
}

@end
