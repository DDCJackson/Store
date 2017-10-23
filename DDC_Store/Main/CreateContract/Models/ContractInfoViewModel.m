//
//  ContracInfoModel.m
//  DDC_Store
//
//  Created by DAN on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractInfoViewModel.h"
#import "OffLineCourseModel.h"

@implementation ContractInfoViewModel

+ (instancetype)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text isRequired:(BOOL)required tag:(NSUInteger)tag
{
    ContractInfoViewModel * model = [[ContractInfoViewModel alloc] init];
    model.title = title;
    model.placeholder = placeholder;
    model.text = text;
    model.isRequired = required;
    model.tag = tag;
    return model;
}

+ (instancetype)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text isRequired:(BOOL)required tag:(NSUInteger)tag type:(ContractInfoModelType)type
{
    ContractInfoViewModel * model = [[ContractInfoViewModel alloc] init];
    model.title = title;
    model.placeholder = placeholder;
    model.text = text;
    model.isRequired = required;
    model.tag = tag;
    model.type = type;
    return model;
}

- (BOOL)isFill
{
    if (self.type == ContractInfoModelTypeTextField)
    {
        return (self.text && self.text.isValidStringValue);
    }
    else
    {
        BOOL oneChecked = NO;
        for (OffLineCourseModel * model in self.courseArr)
        {
            if (model.isChecked)
            {
                oneChecked = YES;
                if (!model.count || !model.count.length)
                {
                    return NO;
                }
            }
        }
        return oneChecked;
    }
}

@end
