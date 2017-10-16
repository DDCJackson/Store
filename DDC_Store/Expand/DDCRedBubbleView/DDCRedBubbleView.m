//
//  DDCRedBubbleVIew.m
//  DayDayCook
//
//  Created by sunlimin on 17/3/1.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCRedBubbleView.h"

@interface DDCRedBubbleView ()

@property (nonatomic, assign) BOOL animationShow;

@end

static const CGFloat kPadding = 10.0f;

@implementation DDCRedBubbleView

@synthesize imageView = _imageView;
@synthesize numberLabel = _numberLabel;
@synthesize plusLabel = _plusLabel;

- (instancetype)initWithType:(DDCRedBubbleViewType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)setupImageTypeViewConstraints
{
    self.alpha = 0;//默认隐藏
    self.userInteractionEnabled = NO;

    [self addSubview:self.imageView];
    [self addSubview:self.numberLabel];
    [self addSubview:self.plusLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(-3, 0, 0, 0));
    }];
    [self.plusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(8);
        make.top.equalTo(self).offset(4);
        make.right.equalTo(self).offset(-4);
    }];
}

- (void)setupNormalTypeViewConstraints
{
    self.alpha = 1;

    self.userInteractionEnabled = NO;
    [self addSubview:self.numberLabel];
    [self addSubview:self.plusLabel];
    self.backgroundColor = COLOR_MAINORANGE;
    self.numberLabel.font = [UIFont systemFontOfSize:10.0f];
    self.plusLabel.font = [UIFont systemFontOfSize:8.0f];
    
    [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.plusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(5);
        make.top.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
    }];
}

#pragma mark - public

- (void)popUpBubble:(BOOL)isShow notificationCount:(NSString *)notificationCount completion:(void (^)(BOOL finished))completion
{
    
    if (isShow) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *numberTemp = [numberFormatter numberFromString:notificationCount];
        self.messageCount = numberTemp;
        if (!self.animationShow) {
            [self showBubbleWithCompletion:completion];
        }
    } else {
        self.alpha = 0;//默认隐藏
    }
}

#pragma mark - private

- (void)showBubbleWithCompletion:(void (^)(BOOL finished))completion
{
    self.animationShow = YES;
    if (IS_IPHONE_DEVICE) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y -  kPadding, self.frame.size.width, self.frame.size.height);
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [self hideBubbleWithCompletion:completion];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(self.frame.origin.x + kPadding / 2, self.frame.origin.y , self.frame.size.width, self.frame.size.height);
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [self hideBubbleWithCompletion:completion];
        }];
    }
}

- (void)hideBubbleWithCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = self.originFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        completion(YES);
        self.animationShow = NO;

    }];
}

#pragma mark - getter && setter

- (void)setOriginFrame:(CGRect)originFrame
{
    _originFrame = self.frame = originFrame;
}

- (void)setType:(DDCRedBubbleViewType)type
{
    _type = type;
    
    switch (type) {
        case DDCRedBubbleViewTypeNormal:
        {
            [self setupNormalTypeViewConstraints];
        }
            break;
        case DDCRedBubbleViewTypeImageBackground:
        {
            [self setupImageTypeViewConstraints];
        }
            break;
        default:
            break;
    }
}

- (void)setMessageCount:(NSNumber *)messageCount
{
    self.hidden = NO;
    if (messageCount.integerValue > 99) {
        self.numberLabel.text = @"99";
        self.plusLabel.hidden = NO;
    } else if (messageCount.integerValue > 0){
        self.numberLabel.text = messageCount.stringValue;
        self.plusLabel.hidden = YES;
    } else {
        self.hidden = YES;
    }
}

#pragma mark - getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redBubble_icon"]];
        
        if (IS_IPAD_DEVICE) {
            _imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
    }
    return _imageView;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:14.0f];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = @"99";
    }
    return _numberLabel;
}

- (UILabel *)plusLabel
{
    if (!_plusLabel) {
        _plusLabel = [[UILabel alloc] init];
        _plusLabel.font = [UIFont systemFontOfSize:12.0f];
        _plusLabel.textAlignment = NSTextAlignmentCenter;
        _plusLabel.textColor = [UIColor whiteColor];
        _plusLabel.text = @"+";
        _plusLabel.hidden = YES;

    }
    return _plusLabel;
}

@end
