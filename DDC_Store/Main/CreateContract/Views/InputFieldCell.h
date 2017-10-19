//
//  InputFieldCell.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircularButton;
@class CircularTextFieldView;

@protocol InputFieldCellDelegate <NSObject>

@optional;
- (void)clickFieldBehindBtn;

@end

@interface InputFieldCell : UICollectionViewCell

@property (nonatomic,weak)id <InputFieldCellDelegate> delegate;

/*
 *  congfigure cell
 *  @param placeholder  占位符
 */
- (void)configureWithPlaceholder:(NSString *)placeholder;

/*
 *  congfigure cell
 *  @param placeholder  占位符
 *  @param btnTitle     用于textField后面有btn的情况
 */
- (void)configureWithPlaceholder:(NSString *)placeholder btnTitle:(NSString *)btnTitle;


/*
 *  congfigure cell
 *  @param placeholder  占位符
 *  @param btnTitle     用于textField后面有文字的情况
 */
- (void)configureWithPlaceholder:(NSString *)placeholder extraTitle:(NSString *)extraTitle;

/*
 *  重置高度
 *  @param height 高度
 */
- (void)resetHeight:(CGFloat)height;

/*
 *  高度
 *  return height
 */

+ (CGFloat)height;

/*
 *  return 是否为空
 */
- (BOOL)isBlankOfTextField;

/*
 *  设置textField的tag值和text值
 */
- (void)setTextFieldTag:(NSInteger)tag text:(NSString *)text;

@end
