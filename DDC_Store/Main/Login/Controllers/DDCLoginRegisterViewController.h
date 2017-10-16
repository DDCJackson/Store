//
//  DDCLoginRegisterViewController.h
//  DayDayCook
//
//  Created by sunlimin on 17/2/7.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SuccessHandler)(BOOL success);

@class InputFieldView;
@class SubmitButton;

@interface DDCLoginRegisterViewController : BaseViewController

@property (nonatomic, strong, readonly) UIImageView *icon;
@property (nonatomic, strong, readonly) InputFieldView *inputFieldView;
@property (nonatomic, strong, readonly) SubmitButton *submitButton;
@property (nonatomic, strong, readonly) UIImageView *backgroundImage;
@property (nonatomic, copy) SuccessHandler successHandler;

+ (void)loginWithTarget:(UIViewController *)targetController successHandler:(SuccessHandler)successHandler;

@end
