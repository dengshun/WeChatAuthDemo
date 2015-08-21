//
//  NSData+AES.h
//  AuthSDKDemo
//
//  Created by Jeason on 12/08/2015.
//  Copyright (c) 2015 Jeason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

@interface NSString (AES)

- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;


@end