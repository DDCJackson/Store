//
//  DDCUserCheckViewController.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCUserCheckViewController.h"
#import "InputFieldView.h"

@interface DDCUserCheckViewController () <UITextFieldDelegate>
{
    BOOL _phoneValidated;
    BOOL _codeValidated;
}

@property (nonatomic, strong) InputFieldView * inputFieldView;

@end

@implementation DDCUserCheckViewController

@dynamic view;

- (void)loadView
{
    self.view = [[DDCBarBackgroundView alloc] initWithRectCornerTopCollectionViewFrame:self.view.bounds hasShadow:NO];
    
    __weak typeof(self) weakSelf = self;
    DDCBottomButton * btn = [[DDCBottomButton alloc] initWithTitle:NSLocalizedString(@"下一步", @"") style:DDCBottomButtonStylePrimary handler:^{
        //        weakSelf.
    }];
//    self.view.bottomBar addBtn:
}

#pragma mark - Events
- (void)getVerificationCodeClick:(UIButton *)btn
{
    
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制字符长度
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField == self.inputFieldView.firstTextFieldView.textField) {
        
        if (existedLength - selectedLength + replaceLength > 11) {//手机号输入长度不超过11个字符
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.inputFieldView.firstTextFieldView.textField) {

        if (textField.text.length == 11) {//输入11个字符
            if (!self.inputFieldView.firstTextFieldView.button.isCounting) {//按钮没有在计时 才可点亮
                self.inputFieldView.firstTextFieldView.enabled = YES;
            }
            _phoneValidated = YES;
        }
    }
    else if (textField.text.length > 3) {//输入4位验证码
        _codeValidated = YES;
    }
}

#pragma mark - Getters
- (InputFieldView *)inputFieldView
{
    if (!_inputFieldView)
    {
        _inputFieldView = [[InputFieldView alloc] init];
        [_inputFieldView.firstTextFieldView.button addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_inputFieldView.firstTextFieldView.extraButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        _inputFieldView.secondTextFieldView.textField.delegate = self;
        _inputFieldView.firstTextFieldView.textField.delegate = self;
        [_inputFieldView.firstTextFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_inputFieldView.secondTextFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputFieldView;
}

@end
    
    
