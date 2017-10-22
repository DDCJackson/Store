//
//  ContractDetailsViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsViewController.h"
#import "CreateContractViewController.h"

//views
#import "ContractDetailsCell.h"
#import "ContractDetailsHeaderView.h"
#import "DDCNavigationBar.h"
#import "DDCBarBackgroundView.h"

//models
#import "DDCContractDetailsModel.h"
#import "DDCUserModel.h"
#import "DDCCustomerModel.h"

//viewModels
#import "DDCContractDetailsViewModel.h"

//API
#import "ContractDetailsAPIManager.h"

#define  kTableLeftPadding   (IPAD_X_SCALE(54))
#define  kTableRightPadding  (IPAD_X_SCALE(54))
#define  kTableTopPadding    (NAVBAR_HI+STATUSBAR_HI+IPAD_Y_SCALE(32))

@interface ContractDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString     *_detailsID;
}
@property (nonatomic,strong)DDCBarBackgroundView *barView;
@property (nonatomic,strong)DDCNavigationBar *navBar;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)DDCContractDetailsModel *detailsModel;
@property (nonatomic,strong)NSString *stateStr;
@property (nonatomic,strong)NSArray<DDCContractDetailsViewModel *> *viewModelArr;
@end

@implementation ContractDetailsViewController

- (instancetype)initWithDetailsID:(NSString *)detailsID
{
    if(self = [super init])
    {
        _detailsID = detailsID;
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
    [Tools showHUDAddedTo:self.view animated:YES];
    [ContractDetailsAPIManager getContractDetailsID:_detailsID withSuccessHandler:^(DDCContractDetailsModel *model) {
        [Tools showHUDAddedTo:self.view animated:NO];
        self.detailsModel = model;
        self.barView.bottomBar.hidden = model.showStatus!=DDCContractStatusInComplete;
        [self.barView.tableView reloadData];
    } failHandler:^(NSError *error) {
        [Tools showHUDAddedTo:self.view animated:NO];
        DLog(@"合同详情页接口失败");
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContractDetailsCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureContactDetailsCellWithModel:self.viewModelArr[indexPath.row] status:self.detailsModel.showStatus];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContractDetailsCell height];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContractDetailsHeaderView *headerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ContractDetailsHeaderView class])];
    headerView.status = self.detailsModel.showStatus;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        
        __weak typeof(self) weakSelf = self;
        [_barView.bottomBar addBtn:[[DDCBottomButton alloc]initWithTitle:@"编辑合同" style:DDCBottomButtonStylePrimary handler:^{
            DLog(@"编辑合同");
            CreateContractViewController *vc =[[CreateContractViewController alloc]initWithContractProgress:DDCContractProgress_AddContractInformation model:self.detailsModel];
            [weakSelf.navigationController pushViewController:vc animated:YES];
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
//        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        [backBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _navBar = [[DDCNavigationBar alloc]initWithFrame:CGRectZero titleView:titleLabel leftButton:backBtn rightButton:nil];
    }
    return _navBar;
}

- (NSArray<DDCContractDetailsViewModel *> *)viewModelArr
{
   return @[
      [DDCContractDetailsViewModel initWithTitle:@"合同编号" desc:self.detailsModel.infoModel.contractNo],
      [DDCContractDetailsViewModel initWithTitle:@"合同状态" desc:[DDCContractDetailsModel backendStatusArray][self.detailsModel.showStatus]],
      [DDCContractDetailsViewModel initWithTitle:@"姓名" desc:self.detailsModel.user.nickName],
      [DDCContractDetailsViewModel initWithTitle:@"性别" desc:[DDCCustomerModel genderArray][self.detailsModel.user.sex]],
      [DDCContractDetailsViewModel initWithTitle:@"年龄" desc:[NSString stringWithFormat:@"%@岁",self.detailsModel.user.age]],
      [DDCContractDetailsViewModel initWithTitle:@"生日" desc:self.detailsModel.user.formattedBirthday],
      [DDCContractDetailsViewModel initWithTitle:@"手机号码" desc:self.detailsModel.user.userName],
      [DDCContractDetailsViewModel initWithTitle:@"职业" desc:[DDCCustomerModel occupationArray][self.detailsModel.user.career]],
      [DDCContractDetailsViewModel initWithTitle:@"邮箱" desc:self.detailsModel.user.email],
      [DDCContractDetailsViewModel initWithTitle:@"渠道" desc:[DDCCustomerModel channelArray][self.detailsModel.user.channel]],
      [DDCContractDetailsViewModel initWithTitle:@"购买课程" desc:[self.detailsModel.infoModel courseString]],
      [DDCContractDetailsViewModel initWithTitle:@"生效期限" desc:[NSString stringWithFormat:@"%@-%@",self.detailsModel.infoModel.startTime,self.detailsModel.infoModel.endTime]],
      [DDCContractDetailsViewModel initWithTitle:@"有限时间" desc:self.detailsModel.infoModel.effectiveTime],
      [DDCContractDetailsViewModel initWithTitle:@"有限门店" desc:[self.detailsModel.infoModel effectiveAddressString]],
      [DDCContractDetailsViewModel initWithTitle:@"支付方式" desc:[DDCContractDetailsModel payMethodArr][self.detailsModel.payMethod]],
      [DDCContractDetailsViewModel initWithTitle:@"支付金额" desc:[NSString stringWithFormat:@"¥%@",[Tools separatedDigitStringWithString:self.detailsModel.infoModel.contractPrice]]],
      [DDCContractDetailsViewModel initWithTitle:@"责任销售" desc:self.detailsModel.createUser.name]];
}

@end
