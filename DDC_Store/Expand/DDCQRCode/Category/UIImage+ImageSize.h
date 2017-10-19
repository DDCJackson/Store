 
//
//  UIImage+SGHelper.h
//  DDCQRCodeExample
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 DayDayCook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageSize)
/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
