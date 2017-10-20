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

- (BOOL)isFill
{
    if(self.type == ContractInfoModelTypeChecked)
    {
        BOOL isFill = NO;
        for (int i =0; i<self.courseArr.count; i++) {
            OffLineCourseModel *courseM = self.courseArr[i];
            if(courseM.isChecked&&courseM.count.length==0)
            {
                isFill = NO;
                break;
            }
            if(courseM.isChecked&&courseM.count.length!=0)
            {
                isFill =YES;
            }
        }
        return isFill;
    }
    else
    {
        return self.text&&self.text.length;
    }
}

@end
