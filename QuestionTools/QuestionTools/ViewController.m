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
#import "PlistFileExchangeController.h"


@interface ViewController()
{
    QuestionCompareController *_qcVC;
    QuestionsEncryptionViewController *_qeVC;
    ProjectFileCompareController *_pfcVC;
    PlistFileExchangeController *_pfeVC;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)showWindow:(NSWindowController *)windowVC
{
    NSRect rect = windowVC.window.frame;
    NSRect windowFrame = [NSApplication sharedApplication].keyWindow.frame;
    rect.origin.x = windowFrame.origin.x + windowFrame.size.width + 10;
    rect.origin.y = windowFrame.origin.y + windowFrame.size.height/2 - rect.size.height/2;
    [windowVC.window setFrame:rect display:YES];
    [[NSApplication sharedApplication].keyWindow addChildWindow:windowVC.window ordered:NSWindowAbove];
//    [[NSApplication sharedApplication].keyWindow addChildWindow:windowVC.window ordered:NSWindowAbove];
//    [NSApp runModalForWindow:windowVC.window];
}

- (IBAction)compareQuestion:(id)sender {
    if (_qcVC==nil) {
        QuestionCompareController *windowVC = [[QuestionCompareController alloc] initWithWindowNibName:@"QuestionCompareController"];
        _qcVC = windowVC;
    }
    [self showWindow:_qcVC];
}

- (IBAction)encodeQuestionDB:(id)sender {
    if (_qeVC==nil) {
        QuestionsEncryptionViewController *windowVC = [[QuestionsEncryptionViewController alloc] initWithWindowNibName:@"QuestionsEncryptionViewController"];
        _qeVC = windowVC;
    }
    [self showWindow:_qeVC];
}

- (IBAction)compareProjectFile:(id)sender {
    if (_pfcVC == nil) {
        ProjectFileCompareController *windowVC = [[ProjectFileCompareController alloc] initWithWindowNibName:@"ProjectFileCompareController"];
        _pfcVC = windowVC;
    }
    [self showWindow:_pfcVC];
}

- (IBAction)PlistFileExchange:(id)sender {
    if (!_pfeVC) {
        _pfeVC = [[PlistFileExchangeController alloc] initWithWindowNibName:@"PlistFileExchangeController"];
    }
    [self showWindow:_pfeVC];
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
//}

@end
