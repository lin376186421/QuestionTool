//
//  AppDelegate.h
//  QuestionTools
//
//  Created by 林 on 2017/5/18.
//  Copyright © 2017年 林. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define App_Delegate  ((AppDelegate *)[NSApplication sharedApplication].delegate)

#define APP_LOG_ADD_EVENT @"app.log.add.event"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSMutableArray<NSString *> *logArr;
-(void)addLog:(NSString *)log;
- (void)setLogWindowController:(NSWindowController *)windowVC;

@end

