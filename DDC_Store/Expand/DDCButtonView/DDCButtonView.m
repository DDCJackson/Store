//
//  DDCButtonView.m
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/13.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "DDCButtonView.h"


@interface DDCButtonView ()

@property (nonatomic, retain) UILabel *titleLbl;
@property (nonatomic, copy) void (^ clickActionBlock)();

@end

@implementation DDCButtonView


//- (instancetype)init
//{
//    if (self = [super init]) {
//        
//        
//    }
//    return self;
//}


+ (nonnull DDCButtonView *)initWithType:(DDCContentModelType)type titleBlock:(void(^ _Nonnull)(UILabel *titleLabel))titleBlock image:(nonnull UIImage *)image interval:(CGFloat)interval clickAction:(void ( ^ _Nullable )())clickAction
{
    DDCButtonView *selfView = [[DDCButtonView alloc] init];
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.numberOfLines = 0;
    [selfView addSubview:titleLbl];
    selfView.titleLbl = titleLbl;
    
    if (titleBlock) {
        titleBlock(titleLbl);
    }
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = image;
    [selfView addSubview:icon];
    
    switch (type) {
        case DDCContentModelTypeImageLeft:
        {
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(selfView.mas_centerX).with.offset(-image.size.width*0.6);
                make.centerY.equalTo(selfView.mas_centerY);
            }];
            
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(selfView.mas_centerY);
                make.left.equalTo(icon.mas_right).with.offset(interval);
            }];
        }
            break;
            
        case DDCContentModelTypeImageRight:
        {
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(selfView.mas_centerY);
                make.centerX.equalTo(selfView.mas_centerX).with.offset(-image.size.width*0.6);
            }];
            
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLbl.mas_right).with.offset(interval);
                make.centerY.equalTo(selfView.mas_centerY);
            }];
        }
            break;
            
        case DDCContentModelTypeImageTop:
        {
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(selfView.mas_centerX);
                make.bottom.equalTo(selfView.mas_centerY);
            }];
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(selfView);
//                make.centerX.equalTo(selfView.mas_centerX);
                make.top.equalTo(selfView.mas_centerY).with.offset(interval);
            }];
        }
            break;
            
        case DDCContentModelTypeImageBottom:
        {
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(selfView.mas_centerX);
                make.left.right.equalTo(selfView);
                make.bottom.equalTo(selfView.mas_centerY).with.offset(-interval);
            }];
            
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(selfView.mas_centerX);
                make.top.equalTo(selfView.mas_centerY);
            }];
        }
            break;
            
        default:
            break;
    }
    
    if (clickAction) {
        selfView.clickActionBlock = clickAction;
        [selfView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:selfView action:@selector(clickAction:)]];
    }

    return selfView;
}


- (void)clickAction:(UITapGestureRecognizer *)tap
{
    self.clickActionBlock();
}

- (void)setTitle:(NSString *)title
{
    self.titleLbl.text = _title = title;
}

- (void)setEnable:(BOOL)enable
{
    self.userInteractionEnabled = enable;
    _enable = enable;
}



@end
