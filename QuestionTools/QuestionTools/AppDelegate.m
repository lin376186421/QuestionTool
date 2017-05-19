//
//  AppDelegate.m
//  QuestionTools
//
//  Created by 林 on 2017/5/18.
//  Copyright © 2017年 林. All rights reserved.
//

#import "AppDelegate.h"
#import "QuestionsEncryptionViewController.h"
@interface AppDelegate ()
{
    NSStoryboard *_storyboard;
    NSWindowController *_mainWindowController;
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


- (IBAction)showDB_DEAction:(id)sender {
    //底部window不能操作
//    QuestionsEncryptionViewController *windowVC = [[QuestionsEncryptionViewController alloc] initWithWindowNibName:@"QuestionsEncryptionViewController"];
////    [windowVC showWindow:nil];
//    [NSApp runModalForWindow:windowVC.window];
    //两个window都能操作
    QuestionsEncryptionViewController *windowVC = [[QuestionsEncryptionViewController alloc] initWithWindowNibName:@"QuestionsEncryptionViewController"];
    [_mainWindowController.window addChildWindow:windowVC.window ordered:NSWindowAbove];
    
}

- (IBAction)showLogAction:(id)sender {

}

@end
