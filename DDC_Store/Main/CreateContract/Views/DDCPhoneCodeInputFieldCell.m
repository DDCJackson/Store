//
//  DDCPhoneCodeInputFieldCell.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/19/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCPhoneCodeInputFieldCell.h"
#import "CountButton.h"


@interface DDCPhoneCodeInputFieldCell() <CountButtonDelegate>

@end

@implementation DDCPhoneCodeInputFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self.contentView addSubview:self.inputFieldView];
    [self setConstraints];
    
    return self;
}

- (void)setConstraints
{
    CGFloat height = 45;
    [self.inputFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(height);
    }];
    self.inputFieldView.cornerRadius = height/2.0;
    self.btn.layer.cornerRadius = height/2.0;
}

- (void)configureWithPlaceholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate
{
    self.inputFieldView.textField.placeholder = placeholder;
    self.inputFieldView.textField.delegate = delegate;
}

#pragma mark - CountButtonDelegate

- (void)countButton:(CountButton *)button countDownFinished:(BOOL)isFinished
{
    if (isFinished && ![Tools isBlankString:self.inputFieldView.textField.text] && [Tools isPhoneNumber:self.inputFieldView.textField.text]) {
        
        [button setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        button.enabled = YES;
    }
}

#pragma mark - Getters

- (CircularTextFieldWithExtraButtonView *)inputFieldView
{
    if (!_inputFieldView)
    {
        _inputFieldView  = [[CircularTextFieldWithExtraButtonView alloc] initWithType:CircularTextFieldViewTypeLabelButton];
//        _inputFieldView.showExtraButton = YES;
        _inputFieldView.button.delegate = self;
        _inputFieldView.extraButton.delegate = self;
    }
    return _inputFieldView;
}

- (CountButton *)btn
{
    return self.inputFieldView.extraButton;
}

@end
