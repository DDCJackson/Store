//
//  FinishContractViewController.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "FinishContractViewController.h"
#import "PayWayModel.h"
#import "PayWayCell.h"
#import "PayWaysHeaderView.h"
#import "DDCPayInfoAPIManager.h"

static float  const kSideMargin = 134.0f;

@interface FinishContractViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) NSMutableArray<PayWayModel *> *data;

@end

@implementation FinishContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildInterface];
    [self getData];
}

- (void)buildInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(kSideMargin);
        make.right.equalTo(self.view).with.offset(-kSideMargin);
    }];
}

- (BOOL)isNeedReloadData
{
    return !self.data.count;
}

- (void)reloadPage
{
    [self getData];
}

- (void)getData
{
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table reloadData];
    return;
    
    dispatch_group_t requestGroup = dispatch_group_create();
    [DDCPayInfoAPIManager getAliPayPayInfoWithTradeNO:nil payMethodId:nil productId:nil totalAmount:nil requestGroup:requestGroup successHandler:^(id data) {
        //self.data
    } failHandler:^(NSError *error) {
        
    }];
    
    [DDCPayInfoAPIManager getWeChatPayInfoWithTradeNO:nil payMethodId:nil productId:nil totalAmount:nil requestGroup:requestGroup successHandler:^(id data) {
        //self.data
    } failHandler:^(NSError *error) {
        
    }];
    
    dispatch_group_notify(requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //self.data
        dispatch_async(dispatch_get_main_queue(), ^{
            self.table.delegate = self;
            self.table.dataSource = self;
            [self.table reloadData];
        });
    });

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [PayWaysHeaderView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.table dequeueReusableHeaderFooterViewWithIdentifier:kPayWaysHeaderViewId];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayWayCell heightWithData:self.data[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayWayCell *cell = [self.table dequeueReusableCellWithIdentifier:kPayWayCellId];
    [cell showCellWithData:self.data[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selected = self.data[indexPath.row].isSelected;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayWayModel *selectModel = self.data[indexPath.row];
    if (selectModel.isSelected) return;
//    if (self.selectedBlock) {
        for (int i=0; i<self.data.count; i++) {
            PayWayModel *m = self.data[i];
            m.isSelected = NO;
        }
        selectModel.isSelected = YES;
        [self.table reloadData];
//        self.selectedBlock(m);
//    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray<PayWayModel *> *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
        NSArray *iconList = @[@"icon_pay_wechat", @"icon_pay_alipay", @"icon_pay_offline"];
        NSArray *titleList = @[@"微信支付", @"支付宝支付", @"已完成线下支付"];
        NSArray *descriptionList = @[@"", @"", @"(请在确认收到款项后勾选此项)"];
        for (int i=0; i<titleList.count; i++) {
            PayWayModel *pModel = [[PayWayModel alloc] init];
            pModel.isEnable = YES;
            pModel.icon = iconList[i];
            pModel.name = titleList[i];
            pModel.Description = descriptionList[i];
            pModel.urlSting = @"http://www.baidu.com";
            pModel.money = @"30240.05";
            [_data addObject:pModel];
        }
        _data.lastObject.isEnable = NO;
    }
    return _data;
}


- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.scrollEnabled = NO;
        _table.tableFooterView = [[UIView alloc] init];
        [_table registerClass:[PayWayCell class] forCellReuseIdentifier:kPayWayCellId];
        [_table registerClass:[PayWaysHeaderView class] forHeaderFooterViewReuseIdentifier:kPayWaysHeaderViewId];
    }
    return _table;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
