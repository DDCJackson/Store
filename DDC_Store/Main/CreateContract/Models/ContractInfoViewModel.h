//
//  ContracInfoModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "GJObject.h"

@class OffLineCourseModel;

typedef NS_ENUM(NSUInteger,ContractInfoModelType) {
    ContractInfoModelTypeTextField = 0,
    ContractInfoModelTypeChecked
};

@interface ContractInfoViewModel : GJObject

+ (instancetype)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text isRequired:(BOOL)required tag:(NSUInteger)tag;


+ (instancetype)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text isRequired:(BOOL)required tag:(NSUInteger)tag  type:(ContractInfoModelType)type;


@property (nonatomic,strong)NSString  *title;
@property (nonatomic,strong)NSString  *placeholder;
@property (nonatomic,strong)NSString  *text;
/*是否有填写*/
@property (nonatomic,assign)BOOL      isFill;
@property (nonatomic,assign)ContractInfoModelType  type;
@property (nonatomic,strong)NSArray<OffLineCourseModel*>  *courseArr;
/*是否是必填项*/
@property (nonatomic,assign)BOOL      isRequired;
@property (nonatomic,assign)NSUInteger tag;

@end
