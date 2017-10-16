//
//  CircularTextFieldView.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/7.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "CircularTextFieldView.h"
#import "CountButton.h"

@implementation CircularTextFieldView
@synthesize contentView = _contentView;
@synthesize button = _button;
@synthesize textField = _textField;

- (instancetype)initWithType:(CircularTextFieldViewType)type
{
    self = [super init];
    if (self) {
        [self addSubview:self.contentView];
        [self addSubview:self.textField];
        [self addSubview:self.button];
        [self setupViewConstraints];

        self.type = type;
    }
    return self;
}

#pragma mark - private

- (void)setupViewConstraints
{

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.bottom.right.equalTo(self);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(14.0f);
        make.right.equalTo(self.button.mas_left);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-14.0f);;
        make.width.mas_equalTo(CGFLOAT_MIN);
    }];
}

#pragma mark - getter && setter

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.shadowColor = COLOR_FONTGRAY.CGColor;
        _contentView.layer.shadowRadius = 5.0f;
        _contentView.layer.shadowOpacity = 0.4;
        _contentView.layer.shadowOffset = CGSizeMake(0, 2);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.adjustsFontSizeToFitWidth = YES;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (CountButton *)button
{
    if (!_button) {
        _button = [[CountButton alloc]init];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [_button setTitle:NSLocalizedString(@"获取验证码", @"LoginRegisterViewController") forState:UIControlStateNormal];
        [_button setTitleColor:COLOR_FONTGRAY forState:UIControlStateNormal];
        
    }
    return _button;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
}

- (void)setType:(CircularTextFieldViewType)type
{
    switch (type) {
        case CircularTextFieldViewTypeNormal:
        {
            [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(CGFLOAT_MIN);
            }];
        }
            break;
        case CircularTextFieldViewTypeLabelButton:
        {
            [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(60.0f);
            }];
        }
            break;
        case CircularTextFieldViewTypeImageButton:
        {
            [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(30.0f);
            }];
            
            [self.button setTitle:@"" forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"btn_password_nodisplay"] forState:UIControlStateNormal];
            [self.button setImage:[UIImage imageNamed:@"btn_password_display"] forState:UIControlStateSelected];

        }
            break;
        default:
            break;
    }
}

@end
