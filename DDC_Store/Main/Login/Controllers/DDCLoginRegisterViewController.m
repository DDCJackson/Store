//
//  LoginRegisterViewController.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/7.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCLoginRegisterViewController.h"
#import "InputFieldView.h"
#import "CircularTextFieldView.h"
#import "CircularTextFieldWithExtraButtonView.h"
#import "CountButton.h"
#import "UIView+DDCToast.h"
#import "SubmitButton.h"
#import "DDCStore.h"
#import "DDCUserModel.h"

#import "MyNavgationController.h"

static const CGFloat kOffsetHeight = 105.0f;
static const CGFloat kInputFieldViewHeight = 145.0f;

@interface DDCLoginRegisterViewController ()<UITextFieldDelegate,InputFieldViewDelegate>

@property (nonatomic, getter= isLoginState, assign) BOOL loginState;
@property (nonatomic, strong) CircularTextFieldWithExtraButtonView *firstTextFieldView;
@property (nonatomic, assign) BOOL userNameValidated;
@property (nonatomic, assign) BOOL passwordValidated;
@property (nonatomic, assign) int padding;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation DDCLoginRegisterViewController
@synthesize icon = _icon;
@synthesize inputFieldView = _inputFieldView;
@synthesize submitButton = _submitButton;
@synthesize backgroundImage = _backgroundImage;

#pragma mark - UIView

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.inputFieldView];
    [self.contentView addSubview:self.submitButton];
    [self.contentView addSubview:self.contentLabel];
    
    [self setupViewConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Class Method

+ (void)loginWithTarget:(UIViewController *)targetController successHandler:(SuccessHandler)successHandler
{
    DDCLoginRegisterViewController *loginVC = [[DDCLoginRegisterViewController alloc]init];
    loginVC.successHandler = successHandler;
    MyNavgationController *loginNav=[[MyNavgationController alloc]initWithRootViewController:loginVC];
    loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [targetController presentViewController:loginNav animated:YES completion:nil];
}

#pragma mark - private

- (void)setupViewConstraints
{
    CGFloat kSize = X_SCALER(40.0f, 50.0f) ;
    CGFloat kIconWidth = X_SCALER(140.0f, 202.0f);
    CGFloat kTopMargin = 30.f;
    
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(212.0f);
        make.width.mas_equalTo(kIconWidth);
        make.height.mas_equalTo(kSize);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.inputFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(102.0f);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(kInputFieldViewHeight);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputFieldView.mas_bottom).offset(kTopMargin);
        make.width.height.mas_equalTo(45.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}

- (BOOL)checkPhoneNumberOrEmail:(NSString *)string
{
    if ([Tools isBlankString:string]) {
        [self.view makeDDCToast:NSLocalizedString(@"请输入用户名", @"") image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
        return NO;
    }
    
//    if (string.length < 11) {
//        [self.view makeToast:NSLocalizedString(@"请将手机号输入完整", @"LoginController")];
//        return NO;
//    }
//    if (![Tools isPhoneNumber:string]) {
//        [self.view makeToast:NSLocalizedString(@"您输入的手机号有误，请检查", @"LoginController")];
//        return NO;
//    }
    return YES;

}

- (void)loginActionWithUserName:(NSString *)userName password:(NSString *)password
{
    [Tools showHUDAddedTo:self.view];
    self.submitButton.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DDCUserModel * u = [[DDCUserModel alloc] init];
        u.nickname = @"张多多";
        u.username = @"张多多用户名";
        u.ID = @"1000";
        u.imgUrlStr = @"http://img.zcool.cn/community/0125b557c448900000012e7e64446f.jpg";
        [DDCStore sharedInstance].user = u;
        [Tools showHUDAddedTo:self.view animated: NO];
        if (self.successHandler)
        {
            self.successHandler(YES);
        }
    });
}

#pragma mark - UITapGestureRecognizer

- (void)tapGestureAction
{
    [self.view endEditing:YES];
}

#pragma mark - notification

-(void)keyboardWillShow:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.23 animations:^{
        self.icon.alpha = 0;
        self.contentView.frame = CGRectMake(0, - kOffsetHeight, DEVICE_WIDTH, DEVICE_HEIGHT);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.23 animations:^{
        self.icon.alpha = 1;
        self.contentView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    }];
}

#pragma mark - UITextFieldDelegate

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
    } else if (textField == self.inputFieldView.secondTextFieldView.textField){//密码输入长度不超过20个字符
        if (existedLength - selectedLength + replaceLength > 20) {
            
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == self.inputFieldView.firstTextFieldView.textField) {
        self.userNameValidated = textField.text.length > 0;
    } else {
        self.passwordValidated = NO;
    
        if (textField.text.length > 5) {//输入6位密码
            self.passwordValidated = YES;
        }
    }
    
    if (self.userNameValidated && self.passwordValidated) {
        [self.submitButton enableButtonWithType:SubmitButtonTypeNext];
    } else {
        [self.submitButton enableButtonWithType:SubmitButtonTypeDefault];
    }
}

#pragma mark - InputFieldViewDelegate

- (void)inputFieldView:(InputFieldView *)view QuickLogin:(BOOL)quickLogin
{
    self.firstTextFieldView.type = CircularTextFieldViewTypeNormal;
//        self.firstTextFieldView.type = CircularTextFieldViewTypeLabelButton;
    [self.submitButton enableButtonWithType:SubmitButtonTypeDefault];
}

- (void)getVerificationCodeClick:(CountButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.loginState) {
        self.firstTextFieldView.button.enabled = NO;
    } else {
        self.firstTextFieldView.extraButton.enabled = NO;
    }
    
    NSString *phoneNumber = self.inputFieldView.firstTextFieldView.textField.text;
    
    if ([Tools isBlankString:phoneNumber]) {
        [self.view makeDDCToast:NSLocalizedString(@"请输入手机号", @"") image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
        return;
    }
    
    if (![Tools isPhoneNumber:phoneNumber]) {
        [self.view makeDDCToast:NSLocalizedString(@"您输入手机号有误，请检查!", @"") image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
        return;
    }
    
    if (sender.isCounting) {
        return;
    }
    
    NSString *type = @"2";
    if (!self.loginState) {
        type = @"0";
    }
}

- (void)submitForm
{
    [self.view endEditing:YES];

    NSString *userName = self.inputFieldView.firstTextFieldView.textField.text;
    NSString *password = self.inputFieldView.secondTextFieldView.textField.text;
    
    if (![self checkPhoneNumberOrEmail:userName]) {
        return;
    }
    
    if (!password || password.length <= 5 )
    {
        [self.view makeDDCToast:NSLocalizedString(@"请输入密码!", @"LoginController") image:[UIImage imageNamed:@"addCar_icon_fail"]];
        return;
    }
    
    [self loginActionWithUserName:userName password:password];
}

#pragma mark - getter

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sign_logo"]];
    }
    return _icon;
}

- (InputFieldView *)inputFieldView
{
    if (!_inputFieldView) {
        _inputFieldView = [[InputFieldView alloc] initWithFrame:CGRectZero];
        [_inputFieldView.firstTextFieldView.button addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_inputFieldView.firstTextFieldView.extraButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        _inputFieldView.delegate = self;
        _inputFieldView.secondTextFieldView.textField.delegate = self;
        _inputFieldView.firstTextFieldView.textField.delegate = self;
        [_inputFieldView.firstTextFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_inputFieldView.secondTextFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        self.firstTextFieldView = _inputFieldView.firstTextFieldView;
    }
    return _inputFieldView;
}

- (UIImageView *)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sign_img_bg"]];
    }
    return _backgroundImage;
}

- (SubmitButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[SubmitButton alloc] initWithFrame:CGRectZero];
        [_submitButton addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton enableButtonWithType:SubmitButtonTypeDefault];

    }
    return _submitButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _contentLabel.textColor = UIColor.blackColor;
        _contentLabel.text = NSLocalizedString(@"登陆账号", @"");
    }
    return _contentLabel;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

@end
