//
//  CircularTextFieldWithExtraButtonView.h
//  DayDayCook
//
//  Created by sunlimin on 17/2/9.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "CircularTextFieldView.h"
@class CountButton;

@interface CircularTextFieldWithExtraButtonView : CircularTextFieldView

@property (nonatomic, strong, readonly) CountButton *extraButton;
@property (nonatomic, assign) BOOL showExtraButton;
@property (nonatomic, assign) BOOL enabled;

- (instancetype)init;

@end
