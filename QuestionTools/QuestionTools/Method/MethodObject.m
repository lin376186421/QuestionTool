//
//  MethodObject.m
//  333
//
//  Created by cheng on 17/4/18.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "MethodObject.h"

NSString * sqlString(NSString *string)
{
    if (string.length) {
        return [NSString stringWithFormat:@"'%@'", string];
    }
    return @"NULL";
}

NSString * readTxtFromPath(NSString *path)
{
    if (path.length <= 0) {
        NSLog(@"readTxtFromPath path为空");
        return nil;
    }
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return string;
}

NSArray * readExcelTxtFromPath(NSString *path)
{
    NSString *txt = readTxtFromPath(path);
    if (txt.length <= 0) {
        NSLog(@"readExcelTxtFromPath txt为空");
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *txtArray = [txt componentsSeparatedByString:@"\r"];
    
    __block int column = 0;
    __block int errorCount = 0;
    [txtArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *subArray = [obj componentsSeparatedByString:@"\t"];
        if (idx == 0) {
            //表头
            column = (int)subArray.count;
        } else {
            if (subArray.count < column) {
                errorCount ++;
            }
            if (subArray) {
                [result addObject:subArray];
            }
        }
    }];
    NSString *string = [NSString stringWithFormat:@"共解析%zd条数据", result.count];
    if (errorCount>0) {
        string = [string stringByAppendingFormat:@", 异常数据%zd条", errorCount];
    } else {
        string = [string stringByAppendingString:@", 无异常数据"];
    }
    NSLog(@"%@", string);
    return result;
}

NSString * sqlStringWithItem(FFQuestionItem *item)
{
    return sqlPHPStringWithItem(item, NO);
}

NSString * sqlPHPStringWithItem(FFQuestionItem *obj, BOOL php)
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO \"dt_question\" ( course,\"question_id\",chapter,category,type,\"cert_type\",question,\"media_type\",media,\"option_a\",\"option_b\",\"option_c\",\"option_d\",answer,difficulty,comments,\"city_id\" ) VALUES ('%d', '%d', '%d', '%d', '%d', '%d', %@, '%d', %@, %@, %@, %@, %@, %@, '%d', %@, %@)", obj.course, obj.question_id, obj.chapter, obj.category, obj.type, obj.cert_type, sqlString(obj.question), obj.media_type, sqlString(obj.media), sqlString(obj.option_a), sqlString(obj.option_b), sqlString(obj.option_c), sqlString(obj.option_d), sqlString(obj.answer), obj.difficulty, sqlString(obj.comments), sqlString(obj.city_id)];
    
    if (php) {
        sql = [sql stringByReplacingOccurrencesOfString:@"\"" withString:@"`"];
        sql = [sql stringByReplacingOccurrencesOfString:@"NULL" withString:@"''"];
        if (!obj.city_id) {
            sql = [sql stringByReplacingOccurrencesOfString:@"'')" withString:@"'0')"];
        }
    }
    return sql;
}

void writeTxtToPath(NSString *text, NSString *path)
{
    if ([path rangeOfString:@"."].length <=0) {
        path = [path stringByAppendingString:@".txt"];
    }
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

void writeDbToPath(NSArray * array, NSString *path)
{
    if ([path rangeOfString:@"."].length <=0) {
        path = [path stringByAppendingString:@".db"];
    }
    FFDatabase *db_clkjz = [[FFDatabase alloc] initWithPath:path
                                             supportClasses:@[[FFQuestionItem class]]];
    [db_clkjz excuteTransactionWithBlock:^(FMDatabase *db) {
        // 重建索引
        for (FFQuestionItem *obj in array) {
//            [db insertObject:obj];
            NSString *sql = sqlStringWithItem(obj);
            [db executeUpdate:sql];
        }
    }];
}

void writeTxtWithFileName(NSString *text, NSString *name)
{
    writeTxtToPath(text, PATH(name));
}

void writeDbWithFileName(NSArray * array, NSString *name)
{
    writeDbToPath(array, PATH(name));
}

void writeSQLWithFileName(NSArray * questions, NSString *name)
{
    writeSQLPHPWithFileName(questions, name, NO);
}

void writeSQLPHPWithFileName(NSArray * questions, NSString *name, BOOL php)
{
    NSMutableString *result = [NSMutableString string];
    for (FFQuestionItem *obj in questions) {
        [result appendFormat:@"%@\n",sqlPHPStringWithItem(obj, php)];
    }
 
    NSString *fileName = [NSString stringWithFormat:@"%@_sql.txt", name];
    writeTxtWithFileName(result, fileName);
}

@implementation MethodObject

+ (void)sqlFromDbPath:(NSString *)dbpath beginId:(NSInteger)beginId fileName:(NSString *)name php:(BOOL)php
{
    FFDatabase * database = [[FFDatabase alloc] initWithPath:dbpath
                                 supportClasses:nil];
    
    [database excuteWithBlock:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from dt_question where question_id >= %zd", beginId];
        NSMutableArray *questions = [NSMutableArray array];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            FFQuestionItem *item = [FFQuestionItem itemFromResultSet:rs];
            item.id = item.itemId;
            [questions addObject:item];
        }
        
        [rs close];
        
        writeSQLPHPWithFileName(questions, name, php);
    }];
}

+ (NSArray *)chineseCharsFromString:(NSString *)string
{
    if (string.length <= 0) {
        return nil;
    }
    NSMutableArray *chars = [NSMutableArray array];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        int src = [substring characterAtIndex:0];
        if (src >= 0x4e00 && src <= 0x9fff) {
            [chars addObject:substring];
        }
    }];
    return chars;
}

+ (NSInteger)compareString:(NSString *)string1 withOther:(NSString *)string2
{
    if (string1 && string2) {
        if ([string1 isEqualToString:string2]) {
            return 0;
        }
    }
    return [self compareArray:[self chineseCharsFromString:string1] withOther:[self chineseCharsFromString:string2]];
}

+ (NSInteger)compareArray:(NSArray *)array1 withOther:(NSArray *)array2
{
    if (array1.count == 0 || array2.count == 0 ) {
        if (array1.count == array2.count) {
            return 0;
        } else {
            return 100;
        }
    }
    
    int score = 0;
    
    NSMutableArray *minArray = (array1.count < array2.count ? [array1 mutableCopy] : [array2 mutableCopy]);
    NSMutableArray *maxArray = (array1.count < array2.count ? [array2 mutableCopy] : [array1 mutableCopy]);
    
    if (maxArray.count - minArray.count < 3) {
        for (int i=0; i<maxArray.count; i++) {
            NSString *cha1 = maxArray[i];
            NSUInteger index = [minArray indexOfObject:cha1];
            if (index != NSNotFound) {
                if (labs((NSInteger)(index - i)) < 3) {
                    [minArray replaceObjectAtIndex:index withObject:@"#"];
                } else {
                    score += 1;
                }
            } else {
                score += 1;
            }
        }
        
        if (score > maxArray.count / 2.f) {
            score *= 10;
        } else if (score > maxArray.count / 4.f){
            score *= 2;
        }
    } else {
        float length = maxArray.count * 1.f;
        [maxArray removeObjectsInArray:minArray];
        if (maxArray.count < 3 || maxArray.count < length / 6.f) {
            return maxArray.count;
        } else {
            return maxArray.count * 3;
        }
    }
    return score;
}

@end

@implementation NSObject (Deal)

+ (void)deal
{
    [self dealItem];
}

+ (id)dealItem
{
    return nil;
}

+ (NSArray *)itemsFromExcelTxtArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]] || !array.count) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id item = [self itemFromTxtArray:obj];
        if (item) {
            [result addObject:item];
        }
    }];
    
    return result;
}
+ (id)itemFromTxtArray:(NSArray *)array
{
    //子类重写
    return nil;
}

@end
