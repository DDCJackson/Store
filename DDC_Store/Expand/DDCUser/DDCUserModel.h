//
//  DDCUserModel.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "GJObject.h"

@interface DDCUserModel : GJObject <NSCoding>

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * imgUrlStr;

@end
