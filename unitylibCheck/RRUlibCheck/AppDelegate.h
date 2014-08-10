//
//  AppDelegate.h
//  
//
//  Created by snishiura on 12/11/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DebugViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *_window;
    DebugViewController *_debugViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DebugViewController *debugViewController;

@end
