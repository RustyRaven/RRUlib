//
//  RRUKeychainUtils.h
//  TestProject
//
//  Created by snishiura on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainUtils.h"

@interface RRUKeychainUtils : KeychainUtils

+ (NSString *)getStringByKey:(NSString *)key error:(NSError **)error;
+ (BOOL)setStringByKey:(NSString *)key value:(NSString *)value force:(BOOL)force error:(NSError **)error;
+ (BOOL)deleteByKey:(NSString *)key error:(NSError **)error;

+ (NSString *)createUUID;
+ (NSString *)getUUID:(NSError **)error;
+ (BOOL)setUUID:(NSString *)uuid force:(BOOL)force error:(NSError **)error;
+ (BOOL)deleteUUID:(NSError **)error;

@end
