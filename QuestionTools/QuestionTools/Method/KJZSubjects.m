//
//  KJZSubjects.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZSubjects.h"

@implementation KJZSubjects

NSDictionary *kjzque_subjects;

+ (void)deal
{
    [self kjzSubjects];
}

+ (void)kjzSubjects
{
    //专项
    kjzque_subjects = [NSDictionary dictionaryWithContentsOfFile:BUNDLE(@"question_subjects", @"plist")];
    
    writeTxtWithFileName([kjzque_subjects JSONString_ff], @"kjz_subject_json");
    return;
    //
    
    NSString *path = PATH(DB(KJZ));
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//    NSMutableString *mString = [NSMutableString string];
//    [_dbQueue inDatabase:^(FMDatabase *db) {
//        
//        [mString appendString:[self txtFromDB:db course:1]];
//        
//        [mString appendString:@"\n\n\n"];
//        
//        [mString appendString:[self txtFromDB:db course:3]];
//    }];
//    
//    [mString writeToFile:PATH(@"kjzque.txt") atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSArray *array = [kjzque_subjects objectForKey:@"1_1"];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        for (NSDictionary *dict in array) {
            NSString *ids = [dict objectForKey:@"ids"];
            NSString *sql = [NSString stringWithFormat:@"select question_id from dt_question where chapter=1000 and question_id in (%@)", ids];
            
            NSMutableArray *arr = [NSMutableArray array];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                [arr addObject:[rs stringForColumnIndex:0]];
            }
            
            if (arr.count) {
                [result setObject:[arr componentsJoinedByString:@","] forKey:[dict objectForKey:@"title"]];
            }
            
            [rs close];
        }

        writeTxtToPath([result JSONString_ff], PATH(@"chapter3_subject"));
    }];
    
    
//    [self dealKJZSubjectIds];
}

+ (void)dealKJZSubjectIds
{
    NSArray *array = [kjzque_subjects objectForKey:@"1_1"];
    NSMutableString *string = [NSMutableString string];
    for (NSDictionary *dict in array) {
        if (string.length) {
            [string appendFormat:@",%@", [dict objectForKey:@"ids"]];
        } else {
            [string appendFormat:@"%@", [dict objectForKey:@"ids"]];
        }
    }
    writeTxtToPath(string, PATH(@"subject1.txt"));
    
    array = [kjzque_subjects objectForKey:@"1_3"];
    string = [NSMutableString string];
    for (NSDictionary *dict in array) {
        if (string.length) {
            [string appendFormat:@",%@", [dict objectForKey:@"ids"]];
        } else {
            [string appendFormat:@"%@", [dict objectForKey:@"ids"]];
        }
    }
    
    writeTxtToPath(string, PATH(@"subject3.txt"));
}

+ (NSString *)txtFromDB:(FMDatabase *)db course:(int)course
{
    NSInteger i = 1;
    NSMutableString *mString = [NSMutableString string];
    
    NSString *sql = [NSString stringWithFormat:@"select * from dt_question where cert_type&1>0 and course = %zd and city_id is null order by chapter asc", course];
    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
        obj.id = (int)i;
        //题目序号	ID	题目	答案	解释	章节	难度 现有分类
        NSString *str = [self carFromQueId:obj.question_id key:[NSString stringWithFormat:@"1_%zd", course]];
        [mString appendFormat:@"%zd\t%zd\t%@\t%@\t%@\t%d\t%d\t%@\n", obj.id, obj.question_id, [obj.question stringByReplacingOccurrencesOfString:@"\n" withString:@" "], obj.answer, [obj.comments stringByReplacingOccurrencesOfString:@"\n" withString:@" "], obj.chapter, obj.difficulty, str];
        i ++;
    }
    [rs close];
    return mString;
}

+ (NSString *)carFromQueId:(NSInteger)qid key:(NSString *)key
{
    NSMutableString *ms = [NSMutableString string];
    NSString *qids = [NSString stringWithFormat:@"%zd", qid];
    NSArray *array = [kjzque_subjects objectForKey:key];
    for (NSDictionary *dict in array) {
        NSString *str = [dict objectForKey:@"ids"];
        NSArray *arr = [str componentsSeparatedByString:@","];
        if ([arr containsObject:qids]) {
            [ms appendString:[dict objectForKey:@"title"]];
            [ms appendString:@" "];
        }
    }
    return ms;
}

@end
