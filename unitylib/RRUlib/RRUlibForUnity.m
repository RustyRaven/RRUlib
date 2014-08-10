//
//  RRUlibForUnity.m
//  
//
//  Created by snishiura on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRUlibForUnity.h"
#import "RRUlib.h"

// 640,780 -> 320,390
#define WEBVIEW_REQUEST_HEADER_UUID  @"X-RustyRaven-Uuid"
#define WEBVIEW_FRAME           CGRectMake(0, -390, 316, 390)
#define WEBVIEW_DURATION        0.333f
#define WEBVIEW_HIDEPOINT       CGPointMake(-160, 240)
#define WEBVIEW_SHOWPOINT       CGPointMake( 160, 240)

// Wheel
void _librarySetup() {
    [RRUlib librarySetup];
    //
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = [app keyWindow];
    CGRect startPos = WEBVIEW_FRAME;
    [RRUlib initWebView:window.rootViewController.view frame:startPos baseURL:nil];
    // Header Setting
    _resetHeader();
    // Webview Frame
    [RRUlib setWebViewFrame:WEBVIEW_FRAME];
}

void _librarySetupWith(UIView *rootView) {
    [RRUlib librarySetup];
    //
    CGRect startPos = WEBVIEW_FRAME;
    //
    [RRUlib initWebView:rootView frame:startPos baseURL:nil];
    // Header Setting
    _resetHeader();
    // Webview Frame
    [RRUlib setWebViewFrame:WEBVIEW_FRAME];
}

void _setWebViewToUnityCallbackByResponse(WebViewToUnityCallbackByResponse cb) {
    RRUlib *sharedRRUlibrary = [RRUlib sharedLibrary];
    if (sharedRRUlibrary.webview) {
        [sharedRRUlibrary.webview setWebViewToUnityCallbackByResponse:cb];
    }
}

void _setWebViewToUnityCallbackByTaplink(WebViewToUnityCallbackByTaplink cb) {
    RRUlib *sharedRRUlibrary = [RRUlib sharedLibrary];
    if (sharedRRUlibrary.webview) {
        [sharedRRUlibrary.webview setWebViewToUnityCallbackByTaplink:cb];
    }
}

// Interval Timer
void _startIntervalTimer(float intervalSec, id target, SEL selector) {
    [RRUlib startIntervalTimer:intervalSec target:target selector:selector];
}

void _stopIntervalTimer() {
    [RRUlib stopIntervalTimer];
}

void _pauseIntervalTimer() {
    [RRUlib pauseIntervalTimer];
}

void _resumeIntervalTimer() {
    [RRUlib resumeIntervalTimer];
}

BOOL _isValidIntervalTimer() {
    return [RRUlib isValidIntervalTimer];
}

// KeyChain
const char * _createUuid() {
    NSString *tmpstr = [RRUlib createUUID];
    char *retchar = nil;
    const char *tmp = [tmpstr UTF8String];
    if (tmp) {
        retchar = (char *)malloc(strlen(tmp)+1);
        strcpy(retchar, tmp);
    }
    return retchar;
}

const char * _loadUuid() {
    NSString *tmpstr = [RRUlib loadUUID];
    char *retchar = nil;
    const char *tmp = [tmpstr UTF8String];
    if (tmp) {
        retchar = (char *)malloc(strlen(tmp)+1);
        strcpy(retchar, tmp);
    }
    return retchar;
}

void _saveUuid(const char *uuid) {
    NSString *uuidstr = [[NSString alloc] initWithCString:uuid encoding:NSUTF8StringEncoding];
    [RRUlib saveUUID:uuidstr];
}

void _deleteUuid() {
    [RRUlib deleteUUID];
}

// WebView
void _resetHeader() {
    [RRUlib removeAllRequestHeader];
    // uuid
    NSString *uuid = [RRUlib loadUUID];
    if (uuid != nil) {
        [RRUlib addWebRequestHeader:WEBVIEW_REQUEST_HEADER_UUID value:uuid];
        NSLog(@"uuid:%@", uuid);
    }
}

int _addWebViewBodyHookKey(const char *key) {
    return [RRUlib addWebViewBodyHookKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
}

void _removeAllWebViewBodyHookKey() {
    [RRUlib removeAllWebViewBodyHookKey];
}

void _loadRequest(const char *requesturl) {
    if (requesturl != nil) {
        _resetHeader();
        NSString *urlstr = [NSString stringWithCString:requesturl encoding:NSUTF8StringEncoding];
        [RRUlib loadRequest:urlstr];
    }
}

void _setWebViewSize(int top, int bottom) {
    CGRect screenR = [[UIScreen mainScreen] applicationFrame];
    float hrate = 1.0f;
    if (screenR.size.height < 960.0f) {
        hrate = screenR.size.height / 960.0f;
    }
    CGRect webviewR = CGRectMake(0.0f, (float)top * hrate, screenR.size.width, screenR.size.height - (float)(top + bottom) * hrate);
    //NSLog(@"%f,%f,%f,%f", webviewR.origin.x, webviewR.origin.y, webviewR.size.width, webviewR.size.height);
    [RRUlib setWebViewFrame:webviewR];
}

void _openWebView() {
    [RRUlib openWebView];
}

void _closeWebView() {
    [RRUlib closeWebView];
}
