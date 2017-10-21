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
#import "PayResultViewController.h"

static float  const kSideMargin = 134.0f;

@interface FinishContractViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray<PayWayModel *> *data;
@property (nonatomic, assign) BOOL isFinished;

@end

@implementation FinishContractViewController

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    self.isFinished = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildInterface];
    [self getData];
//    __autoreleasing NSNumber *state = self.dataTimerState = @(0);
//    [self repeatExecuteWithTimeInterval:60*60 stop:&state action:@selector(getData) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRepeatExecuteFuction) name:DDC_PayCancelShow_Notification object:nil];
}


- (void)buildInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(kSideMargin);
        make.right.equalTo(self.view).with.offset(-kSideMargin);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-[DDCBottomBar height]);
    }];
    
    self.nextPageBtn.title = @"完成";
    self.nextPageBtn.clickable = YES;
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
//    return;
    

    
    [Tools showHUDAddedTo:self.view];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    NSString *contractNO = @"DDCKC-021011701-15084141988888";
    NSString *productId = @"33";
    NSString *money = @"0.01";
    [DDCPayInfoAPIManager getAliPayPayInfoWithContractNO:contractNO payMethodId:@"1" productId:productId totalAmount:money requestGroup:requestGroup successHandler:^(NSString *qrCodeUrl, NSString *tradeNO) {
        self.data[1].urlSting = qrCodeUrl;
        self.data[1].tradeNo = tradeNO;
    } failHandler:^(NSError *error) {
        
    }];
    
    
    contractNO = @"DDCKC-021011701-15084141999999";
    productId = @"33";
    money = @"0.01";
    
    [DDCPayInfoAPIManager getWeChatPayInfoWithContractNO:contractNO payMethodId:@"2" productId:productId totalAmount:money requestGroup:requestGroup successHandler:^(NSString *qrCodeUrl, NSString *tradeNO) {
        self.data[0].urlSting = qrCodeUrl;
        self.data[0].tradeNo = tradeNO;
    } failHandler:^(NSError *error) {

    }];
    
    dispatch_group_notify(requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //self.data
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools hiddenHUDFromSuperview];
            [self.table reloadData];
            if (!self.isFinished) {
                [self performSelector:@selector(getData) withObject:nil afterDelay:60*60];
            }
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
        for (int i=0; i<self.data.count; i++) {
            PayWayModel *m = self.data[i];
            m.isSelected = NO;
        }
        selectModel.isSelected = YES;
    [self.table reloadData];
    
    if ([selectModel.payMethodId isEqualToString:kOfflinePayID]) return;
    [self paySuccessHandler];
    return;

//    __autoreleasing NSNumber *timerState = selectModel.timerState;
    if ([selectModel.payMethodId isEqualToString:kAliPayPayID]){
        [self performSelector:@selector(getAliPayPayStateWithData:) withObject:selectModel afterDelay:5];
//        [self getAliPayPayStateWithTradeNO:selectModel.tradeNo];
//        [self repeatExecuteWithTimeInterval:5 stop:&timerState action:@selector(getAliPayPayStateWithTradeNO:) object:selectModel.tradeNo];
    }else if([selectModel.payMethodId isEqualToString:kWeChatPayID]){
          [self performSelector:@selector(getWeChatPayStateWithData:) withObject:selectModel afterDelay:5];
//        [self getWeChatPayStateWithTradeNO:selectModel.tradeNo];
//        [self repeatExecuteWithTimeInterval:5 stop:&timerState action:@selector(getWeChatPayStateWithTradeNO:) object:selectModel.tradeNo];
    }
}

/*
- (void)repeatExecuteWithTimeInterval:(NSTimeInterval)timeInterval stop:(NSNumber * __autoreleasing *)stop action:(SEL)action object:(id)object
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if ([*stop integerValue]) {
            dispatch_cancel(timer);
        }
        [self performSelectorOnMainThread:action withObject:object waitUntilDone:YES];
    });
    dispatch_resume(timer);
}

- (void)getAliPayPayStateWithTradeNO:(NSString *)tradeNO
{
    [DDCPayInfoAPIManager getAliPayPayStateWithTradeNO:tradeNO successHandler:^(void) {
        [self paySuccessHandler];
    } failHandler:^(NSError *error) {
        
    }];
}

- (void)getWeChatPayStateWithTradeNO:(NSString *)tradeNO
{
    [DDCPayInfoAPIManager getWeChatPayStateWithTradeNO:tradeNO successHandler:^(void) {
        [self paySuccessHandler];
    } failHandler:^(NSError *error) {
        
    }];
}
*/

- (void)getAliPayPayStateWithData:(PayWayModel *)data
{
    [DDCPayInfoAPIManager getAliPayPayStateWithTradeNO:data.tradeNo successHandler:^(void) {
        [self paySuccessHandler];
    } failHandler:^(NSError *error) {
        if (data.isSelected && !self.isFinished) {
            [self performSelector:@selector(getAliPayPayStateWithData:) withObject:data afterDelay:5];
        }
    }];
}

- (void)getWeChatPayStateWithData:(PayWayModel *)data
{
    [DDCPayInfoAPIManager getWeChatPayStateWithTradeNO:data.tradeNo successHandler:^(void) {
        [self paySuccessHandler];
    } failHandler:^(NSError *error) {
        if (data.isSelected && !self.isFinished) {
            [self performSelector:@selector(getWeChatPayStateWithData:) withObject:data afterDelay:5];
        }
    }];
}

- (void)paySuccessHandler
{
#warning ID
    self.isFinished = YES;
    PayResultViewController *prVC = [[PayResultViewController alloc] initWithContractId:@""];
    [self.navigationController pushViewController:prVC animated:YES];
}

- (void)cancelRepeatExecuteFuction
{
    self.isFinished = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDC_PayCancelShow_Notification object:nil];
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
        NSArray *payMethodIdList = @[kWeChatPayID, kAliPayPayID, kOfflinePayID];
        NSArray *descriptionList = @[@"", @"", @"(请在确认收到款项后勾选此项)"];
        for (int i=0; i<titleList.count; i++) {
            PayWayModel *pModel = [[PayWayModel alloc] init];
            pModel.icon = iconList[i];
            pModel.name = titleList[i];
            pModel.Description = descriptionList[i];
//            pModel.urlSting = @"http://www.baidu.com";
            pModel.payMethodId = payMethodIdList[i];
            pModel.totalAmount = @"30240.05";
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
