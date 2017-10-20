//
//  PostStateInfoCell.h
//  DayDayCook
//
//  Created by 张秀峰 on 2016/11/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContractStateInfoViewModel;

static NSString *kPostStateInfoCellId = @"PostStateInfoCell_ID";

@interface ContractStateInfoCell:UICollectionViewCell

- (void)showCellWithData:(ContractStateInfoViewModel *)data width:(CGFloat)width;

+ (CGFloat)heightWithData:(ContractStateInfoViewModel *)data width:(CGFloat)width;

@end
