//
//  LogOutLineView.m
//  QuestionTools
//
//  Created by 林 on 2017/5/25.
//  Copyright © 2017年 林. All rights reserved.
//

#import "LogOutLineView.h"

@implementation LogOutLineView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    [super rightMouseDown:theEvent];
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    NSInteger column = [self columnAtPoint:p];
    NSInteger row = [self rowAtPoint:p];
    if (column >=0 && row >=0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_LOG_OUTLINEVIEW_MOUSEDONW object:@{@"column":@(column),@"row":@(row)}];
    }
}

@end
