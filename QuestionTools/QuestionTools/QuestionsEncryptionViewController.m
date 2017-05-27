//
//  QuestionsEncryptionViewController.m
//  QuestionTools
//
//  Created by 林 on 2017/5/19.
//  Copyright © 2017年 林. All rights reserved.
//

#import "QuestionsEncryptionViewController.h"
#import "fuck_wrapper.h"
#import "FMDB.h"
#import "FMDatabaseAdditions.h"

@interface QuestionsEncryptionViewController ()
{
    FMDatabaseQueue *_dbQueue;
    BOOL _isEncrypt;
    NSString *_newFilePath;
    NSUInteger _curCount;
    NSOperationQueue *_opQueue;
}

@end

@implementation QuestionsEncryptionViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [App_Delegate setQuestionsEncryptionWindowController:nil];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [App_Delegate setQuestionsEncryptionWindowController:self];
    _opQueue = [[NSOperationQueue alloc] init];
    _opQueue.maxConcurrentOperationCount = 5.f;
    
    _eBtn.state = 0;
    _dBtn.state = 1;
    
    _barProgress.hidden = YES;
    _resultLb.hidden = YES;
    _isWork = NO;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (void)windowWillClose:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [App_Delegate setQuestionsEncryptionWindowController:nil];
    [NSApp stopModalWithCode:0];
}

- (void)encryptTxt {
    NSString *txt = @"C";
    txt = sell_coffee(txt, answerWrapper);
    NSLog(@"%@", txt);
}
- (void)decryptTxt {
    NSString *txt = @"C";
    txt = buy_coffee(txt, commentsWrapper);
    NSLog(@"%@", txt);
}

- (void)encryptWholeTxt {
    [self wholeTxt:YES];
}
- (void)decryptWholeTxt {
    [self wholeTxt:NO];
}

-(void)showAlterWithMessage:(NSString *)message{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"ok"];
    
    [alert setMessageText:@"警告"];
    
    [alert setInformativeText:message];
    
    [alert setAlertStyle:NSAlertStyleWarning];
    
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:^(NSInteger result) {
        if (result == NSAlertFirstButtonReturn) {//响应第一个按钮被按下：name：firstname；
            //...
            NSLog(@"Ok");
        }
        if (result == NSAlertSecondButtonReturn) {
            NSLog(@"Cancel");
            
        }
        if (result == NSAlertThirdButtonReturn) {
            NSLog(@"chenglibin1");
        }
        
    }];
}

- (void)wholeTxt:(BOOL)encrypt {
    _isEncrypt = encrypt;
    if([_textInput stringValue].length <= 0)
    {
        [self showAlterWithMessage:@"请输入文件路径"];
        return;
    }
    
    NSString *oldPath = [_textInput stringValue];
    
    BOOL bo;
    if([[NSFileManager defaultManager] fileExistsAtPath:oldPath isDirectory:&bo]){
        if(bo){
            [self showAlterWithMessage:@"无效的文件路径"];
            return;
        }
    }else{
        [self showAlterWithMessage:@"文件不存在"];
        return;
    }
    
    NSMutableArray *fileArr = [NSMutableArray arrayWithArray:[oldPath componentsSeparatedByString:@"/"]];
    NSString *fileName = [fileArr lastObject];
    [fileArr removeLastObject];
    if (_eBtn.state == 1) {
        [fileArr addObject:@"db加密文件"];
    } else {
        [fileArr addObject:@"db解密文件"];
    }
    NSString *newFinder = [fileArr componentsJoinedByString:@"/"];
    BOOL isDir;
    if([[NSFileManager defaultManager] fileExistsAtPath:newFinder isDirectory:&isDir] == NO){
        BOOL ret =  [[NSFileManager defaultManager] createDirectoryAtPath:newFinder withIntermediateDirectories:yearMask attributes:nil error:nil];
        if(ret == NO){
            [self showAlterWithMessage:@"创建文件夹失败"];
            return;
        }
        //        assert(ret);//创建文件夹失败
    }
    [fileArr addObject:fileName];
    NSString *newFilePath = [fileArr componentsJoinedByString:@"/"];
    [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:nil];//删除原有的文件
    [[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:newFilePath error:nil];
    NSString *path = newFilePath;
    _newFilePath = newFilePath;
    
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    _totalCount = [db intForQuery:@"select count(*) from dt_question"];
    [db close];
    
    _barProgress.doubleValue = 0;
    _barProgress.hidden = NO;
    _resultLb.hidden = YES;
    _eBtn.enabled = NO;
    _dBtn.enabled = NO;
    _makeBtn.enabled = NO;
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    _dbQueue = dbQueue;
    _curCount = 0;
    
    NSUInteger maxCount = 2000;//每个线程最多处理条数
    
    NSInteger times = _totalCount/maxCount + 1;
    for (int i = 0; i < times; i++) {
        NSUInteger startIndex = maxCount*i;
        NSUInteger endIndex = maxCount*(i+1);
        if (i==times-1) {
            endIndex = _totalCount;
        }
        [self workWithStartIndex:startIndex endIndex:endIndex];
    }
}

- (void)workWithStartIndex:(NSUInteger)startIndex endIndex:(NSUInteger)endIndex
{
    NSBlockOperation *op = [NSBlockOperation new];
    [op addExecutionBlock:^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sqlStr = [NSString stringWithFormat:@"select course, question_id, question, answer, comments from dt_question limit %zd,%zd",startIndex,(endIndex-startIndex)];
            FMResultSet *rs = [db executeQuery:sqlStr];
            while ([rs next]) {
                _curCount += 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat f = 1.0f*_curCount/_totalCount;
                    _barProgress.doubleValue = f;
                });
                NSString *course = [rs stringForColumnIndex:0];
                NSString *question_id = [rs stringForColumnIndex:1];
                NSString *question;
                NSString *answer;
                NSString *comments;
                if (_isEncrypt) {
                    question = sell_coffee([rs stringForColumnIndex:2], questionWrapper);
                    answer   = sell_coffee([rs stringForColumnIndex:3], answerWrapper);
                    comments = sell_coffee([rs stringForColumnIndex:4], commentsWrapper);
                } else {
                    question = buy_coffee([rs stringForColumnIndex:2], questionWrapper);
                    answer   = buy_coffee([rs stringForColumnIndex:3], answerWrapper);
                    comments = buy_coffee([rs stringForColumnIndex:4], commentsWrapper);
                }
                NSString *sql = [NSString stringWithFormat:@"update dt_question set question='%@', answer='%@', comments=%@ where course=%@ and question_id=%@", question, answer, comments?[NSString stringWithFormat:@"'%@'", comments]:@"null", course, question_id];
                [db executeUpdate:sql];
            }
            [rs close];
            if (_curCount >= _totalCount) {
                [self endWork];
            }
            
        }];

    }];
    [_opQueue addOperation:op];
    return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sqlStr = [NSString stringWithFormat:@"select course, question_id, question, answer, comments from dt_question limit %zd,%zd",startIndex,(endIndex-startIndex)];
            FMResultSet *rs = [db executeQuery:sqlStr];
            while ([rs next]) {
                _curCount += 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat f = 1.0f*_curCount/_totalCount;
                    _barProgress.doubleValue = f;
                });
                NSString *course = [rs stringForColumnIndex:0];
                NSString *question_id = [rs stringForColumnIndex:1];
                NSString *question;
                NSString *answer;
                NSString *comments;
                if (_isEncrypt) {
                    question = sell_coffee([rs stringForColumnIndex:2], questionWrapper);
                    answer   = sell_coffee([rs stringForColumnIndex:3], answerWrapper);
                    comments = sell_coffee([rs stringForColumnIndex:4], commentsWrapper);
                } else {
                    question = buy_coffee([rs stringForColumnIndex:2], questionWrapper);
                    answer   = buy_coffee([rs stringForColumnIndex:3], answerWrapper);
                    comments = buy_coffee([rs stringForColumnIndex:4], commentsWrapper);
                }
                NSString *sql = [NSString stringWithFormat:@"update dt_question set question='%@', answer='%@', comments=%@ where course=%@ and question_id=%@", question, answer, comments?[NSString stringWithFormat:@"'%@'", comments]:@"null", course, question_id];
                [db executeUpdate:sql];
            }
            [rs close];
            if (_curCount >= _totalCount) {
                [self endWork];
            }
            
        }];
        
    });

}
//- (void)setRepresentedObject:(id)representedObject {
//    [super setRepresentedObject:representedObject];
//    
//    // Update the view, if already loaded.
//}

- (IBAction)eAction:(id)sender {
    _eBtn.state = 1;
    _dBtn.state = 0;
}

- (IBAction)dAction:(id)sender {
    _dBtn.state = 1;
    _eBtn.state = 0;
}

- (IBAction)makeAvtion:(id)sender {
    if(_eBtn.state == 1){
        [self encryptWholeTxt];
    }else if(_dBtn.state == 1){
        [self decryptWholeTxt];
    }
    
}

@end
