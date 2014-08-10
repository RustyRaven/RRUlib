//
//  RRUViewAnimationKey.m
//
//
//  Created by snishiura on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRUViewAnimationKey.h"

@implementation RRUViewAnimationKey

@synthesize animtime = m_animtime;
@synthesize center = m_center;

- (id)initWithParams:(float)animtime center:(CGPoint)center
{
    self = [super init];
    if (self) {
        m_animtime = animtime;
        m_center = center;
    }
    return self;
}

@end
