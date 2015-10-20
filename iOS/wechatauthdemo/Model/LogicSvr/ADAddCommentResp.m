//
//  ADAddCommentResp.m
//
//  Created by Jeason  on 20/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAddCommentResp.h"
#import "ADBaseResp.h"
#import "ADCommentList.h"


NSString *const kADAddCommentRespBaseResp = @"base_resp";
NSString *const kADAddCommentRespComment = @"comment";


@interface ADAddCommentResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADAddCommentResp

@synthesize baseResp = _baseResp;
@synthesize comment = _comment;


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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADAddCommentRespBaseResp]];
            self.comment = [ADCommentList modelObjectWithDictionary:[dict objectForKey:kADAddCommentRespComment]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADAddCommentRespBaseResp];
    [mutableDict setValue:[self.comment dictionaryRepresentation] forKey:kADAddCommentRespComment];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADAddCommentRespBaseResp];
    self.comment = [aDecoder decodeObjectForKey:kADAddCommentRespComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADAddCommentRespBaseResp];
    [aCoder encodeObject:_comment forKey:kADAddCommentRespComment];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAddCommentResp *copy = [[ADAddCommentResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.comment = [self.comment copyWithZone:zone];
    }
    
    return copy;
}


@end
