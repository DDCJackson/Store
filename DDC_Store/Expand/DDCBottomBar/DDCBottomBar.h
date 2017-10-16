//
//  CreateContractBottomView.h
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCBottomBar : UIView

+ (DDCBottomBar *)showOneBtnWithBtnTitle:(NSString *)btnTitle clickAction:(void(^)(void))clickAction;


+ (DDCBottomBar *)showTwoBtnWithLeftBtnTitle:(NSString *)leftBtnTitle leftClickAction:(void(^)(void))leftClickAction  rightBtnTitle:(NSString *)rightBtnTitle rightClickAction:(void(^)(void))rightClickAction;

@end
