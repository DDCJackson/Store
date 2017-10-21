//
//  PostStateInfoCell.h
//  DayDayCook
//
//  Created by 张秀峰 on 2016/11/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContractStateInfoViewModel;

@interface ContractStateInfoCell:UICollectionViewCell

- (void)configureCellWithData:(ContractStateInfoViewModel *)data;

+ (CGFloat)height;

+ (CGSize)sizeWithData:(ContractStateInfoViewModel *)data;

@end
