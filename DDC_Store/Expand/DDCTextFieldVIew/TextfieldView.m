//
//  TextfieldView.m
//  DayDayCook
//
//  Created by GFeng on 16/4/5.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "TextfieldView.h"

@implementation TextfieldView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:0];
    cancelButton.frame = CGRectMake(10, 0, 60, 40);
    [cancelButton setTitle:NSLocalizedString(@"取消", @"TextFieldView") forState:0];
    [cancelButton setTitleColor:COLOR_MAINORANGE forState:0];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton addTarget:self action:@selector(CancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIButton *doneButton = [UIButton buttonWithType:0];
    doneButton.frame = CGRectMake(DEVICE_WIDTH - 60, 0, 50, 40);
    if (frame.size.height == 40.1) {
        [doneButton setTitle:NSLocalizedString(@"搜索", @"TextFieldView") forState:0];
    }
    else if(frame.size.height == 40){
        [doneButton setTitle:NSLocalizedString(@"完成", @"TextFieldView") forState:0];
    }
    else{
        [doneButton setTitle:NSLocalizedString(@"提交", @"TextFieldView") forState:0];
    }
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton setTitleColor:COLOR_MAINORANGE forState:0];
    [doneButton addTarget:self action:@selector(DoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    
    return self;
}
 
- (void)DoneClicked:(id)sender
{
    if ([self.toolBarDelegate conformsToProtocol:@protocol(ToolBarSearchViewTextFieldDelegate)])
    {
        if (self.toolBarDelegate)
        {
            [self.toolBarDelegate doneButtonClicked];
        }
        else
        {
            [self endEditing:YES];
        }
    }
    else
    {
        [self endEditing:YES];
    }
}
- (void)CancelClicked:(id)sender
{
    if ([self.toolBarDelegate conformsToProtocol:@protocol(ToolBarSearchViewTextFieldDelegate)])
    {
        if ([self.toolBarDelegate respondsToSelector:@selector(cancelButtonClicked)])
        {
            [self.toolBarDelegate cancelButtonClicked];
        }
    }
    [self endEditing:YES];
    
}
@end
