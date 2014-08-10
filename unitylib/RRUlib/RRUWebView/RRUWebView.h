//
//  RRUWebView.h
//  
//
//  Created by snishiura on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRUlibCallback.h"

@interface RRUWebView : UIWebView<UIWebViewDelegate> {
    NSMutableDictionary *m_requestheaders;
    NSMutableArray *m_hookkeys;
    NSMutableArray *m_animations;
    //
    UIActivityIndicatorView *m_indicator;
    WebViewToUnityCallbackByResponse m_cbresponse;
    WebViewToUnityCallbackByTaplink m_cbtaplink;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSString *)baseURL indicator:(UIActivityIndicatorView *)indicator;
- (void)setWebViewToUnityCallbackByResponse:(WebViewToUnityCallbackByResponse)callback;
- (void)setWebViewToUnityCallbackByTaplink:(WebViewToUnityCallbackByTaplink)callback;
- (int)addRequestHeader:(NSString *)key value:(NSString *)value;
- (void)removeAllRequestHeader;
- (int)addBodyHookKey:(NSString *)key;
- (void)removeAllBodyHookKey;

- (void)setWebviewFrame:(CGRect)frame;
- (void)showWithAnimation;
- (void)hideWithAnimation;

// taplink callback
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
