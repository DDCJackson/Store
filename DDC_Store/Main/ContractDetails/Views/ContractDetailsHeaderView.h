//
//  ContractDetailsHeaderView.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCContractDetailsModel.h"

@interface ContractDetailsHeaderView : UITableViewHeaderFooterView

@property (nonatomic,assign)DDCContractStatus status;

+ (CGFloat)height;

@end
