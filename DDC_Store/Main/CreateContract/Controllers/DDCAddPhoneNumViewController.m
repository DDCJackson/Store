//
//  DDCAddPhoneNumViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCAddPhoneNumViewController.h"
#import "DDCBarBackgroundView.h"
#import "InputFieldCell.h"
#import "TitleCollectionCell.h"
#import "CountButton.h"
#import "DDCPhoneCodeInputFieldCell.h"

#import "DDCPhoneCheckAPIManager.h"

@interface DDCAddPhoneNumViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    BOOL _phoneValidated;
    BOOL _codeValidated;
}
@property (nonatomic, strong) DDCBarBackgroundView * view;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, strong) CircularTextFieldWithExtraButtonView * phoneTextField;
@property (nonatomic, strong) CircularTextFieldView * codeTextField;

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
            __strong typeof(weakSelf) sself = weakSelf;
            if (sself->_codeValidated && sself->_phoneValidated)
            {

                
                [Tools showHUDAddedTo:sself.view animated:YES];
#warning Move before submitting app
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [Tools showHUDAddedTo:sself.view animated:NO];
                    
                    DDCCustomerModel * model = [[DDCCustomerModel alloc] init];
                    model.userName = self.phone;
                    [sself.delegate nextPageWithModel:model];
                });
#warning uncomment before submitting
//                [DDCPhoneCheckAPIManager checkPhoneNumber:sself.phone code:sself.code successHandler:^(DDCCustomerModel *customerModel) {
//                    [Tools showHUDAddedTo:sself.view animated:NO];
////                    [sself.delegate nextPage];
//                } failHandler:^(NSError *err) {
//                    [Tools showHUDAddedTo:sself.view animated:NO];
//                    NSString * errStr = err.userInfo[NSLocalizedDescriptionKey];
//                    if (!errStr)
//                    {
//                        errStr = NSLocalizedString(@"网络不给力，请稍后再试", @"");
//                    }
//                    [sself.view makeDDCToast:errStr image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
//                }];
            }
        }
    }];
    [self.view.bottomBar addBtn:btn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view.collectionView setContentInset:UIEdgeInsetsMake(25, 0, 0, 0)];
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.collectionView.backgroundColor = UIColor.whiteColor;
    
    self.view.collectionView.scrollEnabled = NO;
    self.view.collectionView.delegate = self;
    self.view.collectionView.dataSource = self;
    [self.view.collectionView registerClass:[DDCPhoneCodeInputFieldCell class] forCellWithReuseIdentifier:NSStringFromClass([DDCPhoneCodeInputFieldCell class])];
    [self.view.collectionView registerClass:[InputFieldCell class] forCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class])];
    [self.view.collectionView registerClass:[TitleCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class])];
}

#pragma mark - Events
- (void)getVerificationCodeClick:(CountButton *)btn
{
    [DDCPhoneCheckAPIManager getVerificationCodeWithPhoneNumber:self.phone successHandler:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 200 || [responseObj[@"code"] integerValue] == 201) {
            [btn startCountDown];
        } else if ([responseObj[@"code"] integerValue] == 414) {
            DLog(@"已经注册了");
        } else {
            [self.view makeDDCToast:responseObj[@"msg"] image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
            
            self.phoneTextField.button.enabled = YES;
        }
    } failHandler:^(NSError *error) {
        [self.view makeDDCToast:NSLocalizedString(@"您的网络不稳定，请稍后重试！", @"") image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
        
//            self.firstTextFieldView.button.enabled = YES;
      
            self.phoneTextField.button.enabled = YES;
        
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制字符长度
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField == self.phoneTextField.textField) {
        
        if (existedLength - selectedLength + replaceLength > 11) {//手机号输入长度不超过11个字符
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextField.textField) {
        
        if (textField.text.length == 11) {//输入11个字符
            if (!self.phoneTextField.button.isCounting) {//按钮没有在计时 才可点亮
                self.phoneTextField.enabled = YES;
            }
            _phoneValidated = YES;
        }
    }
    else if (textField.text.length > 3) {//输入4位验证码
        _codeValidated = YES;
    }
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        TitleCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class]) forIndexPath:indexPath];
        if (indexPath.section == 0)
        {
            [cell configureWithTitle:NSLocalizedString(@"手机号码", @"") isRequired:YES tips:@"" isShowTips:NO];
        }
        else
        {
            [cell configureWithTitle:NSLocalizedString(@"验证码", @"") isRequired:YES tips:@"" isShowTips:NO];
        }
        return cell;
    }
    else
    {
        if (indexPath.section == 0)
        {
            DDCPhoneCodeInputFieldCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DDCPhoneCodeInputFieldCell class]) forIndexPath:indexPath];
            [cell.inputFieldView.button addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.inputFieldView.extraButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell configureWithPlaceholder:NSLocalizedString(@"请输入手机号码", @"") delegate:self];
            self.phoneTextField = cell.inputFieldView;
            return cell;
        }
        else
        {
            InputFieldCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class]) forIndexPath:indexPath];
            [cell configureWithPlaceholder:NSLocalizedString(@"请输入验证码", @"")];
            self.codeTextField = cell.textFieldView;
            return cell;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        return CGSizeMake(DEVICE_WIDTH - (134*2), 16);
    }
    else
    {
        return CGSizeMake(DEVICE_WIDTH- (134*2), 60);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(35., 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

#pragma mark - Setters
- (void)setPhoneTextField:(CircularTextFieldWithExtraButtonView *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField = phoneTextField;
        [_phoneTextField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneTextField.textField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.textField.delegate = self;
    }
}

- (void)setCodeTextField:(CircularTextFieldView *)codeTextField
{
    if (!_codeTextField)
    {
        _codeTextField = codeTextField;
        [_codeTextField.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.textField.delegate = self;
    }
}

#pragma mark - Getters

- (NSString *)phone
{
    if (self.phoneTextField)
    {
        return self.phoneTextField.textField.text;
    }
    else
    {
        return @"";
    }
}

- (NSString *)code
{
    if (self.codeTextField)
    {
        return self.codeTextField.textField.text;
    }
    else
    {
        return @"";
    }
}

@end
