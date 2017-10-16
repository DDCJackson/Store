//
//  DDCButton.h
//  DayDayCook
//
//  Created by 张秀峰 on 2016/10/10.
//  Copyright © 2016年 GFeng. All rights reserved.
//

@interface DDCButton : UIButton

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

- (void)setLayerBorderColor:(UIColor *)LayerBorderColor forState:(UIControlState)state;

- (void)setFont:(UIFont *)font forState:(UIControlState)state;

@end
