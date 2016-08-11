//
//  YYPhotosView.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/4.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYPhotosView.h"
#import "SDPhotoBrowser.h"

#define ImgCountRow 4 // 每行图片数量
#define ImageMargin 8 // 图片之间间距

@interface YYPhotosView ()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) UIView *superImgView;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation YYPhotosView

#pragma mark - 添加图片
- (void)addImages:(NSMutableArray *)images {
    self.imgArr = images;
    NSInteger count = images.count;
    
    for (int i = 0; i < [self.subviews count]; i++) {
        if ([self.subviews[i] isKindOfClass:[UIButton class]]) {
            [self.subviews[i] removeFromSuperview];
        }
    }
    for (UIImageView *imageView in self.superImgView.subviews) {
        [imageView removeFromSuperview];
    }
    
    CGFloat imgW = (self.w - (self.imgCountRow + 1) * ImageMargin) / self.imgCountRow;
    CGFloat imgH = imgW;
    
    for (NSInteger index = 0; index < count; index++) {
        UIView *view = [[UIView alloc] init];
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setImage:images[index]];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [imgView setClipsToBounds:YES];
        [imgView setUserInteractionEnabled:YES];
        [imgView setTag:index];
        [view addSubview:imgView];
        [self.superImgView addSubview:view];
        
        [imgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureDidClick:)]];
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setFrame:CGRectMake(imgW-19, -8, 26, 26)];
        [deleteBtn setImage:[UIImage imageNamed:@"ycy_delete_photo"] forState:UIControlStateNormal];
        [deleteBtn setTag:index];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
        
        CGFloat imgX = ImageMargin + (imgW + ImageMargin) * (index % self.imgCountRow);
        CGFloat imgY = ImageMargin + (imgH + ImageMargin) * (index / self.imgCountRow);
        
        UIView *subView = self.superImgView.subviews[index];
        [subView setFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        UIView *subViewImg = subView.subviews[0];
        [subViewImg setFrame:CGRectMake(0, 0, imgW, imgH)];
        self.imageMaxHeight = CGRectGetMaxY(view.frame);
    }
    UIButton *addBtn = [[UIButton alloc] init];
    if (count == 9) {
        addBtn.hidden = YES;
    } else {
        CGFloat btnX = ImageMargin + (imgW + ImageMargin) * (count % self.imgCountRow);
        CGFloat btnY = ImageMargin + (imgH + ImageMargin) * (count / self.imgCountRow);
        [addBtn setFrame:CGRectMake(btnX, btnY, imgW, imgH)];
        [addBtn setImage:[UIImage imageNamed:@"ycy_add_photos"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"ycy_add_photos"] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.imageMaxHeight = (count / self.imgCountRow + 1) * (imgH + ImageMargin);
    }
    self.superImgView.frame = CGRectMake(0, 0, self.w, self.imageMaxHeight + ImageMargin);
    if ([self.delegate respondsToSelector:@selector(photosViewWithImageMaxHeight:)]) {
        [self.delegate photosViewWithImageMaxHeight:self.imageMaxHeight];
    }
}

#pragma mark - 监听按钮事件
- (void)deleteBtnClick:(UIButton *)button {
    [self.imgArr removeObjectAtIndex:button.tag];
    [self addImages:self.imgArr];
}

- (void)addButtonClick {
    if ([self.delegate respondsToSelector:@selector(photosView:withImgCount:)]) {
        [self.delegate photosView:self withImgCount:self.imgArr.count];
    }
}

- (void)pictureDidClick:(UITapGestureRecognizer *)recognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:hideKeyboardNotification object:nil];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    [browser setSourceImagesContainerView:self.superImgView];
    [browser setCurrentImageIndex:(int)recognizer.view.tag];
    [browser setImageCount:self.imgArr.count];
    [browser setHideSaveButton:@"true"];
    [browser setHideDeleteButton:@"true"];
    [browser setDelegate:self];
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = self.superImgView.subviews[index].subviews[0];
    return imageView.image;
}

#pragma mark - 懒加载
- (UIView *)superImgView {
    if (!_superImgView) {
        _superImgView = [[UIView alloc] init];
        [self addSubview:_superImgView];
    }
    return _superImgView;
}

@end
