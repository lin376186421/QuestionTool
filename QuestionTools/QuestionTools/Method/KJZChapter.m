//
//  KJZChapter.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZChapter.h"

@implementation KJZChapter

+ (void)deal
{
    [self updateKaojiazhaoChapter];
}

+ (void)resetKaojiazhaoChapter
{
    [self updateKaojiazhaoChapterReset:YES];
}

+ (void)updateKaojiazhaoChapter
{
    [self updateKaojiazhaoChapterReset:NO];
}

+ (void)updateKaojiazhaoChapterReset:(BOOL)reset
{
    NSString *path = PATH(DB(KJZ));
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    __block NSInteger i =0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //@"select * from Q.dt_question where chapter in (223, 224)"
        NSString *table = [FFQuestionChapterItem tableName];
        if ([db tableExists:table]) {
            if (reset) {
                [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", table]];
                // 创建表
                [db create:table columns:[FFQuestionChapterItem createColumns]];
            }
        } else {
            // 创建表
            [db create:table columns:[FFQuestionChapterItem createColumns]];
            // 创建唯一索引
            NSString *column = [FFQuestionChapterItem uniqueIndex];
            if (column) {
                [db create:table uniqueColumn:column];
            }
        }
        NSMutableString *chapterSql = [NSMutableString string];
        FMResultSet *rs = [db executeQuery:@"select distinct chapter, course, cert_type, city_id from dt_question"];
        while ([rs next]) {
            FFQuestionChapterItem *obj = [FFQuestionChapterItem itemFromResultSet:rs];
            if (reset) {
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (course, chapter, cert_type, title, city_id) VALUES (%d, %d, %d, %@, %@)", table, obj.course, obj.chapter, obj.cert_type, sqlString(obj.title), sqlString(obj.city_id)];
                [db executeUpdate:sql];
                [chapterSql appendFormat:@"%@\n", sql];
                i++;
            } else {
                NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from %@ where course = %d and chapter = %d and cert_type = %d", table, obj.course, obj.chapter, obj.cert_type];
                if (obj.city_id.length > 0) {
                    sql = [sql stringByAppendingFormat:@" and city_id = %@", sqlString(obj.city_id)];
                } else {
                    sql = [sql stringByAppendingString:@" and city_id is NULL"];
                }
                if ([db intForQuery:sql] <= 0) {
                    sql = [NSString stringWithFormat:@"INSERT INTO %@ (course, chapter, cert_type, title, city_id) VALUES (%d, %d, %d, %@, %@)", table, obj.course, obj.chapter, obj.cert_type, sqlString(obj.title), sqlString(obj.city_id)];
                    [db executeUpdate:sql];
                    [chapterSql appendFormat:@"%@\n", sql];
                    i++;
                }
            }
            
            if (obj.title.length <=0) {
                NSLog(@"%zd - %zd - %zd", obj.course, obj.chapter, obj.cert_type);
            }
        }
        [rs close];
        writeTxtToPath(chapterSql, PATH([KJZ stringByAppendingFormat:@"_chapter.txt"]));
    }];
    
    if (reset) {
        NSLog(@"+++++++++++++++生成章节:%zd", i);
    } else {
        NSLog(@"+++++++++++++++增加章节:%zd", i);
    }
    
}

@end
