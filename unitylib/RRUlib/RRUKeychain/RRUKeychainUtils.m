//
//  RRUKeychainUtils.m
//
//
//  Created by snishiura on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRUKeychainUtils.h"

#if TARGET_IPHONE_SIMULATOR
#define RRUKEYCHAIN_ACCESSGROUP     @"test"
#elif DEBUG
#define RRUKEYCHAIN_ACCESSGROUP     @"hoge.com.rustyraven.shared" // デバッグ用
#else
#define RRUKEYCHAIN_ACCESSGROUP     @"fuga.com.rustyraven.shared" // リリース用
#endif

#define RRUKEYCHAIN_SERVICENAME     @"RRU"
#define RRUKEYCHAIN_ERRORDOMAIN     @"RRUKeychainUtilErrorDomain"
#define RRUKEYCHAIN_UUID            @"com.rustyraven.rru.uuid"

@implementation RRUKeychainUtils

+ (NSString *)getStringByKey:(NSString *)key error:(NSError **)error
{
    return [self getStoredValue:key serviceName:RRUKEYCHAIN_SERVICENAME accessGroup:RRUKEYCHAIN_ACCESSGROUP errorDomain:RRUKEYCHAIN_ERRORDOMAIN error:error];
}

+ (BOOL)setStringByKey:(NSString *)key value:(NSString *)value force:(BOOL)force error:(NSError **)error
{
    return [self setValue:value key:key servicename:RRUKEYCHAIN_SERVICENAME accessGroup:RRUKEYCHAIN_ACCESSGROUP force:force errorDomain:RRUKEYCHAIN_ERRORDOMAIN error:error];
}

+ (BOOL)deleteByKey:(NSString *)key error:(NSError **)error
{
    return [self deleteValue:key serviceName:RRUKEYCHAIN_SERVICENAME accessGroup:RRUKEYCHAIN_ACCESSGROUP errorDomain:RRUKEYCHAIN_ERRORDOMAIN error:error];
}

#pragma mark UUID of KeyChain
+ (NSString *)createUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidStr = (NSString *)CFUUIDCreateString(nil, uuidObj);
    NSString *uuid = [NSString stringWithFormat:@"%@", uuidStr];
    [uuidStr release];
    CFRelease(uuidObj);
    return uuid;
}

+ (NSString *)getUUID:(NSError **)error
{
    return [self getStringByKey:RRUKEYCHAIN_UUID error:error];
}

+ (BOOL)setUUID:(NSString *)uuid force:(BOOL)force error:(NSError **)error
{
    return [self setStringByKey:RRUKEYCHAIN_UUID value:uuid force:force error:error];
}

+ (BOOL)deleteUUID:(NSError **)error
{
    return [self deleteByKey:RRUKEYCHAIN_UUID error:error];
}

@end
