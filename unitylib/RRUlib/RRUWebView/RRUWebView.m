//
//  RRUWebView.m
//  
//
//  Created by snishiura on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRUWebView.h"
#import "RRUViewAnimationKey.h"

@implementation RRUWebView

- (id)initWithFrame:(CGRect)frame AndURL:(NSString *)baseURL indicator:(UIActivityIndicatorView *)indicator
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setMultipleTouchEnabled:NO];
        self.scrollView.delaysContentTouches = NO;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.delegate = self;
        self.scalesPageToFit = YES;
        // bounce時の背景を透明＆影グラデを消す.
        self.backgroundColor = [UIColor clearColor];
        for (UIView *subView in [self subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        [shadowView setHidden:YES];
                    }
                }
            }
        }
        //
        m_requestheaders = [[NSMutableDictionary alloc] init];
        m_hookkeys = [[NSMutableArray alloc] init];
        m_animations = [[NSMutableArray alloc] init];
        m_indicator = indicator;
        m_cbresponse = nil;
        m_cbtaplink = nil;
    }
    return self;
}

- (void)dealloc
{
    [m_requestheaders removeAllObjects];
    [m_hookkeys removeAllObjects];
    [m_animations removeAllObjects];
    //
    [m_requestheaders release];
    [m_hookkeys release];
    [m_animations release];
    [super dealloc];
}

//
- (void)setWebViewToUnityCallbackByResponse:(WebViewToUnityCallbackByResponse)callback
{
    m_cbresponse = callback;
}

- (void)setWebViewToUnityCallbackByTaplink:(WebViewToUnityCallbackByTaplink)callback
{
    m_cbtaplink = callback;
}

- (int)addRequestHeader:(NSString *)key value:(NSString *)value
{
#ifdef DEBUG
    NSLog(@"addRequestHeader:%@=%@",key,value);
#endif
    [m_requestheaders setObject:value forKey:key];
    return [m_requestheaders count];
}

- (void)removeAllRequestHeader
{
    [m_requestheaders removeAllObjects];
}

- (int)addBodyHookKey:(NSString *)key
{
    [m_hookkeys addObject:key];
    return [m_hookkeys count];
}

- (void)removeAllBodyHookKey
{
    [m_hookkeys removeAllObjects];
}

- (int)addAnimationKey:(float)animtime center:(CGPoint)center
{
    RRUViewAnimationKey *anim = [[RRUViewAnimationKey alloc] initWithParams:animtime center:center];
    [m_animations addObject:anim];
    [anim release];
    return [m_animations count];
}

- (void)removeAllAnimation
{
    [m_animations removeAllObjects];
}

//
- (void)setWebviewFrame:(CGRect)frame
{
#ifdef DEBUG
    NSLog(@"setWebviewFrame");
#endif
    //
    CGRect hideR = CGRectMake(
                              frame.size.width * -1.0f,
                              frame.origin.y,
                              frame.size.width,
                              frame.size.height);
    [self setFrame:hideR];
    //
    CGPoint hideCenter = CGPointMake(hideR.size.width / -2.0f, hideR.origin.y + hideR.size.height / 2.0f);
    CGPoint showCenter = CGPointMake(frame.size.width /  2.0f, frame.origin.y + frame.size.height / 2.0f);
    [self removeAllAnimation];
    [self addAnimationKey:0.333f center:hideCenter];
    [self addAnimationKey:0.333f center:showCenter];
}

- (void)showWithAnimation
{
#ifdef DEBUG
    NSLog(@"showWithAnimation");
#endif
    for (RRUViewAnimationKey *anim in m_animations) {
        if ((self.center.x != anim.center.x) || (self.center.y != anim.center.y)) {
            [UIView animateWithDuration:anim.animtime
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.center = anim.center;
                             }
                             completion:nil];
        }
    }
}

- (void)hideWithAnimation
{
#ifdef DEBUG
    NSLog(@"hideWithAnimation");
#endif
    for (int i=([m_animations count]-1); i >= 0; i--) {
        RRUViewAnimationKey *anim = [m_animations objectAtIndex:i];
        if ((self.center.x != anim.center.x) || (self.center.y != anim.center.y)) {
            [UIView animateWithDuration:anim.animtime
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.center = anim.center;
                             }
                             completion:nil];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // リンクをタップした時のHook
    NSString *scheme = [[request URL] scheme];
	if ([scheme isEqual:@"mailto"]) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
    if ([scheme isEqual:@"itms-apps"]) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	if ([scheme isEqual:@"safari"]) {
		NSURL *url = [NSURL URLWithString:[[[request URL] absoluteString] substringFromIndex:7 ]];
		[[UIApplication sharedApplication] openURL:url];
		return NO;
	}
    // 登録されているHookKeyと同じスキーマのリンクをタップした際はコールバックを呼ぶだけ（例えばRRUWebViewのCloseとか）
    for (NSString *key in m_hookkeys) {
        if ([scheme isEqualToString:key]) {
#ifdef DEBUG
            NSLog(@"Find Scheme:%@", scheme);
#endif
            if (m_cbtaplink != nil) {
                m_cbtaplink([scheme UTF8String]);
            }
            return NO;
        }
    }
    // インディケーター表示開始
    [m_indicator startAnimating];
    // リンクをタップした時の挙動（その２）
	switch (navigationType) {
        case UIWebViewNavigationTypeFormSubmitted:
        case UIWebViewNavigationTypeLinkClicked:
        case UIWebViewNavigationTypeOther:
        {
            //:todo?
            break;
        }
        default:
            break;
	}

    // iOSキャッシュを飛ばす!
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    // 独自ヘッダをつける
    BOOL missing = NO;
    NSArray *currentHeaders = [[request allHTTPHeaderFields] allKeys];
    for (NSString *key in m_requestheaders) {
        if (![currentHeaders containsObject:key]) {
            missing = YES;
            break;
        }
    }
    if (missing) {
        NSMutableURLRequest *newRequest = [request mutableCopy];
        for (NSString *key in [m_requestheaders allKeys]) {
            [newRequest setValue:[m_requestheaders valueForKey:key] forHTTPHeaderField:key];
        }
#ifdef DEBUG
        currentHeaders = [[request allHTTPHeaderFields] allKeys];
        for (NSString *key in currentHeaders) {
            NSLog(@"RequestHeader:%@=%@", key, [[request allHTTPHeaderFields] objectForKey:key]);
        }
#endif
        [self loadRequest:newRequest];
        [newRequest release];
        return FALSE;
    }
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // レスポンスを受け取った時のHook
    NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSArray *parsedStrings = [body componentsSeparatedByString:@"\n"];
    for (NSString *line in parsedStrings) {
        NSArray *entries = [line componentsSeparatedByString:@"="];
        if ([entries count] != 2) continue;
        NSString *ekey = [entries objectAtIndex:0];
        NSString *evalue = [entries objectAtIndex:1];
        for (NSString *key in m_hookkeys) {
            if ([ekey isEqualToString:key]) {
#ifdef DEBUG
                NSLog(@"Find Key:%@ Value is %@", ekey, evalue);
#endif
                if (m_cbresponse != nil) {
                    m_cbresponse([ekey UTF8String], [evalue UTF8String]);
                }
                break;
            }
        }
    }
    // インディケーター表示終了
    [m_indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // インディケーター表示終了
    [m_indicator stopAnimating];
    // エラーレスポンスを受け取った時のHook
	NSInteger err_code = [error code];
	if (err_code == NSURLErrorCancelled) {
		return;
	}	
	
	NSString* description = [NSString stringWithString:[error localizedDescription]];
	
    NSString* path = [[NSBundle mainBundle] pathForResource:@"error_page" ofType:@"html"];
    if(path != nil) {
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil]; 
    }
    //
	UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alertView show];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ( abs(velocity.y) < 1) {
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
    }
}

@end
