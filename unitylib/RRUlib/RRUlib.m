//
//  RRUlib.m
//  
//
//  Created by snishiura on 12/11/26.
//  Copyright (c) 2012年 RustyRaven Inc. All rights reserved.
//

#import "RRUlib.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RRUlib

@synthesize webview       = m_webview;
@synthesize uuid          = m_uuid;
@synthesize indicator     = m_indicator;
@synthesize intervalTimer = m_intervalTimer;

static RRUlib *s_RRUlib = nil;

#pragma mark RRUlib Wheel methods
+ (void)librarySetup
{
    RRUlib *RRUlib = [self sharedLibrary];
#ifdef DEBUG
    if (RRUlib) {
        NSLog(@"RRUlib Setup Success!!");
    } else {
        NSLog(@"RRUlib Setup Failed...");
    }
#endif
}

+ (RRUlib *)sharedLibrary
{
    @synchronized(self) {
        if (s_RRUlib == nil) {
            s_RRUlib = [[RRUlib alloc] init];
        }
    }
    return s_RRUlib;
}

+ (void)libraryCleanup
{
    @synchronized(self) {
        if (s_RRUlib) {
            [s_RRUlib.intervalTimer invalidate];
            [s_RRUlib release];
            s_RRUlib = nil;
        }
    }
}

#pragma mark RRUlib inner
- (id)init
{
    self = [super init];
    if (self) {
        //m_uuid = nil;
        m_intervalTimer = nil;
    }
    return self;
}

- (void)pauseTimer
{
    [m_intervalTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer
{
    float pauseTime = -1 * [m_pauseStart timeIntervalSinceNow];
    [m_intervalTimer setFireDate:[m_prevFiring initWithTimeInterval:pauseTime sinceDate:m_prevFiring]];
    [m_pauseStart release];
    [m_prevFiring release];
}

- (void)resetTimer
{
    if (m_intervalTimer) {
        [m_intervalTimer release];
    }
}

- (void)dealloc
{
    [self resetTimer];
    //
    [super dealloc];
#ifdef DEBUG
    NSLog(@"RRUlib Cleanup!!");
#endif
}

#pragma mark Interval Timer
+ (void)startIntervalTimer:(float)intervalSec target:(id)target selector:(SEL)selector
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    if (sharedRRUlibrary.intervalTimer != nil) {
        [sharedRRUlibrary.intervalTimer release];
        sharedRRUlibrary.intervalTimer = nil;
    }
    sharedRRUlibrary.intervalTimer = [NSTimer scheduledTimerWithTimeInterval:intervalSec target:target selector:selector userInfo:nil repeats:TRUE];
    [sharedRRUlibrary.intervalTimer fire];
}

+ (void)stopIntervalTimer
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    if ([sharedRRUlibrary.intervalTimer isValid]) {
        [sharedRRUlibrary.intervalTimer invalidate];
    }
    [sharedRRUlibrary resetTimer];
}

+ (void)pauseIntervalTimer
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    if ([sharedRRUlibrary.intervalTimer isValid]) {
        [sharedRRUlibrary pauseTimer];
#ifdef DEBUG
        NSLog(@"pauseIntervalTimer");
#endif
    }
}

+ (void)resumeIntervalTimer
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    if ([sharedRRUlibrary.intervalTimer isValid]) {
        [sharedRRUlibrary resumeTimer];
#ifdef DEBUG
        NSLog(@"resumeIntervalTimer");
#endif
    }
}

+ (BOOL)isValidIntervalTimer
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    return [sharedRRUlibrary.intervalTimer isValid];
}

#pragma mark RRUlib Keychain
+ (NSString *)loadStringByKey:(NSString *)key
{
    return [RRUKeychainUtils getStringByKey:key error:nil];
}

+ (BOOL)saveStringByKey:(NSString *)key value:(NSString *)value
{
    return [RRUKeychainUtils setStringByKey:key value:value force:TRUE error:nil];
}

+ (void)deleteStringByKey:(NSString *)key
{
    [RRUKeychainUtils deleteByKey:key error:nil];
}

+ (NSString *)createUUID
{
    return [RRUKeychainUtils createUUID];
}

+ (NSString *)loadUUID
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    if (sharedRRUlibrary.uuid == nil) {
        NSString *uuid = [RRUKeychainUtils getUUID:nil];
        if (uuid) {
            sharedRRUlibrary.uuid = [[NSString alloc] initWithString:uuid];
        }
    }
#ifdef DEBUG
    NSLog(@"loadUUID:%@", sharedRRUlibrary.uuid);
#endif
    return sharedRRUlibrary.uuid;
}

+ (BOOL)saveUUID:(NSString *)uuid
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    sharedRRUlibrary.uuid = [[NSString alloc] initWithString:uuid];
    return [RRUKeychainUtils setUUID:uuid force:TRUE error:nil];
}

+ (void)deleteUUID
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    sharedRRUlibrary.uuid = nil;
    [RRUKeychainUtils deleteUUID:nil];
#ifdef DEBUG
    NSLog(@"deleteUUID");
#endif
}

#pragma mark RRUlib Webview
+ (void)initWebView:(UIView *)parent frame:(CGRect)frame baseURL:(NSString *)baseURL
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    if (sharedRRUlibrary.indicator == nil) {
        CGRect mainRect = [[UIScreen mainScreen] bounds];
        sharedRRUlibrary.indicator = [[UIActivityIndicatorView alloc] initWithFrame:mainRect];
        [sharedRRUlibrary.indicator setCenter:CGPointMake(mainRect.size.width / 2, mainRect.size.height / 2)];
        UIColor *bgColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
        [sharedRRUlibrary.indicator setBackgroundColor:bgColor];
    }
    if (sharedRRUlibrary.webview == nil) {
        sharedRRUlibrary.webview = [[RRUWebView alloc] initWithFrame:frame AndURL:baseURL indicator:sharedRRUlibrary.indicator];
    }
    [parent addSubview:sharedRRUlibrary.webview];
    [parent addSubview: sharedRRUlibrary.indicator];
    [sharedRRUlibrary.indicator release];
    [sharedRRUlibrary.webview release];
}

+ (int)addWebRequestHeader:(NSString *)key value:(NSString *)value
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        return [webView addRequestHeader:key value:value];
    }
    return 0;
}

+ (void)removeAllRequestHeader
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        [webView removeAllRequestHeader];
    }
}

+ (int)addWebViewBodyHookKey:(NSString *)key
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        return [webView addBodyHookKey:key];
    }
    return 0;
}

+ (void)removeAllWebViewBodyHookKey
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        [webView removeAllBodyHookKey];
    }
}

+ (void)loadRequest:(NSString *)requestURL
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        // インディケーター表示開始
        [sharedRRUlibrary.indicator startAnimating];
        NSLog(@"requestURL:%@", requestURL);
        NSURL *url = [NSURL URLWithString:requestURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        [webView loadRequest:request];
    }
}

+ (void)setWebViewFrame:(CGRect)frame
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        [webView setWebviewFrame:frame];
    }
}

+ (void)openWebView
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        [webView showWithAnimation];
    }
}

+ (void)closeWebView
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        [webView hideWithAnimation];
    }
}

+ (void)loadHTMLStringToWebView:(NSString *)html baseURL:(NSURL *)baseURL
{
    RRUlib *sharedRRUlibrary = [self sharedLibrary];
    RRUWebView *webView = sharedRRUlibrary.webview;
    if (webView) {
        [webView loadHTMLString:html baseURL:baseURL];
    }
}

@end
