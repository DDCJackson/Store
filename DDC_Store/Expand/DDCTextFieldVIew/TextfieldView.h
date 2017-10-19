//
//  TextfieldView.h
//  DayDayCook
//
//  Created by GFeng on 16/4/5.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ToolBarSearchViewTextFieldDelegate<NSObject>
@optional
- (void)doneButtonClicked;
- (void)cancelButtonClicked;

@end
@interface TextfieldView : UIView

@property (nonatomic, assign) BOOL isSearch;
@property (assign, nonatomic) id <ToolBarSearchViewTextFieldDelegate> toolBarDelegate;

@end
