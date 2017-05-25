//
//  MouseButton.m
//  QuestionTools
//
//  Created by 林 on 2017/5/25.
//  Copyright © 2017年 林. All rights reserved.
//

#import "MouseButton.h"


@implementation MouseButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

//重新设定检测区域 以及 需要检测的方式
- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways) owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event
{
    [super mouseEntered:event];
    self.image = _highlightImage;
}

- (void)mouseExited:(NSEvent *)event
{
    [super mouseExited:event];
    self.image = self.alternateImage;
}

-(void)dealloc
{
    _highlightImage = nil;
}


@end
