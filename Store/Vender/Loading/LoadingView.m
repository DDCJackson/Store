//
//  LoadingView.m
//  DayDayCook
//
//  Created by GFeng on 15/11/2.
//  Copyright (c) 2015年 GFeng. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()

@property (strong, nonatomic) UIImageView *loadingImg1;
@property (strong, nonatomic) UIImageView *loadingImg2;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation LoadingView

+ (LoadingView *)sharedLoading
{
    static dispatch_once_t token;
    static LoadingView *store;
    dispatch_once(&token, ^() {
        store = [[LoadingView alloc] init];
    });
    return store;
}

- (void)runAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [[LoadingView sharedLoading].loadingImg1.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (id)init
{
    if (self = [super init]) {
                
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.loadingImg1];
        [self.contentView addSubview:self.loadingImg2];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(82);
            make.height.mas_equalTo(107);
        }];

        [self.loadingImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(5);
            make.width.height.mas_equalTo(72);
        }];
        
        [self.loadingImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(80);
            make.width.mas_equalTo(82);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}


#pragma mark - getter
- (UIImageView *)loadingImg1
{
    if (!_loadingImg1) {
        _loadingImg1 = [[UIImageView alloc] init];
        _loadingImg1.image = [UIImage imageNamed:@"loadingIcon"];
        _loadingImg1.backgroundColor = [UIColor clearColor];
        _loadingImg1.layer.borderColor = [UIColor clearColor].CGColor;
        _loadingImg1.layer.borderWidth = 1.0f;
        _loadingImg1.layer.cornerRadius = 36.0f;
        _loadingImg1.layer.masksToBounds = YES;
    }
    
    return _loadingImg1;
}

- (UIImageView *)loadingImg2
{
    if (!_loadingImg2) {
        _loadingImg2 = [[UIImageView alloc] init];
#ifndef TARGET_IS_EXTENSION
        _loadingImg2.image = [UIImage imageNamed:NSLocalizedString(@"loadingIcon2", @"pic")];
#else
        _loadingImg2.image = [UIImage imageNamed:NSLocalizedStringFromTableInBundle(@"loadingIcon2", @"Localizable", LBundle, @"pic")];
#endif
        _loadingImg2.contentMode = UIViewContentModeCenter;
        _loadingImg2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _loadingImg2.backgroundColor = [UIColor clearColor];
    }
    
    return _loadingImg2;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = NO;
        _contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _contentView.layer.borderColor = [UIColor clearColor].CGColor;
        _contentView.layer.borderWidth = 1.0f;
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect backButtonRect = CGRectMake(0, 0, 60, 60);
    
    return !CGRectContainsPoint(backButtonRect, point);
}

@end
