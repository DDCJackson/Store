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

//models
#import "ContractDetailsModel.h"

@interface ContractDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)DDCNavigationBar *navBar;
@end

@implementation ContractDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor =[UIColor lightGrayColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVBAR_HI+STATUSBAR_HI);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAVBAR_HI + STATUSBAR_HI+40);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
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
- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(30, 60, DEVICE_WIDTH-60, DEVICE_HEIGHT-60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置阴影
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.shadowOffset = CGSizeMake(10, 10);
        _tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        //设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _tableView.bounds;
        maskLayer.path = maskPath.CGPath;
        _tableView.layer.mask = maskLayer;
        
        _tableView.bounces = NO;
        
        //register
        [_tableView registerClass:[ContractDetailsHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ContractDetailsHeaderView class])];
        [_tableView registerClass:[ContractDetailsCell class] forCellReuseIdentifier:NSStringFromClass([ContractDetailsCell class])];
    }
    return _tableView;
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
