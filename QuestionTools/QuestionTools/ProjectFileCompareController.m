//
//  ProjectFileCompareController.m
//  QuestionTools
//
//  Created by cheng on 2017/9/29.
//  Copyright © 2017年 林. All rights reserved.
//

#import "ProjectFileCompareController.h"
#import "OCProjectParse.h"

@interface ProjectFileCompareController () {
    
    IBOutlet NSTextField *_pathTextField;
    IBOutlet NSTextField *_targetTextField1;
    IBOutlet NSTextField *_targetTextField2;
    
    IBOutlet NSTextView *_resultTextView;
    IBOutlet NSButton *_submitBtn;
}

@end

@implementation ProjectFileCompareController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [_submitBtn setAction:@selector(submitBtnAction:)];
    [_submitBtn setTarget:self];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [App_Delegate setQuestionsEncryptionWindowController:nil];
    [NSApp stopModalWithCode:0];
}

- (IBAction)submitBtnAction:(id)sender {
//    NSString *path = [_pathTextField stringValue];
//    NSString *target1 = [_targetTextField1 stringValue];
//    NSString *target2 = [_targetTextField2 stringValue];
//    
//    NSString *string = [OCProjectParse parseProjectWithPath:path targetName:target1 andTargetName:target2];
//    [_resultTextView setString:string];
}
- (IBAction)submitAct:(id)sender {
    
}

@end
