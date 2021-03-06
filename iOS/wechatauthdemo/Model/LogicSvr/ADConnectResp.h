//
//  ADConnectResp.h
//
//  Created by WeChat  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp;

@interface ADConnectResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, assign) double tempUin;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
