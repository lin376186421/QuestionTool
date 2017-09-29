//
//  AppDelegate.m
//  QuestionTools
//
//  Created by 林 on 2017/5/18.
//  Copyright © 2017年 林. All rights reserved.
//

#import "AppDelegate.h"
#import "QuestionsEncryptionViewController.h"
#import "LogViewController.h"
#import "QuestionsEncryptionViewController.h"
@interface AppDelegate ()
{
    NSStoryboard *_storyboard;
    NSWindowController *_mainWindowController;
    LogViewController *_logWindowController;
    QuestionsEncryptionViewController *_QuestionsEncryptionWindowController;
    
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *windowController = [_storyboard instantiateControllerWithIdentifier:@"MainWindowController"];
    _mainWindowController = windowController;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)setLogWindowController:(NSWindowController *)windowVC
{
    _logWindowController = (id)windowVC;
}

- (void)setQuestionsEncryptionWindowController:(NSWindowController *)windowVC
{
    _QuestionsEncryptionWindowController = (id)windowVC;
}

- (void)addLog:(NSString *)log
{
    if (_logArr == nil) {
        _logArr = [NSMutableArray array];
    }
    
    [_logArr addObject:log];
    if (_logWindowController) {
        [_logWindowController addLog];
    }
}

- (IBAction)showDB_DEAction:(id)sender {
    
    if (_QuestionsEncryptionWindowController) {
        return;
    }
    
    QuestionsEncryptionViewController *windowVC = [[QuestionsEncryptionViewController alloc] initWithWindowNibName:@"QuestionsEncryptionViewController"];
    [_mainWindowController.window addChildWindow:windowVC.window ordered:NSWindowAbove];
    //[NSApp runModalForWindow:windowVC.window]; 底部window不能操作
    
}

- (IBAction)showLogAction:(id)sender {
    
    if (_logWindowController) {
        return;
    }
    
    LogViewController *windowVC = [[LogViewController alloc] initWithWindowNibName:@"LogViewController"];
    [_mainWindowController.window addChildWindow:windowVC.window ordered:NSWindowAbove];
}

- (void)addStrToPasteboard:(NSString *)str
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]
               owner:self];
    BOOL ret = [pb setString:str forType:NSStringPboardType];
    NSLog(@"%zd",ret);
}

@end
