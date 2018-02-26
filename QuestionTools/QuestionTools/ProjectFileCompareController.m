//
//  ProjectFileCompareController.m
//  QuestionTools
//
//  Created by cheng on 2017/9/29.
//  Copyright © 2017年 林. All rights reserved.
//

#import "ProjectFileCompareController.h"
#import "OCProjectParse.h"

#define APP_CONST_ProjectFileCompareController_LAST_PATH    @"app.const.ProjectFileCompareController.last.path"

@interface ProjectFileCompareController () <NSTextFieldDelegate> {
    
    IBOutlet NSTextField *_pathTextField;
    
    IBOutlet NSPopUpButton *_target1Item;
    IBOutlet NSPopUpButton *_target2Item;
    
    IBOutlet NSTextView *_resultTextView;
    IBOutlet NSButton *_submitBtn;
    
    NSArray *_targetsArray;
}

@end

@implementation ProjectFileCompareController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:nil];
    
    NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:APP_CONST_ProjectFileCompareController_LAST_PATH];
    if (path) {
        [_pathTextField setStringValue:path];
    }
    
    [_resultTextView setFont:[NSFont systemFontOfSize:14]];
    
    [self updateTargets];
}

- (void)updateTargets
{
    _targetsArray = [OCProjectParse targetsFromProjectPath:[_pathTextField stringValue]];
    
    [_target1Item removeAllItems];
    [_target2Item removeAllItems];
    if (_targetsArray) {
        [_target1Item addItemsWithTitles:_targetsArray];
        [_target2Item addItemsWithTitles:_targetsArray];
        
        [_target2Item removeItemWithTitle:[_target1Item titleOfSelectedItem]];
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [App_Delegate setQuestionsEncryptionWindowController:nil];
    [NSApp stopModalWithCode:0];
}

- (IBAction)clearBtnAction:(id)sender {
    [_pathTextField setStringValue:@""];
}

- (IBAction)target1SelectAction:(id)sender {
    [self selectedTargetAction:_target1Item otherBtn:_target2Item];
}

- (IBAction)target2SelectAction:(id)sender {
    [self selectedTargetAction:_target2Item otherBtn:_target1Item];
}

- (void)selectedTargetAction:(NSPopUpButton *)btn1 otherBtn:(NSPopUpButton *)btn2
{
    NSString *title1 = [btn1 titleOfSelectedItem];
    NSString *title2 = [btn2 titleOfSelectedItem];
    if (title1.length && title2.length) {
        if ([title1 isEqualToString:title2]) {
            if ([btn2 indexOfSelectedItem] == 0 && _targetsArray.count > 1) {
                [btn2 selectItemAtIndex:1];
            } else {
                [btn2 selectItemAtIndex:0];
            }
        }
    }
}

- (IBAction)submitBtnAction:(id)sender {
    NSString *path = [_pathTextField stringValue];
    NSString *target1 = [_target1Item titleOfSelectedItem];
    NSString *target2 = [_target2Item titleOfSelectedItem];
    
    if (path) {
        if ([OCProjectParse isValidProjectPath:path]) {
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:APP_CONST_ProjectFileCompareController_LAST_PATH];
        }
    }
    
    NSString *string = [OCProjectParse parseProjectWithPath:path targetName:target1 andTargetName:target2];
    [_resultTextView setString:string];
}

#pragma mark - NSTextFieldDelegate

- (void)textDidChange:(NSNotification *)notification
{
    NSTextView *textView = notification.object;
    if ([textView.superview superview] == _pathTextField) {
        [self updateTargets];
    }
}

@end
