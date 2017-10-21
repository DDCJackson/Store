//
//  CreateContactViewController.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, DDCContractProgress) {
    DDCContractProgress_AddPhoneNumber = 0,
    DDCContractProgress_EditClientInformation = 1,
    DDCContractProgress_AddContractInformation = 2,
    DDCContractProgress_FinishContract = 3
};

@interface CreateContractViewController : BaseViewController

- (instancetype)init __attribute__((unavailable("必须用initWithContractProgress:")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("必须用initWithContractProgress:")));
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("必须用initWithContractProgress:")));

- (instancetype)initWithContractProgress:(DDCContractProgress)contractProgress model:(GJObject *)model;

@end
