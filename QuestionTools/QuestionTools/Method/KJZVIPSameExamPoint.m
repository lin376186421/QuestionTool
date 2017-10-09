//
//  KJZVIPSameExamPoint.m
//  333
//
//  Created by cheng on 17/5/23.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZVIPSameExamPoint.h"
#import "FFQuestionItem.h"

@implementation KJZVIPSameExamPoint

+ (void)deal
{
    [self saveAllSameId];
    return;
    for (int course = 1; course <= 4; course += 3) {
        NSString *fileName = [NSString stringWithFormat:@"sameExamPoint_%zd", course];
        NSArray *array = readExcelTxtFromPath(BUNDLE(fileName, @"txt"));
        NSArray *items = [FFQuestionSameExamPointItem itemsFromExcelTxtArray:array];
        
        NSLog(@"count = %zd", items.count);
        
        items = [FFQuestionSameExamPointItem getValidItems:items];
        
        NSLog(@"valid count = %zd", items.count);
        
        NSString *path = PATH(DB(KJZ));
        
        FFDatabase *database = [[FFDatabase alloc] initWithPath:path
                                                 supportClasses:@[[FFQuestionSameExamPointItem class]]];
        
        [database excuteWithBlock:^(FMDatabase *db) {
            [items enumerateObjectsUsingBlock:^(FFQuestionSameExamPointItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where question_id=%zd and course=%zd", [FFQuestionSameExamPointItem tableName], obj.question_id, obj.course];
                
                if ([db intForQuery:sql] <= 0) {
                    [db insertObject:obj];
                } else {
                    [db updateObject:obj];
                }
            }];
        }];
    }
}

+ (void)saveAllSameId
{
    NSString *path = PATH(DB(KJZ));
    
    FFDatabase *database = [[FFDatabase alloc] initWithPath:path
                                             supportClasses:@[[FFQuestionSameExamPointItem class]]];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableDictionary *resultId = [NSMutableDictionary dictionary];
    for (int course = 1; course <= 3; course += 2) {
        [database excuteWithBlock:^(FMDatabase *db) {
            NSMutableString *string = [NSMutableString string];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where course=%zd", [FFQuestionSameExamPointItem tableName], course];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString *sameId = [rs stringForColumn:@"same_question"];
                if (string.length) {
                    [string appendFormat:@",%@", sameId];
                } else {
                    [string appendString:sameId];
                }
                
                NSArray *array = [sameId componentsSeparatedByString:@","];
                NSString *key = [NSString stringWithFormat:@"%zd", array.count];
                if ([dict objectForKey:key]) {
                    NSString *str = [dict objectForKey:key];
                    str = [str stringByAppendingFormat:@",%zd", [rs intForColumn:@"question_id"]];
                    [dict setObject:str forKey:key];
                } else {
                    [dict setObject:[NSString stringWithFormat:@"%zd", [rs intForColumn:@"question_id"]] forKey:key];
                }
            }

            [rs close];
            
            NSString *key = [NSString stringWithFormat:@"%zd", course];
            [resultId setObject:string forKey:key];
            [result setObject:dict forKey:key];
        }];
    }

    writeTxtToPath([resultId JSONString_ff], PATH(@"all_same_id.txt"));
    
    writeTxtToPath([result JSONString_ff], PATH(@"all_same_dict.txt"));
}

@end
