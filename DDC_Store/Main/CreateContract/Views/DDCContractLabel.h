//
//  DDCContractLabel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCContractLabel : UILabel


/*
 *  Configure DDCContractLabel
 *  @param title   标题字段
 *  @param isRequired  是否是必填项
 *  @param tips  提示语句字段
 *  @param isShowTips  是否需要展示提示语句
 */
- (void)configureWithTitle:(NSString *)title isRequired:(BOOL)isRequired tips:(NSString *)tips isShowTips:(BOOL)isShowTips;

@end
