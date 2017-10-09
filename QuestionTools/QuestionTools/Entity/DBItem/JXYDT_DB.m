//
//  JXYDT_DB.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "JXYDT_DB.h"
#import "FFJXYDTQuestionItem.h"

@implementation JXYDT_DB

- (void)setUp
{
    self.name = @"jxydt520";
    self.oldName = @"jxydt";
    self.appName = @"驾校一点通";
}

- (void)compareSelf:(NSString *)path withOldPath:(NSString *)oldPath
{
    NSLog(@"自身比对");
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", oldPath];
        [db executeUpdate:sql];
    }];
    
    __block NSInteger lastId = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        //比较章节
        NSLog(@"章节比较：");
        FMResultSet *rs = [db executeQuery:@"select a.*, b.counts as bcounts from Chapter a left outer join Q.Chapter b on a.id = b.id"];
        while ([rs next]) {
            if ([rs intForColumn:@"bcounts"] != [rs intForColumn:@"counts"]) {
                NSLog(@"%zd.%@ = %zd - %zd", [rs intForColumn:@"id"], [rs stringForColumn:@"Str"], [rs intForColumn:@"counts"], [rs intForColumn:@"bcounts"]);
            }
        }
        [rs close];
        
        NSLog(@"题目比较：");
        //todo
        NSInteger acount = [db intForQuery:@"select count(*) from t_question"];
        NSInteger bcount = [db intForQuery:@"select count(*) from Q.t_question"];
        
        NSInteger lastAid = 0;
        NSInteger lastBid = 0;
        rs = [db executeQuery:@"select * from t_question order by _id desc limit 1"];
        while ([rs next]) {
            lastAid = [rs intForColumn:@"_id"];
        }
        
        rs = [db executeQuery:@"select * from Q.t_question order by _id desc limit 1"];
        while ([rs next]) {
            lastBid = [rs intForColumn:@"_id"];
        }
        
        NSLog(@"count: %zd - %zd = %zd", acount, bcount, acount - bcount);
        NSLog(@"qid  : %zd - %zd = %zd", lastAid, lastBid, lastAid - lastBid);
        
        lastId = lastBid;
        
        [rs close];
    }];
    self.lastId = lastId;
}

- (void)changeToCLDBWithFromId:(NSInteger)fromId
{
    NSLog(@"转换题库(CL_DB)");
    
    NSString *bundlePath = BUNDLE(self.name, @"db");
    // 获取题库
    NSMutableArray *items = [NSMutableArray array];
    FFDatabase *db_other = [[FFDatabase alloc] initWithPath:bundlePath
                                             supportClasses:nil];
    [db_other excuteTransactionWithBlock:^(FMDatabase *db) {
        
        //todo fromId
        FMResultSet *rs = [db executeQuery:@"select * from web_note"];
        while ([rs next]) {
            FFJXYDTQuestionItem *item = [[FFJXYDTQuestionItem alloc] initWithResultSet:rs];
            [items addObject:item];
        }
        [rs close];
        NSLog(@"读取考题成功，共%zd题", items.count);
    }];
    
    // 存入考驾照数据库
    NSString *path = [self cldb_pathWithFromId:fromId];
    
    FFDatabase *db_clkjz = [[FFDatabase alloc] initWithPath:path
                                             supportClasses:@[[FFQuestionItem class]]];
    [db_clkjz excuteTransactionWithBlock:^(FMDatabase *db) {
        // 重建索引
        [items enumerateObjectsUsingBlock:^(FFJXYDTQuestionItem *obj, NSUInteger idx, BOOL *top) {
            // 转换考题对象
            FFQuestionItem *item = [FFQuestionItem new];
            item.id              = (int)idx+1;
            item.course          = obj.course;
            item.question_id     = obj.ID;
            item.chapter         = 0;
            item.category        = obj.category;
            item.type            = obj.type;
            item.cert_type       = obj.cert_type;
            item.question        = obj.Question;
            item.media           = obj.media;
            item.media_type      = obj.media_type;
            item.option_a        = obj.An1;
            item.option_b        = obj.An2;
            item.option_c        = obj.An3;
            item.option_d        = obj.An4;
            item.option_e        = obj.An5;
            item.option_f        = obj.An6;
            item.option_g        = obj.An7;
            item.answer          = obj.answer;
            item.difficulty      = obj.diff_degree;
            item.comments        = obj.explain;
            [db insertObject:item];
        }];
        NSLog(@"转换考题成功:共%zd题", items.count);
    }];
}

@end
