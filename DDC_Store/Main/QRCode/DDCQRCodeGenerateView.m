//
//  DDCQRCodeGenerateView.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCQRCodeGenerateView.h"
#import "DDCQRCode.h"

@implementation DDCQRCodeGenerateView

// 生成二维码
- (void)setupGenerateQRCodeWithContent:(NSString *)content width:(CGFloat)width
{
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 2、将CIImage转换成UIImage，并放大显示
    imageView.image = [DDCQRCodeGenerateManager generateWithDefaultQRCodeData:content imageViewWidth:width];
    
//#pragma mark - - - 模仿支付宝二维码样式（添加用户头像）
//    CGFloat scale = 0.22;
//    CGFloat borderW = 5;
//    UIView *borderView = [[UIView alloc] init];
//    CGFloat borderViewW = imageViewW * scale;
//    CGFloat borderViewH = imageViewH * scale;
//    CGFloat borderViewX = 0.5 * (imageViewW - borderViewW);
//    CGFloat borderViewY = 0.5 * (imageViewH - borderViewH);
//    borderView.frame = CGRectMake(borderViewX, borderViewY, borderViewW, borderViewH);
//    borderView.layer.borderWidth = borderW;
//    borderView.layer.borderColor = [UIColor purpleColor].CGColor;
//    borderView.layer.cornerRadius = 10;
//    borderView.layer.masksToBounds = YES;
//    borderView.layer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
//
//    [imageView addSubview:borderView];
}

#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCodeWithContent:(NSString *)content
{
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
//    CGFloat imageViewW = 150;
//    CGFloat imageViewH = imageViewW;
//    CGFloat imageViewX = (self.frame.size.width - imageViewW) / 2;
//    CGFloat imageViewY = 240;
//    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat scale = 0.2;
    
    // 2、将最终合得的图片显示在UIImageView上
    imageView.image = [DDCQRCodeGenerateManager generateWithLogoQRCodeData:content logoImageName:@"logo" logoScaleToSuperView:scale];
    
}

#pragma mark - - - 彩色图标二维码生成
- (void)setupGenerate_Color_QRCodeWithContent:(NSString *)content
{
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
//    CGFloat imageViewW = 150;
//    CGFloat imageViewH = imageViewW;
//    CGFloat imageViewX = (self.frame.size.width - imageViewW) / 2;
//    CGFloat imageViewY = 400;
//    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 2、将二维码显示在UIImageView上
    imageView.image = [DDCQRCodeGenerateManager generateWithColorQRCodeData:content backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
