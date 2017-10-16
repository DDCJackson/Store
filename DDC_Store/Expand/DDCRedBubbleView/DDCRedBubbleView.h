//
//  DDCRedBubbleVIew.h
//  DayDayCook
//
//  Created by sunlimin on 17/3/1.
//  Copyright © 2017年 GFeng. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DDCRedBubbleViewType) {
    DDCRedBubbleViewTypeNormal,
    DDCRedBubbleViewTypeImageBackground,
};
@interface DDCRedBubbleView : UIView

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *numberLabel;
@property (nonatomic, strong, readonly) UILabel *plusLabel;
@property (nonatomic, strong) NSNumber *messageCount;
@property (nonatomic, assign) DDCRedBubbleViewType type;
@property (nonatomic, assign) CGRect originFrame;


- (void)popUpBubble:(BOOL)isShow notificationCount:(NSString *)notificationCount completion:(void (^)(BOOL finished))completion;
- (instancetype)initWithType:(DDCRedBubbleViewType)type;

@end
