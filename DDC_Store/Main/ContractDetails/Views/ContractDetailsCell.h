//
//  ContractDetailsCell.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCContractDetailsModel;

@interface ContractDetailsCell : UITableViewCell

- (void)configureContactDetailsCellWithModel:(DDCContractDetailsModel *)model;

+ (CGFloat)height;

@end
