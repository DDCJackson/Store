//
//  ViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ViewController.h"

#import "ContractDetailsViewController.h"
#import "CreateContractViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBtnForDetails];
    [self createBtnForCreateContract];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)createBtnForDetails
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 50, 100, 100);
    [self.view addSubview:btn];
    [btn setTitle:@"合同详情页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(intoDetails) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createBtnForCreateContract
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 200, 100, 100);
    [self.view addSubview:btn];
    [btn setTitle:@"创建合同" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(intoCreate) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Events -
- (void)intoDetails
{
    ContractDetailsViewController *detailsVC =[[ContractDetailsViewController alloc]init];
    [self.navigationController pushViewController:detailsVC hidesBottomBarForSourceController:self animated:YES];
}

- (void)intoCreate
{
    CreateContractViewController *createVC =[[CreateContractViewController alloc] initWithContractProgress:DDCContractProgress_AddPhoneNumber model:nil];
    [self.navigationController pushViewController:createVC hidesBottomBarForSourceController:self
                                         animated:YES];
}


@end
