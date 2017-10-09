//
//  ViewController.m
//  QuestionTools
//
//  Created by 林 on 2017/5/18.
//  Copyright © 2017年 林. All rights reserved.
//

#import "ViewController.h"
#import "QuestionsEncryptionViewController.h"
#import "QuestionCompareController.h"
#import "ProjectFileCompareController.h"

@interface ViewController()
{
    
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)showWindow:(NSWindowController *)windowVC
{
    [[NSApplication sharedApplication].keyWindow addChildWindow:windowVC.window ordered:NSWindowAbove];
}

- (IBAction)compareQuestion:(id)sender {
    QuestionCompareController *windowVC = [[QuestionCompareController alloc] initWithWindowNibName:@"QuestionCompareController"];
    [self showWindow:windowVC];
}

- (IBAction)encodeQuestionDB:(id)sender {
    QuestionsEncryptionViewController *windowVC = [[QuestionsEncryptionViewController alloc] initWithWindowNibName:@"QuestionsEncryptionViewController"];
    [self showWindow:windowVC];
}

- (IBAction)compareProjectFile:(id)sender {
    ProjectFileCompareController *windowVC = [[ProjectFileCompareController alloc] initWithWindowNibName:@"ProjectFileCompareController"];
    [self showWindow:windowVC];
}

@end
