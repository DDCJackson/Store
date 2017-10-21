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
#import "DDCEditClientInfoViewController.h"
#import "AddContractInfoViewController.h"
#import "FinishContractViewController.h"

//View
#import "DDCNavigationBar.h"
#import "ContractStateInfoCell.h"
#import "ContractStateInfoViewModel.h"

@interface CreateContractViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource, ChildContractViewControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)GJObject *model;
@property (nonatomic, strong) NSMutableArray<ContractStateInfoViewModel *> *dataList;
@property (nonatomic, assign) DDCContractProgress contractProgress;
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong)UIPageViewController *pageViewController;
@property (nonatomic,strong)DDCNavigationBar     *navBar;
@property (nonatomic,strong)NSMutableArray<ChildContractViewController *>    *vcs;
@property (nonatomic,assign)NSUInteger            selectedIndex;

@end

@implementation CreateContractViewController


- (instancetype)initWithContractProgress:(DDCContractProgress)contractProgress model:(GJObject *)model
{
    if (self = [super init]) {
        _selectedIndex =_contractProgress = contractProgress;
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getData];
}

- (void)back
{
    [super back];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDC_PayCancelShow_Notification object:nil];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVBAR_HI+STATUSBAR_HI);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100.0f);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([ContractStateInfoCell height]);
    }];
    
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self addChildViewController:self.pageViewController];
    
     //创建pageViewController的子控制器
    DDCAddPhoneNumViewController *phoneNumVC = [[DDCAddPhoneNumViewController alloc]initWithDelegate:self];
    phoneNumVC.index = 0;
    [self.vcs addObject:phoneNumVC];
    
    DDCEditClientInfoViewController *clientInfoVC =[[DDCEditClientInfoViewController alloc]initWithDelegate:self];
    clientInfoVC.index = 1;

    [self.vcs addObject:clientInfoVC];
    
    AddContractInfoViewController *contractInfoVC = [[AddContractInfoViewController alloc]initWithDelegate:self];
    contractInfoVC.index = 2;
    [self.vcs addObject:contractInfoVC];
    
    FinishContractViewController *finishVC = [[FinishContractViewController alloc] initWithDelegate:self];
    finishVC.index = 3;
    [self.vcs addObject:finishVC];
    
    [self.pageViewController setViewControllers:@[self.vcs[self.selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    if(self.model)
    {
        self.vcs[self.selectedIndex].model = self.model;
    }
}

- (void)getData
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

#pragma mark 协议UICollectionViewDelegateFlowLayout相关
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContractStateInfoViewModel *model = self.dataList[indexPath.row];
    return [ContractStateInfoCell sizeWithData:model];
}
#pragma mark 协议UICollectionViewDataSource相关

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContractStateInfoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ContractStateInfoCell class]) forIndexPath:indexPath];
     ContractStateInfoViewModel *model = self.dataList[indexPath.row];
    [cell configureCellWithData:model];
    return cell;
}

#pragma mark 协议UICollectionViewDelegate相关
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
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

#pragma mark - ChildViewControllerDelegate
- (void)nextPageWithModel:(GJObject *)model
{
    if (self.selectedIndex >= self.vcs.count) return;
    self.selectedIndex++;
    
    ChildContractViewController * vc = self.vcs[self.selectedIndex];
    vc.model = model;
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)previousPageWithModel:(GJObject *)model
{
    if (self.selectedIndex == 0) return;
    self.selectedIndex--;
    
    ChildContractViewController * vc = self.vcs[self.selectedIndex];
    if (model)
    {
        vc.model = model;
    }
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
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

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ContractStateInfoCell class] forCellWithReuseIdentifier:NSStringFromClass([ContractStateInfoCell class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSMutableArray<ContractStateInfoViewModel *> *)dataList
{
    if (!_dataList) {
        NSArray *titleList = @[@"添加手机", @"编辑客户信息", @"添加合同信息", @"合同创建成功"];
        _dataList = [NSMutableArray arrayWithCapacity:titleList.count];
        NSUInteger interval = self.contractProgress - DDCContractProgress_AddPhoneNumber;
        for (int i=0; i<titleList.count; i++) {
            ContractStateInfoViewModel *model = [[ContractStateInfoViewModel alloc] init];
            model.title = titleList[i];
            
            if (i == 0) {
                model.position = ContractStateNodePositionLeft;
            }else if(i == titleList.count -1){
                model.position = ContractStateNodePositionRight;
            }else{
                model.position = ContractStateNodePositionMiddle;
            }
            
            if (i < interval) {
                model.state = ContractStateDone;
            }else if(i == interval){
                model.state = ContractStateDoing;
            }else{
                model.state = ContractStateTodo;
            }
            [_dataList addObject:model];
        }
    }
    return _dataList;
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
//                 ((UIScrollView *)v).scrollEnabled = NO;
                break;
            }
        }
    }
    return _pageViewController;
}

- (NSMutableArray<ChildContractViewController *> *)vcs
{
    if(!_vcs)
    {
        _vcs = [NSMutableArray array];
    }
    return _vcs;
}

#pragma mark - Setters-

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    self.contractProgress = DDCContractProgress_AddPhoneNumber + selectedIndex;
}

- (void)setContractProgress:(DDCContractProgress)contractProgress
{
    if (_contractProgress == contractProgress) return;
    _contractProgress = contractProgress;
    NSUInteger interval = contractProgress - DDCContractProgress_AddPhoneNumber;
    [self.dataList enumerateObjectsUsingBlock:^(ContractStateInfoViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < interval) {
            obj.state = ContractStateDone;
        }else if(idx == interval){
            obj.state = ContractStateDoing;
        }else{
            obj.state = ContractStateTodo;
        }
    }];
    [self.collectionView reloadData];
}

@end
