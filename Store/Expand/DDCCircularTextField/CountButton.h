//
//  CountButton.h
//  DayDayCook
//
//  Created by sunlimin on 17/2/8.
//  Copyright © 2017年 GFeng. All rights reserved.
//


@protocol CountButtonDelegate;

@interface CountButton : UIButton

@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, getter=isCounting, assign) BOOL counting;
@property (nonatomic, weak) id<CountButtonDelegate> delegate;

- (void)startCountDown;

@end

@protocol CountButtonDelegate <NSObject>

- (void)countButton:(CountButton *)button countDownFinished:(BOOL)isFinished;

@end
