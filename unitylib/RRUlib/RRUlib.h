//
//  RRUlib.h
//
//
//  Created by snishiura on 12/11/26.
//  Copyright (c) 2012年 RustyRaven Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRUKeychainUtils.h"
#import "RRUWebView.h"
#import "RRUKeychainUtils.h"

@interface RRUlib : NSObject {
    RRUWebView *m_webview;
    
    // for keychain
    NSString *m_uuid;

    // for indicator
    UIActivityIndicatorView *m_indicator;

    // for inner
    NSTimer *m_intervalTimer;
    NSDate *m_pauseStart;
    NSDate *m_prevFiring;
}

@property (nonatomic, retain) RRUWebView *webview;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSTimer *intervalTimer;

// Lib wheel
+ (void)librarySetup;
+ (RRUlib *)sharedLibrary;
+ (void)libraryCleanup;

// Interval Timer
+ (void)startIntervalTimer:(float)intervalSec target:(id)target selector:(SEL)selector;
+ (void)stopIntervalTimer;
+ (void)pauseIntervalTimer;
+ (void)resumeIntervalTimer;
+ (BOOL)isValidIntervalTimer;

// Keychain
+ (NSString *)loadStringByKey:(NSString *)key;
+ (BOOL)saveStringByKey:(NSString *)key value:(NSString *)value;
+ (void)deleteStringByKey:(NSString *)key;
+ (NSString *)createUUID;
+ (NSString *)loadUUID;
+ (BOOL)saveUUID:(NSString *)uuid;
+ (void)deleteUUID;

// WebView
+ (void)initWebView:(UIView *)parent frame:(CGRect)frame baseURL:(NSString *)baseURL;
+ (int)addWebRequestHeader:(NSString *)key value:(NSString *)value;
+ (void)removeAllRequestHeader;
+ (int)addWebViewBodyHookKey:(NSString *)key;
+ (void)removeAllWebViewBodyHookKey;
+ (void)loadRequest:(NSString *)requestURL;
+ (void)setWebViewFrame:(CGRect)frame;
+ (void)openWebView;
+ (void)closeWebView;
+ (void)loadHTMLStringToWebView:(NSString *)html baseURL:(NSURL *)baseURL;

@end
