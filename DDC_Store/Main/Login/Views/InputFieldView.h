//
//  TabBarView.h
//  DayDayCook
//
//  Created by sunlimin on 17/2/7.
//  Copyright © 2017年 GFeng. All rights reserved.
//

@class CircularTextFieldView;
@class CircularTextFieldWithExtraButtonView;

@protocol InputFieldViewDelegate;

@interface InputFieldView : UIView

@property (nonatomic, strong, readonly) CircularTextFieldWithExtraButtonView *firstTextFieldView;
@property (nonatomic, strong, readonly) CircularTextFieldView *secondTextFieldView;
@property (nonatomic, assign) BOOL bottomHidden;
@property (nonatomic, weak) id<InputFieldViewDelegate> delegate;

@end

@protocol InputFieldViewDelegate <NSObject>

- (void)inputFieldView:(InputFieldView *)view QuickLogin:(BOOL)quickLogin;

@end
