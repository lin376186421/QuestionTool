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

//- (void)courseBtnAction:(NSNotification *)n
//{
//   
//}
//
//- (IBAction)certTypeAction:(NSView *)sender {
//    //选择驾校类型
//}

//- (IBAction)compareAction:(NSView *)sender {
//
//    BOOL _newPatnVaild = [[NSFileManager defaultManager] fileExistsAtPath:_jingpinNewFullPathLabel.stringValue];
//    BOOL _oldPatnVaild = [[NSFileManager defaultManager] fileExistsAtPath:_jingpinOldFullPathLabel.stringValue];
//    BOOL _kjzPatnVaild = [[NSFileManager defaultManager] fileExistsAtPath:_kjzFullPathLabel.stringValue];
//    NSUInteger certType = [self certType];//驾照类型
//    
//    
////    NSWindow *window = self.view.window;
////    [window setFrame:CGRectMake(0, 0, 580, 400) display:YES];
////    return;
////    _course//科目 x X
////    _isAuto//
////    _isCL_DB//
////    _isCreateFile
//    switch (sender.tag) {
//        case 1:
//        {
//            //比对自身
//            if (!_newPatnVaild) {
//                [self showAlterWithMessage:@"请拖入有效的新竞品题库路径"];
//                return;
//            }
//            
//            if (!_oldPatnVaild) {
//                [self showAlterWithMessage:@"请拖入有效的旧竞品题库路径"];
//                return;
//            }
//            
//        }
//            break;
//        case 2:
//        {
//            //比对考驾照
//            if (!_kjzPatnVaild) {
//                [self showAlterWithMessage:@"请拖入有效的考驾照题库路径"];
//                return;
//            }
//            
//            if (!_newPatnVaild || !_oldPatnVaild) {
//                [self showAlterWithMessage:@"请至少拖入一个有效的竞品题库路径"];
//                return;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//>>>>>>> 921af7d77af1656033fb8b9f313dbd8d7944216c
//}

@end
