//
//  UIView+DDCToast.h
//  DayDayCook
//
//  Created by DAN on 16/9/3.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//宽度固定，图片在上面，文字下面，文字最多显示2行

typedef NS_ENUM(NSInteger,ImagePosition) {
    ImageTop           = -1,
    ImageLeft          = 0,
    ImageBottom        = 1,
    ImageRight         = 2,
};

@interface DDCToastModel: NSObject

@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic) ImagePosition position;

- (instancetype)initWithMessage:(NSString *)message imageStr:(NSString *)imageStr position:(ImagePosition)position;

@end

@interface UIView (DDCToast)

- (void)makeDDCToast:(DDCToastModel *)model;

- (void)makeDDCToast:(NSString *)message image:(UIImage *)image;

- (void)makeDDCToast:(NSString *)message image:(UIImage *)image imagePosition:(ImagePosition)position;

- (void)makeDDCToast:(NSString *)message image:(UIImage *)image imagePosition:(ImagePosition)position finishedBlock:(void (^)())finishedBlock;


@end
