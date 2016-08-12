//
//  YYBottomView.m
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/5.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "YYBottomView.h"

@interface YYBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *mentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *whoLookBtn;
@end

@implementation YYBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.locationBtn setTag:BtnTypeLocation];
    [self.mentionBtn  setTag:BtnTypeMention];
    [self.whoLookBtn  setTag:BtnTypeWhoLook];
}

+ (instancetype)bottomView {
    return [[[NSBundle mainBundle]
             loadNibNamed:@"YYBottomView"
             owner:self
             options:nil] lastObject];
}

- (IBAction)bottomViewBtnClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
