//
//  DDCCustomerModel.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "GJObject.h"

typedef NS_ENUM(NSUInteger, DDCGender)
{
    DDCGenderFemale,
    DDCGenderMale
};

typedef NS_ENUM(NSUInteger, DDCOccupation)
{
    DDCOccupationEmployee,
    DDCOccupationMother,
    DDCOccupationFreelancer,
    DDCOccupationBizOwner,
    DDCOccupationManager,
    DDCOccupationStudent,
    DDCOccupationOther
};

typedef NS_ENUM(NSUInteger, DDCChannel)
{
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
