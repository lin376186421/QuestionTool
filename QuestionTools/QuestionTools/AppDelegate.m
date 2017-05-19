//
//  AppDelegate.m
//  QuestionTools
//
//  Created by 林 on 2017/5/18.
//  Copyright © 2017年 林. All rights reserved.
//

#import "AppDelegate.h"
#import "QuestionsEncryptionControll.h"

@interface AppDelegate ()
{
    NSStoryboard *_storyboard;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)showDB_DEAction:(id)sender {
   
    QuestionsEncryptionControll *vc = [_storyboard instantiateControllerWithIdentifier:@"QuestionsEncryptionControll"];
//    NSApp.keyWindow
    NSWindowController *windowVC = [[NSWindowController alloc] initWithWindow:[[NSWindow alloc] init]];
    [windowVC setContentViewController:vc];
    [windowVC showWindow:nil];
}

- (IBAction)showLogAction:(id)sender {
}

@end
