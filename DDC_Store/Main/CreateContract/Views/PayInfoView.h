//
//  PayInfoView.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoView : UIView

- (void)configuareWithPayUrl:(NSString *)payUrl money:(NSString *)money;

+ (CGFloat)height;

@end
