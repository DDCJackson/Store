//
//  InputFieldCell.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  重置高度
 *  @param height 高度
 */
- (void)resetHeight:(CGFloat)height;

@end
