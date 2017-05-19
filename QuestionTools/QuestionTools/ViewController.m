//
//  ViewController.m
//  QuestionTools
//
//  Created by 林 on 2017/5/18.
//  Copyright © 2017年 林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
{
    IBOutlet NSButton *_jiakaoBtn;
    IBOutlet NSButton *_yidiantongBtn;
    IBOutlet NSButton *_yuanbeiBtn;
    
    IBOutlet NSPopUpButton *_certTypeBtn;
    IBOutlet NSButton *_kemu4Btn;
    IBOutlet NSButton *_kemu1Btn;
    IBOutlet NSButton *_createFileBtn;
    IBOutlet NSTextField *_kjzPathTextField;
    IBOutlet NSTextField *_kjzFullPathLabel;
    IBOutlet NSButton *_isCL_DBBtn;
    IBOutlet NSButton *_autoReadBtn;
    IBOutlet NSTextField *_jingpPinOldPathTextField;
    IBOutlet NSTextField *_jingpinNewFullPathLabel;
    IBOutlet NSTextField *_jingpPinNewPathTextField;
    IBOutlet NSTextField *_jingpinOldFullPathLabel;
    IBOutlet NSButton *_compareSelfBtn;
    IBOutlet NSButton *_comparseSelf;
    
    NSUInteger _chooseJinPinType;//1 驾考 2 一点通 3 元贝
    NSUInteger _course;//1 4
    NSUInteger _certType;
    BOOL _isAuto;
    BOOL _isCL_DB;
    BOOL _isCreateFile;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _jingpinNewFullPathLabel.maximumNumberOfLines = _jingpinOldFullPathLabel.maximumNumberOfLines = _kjzFullPathLabel.maximumNumberOfLines = 5;
    [_certTypeBtn removeAllItems];
    [_certTypeBtn addItemsWithTitles:@[@"1-小车",@"2-客车",@"4-货车",@"8-摩托车"]];
    [_certTypeBtn selectItemAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseBtnAction:) name:NSPopUpButtonWillPopUpNotification object:nil];
    
    [self chooseJinPinAction:_jiakaoBtn];
    [self chooseCourseAction:_kemu1Btn];

     _autoReadBtn.state = 1;
    _isCL_DBBtn.state = 0;
    _isAuto = 1;
    _isCL_DB = 0;
    _createFileBtn.state = 1;
    _isCreateFile = 1;
    [self autoReadAction:_autoReadBtn];
    [self setDefaultKJZPath];
    // Do any additional setup after loading the view.
}

- (void)setDefaultKJZPath
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDesktopDirectory,NSUserDomainMask, YES);
    NSString *deskPath = paths[0];
    NSString *kjzPath = [[deskPath stringByAppendingPathComponent:@"kjz_db"] stringByAppendingPathComponent:@"questions.db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:kjzPath]) {
        [_kjzPathTextField setStringValue:kjzPath];
        [self textFieldDidChange:_kjzPathTextField];
    }
}

- (void)textDidChange:(NSNotification *)notification
{
    NSTextView *textView = notification.object;
    if (![textView isKindOfClass:[NSTextView class]]) {
        return;
    }
    NSTextField *textField = (id)textView.superview.superview;
    [self textFieldDidChange:textField];
}

- (void)textFieldDidChange:(NSTextField *)textField
{
    if (textField == nil) {
        return;
    }
    NSString *fullPath = textField.stringValue;
    NSString *lastPath = [fullPath lastPathComponent];
    [textField setStringValue:lastPath];
    if (textField == _jingpPinNewPathTextField) {
        [_jingpinNewFullPathLabel setStringValue:fullPath];
    } else if (textField == _jingpPinOldPathTextField) {
        [_jingpinOldFullPathLabel setStringValue:fullPath];
    } else if (textField == _kjzPathTextField) {
        [_kjzFullPathLabel setStringValue:fullPath];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)showAlterWithMessage:(NSString *)message{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"ok"];
    
    [alert setMessageText:@"警告"];
    
    [alert setInformativeText:message];
    
    [alert setAlertStyle:NSAlertStyleWarning];
    
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:^(NSInteger result) {
//        if (result == NSAlertFirstButtonReturn) {//响应第一个按钮被按下：name：firstname；
//            //...
//            NSLog(@"Ok");
//        }
//        if (result == NSAlertSecondButtonReturn) {
//            NSLog(@"Cancel");
//            
//        }
//        if (result == NSAlertThirdButtonReturn) {
//            NSLog(@"chenglibin1");
//        }
        
    }];
}

- (NSUInteger)certType
{
    NSString *certTypeTitle = [_certTypeBtn itemTitleAtIndex:[_certTypeBtn indexOfSelectedItem]];
    NSArray *arr = [certTypeTitle componentsSeparatedByString:@"-"];
    if (arr.count != 2) {
        [self showAlterWithMessage:@"驾照类型数据设置错误"];
        return 0;
    }
    return [arr[0] integerValue];
}

- (IBAction)chooseJinPinAction:(NSButton *)sender {
    _jiakaoBtn.state = _yuanbeiBtn.state = _yidiantongBtn.state = 0;
    sender.state = 1;
    _chooseJinPinType = sender.tag;
}

- (IBAction)isCreateFileAction:(NSButton *)sender {
    
}

- (IBAction)autoReadAction:(NSButton *)sender {
    //自动识别
    
    if (sender.state == 1) {
        _isCL_DBBtn.enabled = NO;
    } else {
        _isCL_DBBtn.enabled = YES;
    }
    _isAuto = _autoReadBtn.state;
    _isCL_DB = _isCL_DBBtn.state;
    NSLog(@"%zd %zd",_isAuto,_isCL_DB);
}

- (IBAction)isCL_DBAction:(NSButton *)sender {
    
    _isAuto = _autoReadBtn.state;
    _isCL_DB = _isCL_DBBtn.state;
    NSLog(@"%zd %zd",_isAuto,_isCL_DB);
}

- (IBAction)chooseCourseAction:(NSButton *)sender {
    _kemu1Btn.state = _kemu4Btn.state = 0;
    sender.state = 1;
    _course = sender.tag;
}

//- (void)courseBtnAction:(NSNotification *)n
//{
//   
//}
//
//- (IBAction)certTypeAction:(NSView *)sender {
//    //选择驾校类型
//}

- (IBAction)compareAction:(NSView *)sender {
    BOOL _newPatnVaild = [[NSFileManager defaultManager] fileExistsAtPath:_jingpinNewFullPathLabel.stringValue];
    BOOL _oldPatnVaild = [[NSFileManager defaultManager] fileExistsAtPath:_jingpinOldFullPathLabel.stringValue];
    BOOL _kjzPatnVaild = [[NSFileManager defaultManager] fileExistsAtPath:_kjzFullPathLabel.stringValue];
    NSUInteger certType = [self certType];//驾照类型

//    _course//科目
//    _isAuto//
//    _isCL_DB//
//    _isCreateFile
    switch (sender.tag) {
        case 1:
        {
            //比对自身
            if (!_newPatnVaild) {
                [self showAlterWithMessage:@"请拖入有效的新竞品题库路径"];
                return;
            }
            
            if (!_oldPatnVaild) {
                [self showAlterWithMessage:@"请拖入有效的旧竞品题库路径"];
                return;
            }
            
        }
            break;
        case 2:
        {
            //比对考驾照
            if (!_kjzPatnVaild) {
                [self showAlterWithMessage:@"请拖入有效的考驾照题库路径"];
                return;
            }
            
            if (!_newPatnVaild || !_oldPatnVaild) {
                [self showAlterWithMessage:@"请至少拖入一个有效的竞品题库路径"];
                return;
            }
        }
            break;
        default:
            break;
    }
}

@end
