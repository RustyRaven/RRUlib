//
//  RRUlibForUnity.h
//  
//
//  Created by snishiura on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RRUlibCallback.h"

// Wheel
void _librarySetup();
void _librarySetupWith(UIView *rootView);
void _setWebViewToUnityCallbackByResponse(WebViewToUnityCallbackByResponse cb);
void _setWebViewToUnityCallbackByTaplink(WebViewToUnityCallbackByTaplink cb);

// IntervalTimer
void _startIntervalTimer(float intervalSec, id target, SEL selector);
void _stopIntervalTimer();
void _pauseIntervalTimer();
void _resumeIntervalTimer();
BOOL _isValidIntervalTimer();

// KeyChain
const char * _createUuid();
const char * _loadUuid();
void _saveUuid(const char *uuid);
void _deleteUuid();

// WebView
void _resetHeader();
int  _addWebViewBodyHookKey(const char *key);
void _removeAllWebViewBodyHookKey();
void _loadRequest(const char *requesturl);
void _setWebViewSize(int top, int bottom);
void _openWebView();
void _closeWebView();
