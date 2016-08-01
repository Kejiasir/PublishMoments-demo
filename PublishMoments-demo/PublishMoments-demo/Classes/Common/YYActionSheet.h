//
//  YYActionSheet.h
//  PublishMoments-demo
//
//  Created by Arvin on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedIndexBlock)(NSInteger index);

@class YYActionSheet;
@protocol YYActionSheetDelegate <NSObject>

@optional
/*!
 *  @brief YCYActionSheet将要显示
 *  @param actionSheet YCYActionSheet
 */
- (void)willPresentActionSheet:(YYActionSheet *)actionSheet;

/*!
 *  @brief YCYActionSheet已经显示
 *  @param actionSheet YCYActionSheet
 */
- (void)didPresentActionSheet:(YYActionSheet *)actionSheet;

@required
/*!
 *  @brief 被选中的按钮
 *  @param actionSheet YCYActionSheet
 *  @param buttonIndex 选中按钮的Index(取消按钮默认为最后一个按钮)
 */
- (void)actionSheet:(YYActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface YYActionSheet : UIView
/// 标题
@property (strong,nonatomic) NSString *titleText;
/// 取消标题
@property (strong,nonatomic) NSString *cancelText;
/// 代理属性
@property (nonatomic, weak) id<YYActionSheetDelegate> delegate;

/*!
 *  @brief 初始化YCYActionSheet(委托回调结果)
 *  @param title                  ActionSheet标题
 *  @param delegate               委托
 *  @param cancelButtonTitle      取消按钮标题
 *  @param otherButtonTitles      其他按钮标题
 *  @return YCYActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<YYActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;

/*!
 *  @brief 初始化YCYActionSheet(Block回调结果)
 *  @param title             ActionSheet标题
 *  @param block             Block回调选中的Index
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题
 *  @return YCYActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title
               clickedAtIndex:(ClickedIndexBlock)block
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;

/*!
 *  @brief 显示ActionSheet
 */
- (void)show;

/*!
 *  @brief 添加按钮
 *  @param title 按钮标题
 *  @return 按钮的Index
 */
- (NSInteger)addButtonWithTitle:(NSString *)title;

@end
