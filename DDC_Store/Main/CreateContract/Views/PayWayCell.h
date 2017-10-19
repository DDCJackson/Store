//
//  PayWayCell.h
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayWayModel;

static NSString *kPayWayCellId = @"PayWayCell_ID";

@interface PayWayCell : UITableViewCell

- (void)showCellWithData:(PayWayModel *)data;

+ (CGFloat)heightWithData:(PayWayModel *)data;

@end
