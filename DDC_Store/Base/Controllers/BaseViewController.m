//
//  BaseViewController.m
//  iCarCenter
//
//  Created by Storm on 14-4-28.
//  Copyright (c) 2014年 Storm. All rights reserved.
//

#import "BaseViewController.h"
#import "Tools.h"
#import "DDCButton.h"
#import "DDCRedBubbleView.h"

static const CGFloat kRedBubbleWidth =  25.0f;
static const CGFloat kRedBubbleHeight = 12.0f;

static const CGFloat kRedBubbleWidthIPad =  26.0f;
static const CGFloat kRedBubbleHeightIpad = 14.0f;

static const CGFloat kRedBubbleTag = 800;

@interface BaseViewController ()
{
    NSInteger prewTag ; //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
    float prewMoveY; //编辑的时候移动的高度
    CALayer * _redDotLayer;
    UIBarButtonItem * _rightSpace;
}
@property (nonatomic,strong)DDCRedBubbleView *redBubbleView;

@end

@implementation BaseViewController

/**
 开始编辑UITextField的方法
 */
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFrame = textField.frame;
    float textY = textFrame.origin.y+textFrame.size.height;
    float bottomY = self.view.frame.size.height-textY;
    if(bottomY>=216) //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {
        prewTag = -1;
        return;
    }
    prewTag = textField.tag;
    float moveY = 216-bottomY;
    prewMoveY = moveY;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}
/**
 结束编辑UITextField的方法，让原来的界面还原高度
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    { //还原界面
        moveY = prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.view.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
}

- (id)init
{
    if (!(self = [super init])) {return nil;}
    
    _redDotLayer = [[CALayer alloc] init];
    _redDotLayer.backgroundColor = COLOR_REDDOT.CGColor;
    _rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary* textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:(IS_IPHONE_DEVICE ? 14.0f:16.0f) weight:UIFontWeightMedium]};
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)setRightNaviBtnImage:(UIImage *)img withRightSpacing:(CGFloat)rightSpacing
{
    self.rightNaviBtn = [DDCButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, 44, 44);
    //[self.rightNaviBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.rightNaviBtn setImage:img forState:UIControlStateNormal];
    //    [self.rightNaviBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.rightNaviBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.rightNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _rightSpace.width = -rightSpacing;
    self.navigationItem.rightBarButtonItems=@[_rightSpace,rightButton];
}

-(void)setRightNaviBtnTitle:(NSString *)str withRightSpacing:(CGFloat)rightSpacing
{
    UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    CGFloat h = 44;
    CGFloat w = 0;
    if (str)
    {
        w = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, h) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    }
    self.rightNaviBtn = [DDCButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.contentMode = UIViewContentModeCenter;
    self.rightNaviBtn.frame=CGRectMake(0, 0, w, h);
    [self.rightNaviBtn setTitle:str forState:UIControlStateNormal];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    self.rightNaviBtn.titleLabel.font= font;
    [self.rightNaviBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.rightNaviBtn setEnlargeEdgeWithTop:20 right:10 bottom:20 left:20];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    
    _rightSpace.width = -rightSpacing;
    self.navigationItem.rightBarButtonItems=@[_rightSpace,rightButton];
}

-(void)rightNaviBtnAddRedDot
{
    _redDotLayer.frame = CGRectMake(self.rightNaviBtn.bounds.size.width-14, 10, 5, 5);
    _redDotLayer.cornerRadius = 3;
    [self.rightNaviBtn.layer addSublayer:_redDotLayer];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightNaviBtn];
    self.navigationItem.rightBarButtonItems = @[_rightSpace, rightButton];
}

-(void)rightNaviBtnRemoveRedDot
{
    if (_redDotLayer)
    {
        [_redDotLayer removeFromSuperlayer];
    }
}

- (void)navBtn:(UIButton *)navBtn addRedDotWithNumber:(NSNumber *)number
{
    DDCRedBubbleView *redView = (DDCRedBubbleView *)[navBtn viewWithTag:kRedBubbleTag];
    if(!redView)
    {
        [navBtn addSubview:self.redBubbleView];
    }
    self.redBubbleView.messageCount = number;
    
    CGFloat topPading;
    if (@available(iOS 11.0, *)) {
        topPading = -8;
    }
    else
    {
        topPading = 3;
    }
    if(number.stringValue.length==1)
    {
        [self.redBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navBtn).with.offset(topPading);
            make.centerX.equalTo(navBtn).with.offset(7);
            make.width.mas_equalTo((IS_IPHONE_DEVICE ? kRedBubbleHeight:kRedBubbleHeightIpad));
            make.height.mas_equalTo((IS_IPHONE_DEVICE ? kRedBubbleHeight:kRedBubbleHeightIpad));
        }];
    }
    else
    {
        [self.redBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navBtn).with.offset(topPading);
            make.centerX.equalTo(navBtn).with.offset(7);
            make.width.mas_equalTo((IS_IPHONE_DEVICE ? kRedBubbleWidth:kRedBubbleWidthIPad));
            make.height.mas_equalTo((IS_IPHONE_DEVICE ? kRedBubbleHeight:kRedBubbleHeightIpad));
        }];
    }
}

- (void)rightNaviBtnPressed
{
    
}

-(void)setLeftNaviBtnImage
{
    [self setLeftNaviBtnImage:[UIImage imageNamed:@"whiteback"]];
}

- (void)setLeftNaviBtnImage:(UIImage *)img
{
    if (!img) return;
    
    UIButton *leftButton = [DDCButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:0];
    [leftButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    leftButton.imageView.tintColor = [UIColor blackColor];
    leftButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.leftNaviBtn = leftButton;
//    UIView *leftView = [[UIView alloc] initWithFrame:leftButton.bounds];
//    leftView.bounds = CGRectOffset(leftView.bounds, -6, 0);
//    [leftView addSubview:leftButton];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

-(void)setLeftNaviBtnTitle:(NSString*)str{
    self.leftNaviBtn = [DDCButton buttonWithType:UIButtonTypeCustom];
    self.leftNaviBtn.frame=CGRectMake(0, 0, 44, 44);
    //    [self.rightNaviBtn setBackgroundImage:[UIImage imageNamed:@"home_update.png"] forState:UIControlStateNormal];
    [self.leftNaviBtn setTitle:str forState:UIControlStateNormal];
    self.leftNaviBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.leftNaviBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.leftNaviBtn.backgroundColor=[UIColor clearColor];
    [self.leftNaviBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftNaviBtn];
    self.navigationItem.leftBarButtonItem=leftButton;
}

-(void)showLoadingView{ //开始加载  需要手动关闭;
   MBProgressHUD* progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHud];
    [self.view bringSubviewToFront:progressHud];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    //_progressHud.delegate = self;
    //_HUD.labelText = cString;
    [progressHud show:YES];
    [progressHud setTag:9955];
}

-(void)stopLoadingView
{ //关闭加载;
     [[self.view viewWithTag:9955]removeFromSuperview];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (DDCRedBubbleView *)redBubbleView
{
    if (!_redBubbleView) {
        _redBubbleView = [[DDCRedBubbleView alloc] initWithType:DDCRedBubbleViewTypeNormal];
        _redBubbleView.alpha = 1;
        _redBubbleView.tag = kRedBubbleTag;
        _redBubbleView.layer.cornerRadius = (IS_IPHONE_DEVICE ? kRedBubbleHeight:kRedBubbleHeightIpad)/2;
    }
    return _redBubbleView;
}

@end
