//
//  PayResultViewController.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "PayResultViewController.h"
#import "DDCButtonView.h"
#import "DDCNavigationBar.h"
#import "ContractDetailsViewController.h"

@interface PayResultViewController ()

@property (nonatomic, strong) DDCNavigationBar *navBar;
@property (nonatomic, copy) NSString *contractId;

@end

@implementation PayResultViewController

- (instancetype)initWithContractId:(NSString *)contractId
{
    if (self = [super init]) {
        _contractId = contractId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付结果";

    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64.0f);
    }];
    
    DDCButtonView *toastView = [DDCButtonView initWithType:DDCContentModelTypeImageTop titleBlock:^(UILabel * _Nonnull titleLabel) {
        NSString *former = @"支付成功", *latter = @"已收到付款";
        NSMutableAttributedString *targetString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",former,latter]];
        [targetString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24.0f weight:UIFontWeightMedium], NSForegroundColorAttributeName:COLOR_474747} range:NSMakeRange(0, former.length)];
        [targetString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium], NSForegroundColorAttributeName:COLOR_A5A4A4} range:NSMakeRange(former.length+1, latter.length)];
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineSpacing = 12.0f;
//        pStyle.lineHeightMultiple = 8;
//        pStyle.maximumLineHeight = 6;
//        pStyle.minimumLineHeight = 10;
        [targetString addAttributes:@{NSParagraphStyleAttributeName:pStyle} range:NSMakeRange(0, former.length + latter.length)];
        titleLabel.attributedText = targetString;
        titleLabel.textAlignment = NSTextAlignmentCenter;
    } image:[UIImage imageNamed:@"icon_paySuccess_toast"] interval:30.0f clickAction:nil];
    toastView.enable = NO;
    [self.view addSubview:toastView];
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(200.0f);
        make.height.mas_equalTo(250.0f);
        make.top.equalTo(self.navBar).with.offset(250.0f);
    }];
    self.previousPageBtn.title = @"查看合同";
    self.nextPageBtn.title = @"完成";
    self.nextPageBtn.clickable = YES;
}


- (void)backwardPreviousPage
{
    //查看合同
    ContractDetailsViewController *detailVC = [[ContractDetailsViewController alloc] initWithDetailsID:self.contractId];
    [self.navigationController.topViewController.navigationController pushViewController:detailVC animated:YES];
}

- (void)forwardNextPage
{
    //完成
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (DDCNavigationBar *)navBar
{
    if(!_navBar)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _navBar = [[DDCNavigationBar alloc]initWithFrame:CGRectZero titleView:titleLabel leftButton:backBtn rightButton:rightBtn];
        _navBar.bottomLineHidden = NO;
    }
    return _navBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
