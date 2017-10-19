//
//  DDCBackstageLabel.m
//  DayDayCook
//
//  Created by sunlimin on 2017/5/25.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCBackstageButton.h"
#import "TestViewController.h"

@implementation DDCBackstageButton

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        self.backgroundColor = COLOR_MAINORANGE;
        self.layer.cornerRadius = CGRectGetHeight(frame) / 2;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self setTitle:@"测试" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}


@end
