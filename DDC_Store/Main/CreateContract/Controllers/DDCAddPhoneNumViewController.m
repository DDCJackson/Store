//
//  DDCAddPhoneNumViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCAddPhoneNumViewController.h"
#import "InputFieldView.h"

#import "DDCPhoneCheckAPIManager.h"

@interface DDCAddPhoneNumViewController () <UITextFieldDelegate>
{
    BOOL _phoneValidated;
    BOOL _codeValidated;
}

@property (nonatomic, strong) InputFieldView * inputFieldView;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * code;

@end

@implementation DDCAddPhoneNumViewController

@dynamic view;

- (void)loadView
{
    self.view = [[DDCBarBackgroundView alloc] initWithRectCornerTopCollectionViewFrame:CGRectZero hasShadow:NO];
    
    __weak typeof(self) weakSelf = self;
    DDCBottomButton * btn = [[DDCBottomButton alloc] initWithTitle:NSLocalizedString(@"下一步", @"") style:DDCBottomButtonStylePrimary handler:^{
        if (weakSelf)
        {
            DDCAddPhoneNumViewController * sself = weakSelf;
            if (sself->_codeValidated && sself->_phoneValidated)
            {
                [Tools showHUDAddedTo:sself.view animated:YES];
                [DDCPhoneCheckAPIManager checkPhoneNumber:sself.phone code:sself.code successHandler:^(DDCCustomerModel *customerModel) {
                    [Tools showHUDAddedTo:sself.view animated:NO];
                    [sself.delegate nextPage];
                } failHandler:^(NSError *err) {
                    [Tools showHUDAddedTo:sself.view animated:NO];
                    [sself.view makeToast:err.userInfo[NSLocalizedDescriptionKey]];
                }];
            }
        }
    }];
    [self.view.bottomBar addBtn:btn];
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

- (NSString *)phone
{
    return self.inputFieldView.firstTextFieldView.textField.text;
}

- (NSString *)code
{
    return self.inputFieldView.secondTextFieldView.textField.text;
}

@end
