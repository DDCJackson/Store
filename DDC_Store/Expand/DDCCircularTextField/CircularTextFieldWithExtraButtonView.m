//
//  CircularTextFieldWithExtraButtonView.m
//  DayDayCook
//
//  Created by sunlimin on 17/2/9.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "CircularTextFieldWithExtraButtonView.h"
#import "CountButton.h"

@implementation CircularTextFieldWithExtraButtonView
@synthesize extraButton = _extraButton;

- (instancetype)init
{
    self = [super initWithType:CircularTextFieldViewTypeLabelButton];
    if (self) {
        [self addSubview:self.extraButton];
        [self updateViewConstraints];

    }
    return self;
}

#pragma mark - private

- (void)updateViewConstraints
{
    [self.extraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-14.0f);;
        make.width.mas_equalTo(60.0f);
    }];
}

#pragma mark - getter && setter

- (CountButton *)extraButton
{
    if (!_extraButton) {
        _extraButton = [[CountButton alloc]init];
        _extraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _extraButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [_extraButton setTitle:NSLocalizedString(@"获取验证码", @"LoginRegisterViewController") forState:UIControlStateNormal];
        [_extraButton setTitleColor:COLOR_FONTGRAY forState:UIControlStateNormal];
        _extraButton.hidden = YES;
    }
    return _extraButton;
}

- (void)setShowExtraButton:(BOOL)showExtraButton
{
    _showExtraButton = showExtraButton;
    self.button.hidden = showExtraButton;
    self.extraButton.hidden = !showExtraButton;
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.showExtraButton) {
        self.button.hidden = enabled;
        self.extraButton.hidden = !enabled;
        self.button.enabled = !enabled;
        self.extraButton.enabled = enabled;
    } else {
        self.button.hidden = !enabled;
        self.extraButton.hidden = enabled;
        self.button.enabled = enabled;
        self.extraButton.enabled = !enabled;
    }
}

@end
