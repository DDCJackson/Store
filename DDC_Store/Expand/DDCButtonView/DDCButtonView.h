//
//  DDCButtonView.h
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/13.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,DDCContentModelType) {
    DDCContentModelTypeImageLeft,
    DDCContentModelTypeImageRight,
    DDCContentModelTypeImageTop,
    DDCContentModelTypeImageBottom
};

@interface DDCButtonView : UIView

@property (nonatomic, copy, nonnull) NSString *title;

@property (nonatomic, assign) BOOL enable;

+ (nonnull DDCButtonView *)initWithType:(DDCContentModelType)type titleBlock:(void(^ _Nonnull)(UILabel * _Nonnull titleLabel))titleBlock image:(nonnull UIImage *)image interval:(CGFloat)interval clickAction:(void ( ^ _Nullable )())clickAction;

@end
