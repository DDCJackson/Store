//
//  SubmitButton.h
//  DayDayCook
//
//  Created by sunlimin on 17/2/10.
//  Copyright © 2017年 GFeng. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SubmitButtonType) {
    SubmitButtonTypeDefault,
    SubmitButtonTypeNext,
    SubmitButtonTypeCommit,
    SubmitButtonTypeUnCommittable,
};

@interface SubmitButton : UIButton

- (void)enableButtonWithType:(SubmitButtonType)type;

@end
