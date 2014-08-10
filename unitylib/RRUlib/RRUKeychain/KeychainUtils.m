//
//  KeychainUtils.m
//  TestProject
//
//  Created by snishiura on 12/07/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KeychainUtils.h"

@implementation KeychainUtils

+ (NSString *)getStoredValue:(NSString *)key serviceName:(NSString *)serviceName accessGroup:(NSString *)accessGroup errorDomain:(NSString *)errorDomain error:(NSError **)error
{
    // グループ、サービス名確認とエラー初期化.
    if (!accessGroup || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain:errorDomain code:-2000 userInfo:nil];
        }
        return nil;
    }
    if (error != nil) {
        *error = nil;
    }
    // キーチェーンへの問い合わせクエリの構築.
    NSArray *keys = [[[NSArray alloc] initWithObjects:
                      (NSString *)kSecClass,
                      kSecAttrAccount,
                      kSecAttrService,
                      kSecAttrAccessGroup,
                      nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects:
                         (NSString *)kSecClassGenericPassword,
                         key,
                         serviceName,
                         accessGroup,
                         nil] autorelease];
    NSMutableDictionary *query = [[[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
    // まずUUIDの格納アトリビュートを確認.
    NSDictionary *attributeResult = NULL;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
    [attributeResult release];
    [attributeQuery release];
    if (status != noErr) {
        if (error != nil && status != errSecItemNotFound) {
            *error = [NSError errorWithDomain:errorDomain code:status userInfo:nil];
        }
        return nil;
    }
    // 次いでUUIDを取得.
    NSData *resultData = nil;
    NSMutableDictionary *uuidQuery = [query mutableCopy];
    [uuidQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    status = SecItemCopyMatching((CFDictionaryRef)uuidQuery, (CFTypeRef *)&resultData);
    [resultData autorelease];
    [uuidQuery release];
    if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (error != nil) {
                *error = [NSError errorWithDomain:errorDomain code:-1999 userInfo:nil];
            }
        } else {
            if (error != nil) {
                *error = [NSError errorWithDomain:errorDomain code:status userInfo:nil];
            }
        }
        return nil;
    }
    //
    NSString *uuid = nil;
    if (resultData) {
        uuid = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    } else {
        if (error != nil) {
            *error = [NSError errorWithDomain:errorDomain code:-1999 userInfo:nil];
        }
    }
    return [uuid autorelease];
}

+ (BOOL)setValue:(NSString *)value key:(NSString *)key servicename:(NSString *)serviceName accessGroup:(NSString *)accessGroup force:(BOOL)force errorDomain:(NSString *)errorDomain error:(NSError **)error
{
    if (!value || !key || !serviceName || !accessGroup || !errorDomain) {
        if (error != nil) {
            *error = [NSError errorWithDomain:errorDomain code:-2000 userInfo:nil];
        }
        return FALSE;
    }
    // まず、既に存在してないかどうか確認.
    NSError *getError = nil;
    NSString *existingValue = [KeychainUtils getStoredValue:key serviceName:serviceName accessGroup:accessGroup errorDomain:errorDomain error:error];
    if ([getError code] == -1999) {
        getError = nil;
        [self deleteValue:key serviceName:serviceName accessGroup:accessGroup errorDomain:errorDomain error:&getError];
        if ([getError code] != noErr) {
            if (error != nil) {
                *error = getError;
            }
            return FALSE;
        }
    } else if ([getError code] != noErr) {
        if (error != nil) {
            *error = getError;
        }
        return FALSE;
    }
    if (error != nil) {
        *error = nil;
    }
    OSStatus status = noErr;
    //
    if (existingValue) {
        if (![existingValue isEqualToString:value] && force) {
            // 存在していても強制的に更新する場合
            NSArray *keys = [[[NSArray alloc] initWithObjects:
                              (NSString *)kSecClass,
                              kSecAttrService,
                              kSecAttrLabel,
                              kSecAttrAccount,
                              kSecAttrAccessGroup,
                              nil] autorelease];
            NSArray *objects = [[[NSArray alloc] initWithObjects:
                                 (NSString *)kSecClassGenericPassword,
                                 serviceName,
                                 serviceName,
                                 key,
                                 accessGroup,
                                 nil] autorelease];
            NSDictionary *query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
            status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)[NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(NSString *)kSecValueData]);
        }
    } else {
        // 存在しないので挿入
        NSArray *keys = [[[NSArray alloc] initWithObjects:
                          (NSString *)kSecClass,
                          kSecAttrService,
                          kSecAttrLabel,
                          kSecAttrAccount,
                          kSecValueData,
                          kSecAttrAccessGroup,
                          nil] autorelease];
        NSArray *objects = [[[NSArray alloc] initWithObjects:
                             (NSString *)kSecClassGenericPassword,
                             serviceName,
                             serviceName,
                             key,
                             [value dataUsingEncoding:NSUTF8StringEncoding],
                             accessGroup,
                             nil] autorelease];
        NSDictionary *query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
        status = SecItemAdd((CFDictionaryRef)query, NULL);
    }
    //
    if (status != noErr) {
        if (error != nil) {
            *error = [NSError errorWithDomain:errorDomain code:status userInfo:nil];
        }
        return FALSE;
    }
    return TRUE;
}

+ (BOOL)deleteValue:(NSString *)key serviceName:(NSString *)serviceName accessGroup:(NSString *)accessGroup errorDomain:(NSString *)errorDomain error:(NSError **)error
{
    if (!accessGroup || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain:errorDomain code:-2000 userInfo:nil];
            return FALSE;
        }
    }
    if (error != nil) {
        *error = nil;
    }
    //
    NSArray *keys = [[[NSArray alloc] initWithObjects:
                      (NSString *)kSecClass,
                      kSecAttrAccount,
                      kSecAttrService,
                      kSecReturnAttributes,
                      kSecAttrAccessGroup,
                      nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects:
                         (NSString *)kSecClassGenericPassword,
                         key,
                         serviceName,
                         kCFBooleanTrue,
                         accessGroup,
                         nil] autorelease];
    NSDictionary *query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    if (status != noErr) {
        if (error != nil) {
            *error = [NSError errorWithDomain:errorDomain code:status userInfo:nil];
        }
        return FALSE;
    }
    return TRUE;
}

@end
