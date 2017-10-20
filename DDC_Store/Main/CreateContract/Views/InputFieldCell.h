//
//  InputFieldCell.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContractInfoViewModel;
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

- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

- (void)clickeDoneBtn:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

- (void)clickFieldBehindBtn;

@end

@interface InputFieldCell : UICollectionViewCell

@property (nonatomic,weak)id <InputFieldCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate> delegate;
@property (nonatomic,strong)NSIndexPath  *indexPath;
@property (nonatomic,assign)InputFieldCellStyle style;
@property (nonatomic,strong)CircularTextFieldView *textFieldView;
@property (nonatomic,strong)CircularButton *btn;

/*
 *  congfigure cell
 *  @param placeholder  占位符
 */
- (void)configureWithPlaceholder:(NSString *)placeholder;


/*
 *  congfigure cell  
 *  @param viewModel
 */
- (void)configureCellWithViewModel:(ContractInfoViewModel *)viewModel;

/*
 *  congfigure cell
 *  @param viewModel
 *  @param btnTitle    用于textField后面有btn的情况
 */
- (void)configureCellWithViewModel:(ContractInfoViewModel *)viewModel btnTitle:(NSString *)btnTitle;


/*
 *  congfigure cell
 *  @param viewModel
 *  @param extraTitle   用于textField尾部有文字的情况
 */
- (void)configureCellWithViewModel:(ContractInfoViewModel *)viewModel extraTitle:(NSString *)extraTitle;

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
