//
//  RRUViewAnimationKey.h
//
//
//  Created by snishiura on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RRUViewAnimationKey : NSObject {
    float m_animtime;
    CGPoint m_center;
}

@property (nonatomic, readonly) float animtime;
@property (nonatomic, readonly) CGPoint center;

- (id)initWithParams:(float)animtime center:(CGPoint)center;

@end
