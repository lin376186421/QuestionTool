//
//  YBJK_DB.m
//  333
//
//  Created by cheng on 17/5/8.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "YBJK_DB.h"
#import "FFYBJKQuestionItem.h"

@implementation YBJK_DB

- (void)setUp
{
    self.name = @"ybkj622";
    self.oldName = @"ybjk601";
    self.appName = @"元贝驾考";
}

- (void)compareSelf:(NSString *)path withOldPath:(NSString *)oldPath
{
    NSLog(@"自身比对");
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (oldPath) {
            NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", oldPath];
            [db executeUpdate:sql];
        }
    }];
    
    __block NSInteger lastId = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //比较章节
        NSLog(@"章节比较：");
        //todo  sql
        FMResultSet *rs = [db executeQuery:@"select a.*, b.count as bcount from t_chapter a left outer join Q.t_chapter b on a._id = b._id"];
        while ([rs next]) {
            if ([rs intForColumn:@"bcount"] != [rs intForColumn:@"count"]) {
                NSLog(@"%zd.%@ = %zd - %zd", [rs intForColumn:@"_id"], [rs stringForColumn:@"title"], [rs intForColumn:@"count"], [rs intForColumn:@"bcount"]);
            }
        }
        //比较题数 以及最后一题
        NSLog(@"题目比较：");
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
    NSLog(@"转换题库");
    // 获取题库
    NSString *bundlePath = BUNDLE(self.name, @"sqlite");
    NSMutableArray *items = [NSMutableArray array];
    
    FFDatabase *db_other = [[FFDatabase alloc] initWithPath:bundlePath
                                             supportClasses:nil];
    [db_other excuteTransactionWithBlock:^(FMDatabase *db) {
        //todo  fromId
        FMResultSet *rs = [db executeQuery:@"select a.*, b.* from app_exam_base a left outer join app_exam_main b on a.BaseId=b.BaseID where b.TikuID = 'wyc'"];
        while ([rs next]) {
            FFYBJKQuestionItem *item = [[FFYBJKQuestionItem alloc] initWithResultSet:rs];
            [items addObject:item];
        }
        [rs close];
        NSLog(@"转换考题成功，共%zd题", items.count);
    }];
    
    // 创建图片文件夹
    NSString *dir_image = PATH(([NSString stringWithFormat:@"%@_images", self.name]));
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:dir_image]) {
        [manager createDirectoryAtPath:dir_image
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    
    // 存入考驾照数据库
    NSString *path = [self cldb_pathWithFromId:fromId];
    
    FFDatabase *db_clkjz = [[FFDatabase alloc] initWithPath:path
                                             supportClasses:@[[FFQuestionItem class]]];
    [db_clkjz excuteTransactionWithBlock:^(FMDatabase *db) {
        // 重建索引
        [items enumerateObjectsUsingBlock:^(FFYBJKQuestionItem *obj, NSUInteger idx, BOOL *top) {
            // 转换考题对象
            FFQuestionItem *item = [FFQuestionItem new];
            item.id              = (int)idx+1;
            item.course          = 1;
            item.question_id     = 0;
            item.chapter         = 9;
            item.category        = obj.category;
            item.type            = obj.type;
            item.cert_type       = 512;
            item.question        = obj.question;
            item.media           = obj.media;
            item.media_type      = obj.media_type;
            item.option_a        = obj.option_a;
            item.option_b        = obj.option_b;
            item.option_c        = obj.option_c;
            item.option_d        = obj.option_d;
            item.answer          = obj.answer;
            item.difficulty      = obj.EasyRank;
            item.comments        = obj.fx;
            [db insertObject:item];
        }];
        NSLog(@"保存考题成功:共%zd题", items.count);
    }];
}

@end
