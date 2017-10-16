//
//  CountButton.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/8.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "CountButton.h"

static const CGFloat countTime = 60.0f;

@implementation CountButton

#pragma mark - public

- (void)startCountDown
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    self.countDown = countTime;
    self.enabled = NO;
    [self setTitleColor:COLOR_FONTGRAY forState:UIControlStateNormal];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];

}

#pragma mark - private

- (void)countDownTime
{
    self.counting = YES;
    self.countDown--;
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"已发送(%lds)", @"LoginRegisterViewController"), (long)self.countDown] forState:UIControlStateNormal];
    if (self.countDown == 0) {
        self.counting = NO;
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"重新发送", @"LoginRegisterViewController")] forState:UIControlStateNormal];

        if ([self.delegate respondsToSelector:@selector(countButton:countDownFinished:)]) {
            [self.delegate countButton:self countDownFinished:YES];
        }

    }
}

#pragma mark - getter && setter

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        [self setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
    } else {
        [self setTitleColor:COLOR_FONTGRAY forState:UIControlStateNormal];
    }
}

@end
