 
//
//  UIImage+SGHelper.m
//  DDCQRCodeExample
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 DayDayCook. All rights reserved.
//

#import "UIImage+ImageSize.h"

#define DDCQRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define DDCQRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation UIImage (ImageSize)

/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = DDCQRCodeScreenWidth;
    CGFloat screenHeight = DDCQRCodeScreenHeight;
    
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (screenHeight * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

