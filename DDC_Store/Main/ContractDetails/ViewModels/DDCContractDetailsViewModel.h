//
//  DDCContractDetailsViewModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/21.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "GJObject.h"

@interface DDCContractDetailsViewModel : GJObject

@property (nonatomic,strong)NSString  *title;
@property (nonatomic,strong)NSString  *desc;

+ (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc;

@end
