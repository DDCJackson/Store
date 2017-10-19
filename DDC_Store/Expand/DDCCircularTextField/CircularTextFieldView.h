//
//  CircularTextFieldView.h
//  DayDayCook
//
//  Created by sunlimin on 17/2/7.
//  Copyright © 2017年 GFeng. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CircularTextFieldViewType) {
    CircularTextFieldViewTypeNormal,
    CircularTextFieldViewTypeLabelButton,
    CircularTextFieldViewTypeImageButton,
};

@class CountButton;

@interface CircularTextFieldView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) CountButton *button;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CircularTextFieldViewType type;

- (instancetype)initWithType:(CircularTextFieldViewType)type;

- (void)setPlaceholderWithColor:(UIColor *)color font:(UIFont *)font;

- (void)setBtnTitle:(NSString *)btnTitle btnFont:(UIFont *)btnFont;

@end
