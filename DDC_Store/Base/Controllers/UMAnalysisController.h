//
//  UMAnalysisController.h
//  DayDayCook
//
//  Created by 张秀峰 on 16/6/15.
//  Copyright © 2016年 DayDayCook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DefaultImageView;
@class NetworkLoadView;

@interface UMAnalysisController : UIViewController

@property (nonatomic, assign)CGRect networkViewRect;

@property (nonatomic,strong,nonnull)DefaultImageView *defaultView;

@property (nonatomic, assign)UIStatusBarStyle   statusBarStyle;//状态栏的风格
@property (nonatomic, assign)BOOL statusBarHidden;//要不要隐藏状态栏

//-(void)networkReloadView;
-(nonnull NetworkLoadView *)networkReloadView;
-(void)removeNetworkView;
-(void)reloadPage;
- (BOOL)isNeedReloadData;//default is YES; 可以根据当前数据情况决定是否需要刷新



@end
