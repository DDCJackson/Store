//
//  CircularButton.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/10.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "CircularButton.h"

@implementation CircularButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        [self setTitleColor:COLOR_DESCGRAY forState:UIControlStateNormal];
        self.layer.shadowColor = COLOR_FONTGRAY.CGColor;
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark - setter && getter

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.layer.shadowColor = COLOR_MAINORANGE.CGColor;
        self.layer.borderColor = COLOR_MAINORANGE.CGColor;
        self.layer.borderWidth = 1.0f;
        [self setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
    } else {
        self.layer.shadowColor = COLOR_FONTGRAY.CGColor;
        self.layer.borderColor = COLOR_FONTGRAY.CGColor;
        self.layer.borderWidth = 0.0f;
        [self setTitleColor:COLOR_DESCGRAY forState:UIControlStateNormal];
    }
}

@end
