//
//  OffLineCourseModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "GJObject.h"

@interface OffLineCourseModel : GJObject

@property (nonatomic,assign)BOOL  isChecked;
@property (nonatomic,strong)NSString  *count;
@property (nonatomic,strong)NSString  *categoryName;
@property (nonatomic,strong)NSString  *ID;

@end
