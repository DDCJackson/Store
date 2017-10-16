//
//  SubmitButton.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/10.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "SubmitButton.h"

@implementation SubmitButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_FONTGRAY;
        self.layer.cornerRadius = 22.5f;
        self.layer.shadowColor = COLOR_FONTGRAY.CGColor;
        self.layer.shadowRadius = 6.0f;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.6;
        [self setImage:[UIImage imageNamed:@"sign_btn_next"] forState:UIControlStateNormal];
        self.adjustsImageWhenDisabled = NO;
    }
    return self;
}

#pragma mark - private

- (void)enableButtonWithType:(SubmitButtonType)type
{
    switch (type) {
        case SubmitButtonTypeDefault:
        {
            //self.enabled = NO;
            self.backgroundColor = COLOR_FONTGRAY;
            self.layer.shadowColor = COLOR_FONTGRAY.CGColor;
            [self setImage:[UIImage imageNamed:@"sign_btn_next"] forState:UIControlStateNormal];
        }
            break;
        case SubmitButtonTypeNext:
        {
            //self.enabled = YES;
            self.backgroundColor = COLOR_MAINORANGE;
            self.layer.shadowColor = COLOR_MAINORANGE.CGColor;
            [self setImage:[UIImage imageNamed:@"sign_btn_next"] forState:UIControlStateNormal];

        }
            break;
        case SubmitButtonTypeCommit:
        {
            //self.enabled = YES;
            self.backgroundColor = COLOR_MAINORANGE;
            self.layer.shadowColor = COLOR_MAINORANGE.CGColor;
            [self setImage:[UIImage imageNamed:@"sign_btn_finish"] forState:UIControlStateNormal];

        }
            break;
        case SubmitButtonTypeUnCommittable:
        {
            //self.enabled = NO;
            self.backgroundColor = COLOR_FONTGRAY;
            self.layer.shadowColor = COLOR_FONTGRAY.CGColor;
            [self setImage:[UIImage imageNamed:@"sign_btn_finish"] forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
}

@end
