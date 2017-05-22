//
//  LogShowViewController.m
//  QuestionTools
//
//  Created by 林 on 2017/5/22.
//  Copyright © 2017年 林. All rights reserved.
//

#import "LogShowViewController.h"

@interface LogShowViewController ()
{
    IBOutlet NSScrollView *_scrollView;
    
}

@end

@implementation LogShowViewController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self addLabel];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)addLabel
{
    {
    NSTextField *text = [NSTextField labelWithString:@"ssssssssssssssssssssssssssssssssssss"];
    text.frame = CGRectMake(0, 0, _scrollView.documentView.bounds.size.width, _scrollView.documentView.bounds.size.height);
    text.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    [_scrollView.documentView addSubview:text];
    }
    {
    NSTextField *text = [NSTextField labelWithString:@"ssssssssssssssssssssssssssssssssssss"];
    text.frame = CGRectMake(0, 70, _scrollView.documentView.bounds.size.width, _scrollView.documentView.bounds.size.height);
    text.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    [_scrollView.documentView addSubview:text];
    }
}


@end
