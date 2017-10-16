//
//  LoadingView.h
//  DayDayCook
//
//  Created by GFeng on 15/11/2.
//  Copyright (c) 2015年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (LoadingView *)sharedLoading;

- (void)runAnimation;

@end
