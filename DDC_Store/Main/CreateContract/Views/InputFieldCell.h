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

typedef NS_ENUM(NSUInteger,InputFieldCellStyle)
{
    InputFieldCellStyleNormal = 0,
    InputFieldCellStyleNumber,
    InputFieldCellStylePicker,
    InputFieldCellStyleDatePicker
};

#import "CircularTextFieldView.h"
#import "CircularButton.h"

@protocol InputFieldCellDelegate <NSObject>

- (void)clickFieldBehindBtn;
- (void)clickToobarFinishBtn:(NSString *)str;

@end

@interface InputFieldCell : UICollectionViewCell

@property (nonatomic,weak)id <InputFieldCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate> delegate;

@property (nonatomic,assign)InputFieldCellStyle  style;

@property (nonatomic,strong)CircularTextFieldView *textFieldView;
@property (nonatomic,strong)CircularButton *btn;

/*
 *  congfigure cell
 *  @param placeholder  占位符
 *  @param text 输入框中的内容
 */
- (void)configureWithPlaceholder:(NSString *)placeholder text:(NSString *)text;

/*
 *  congfigure cell
 *  @param placeholder  占位符
 *  @param btnTitle     用于textField后面有btn的情况
 *  @param text 输入框中的内容
 */
- (void)configureWithPlaceholder:(NSString *)placeholder btnTitle:(NSString *)btnTitle text:(NSString *)text;


/*
 *  congfigure cell
 *  @param placeholder  占位符
 *  @param btnTitle     用于textField后面有文字的情况
 *  @param text 输入框中的内容
 */
- (void)configureWithPlaceholder:(NSString *)placeholder extraTitle:(NSString *)extraTitle text:(NSString *)text;

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

@end
