//
//  CreateContactViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "CreateContractViewController.h"

//Controllers
#import "DDCAddPhoneNumViewController.h"
#import "EditClientInfoViewController.h"
#import "AddContractInfoViewController.h"
#import "FinishContractViewController.h"

//View
#import "DDCNavigationBar.h"

@interface CreateContractViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong)UIPageViewController *pageViewController;
@property (nonatomic,strong)DDCNavigationBar     *navBar;
@property (nonatomic,strong)NSMutableArray       *vcs;
@property (nonatomic,assign)NSUInteger            selectedIndex;

@end

@implementation CreateContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVBAR_HI+STATUSBAR_HI);
    }];
    
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self addChildViewController:self.pageViewController];
    
     //创建pageViewController的子控制器
    DDCAddPhoneNumViewController *phoneNumVC = [[DDCAddPhoneNumViewController alloc]init];
    phoneNumVC.index = 0;
    phoneNumVC.view.backgroundColor =[UIColor redColor];
    [self.vcs addObject:phoneNumVC];
    
    EditClientInfoViewController *clientInfoVC =[[EditClientInfoViewController alloc]init];
    clientInfoVC.index = 1;
    clientInfoVC.view.backgroundColor =[UIColor blueColor];

    [self.vcs addObject:clientInfoVC];
    
    AddContractInfoViewController *contractInfoVC = [[AddContractInfoViewController alloc]init];
    contractInfoVC.index = 2;
    [self.vcs addObject:contractInfoVC];
    
    FinishContractViewController *finishVC = [[FinishContractViewController alloc] init];
    finishVC.index = 3;
    [self.vcs addObject:finishVC];
    
    [self.pageViewController setViewControllers:@[phoneNumVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];//

}

#pragma mark 协议UIPageViewControllerDelegate相关
#pragma mark 协议UIPageViewControllerDataSource相关
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int index = ((ChildContractViewController *)viewController).index;
    index--;
    if (index < 0 || index == NSNotFound) return nil;
    return self.vcs[index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index = ((ChildContractViewController *)viewController).index;
    index++;
    if (index >= self.vcs.count) return nil;
    return self.vcs[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{

}

#pragma mark - backAction
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - navigationController 返回手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    NSArray *gestureRecognizers = self.navigationController.view.gestureRecognizers;
    if (gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

#pragma mark - Getters-
- (DDCNavigationBar *)navBar
{
    if(!_navBar)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"创建新合同";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _navBar = [[DDCNavigationBar alloc]initWithFrame:CGRectZero titleView:titleLabel leftButton:backBtn rightButton:rightBtn];
        _navBar.bottomLineHidden = NO;
    }
    return _navBar;
}


- (UIPageViewController *)pageViewController
{
    if(!_pageViewController)
    {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        _pageViewController.view.backgroundColor = [UIColor grayColor];
        NSArray *views = _pageViewController.view.subviews;
        for (UIView *v in views) {
            if([v isKindOfClass:[UIScrollView class]])
            {
                ((UIScrollView *)v).pagingEnabled = YES;
//                [((UIScrollView *)v).panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
            }
        }
    }
    return _pageViewController;
}

- (NSMutableArray *)vcs
{
    if(!_vcs)
    {
        _vcs = [NSMutableArray array];
    }
    return _vcs;
}

@end
