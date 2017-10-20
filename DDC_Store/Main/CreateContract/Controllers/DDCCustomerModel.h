//
//  DDCCustomerModel.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "GJObject.h"

typedef NS_ENUM(NSInteger, DDCGender)
{
    DDCGenderNone = 0,
    DDCGenderFemale,
    DDCGenderMale
};

typedef NS_ENUM(NSInteger, DDCOccupation)
{
    DDCOccupationNone = 0,
    DDCOccupationEmployee,
    DDCOccupationMother,
    DDCOccupationFreelancer,
    DDCOccupationBizOwner,
    DDCOccupationManager,
    DDCOccupationStudent,
    DDCOccupationOther
};

typedef NS_ENUM(NSInteger, DDCChannel)
{
    DDCChannelNone = 0,
    DDCChannelMemberIntro,
    DDCChannelSawStore,
    DDCChannelWeibo,
    DDCChannelFoodiesMarket,
    DDCChannelApp,
    DCChannelOther
};

@interface DDCCustomerModel : GJObject

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, assign) DDCGender sex;
@property (nonatomic, strong) NSDate * birthday;
@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, assign) DDCOccupation career;
@property (nonatomic, assign) DDCChannel channel;

@property (nonatomic, copy) NSString * formattedBirthday;

- (NSDictionary *)toJSONDict;

+ (NSArray *)genderArray;
+ (NSArray *)occupationArray;
+ (NSArray *)channelArray;

@end
