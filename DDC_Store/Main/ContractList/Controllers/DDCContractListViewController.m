//
//  DDCContractListViewController.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractListViewController.h"
#import "DDCLoginRegisterViewController.h"
#import "DDCStore.h"

@interface DDCContractListViewController()

@end

@implementation DDCContractListViewController

@dynamic view;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self login];
    [self makeUI];
}

#pragma mark - Private
- (void)login
{
    __weak typeof(self) weakSelf = self;
    if (![DDCStore sharedInstance].user)
    {
        [DDCLoginRegisterViewController loginWithTarget:self successHandler:^(BOOL success) {
            if (success)
            {
                [weakSelf reloadPage];
            }
        }];
    }
}

- (void)makeUI
{
    
}

#pragma mark - Getters

@end
