//
//  DDCNavigationBar.m
//  DayDayCook
//
//  Created by Christopher Wood on 8/22/17.
//  Copyright © 2017 DayDayCook. All rights reserved.
//

#import "DDCNavigationBar.h"
#import <KVOController/KVOController.h>

static const float kNavBtnWidthHeight = 32.0f;
static const float kNavBtnTopPadding = 27.0f;

@interface DDCNavigationBar()
{
    struct {
        BOOL frameResized;
        BOOL leftButtonResized;
        BOOL rightButtonResized;
        BOOL titleViewResized;
    } _flags;
    
    BOOL    _showingAlternateViews;
}

// 假设不用在使用过程中切换primaryViews 如果有这个需求，可以把这些搬到h文件
@property (nonatomic, strong) UIButton  * defaultLeftButton;
@property (nonatomic, strong) UIView    * defaultTitleView;
@property (nonatomic, strong) UIButton  * defaultRightButton;

@property (nonatomic, strong) CALayer   * bottomLineLayer;

@property (nonatomic, strong) FBKVOController * KVOController;
@end

@implementation DDCNavigationBar

@synthesize leftButton = _leftButton;
@synthesize titleView = _titleView;
@synthesize rightButton = _rightButton;

+ (instancetype)defaultNavBarWithAlternateTitleView:(UIView *)alternateTitleView buttonTarget:(id)target leftButtonSelector:(SEL)leftSelector rightButtonSelector:(SEL)rightSelector
{
    UIButton * backButton = [DDCNavigationBar backButtonWithImage:[UIImage imageNamed:@"recipe_back"] target:target selector:leftSelector];
    UIButton * shareButton = [DDCNavigationBar shareButtonWithImage:[UIImage imageNamed:@"goods_share"] target:target selector:rightSelector];
    
    CGRect frame = CGRectMake(0, 0, DEVICE_WIDTH, NAVBAR_HI+STATUSBAR_HI);
    
    DDCNavigationBar * navBar = [[DDCNavigationBar alloc] initWithFrame:frame titleView:nil leftButton:backButton rightButton:shareButton];
    
    UIButton * altBackButton = [DDCNavigationBar backButtonWithImage:[UIImage imageNamed:@"icon_xiangqing_back_black"] target:target selector:leftSelector];
    UIButton * altShareButton = [DDCNavigationBar shareButtonWithImage:[UIImage imageNamed:@"icon_xiangqing_share_black"] target:target selector:rightSelector];
    navBar.alternateLeftButton = altBackButton;
    navBar.alternateTitleView = alternateTitleView;
    navBar.alternateRightButton = altShareButton;
    
    return navBar;
}

+ (UIButton *)backButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setEnlargeEdge:30];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

+ (UIButton *)shareButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:image forState:UIControlStateNormal];
    [shareButton setEnlargeEdge:30];
    [shareButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return shareButton;
}

- (instancetype)initWithFrame:(CGRect)frame
                   titleView:(UIView *)titleView
                  leftButton:(UIButton *)leftButton
                 rightButton:(UIButton *)rightButton
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    self.titleView = self.defaultTitleView = titleView;
    self.leftButton = self.defaultLeftButton = leftButton;
    self.rightButton = self.defaultRightButton = rightButton;
    
    [self.layer addSublayer:self.bottomLineLayer];
    self.layer.masksToBounds = YES;
    return self;
}

- (void)showAlternateViewsWithAnimation:(BOOL)animation callback:(void(^)())callback
{
    if (_showingAlternateViews) return;
    
    _showingAlternateViews = YES;
    
    if(animation)
    {
       [UIView animateWithDuration:0.3 animations:^{
           self.alternateLeftButton.alpha = 0.2;
           self.alternateTitleView.alpha = 0.2;
           self.alternateRightButton.alpha = 0.2;
           
       } completion:^(BOOL finished) {
           
           self.leftButton = self.alternateLeftButton;
           self.titleView = self.alternateTitleView;
           self.rightButton = self.alternateRightButton;
           
           if (self.switchViewsBlock)
           {
               self.switchViewsBlock(YES);
           }

           [UIView animateWithDuration:0.3 animations:^{
               
               self.leftButton.alpha = 1.0;
               self.titleView.alpha = 1.0;
               self.rightButton.alpha = 1.0;
           } completion:^(BOOL finished) {
               
               if (callback)
               {
                   callback();
               }
           }];
       }];
    }
    else
    {
        self.leftButton = self.alternateLeftButton;
        self.titleView = self.alternateTitleView;
        self.rightButton = self.alternateRightButton;
        
        if (self.switchViewsBlock)
        {
            self.switchViewsBlock(YES);
        }
        if (callback)
        {
            callback();
        }
    }
}

- (void)showDefaultViewsWithAnimation:(BOOL)animation callback:(void(^)())callback
{
    if (!_showingAlternateViews) return;
    
    _showingAlternateViews = NO;
    
    if(animation)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.leftButton.alpha = 0.2;
            self.titleView.alpha = 0.2;
            self.rightButton.alpha = 0.2;
            
        } completion:^(BOOL finished) {
            
            self.leftButton = self.defaultLeftButton;
            self.titleView = self.defaultTitleView;
            self.rightButton = self.defaultRightButton;
            
            if (self.switchViewsBlock)
            {
                self.switchViewsBlock(NO);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.leftButton.alpha = 1.0;
                self.titleView.alpha = 1.0;
                self.rightButton.alpha = 1.0;
           } completion:^(BOOL finished) {
            
               if (callback)
               {
                   callback();
               }
           }];
        }];
    }
    else
    {
        self.leftButton = self.defaultLeftButton;
        self.titleView = self.defaultTitleView;
        self.rightButton = self.defaultRightButton;
        
        if (self.switchViewsBlock)
        {
            self.switchViewsBlock(NO);
        }
        if (callback)
        {
            callback();
        }
    }
}

- (void)updateConstraints
{
    if (self.leftButton && (_flags.leftButtonResized || _flags.frameResized))
    {
        [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);//设计稿间距为10
            make.top.equalTo(self).with.offset(kNavBtnTopPadding);
            make.width.height.mas_equalTo(kNavBtnWidthHeight);
        }];
    }
    
    if (self.rightButton && (_flags.rightButtonResized || _flags.frameResized))
    {
        [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-20);
            make.top.equalTo(self).with.offset(kNavBtnTopPadding);
            make.width.height.mas_greaterThanOrEqualTo(kNavBtnWidthHeight);
        }];
    }
    
    if (self.titleView && (_flags.titleViewResized || _flags.frameResized))
    {
        [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            if (self.leftButton)
            {
                make.left.equalTo(self.leftButton.mas_right).with.offset(15);
            }
            if (self.rightButton)
            {
                make.right.equalTo(self.rightButton.mas_left).with.offset(-15);
            }
            make.centerY.equalTo(self.leftButton ? self.leftButton : self.rightButton ? self.rightButton : self);
        }];
    }
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_flags.frameResized)
    {
        self.bottomLineLayer.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
    }
    
    [self resetFlags];
}

- (void)resetFlags
{
    _flags.frameResized = NO;
    _flags.leftButtonResized = NO;
    _flags.titleViewResized = NO;
    _flags.rightButtonResized = NO;
}

#pragma mark - Setters
- (void)setFrame:(CGRect)frame
{
    _flags.frameResized = YES;
    [super setFrame:frame];
}

- (void)setLeftButton:(UIButton *)leftButton
{
    [self.leftButton removeFromSuperview];
    [self quitObservingFrame:self.leftButton];
    _leftButton = leftButton;
    if (leftButton)
    {
        _flags.leftButtonResized = YES;
        [self addSubview:leftButton];
        [self observeFrame:leftButton];
    }
}

- (void)setTitleView:(UIView *)titleView
{
    [self.titleView removeFromSuperview];
    [self quitObservingFrame:self.titleView];
    _titleView = titleView;
    if (titleView)
    {
        _flags.titleViewResized = YES;
        [self addSubview:titleView];
        [self observeFrame:titleView];
    }
}

- (void)setRightButton:(UIButton *)rightButton
{
    [self.rightButton removeFromSuperview];
    [self quitObservingFrame:self.rightButton];
    _rightButton = rightButton;
    if (rightButton)
    {
        _flags.rightButtonResized = YES;
        [self addSubview:rightButton];
        [self observeFrame:rightButton];
    }
}

-(void)setBottomLineHidden:(BOOL)bottomLineHidden
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _bottomLineLayer.hidden = bottomLineHidden;
    [CATransaction commit];
}

#pragma mark - Getters
-(CALayer *)bottomLineLayer
{
    if (!_bottomLineLayer)
    {
        _bottomLineLayer = [[CALayer alloc] init];
        _bottomLineLayer.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
        _bottomLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        _bottomLineLayer.hidden = YES;
    }
    return _bottomLineLayer;
}

-(BOOL)bottomLineHidden
{
    return _bottomLineLayer.hidden;
}

#pragma mark - KVO
- (void)quitObservingFrame:(UIView *)view
{
    [self.KVOController unobserve:view keyPath:@"frame"];
}

- (void)observeFrame:(UIView *)view
{
    [self.KVOController observe:view keyPath:@"frame" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        if (object == self.leftButton)
        {
            _flags.leftButtonResized = YES;
        }
        else if (object == self.titleView)
        {
            _flags.titleViewResized = YES;
        }
        else if (object == self.rightButton)
        {
            _flags.rightButtonResized = YES;
        }
        else
        {
            return;
        }
        
        [self setNeedsLayout];
    }];
}

-(void)dealloc
{
    [self.leftButton removeObserver:self forKeyPath:@"frame"];
    [self.titleView removeObserver:self forKeyPath:@"frame"];
    [self.rightButton removeObserver:self forKeyPath:@"frame"];
}

@end
