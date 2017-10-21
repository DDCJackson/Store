//
//  PayResultViewController.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ChildContractViewController.h"

@interface PayResultViewController : ChildContractViewController

- (instancetype)init __attribute__((unavailable("必须用initWithContractId:")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("必须用initWithContractId:")));
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("必须用initWithContractId:")));

- (instancetype)initWithContractId:(NSString *)contractId;

@end
