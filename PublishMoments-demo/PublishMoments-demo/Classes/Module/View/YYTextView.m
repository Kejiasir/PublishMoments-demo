//
//  YYTextView.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/4.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYTextView.h"

@interface YYTextView ()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation YYTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // add placeHolder Label
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        [self addSubview:placeHolderLabel];
        
        self.placeHolderLabel = placeHolderLabel;
        self.placeHolderLabel.numberOfLines = 0;
        
        // add notification observer text did change
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChange)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)textChange {
    // hidden placeHolderLabel
    [self.placeHolderLabel setHidden:self.text.length > 0];
}

#pragma mark - Setter Method
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolderLabel.font = font;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    self.placeHolderLabel.textColor = placeHolderColor;
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWindth =  self.w - 8 * 2;
    // calculate text size
    CGSize placeHolderSize =
    [self.placeHolder boundingRectWithSize:CGSizeMake(labelWindth, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:self.placeHolderLabel.font}
                                   context:nil].size;
    // self.placeHolderLabel.backgroundColor = [UIColor redColor];
    self.placeHolderLabel.frame = CGRectMake(8, 10, labelWindth, placeHolderSize.height);
}

- (void)dealloc {
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
