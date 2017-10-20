//
//  PayResultViewController.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "PayResultViewController.h"
#import "DDCButtonView.h"

@interface PayResultViewController ()

@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付结果";

    DDCButtonView *toastView = [DDCButtonView initWithType:DDCContentModelTypeImageTop titleBlock:^(UILabel * _Nonnull titleLabel) {
        NSString *former = @"支付成功", *latter = @"已收到付款";
        NSMutableAttributedString *targetString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",former,latter]];
        [targetString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24.0f weight:UIFontWeightMedium], NSForegroundColorAttributeName:COLOR_474747} range:NSMakeRange(0, former.length)];
        [targetString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium], NSForegroundColorAttributeName:COLOR_A5A4A4} range:NSMakeRange(former.length, latter.length)];
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineSpacing = 2.0f;
        pStyle.lineHeightMultiple = 8;
        pStyle.maximumLineHeight = 6;
        pStyle.minimumLineHeight = 10;
        [targetString addAttributes:@{NSParagraphStyleAttributeName:pStyle} range:NSMakeRange(0, former.length + latter.length)];
        titleLabel.attributedText = targetString;
        
    } image:[UIImage imageNamed:@"icon_paySuccess_toast"] interval:10.0f clickAction:nil];
    toastView.enable = NO;
    [self.view addSubview:toastView];
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(196.0f);
    }];
    self.previousPageBtn.title = @"查看合同";
    self.nextPageBtn.title = @"完成";
    self.nextPageBtn.clickable = YES;
}


- (void)backwardPreviousPage
{
    //查看合同
}

- (void)forwardNextPage
{
    //完成
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
