//
//  DebugViewController.m
//  
//
//  Created by snishiura on 12/11/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DebugViewController.h"
#import <RRUlib/RRUlibForUnity.h>
#import "AppDelegate.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

@synthesize timerLabel = m_timerLabel;
@synthesize timerSwitch = m_timerSwitch;
@synthesize uuidLabel = m_uuidLabel;
@synthesize keychainLoadButton = m_keychainLoadButton;
@synthesize keychainDeleteButton = m_keychainDeleteButton;
@synthesize webViewButton = m_webViewButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _librarySetupWith(self.view);
    _setWebViewSize(60, 100);
    
    _startIntervalTimer(1.0f, self, @selector(onTickTack:));
    
    m_keychainLoadButton.enabled = YES;
    m_keychainDeleteButton.enabled = NO;
    
    NSString *str = @"TEST";
    const char *key = [str UTF8String];
    _addWebViewBodyHookKey(key);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// RRUlib
// - Timer
- (IBAction)toggleTimer:(id)sender
{
    NSLog(@"toggleTimer");
    if (m_timerSwitch.on) {
        _resumeIntervalTimer();
    } else {
        _pauseIntervalTimer();
    }
}

- (void)onTickTack:(NSTimer *)timer
{
    if (_isValidIntervalTimer()) {
        if (m_ticktack) {
            m_timerLabel.text = @"ヾ(⌒(_・ω・)ノ";
        } else {
            m_timerLabel.text = @"ヽ(⌒(_＞ω＜)シ";
        }
        m_ticktack = !m_ticktack;
    } else {
        m_timerLabel.text = @"paused";
    }
}

// KeyChain
- (IBAction)createButtonPushed:(id)sender
{
    const char *uuid = _createUuid();
    if (uuid) {
        m_uuidLabel.text = [NSString stringWithCString:uuid encoding:NSUTF8StringEncoding];
    } else {
        m_uuidLabel.text = @"no uuid created...";
    }
}

- (IBAction)saveButtonPushed:(id)sender
{
    _saveUuid([m_uuidLabel.text UTF8String]);
    m_uuidLabel.text = @"uuid saved...";
}

- (IBAction)loadButtonPushed:(id)sender
{
    const char *uuid = _loadUuid();
    if (uuid) {
        m_uuidLabel.text = [NSString stringWithCString:uuid encoding:NSUTF8StringEncoding];
        m_keychainDeleteButton.enabled = YES;
    } else {
        m_uuidLabel.text = @"no uuid stored...";
        m_keychainDeleteButton.enabled = NO;
    }
}

- (IBAction)deleteButtonPushed:(id)sender
{
    _deleteUuid();
    m_uuidLabel.text = @"uuid deleted...";
}

- (IBAction)testButtonPushed:(id)sender
{
    NSString *testUUID = @"testuuid";
    _saveUuid([testUUID UTF8String]);
    [self loadButtonPushed:sender];
}

// WebView表示
- (IBAction)toggleWebView:(id)sender
{
    m_wvtoggle = !m_wvtoggle;
    if (m_wvtoggle) {
        NSString *baseurl = @"http://jp.rusty-raven.com/";
        const char *cp = [baseurl UTF8String];
        _loadRequest(cp);
        _openWebView();
    } else {
        _closeWebView();
    }
}

@end
