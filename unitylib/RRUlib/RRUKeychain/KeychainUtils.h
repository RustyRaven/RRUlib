//
//  KeychainUtils.h
//  TestProject
//
//  Created by snishiura on 12/07/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainUtils : NSObject

+ (NSString *)getStoredValue:(NSString *)key serviceName:(NSString *)serviceName accessGroup:(NSString *)accessGroup errorDomain:(NSString *)errorDomain error:(NSError **)error;
+ (BOOL)setValue:(NSString *)value key:(NSString *)key servicename:(NSString *)serviceName accessGroup:(NSString *)accessGroup force:(BOOL)force errorDomain:(NSString *)errorDomain error:(NSError **)error;
+ (BOOL)deleteValue:(NSString *)key serviceName:(NSString *)serviceName accessGroup:(NSString *)accessGroup errorDomain:(NSString *)errorDomain error:(NSError **)error;

@end
