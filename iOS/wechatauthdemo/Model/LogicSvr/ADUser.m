//
//  ADUser.m
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADUser.h"


NSString *const kADUserSex = @"sex";
NSString *const kADUserCountry = @"country";
NSString *const kADUserNickname = @"nickname";
NSString *const kADUserCity = @"city";
NSString *const kADUserHeadimgurl = @"headimgurl";
NSString *const kADUserOpenid = @"openid";


@interface ADUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADUser

@synthesize sex = _sex;
@synthesize country = _country;
@synthesize nickname = _nickname;
@synthesize city = _city;
@synthesize headimgurl = _headimgurl;
@synthesize openid = _openid;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.sex = [[self objectOrNilForKey:kADUserSex fromDictionary:dict] doubleValue];
            self.country = [self objectOrNilForKey:kADUserCountry fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kADUserNickname fromDictionary:dict];
            self.city = [self objectOrNilForKey:kADUserCity fromDictionary:dict];
            self.headimgurl = [self objectOrNilForKey:kADUserHeadimgurl fromDictionary:dict];
            self.openid = [self objectOrNilForKey:kADUserOpenid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sex] forKey:kADUserSex];
    [mutableDict setValue:self.country forKey:kADUserCountry];
    [mutableDict setValue:self.nickname forKey:kADUserNickname];
    [mutableDict setValue:self.city forKey:kADUserCity];
    [mutableDict setValue:self.headimgurl forKey:kADUserHeadimgurl];
    [mutableDict setValue:self.openid forKey:kADUserOpenid];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.sex = [aDecoder decodeDoubleForKey:kADUserSex];
    self.country = [aDecoder decodeObjectForKey:kADUserCountry];
    self.nickname = [aDecoder decodeObjectForKey:kADUserNickname];
    self.city = [aDecoder decodeObjectForKey:kADUserCity];
    self.headimgurl = [aDecoder decodeObjectForKey:kADUserHeadimgurl];
    self.openid = [aDecoder decodeObjectForKey:kADUserOpenid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_sex forKey:kADUserSex];
    [aCoder encodeObject:_country forKey:kADUserCountry];
    [aCoder encodeObject:_nickname forKey:kADUserNickname];
    [aCoder encodeObject:_city forKey:kADUserCity];
    [aCoder encodeObject:_headimgurl forKey:kADUserHeadimgurl];
    [aCoder encodeObject:_openid forKey:kADUserOpenid];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADUser *copy = [[ADUser alloc] init];
    
    if (copy) {

        copy.sex = self.sex;
        copy.country = [self.country copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.headimgurl = [self.headimgurl copyWithZone:zone];
        copy.openid = [self.openid copyWithZone:zone];
    }
    
    return copy;
}


@end