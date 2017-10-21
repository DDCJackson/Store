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
#import "DDCBarBackgroundView.h"

//models
#import "DDCContractDetailsModel.h"

//API
#import "ContractDetailsAPIManager.h"

#define  kTableLeftPadding   (IPAD_X_SCALE(54))
#define  kTableRightPadding  (IPAD_X_SCALE(54))
#define  kTableTopPadding    (NAVBAR_HI+STATUSBAR_HI+IPAD_Y_SCALE(32))

@interface ContractDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)DDCBarBackgroundView *barView;
@property (nonatomic,strong)DDCNavigationBar *navBar;
@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation ContractDetailsViewController

- (instancetype)initWithDetailsID:(NSString *)detailsID
{
    if(self = [super init])
    {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
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
        make.top.equalTo(self.view).offset(kTableTopPadding);
        make.left.equalTo(self.view).offset(kTableLeftPadding);
        make.right.equalTo(self.view).offset(-kTableRightPadding);
        make.bottom.equalTo(self.view);
    }];
}

- (void)getData
{
    [ContractDetailsAPIManager getContractDetailsID:@"" withSuccessHandler:^(DDCContractDetailsModel *model) {
        
    } failHandler:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContractDetailsCell class])];
    DDCContractDetailsModel *model = [[DDCContractDetailsModel alloc]init];
//    model.title = @"合同编号";
//    model.desc = @"张多多";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureContactDetailsCellWithModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContractDetailsCell height];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContractDetailsHeaderView *headerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ContractDetailsHeaderView class])];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [ContractDetailsHeaderView height];
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

- (DDCBarBackgroundView *)barView
{
    if(!_barView)
    {
        _barView = [[DDCBarBackgroundView alloc]initWithRectCornerTopTableViewFrame:CGRectMake(0, 0, DEVICE_WIDTH-kTableLeftPadding-kTableRightPadding, DEVICE_HEIGHT-kTableTopPadding) hasShadow:YES];
        _barView.tableView.delegate = self;
        _barView.tableView.dataSource = self;
        _barView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        //register
        [ _barView.tableView registerClass:[ContractDetailsHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ContractDetailsHeaderView class])];
        [ _barView.tableView  registerClass:[ContractDetailsCell class] forCellReuseIdentifier:NSStringFromClass([ContractDetailsCell class])];
        
        [_barView.bottomBar addBtn:[[DDCBottomButton alloc]initWithTitle:@"编辑合同" style:DDCBottomButtonStylePrimary handler:^{
            DLog(@"编辑合同");
        }]];
        _barView.bottomBar.hidden = YES;
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
