//
//  DDCQRCodeGenerateView.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCQRCodeGenerateView : UIView

//选择一个初始化
- (void)setupGenerateQRCodeWithContent:(NSString *)content width:(CGFloat)width;
- (void)setupGenerate_Icon_QRCodeWithContent:(NSString *)content;
- (void)setupGenerate_Color_QRCodeWithContent:(NSString *)content;

@end
