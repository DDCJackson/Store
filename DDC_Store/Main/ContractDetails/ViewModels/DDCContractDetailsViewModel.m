//
//  DDCContractDetailsViewModel.m
//  DDC_Store
//
//  Created by DAN on 2017/10/21.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCContractDetailsViewModel.h"

@implementation DDCContractDetailsViewModel

+ (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc
{
    DDCContractDetailsViewModel *viewModel = [[DDCContractDetailsViewModel alloc]init];
    viewModel.title = title;
    viewModel.desc = desc;
    return viewModel;
}
@end
