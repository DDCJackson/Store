//
//  NetworkLoadView.h
//  DayDayCook
//
//  Created by GFeng on 16/3/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReloadRequestDelegate<NSObject>

-(void)reloadRequestClick;


@end

@interface NetworkLoadView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic ,assign) id<ReloadRequestDelegate>delegate;

@property (nonatomic, assign) BOOL isNeedSendSuggestion;


@end
