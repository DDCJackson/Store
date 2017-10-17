//
//  ContractDetailsViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsViewController.h"

//views
#import "ContractDetailsCell.h"
#import "ContractDetailsHeaderView.h"
#import "DDCNavigationBar.h"
#import "DDCBarBackGroundView.h"

//models
#import "ContractDetailsModel.h"

@interface ContractDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)DDCBarBackGroundView *barView;
@property (nonatomic,strong)DDCNavigationBar *navBar;

@end

@implementation ContractDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = COLOR_F8F8F8;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVBAR_HI+STATUSBAR_HI);
    }];
    
    [self.view addSubview:self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAVBAR_HI + STATUSBAR_HI + 40);
        make.left.equalTo(self.view).offset(54);
        make.right.equalTo(self.view).offset(-54);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContractDetailsCell class])];
    ContractDetailsModel *model = [[ContractDetailsModel alloc]init];
    model.title = @"合同编号";
    model.desc = @"张多多";
    [cell configureContactDetailsCellWithModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContractDetailsHeaderView *headerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ContractDetailsHeaderView class])];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

//处理不悬浮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 200;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark  - back -
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters -

- (DDCBarBackGroundView *)barView
{
    if(!_barView)
    {
        _barView = [[DDCBarBackGroundView alloc]initWithRectCornerTopTableViewFrame:CGRectMake(0, 0, self.view.frame.size.width-60, self.view.frame.size.height-NAVBAR_HI-STATUSBAR_HI-40) hasShadow:YES];
        _barView.tableView.delegate = self;
        _barView.tableView.dataSource = self;
       
        //register
        [ _barView.tableView registerClass:[ContractDetailsHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ContractDetailsHeaderView class])];
        [ _barView.tableView  registerClass:[ContractDetailsCell class] forCellReuseIdentifier:NSStringFromClass([ContractDetailsCell class])];
        
        [_barView.bottomBar addBtn:[[DDCBottomButton alloc]initWithTitle:@"编辑合同" style:DDCBottomButtonStylePrimary handler:^{
            DLog(@"编辑合同");
        }]];
    }
    return _barView;
}


- (DDCNavigationBar *)navBar
{
    if(!_navBar)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"合同详情";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBar = [[DDCNavigationBar alloc]initWithFrame:CGRectZero titleView:titleLabel leftButton:backBtn rightButton:rightBtn];
    }
    return _navBar;
}

@end
