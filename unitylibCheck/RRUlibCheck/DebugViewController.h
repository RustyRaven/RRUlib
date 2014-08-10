//
//  DebugViewController.h
//  
//
//  Created by snishiura on 12/11/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugViewController : UIViewController {
    // Interval Timer
    UILabel *m_timerLabel;
    UISwitch *m_timerSwitch;
    
    // KeyChain
    UILabel *m_uuidLabel;
    UILabel *m_passLabel;
    UIButton *m_keychainLoadButton;
    UIButton *m_keychainDeleteButton;
    
    // WebView
    UIButton *m_webViewButton;

    // inner
    BOOL m_ticktack;
    BOOL m_wvtoggle;
}

@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UISwitch *timerSwitch;
@property (nonatomic, retain) IBOutlet UILabel *uuidLabel;
@property (nonatomic, retain) IBOutlet UIButton *keychainLoadButton;
@property (nonatomic, retain) IBOutlet UIButton *keychainDeleteButton;
@property (nonatomic, retain) IBOutlet UIButton *webViewButton;

- (IBAction)toggleTimer:(id)sender;
- (IBAction)createButtonPushed:(id)sender;
- (IBAction)saveButtonPushed:(id)sender;
- (IBAction)loadButtonPushed:(id)sender;
- (IBAction)deleteButtonPushed:(id)sender;
- (IBAction)testButtonPushed:(id)sender;
- (IBAction)toggleWebView:(id)sender;

@end
