//
//  KJZNocomment.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZNocomment.h"

@implementation KJZNocomment

+ (void)deal
{
    NSMutableArray *questions = [NSMutableArray array];
    NSString *path = PATH(DB(KJZ));
    FFDatabase *database;
    
    database = [[FFDatabase alloc] initWithPath:path
                                 supportClasses:nil];
    
    [database excuteWithBlock:^(FMDatabase *db) {
        NSString *sql = @"select * from dt_question where cert_type&1>0 and comments is NULL";
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            FFQuestionItem *item = [FFQuestionItem itemFromResultSet:rs];
            item.id = item.itemId;
            [questions addObject:item];
        }
    }];
    
    // 拷贝题库到Documents
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    // 存入考驾照数据库
    NSString *file = [dir stringByAppendingPathComponent:CLDB([KJZ stringByAppendingString:@"_nocomments"])];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    FFDatabase *db_clkjz = [[FFDatabase alloc] initWithPath:file
                                             supportClasses:@[[FFQuestionItem class]]];
    [db_clkjz excuteTransactionWithBlock:^(FMDatabase *db) {
        // 重建索引
        [questions enumerateObjectsUsingBlock:^(FFQuestionItem *obj, NSUInteger idx, BOOL *top) {
            [db insertObject:obj];
        }];
        NSLog(@"导出无评论:共%zd条", questions.count);
    }];
}

@end
