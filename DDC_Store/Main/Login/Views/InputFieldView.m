//
//  TabBarView.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/7.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "InputFieldView.h"
#import "CircularTextFieldView.h"
#import "CircularTextFieldWithExtraButtonView.h"
#import "CountButton.h"

@interface InputFieldView () <CountButtonDelegate>

//@property (nonatomic, getter = isMainlandOfChina, assign) BOOL mainlandOfChina;
@property (nonatomic, assign) int padding;

@end

@implementation InputFieldView
@synthesize firstTextFieldView = _firstTextFieldView;
@synthesize secondTextFieldView = _secondTextFieldView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.firstTextFieldView];
        [self addSubview:self.secondTextFieldView];
        
        [self setupViewConstraints];
    }
    return self;
}

#pragma mark - private

- (void)setupViewConstraints
{
    CGFloat kWidth = X_SCALER(275.0f, 424.0f);
    CGFloat kHeight = 145.0f * 0.3;
    CGFloat kTextFieldMargin = (DEVICE_WIDTH - kWidth) / 2;
    
    [self.firstTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.0f);;
        make.height.equalTo(self).multipliedBy(0.3);
        make.left.equalTo(self).offset(kTextFieldMargin);
        make.right.equalTo(self).offset(-kTextFieldMargin);
        make.centerX.equalTo(self);
    }];
    
    [self.secondTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTextFieldView.mas_bottom).offset(10.0f);
        make.height.equalTo(self).multipliedBy(0.3);
        make.left.equalTo(self).offset(kTextFieldMargin);
        make.right.equalTo(self).offset(-kTextFieldMargin);
        make.centerX.equalTo(self);
    }];
    
    self.firstTextFieldView.cornerRadius = kHeight / 2 ;
    self.secondTextFieldView.cornerRadius = kHeight / 2 ;

}

#pragma mark - CountButtonDelegate

- (void)countButton:(CountButton *)button countDownFinished:(BOOL)isFinished
{
    if (isFinished && ![Tools isBlankString:self.firstTextFieldView.textField.text] && [Tools isPhoneNumber:self.firstTextFieldView.textField.text]) {
        
        [button setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        button.enabled = YES;
    }
}

#pragma mark - events
- (void)needSecureText:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.secondTextFieldView.textField.secureTextEntry = !sender.selected;
}

#pragma mark - getter

- (CircularTextFieldWithExtraButtonView *)firstTextFieldView
{
    if (!_firstTextFieldView) {
        _firstTextFieldView  = [[CircularTextFieldWithExtraButtonView alloc] init];

        _firstTextFieldView.textField.placeholder = NSLocalizedString(@"请输入用户名 ", @"LoginRegisterViewController");
        _firstTextFieldView.button.delegate = self;
        _firstTextFieldView.extraButton.delegate = self;

    }
    return _firstTextFieldView;
}

- (CircularTextFieldView *)secondTextFieldView
{
    if (!_secondTextFieldView) {
        _secondTextFieldView = [[CircularTextFieldView alloc] initWithType:CircularTextFieldViewTypeNormal];
        _secondTextFieldView.textField.placeholder = NSLocalizedString(@"请输入密码", @"LoginRegisterViewController");
        _secondTextFieldView.textField.secureTextEntry =YES;
        [_secondTextFieldView.button addTarget:self action:@selector(needSecureText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondTextFieldView;
}

@end
