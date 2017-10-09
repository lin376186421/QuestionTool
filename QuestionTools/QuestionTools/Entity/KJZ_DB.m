//
//  KJZ_DB.m
//  333
//
//  Created by cheng on 17/5/8.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZ_DB.h"
//#import "KJZChapter.h"
//#import "fuck_wrapper.h"
#import "FFQuestionItem.h"
#import "SqlString.h"

@interface KJZ_DB () {
    NSMutableDictionary *kjz_questions;
    NSMutableDictionary *other_questions;
    
    NSMutableDictionary *same_ids;
    NSMutableDictionary *likeness_ids;
    
    NSMutableDictionary *medias;
    
    NSMutableDictionary *realQuestions;
    NSMutableDictionary *otherRealQuestions;
    
    NSMutableArray *other_ids;
    
    NSInteger limit_size;
    
    NSInteger likeness;
}

@end

@implementation KJZ_DB

+ (void)deal
{
    KJZ_DB *item = [KJZ_DB new];
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:item.cldb_path];
    
//    NSArray *array = readExcelTxtFromPath(BUNDLE(@"1233", @"txt"));
//    NSMutableString *mString = [NSMutableString string];
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            FFQuestionItem *item = [FFQuestionItem itemFromTxtArray:obj];
//            if (item) {
//                if (item.media_type > 0) {
//                    item.category = 1;
//                }
//                NSString *sql = sqlPHPStringWithItem(item, YES);
////                [db executeUpdate:sql];
//                [mString appendFormat:@"%@;\n", sql];
//            }
//        }];
//    }];
//    
//    writeTxtToPath(mString, PATH(@"682.txt"));
    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *path = BUNDLE(KJZ, @"db");
//        NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", path];
//        [db executeUpdate:sql];
//    }];
//    
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"select * from Q.dt_vipsame"];
//        FMResultSet *rs = [db executeQuery:sql];
//        NSArray *items = [FFQuestionSameExamPointItem itemsFromResultSet:rs];
//        [rs close];
//        
//        FFDatabase *dataBase = [[FFDatabase alloc] initWithPath:item.cldb_path supportClasses:@[[FFQuestionSameExamPointItem class]]];
//        
//        [dataBase excuteWithBlock:^(FMDatabase *db) {
//            [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [db insertObject:obj];
//            }];
//        }];
//    }];
   
    [dbQueue inDatabase:^(FMDatabase *db) {
        
    }];

    //导入解释，并生成php sql
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        NSArray *array = readExcelTxtFromPath(BUNDLE(@"nocomment_kjz", @"txt"));
//        //index 16
//        NSMutableString *phpSql = [NSMutableString string];
//        [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.count >=16) {
//                NSString *commment = [obj objectSafeAtIndex:16];
//                
//                if (commment.length) {
//                    NSInteger course = [[obj objectSafeAtIndex:1] integerValue];
//                    NSInteger qid = [[obj objectSafeAtIndex:2] integerValue];
//                    NSString *sql = [NSString stringWithFormat:@"UPDATE dt_question SET comments = %@ where question_id=%zd and course=%zd", sqlString(commment), qid, course];
//                    NSString *php = [NSString stringWithFormat:@"UPDATE dt_question SET comments = %@ where question_id=%zd and course=%zd", sqlPhpString(commment), qid, course];
//                    [phpSql appendFormat:@"%@;\n", php];
//                    [db executeUpdate:sql];
//                }
//            }
//        }];
//        
//        writeTxtToPath(phpSql, PATH(@"php_nocomment.txt"));
//    }];
    
//    //题库加密后，生成 ios sql
//    FMDatabaseQueue *dbQueueJM = [FMDatabaseQueue databaseQueueWithPath:item.bundleJMPath];
//    [dbQueueJM inDatabase:^(FMDatabase *db) {
//        NSArray *array = readExcelTxtFromPath(BUNDLE(@"nocomment_kjz", @"txt"));
//        //index 16
//        NSMutableString *sqlTxt = [NSMutableString string];
//        [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.count >=16) {
//                NSString *commment = [obj objectSafeAtIndex:16];
//                if (commment.length) {
//                    NSInteger course = [[obj objectSafeAtIndex:1] integerValue];
//                    NSInteger qid = [[obj objectSafeAtIndex:2] integerValue];
////                    NSString *sql = [NSString stringWithFormat:@"UPDATE dt_question SET comments = %@ where question_id=%zd and course=%zd", sqlString(commment), qid, course];
//                    NSString *sql = [NSString stringWithFormat:@"select comments from dt_question where question_id=%zd and course=%zd", qid, course];
//                    FMResultSet *rs = [db executeQuery:sql];
//                    if ([rs next]) {
//                        commment = [rs stringForColumn:@"comments"];
//                        if (commment.length) {
//                            sql = [NSString stringWithFormat:@"UPDATE dt_question SET comments = %@ where question_id=%zd and course=%zd", sqlString(commment), qid, course];
//                            [sqlTxt appendFormat:@"%@;\n", sql];
//                        }
//                    }
//                    [rs close];
//                }
//            }
//        }];
//
//        NSString *sql = [NSString stringWithFormat:@"select * from dt_question where city_id = 27"];
//        
//        FMResultSet *rs = [db executeQuery:sql];
//        NSArray *array = [FFQuestionItem itemsFromResultSet:rs];
//        
//        [array enumerateObjectsUsingBlock:^(FFQuestionItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj) {
//                NSString *sq = sqlStringWithItem(obj);
//                [sqlTxt appendFormat:@"%@;\n", sq];
//            }
//        }];
//        
//        writeTxtToPath(sqlTxt, PATH(@"beijing_sql.txt"));
//    }];
}

+ (KJZ_DB *)itemWith:(Base_DB *)item
{
    KJZ_DB *kjz = [KJZ_DB new];
    
    kjz.item = item;
    
    return kjz;
}

- (NSString *)cldb_path
{
    return PATH((DB(self.name)));
}

- (NSString *)bundleJMPath
{
    return BUNDLE(KJZ_JM, @"db");
}

- (void)setUp
{
    self.name = KJZ;
    self.oldName = nil;
    self.appName = @"考驾照";
    
    self.certType = 1;
    
    NSString *path = self.cldb_path;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager copyItemAtPath:BUNDLE(self.name, @"db") toPath:path error:nil];
    }
}

- (NSMutableArray *)questions
{
    NSMutableArray *array = [NSMutableArray array];
    FFDatabase *database;
    database = [[FFDatabase alloc] initWithPath:self.cldb_path
                                 supportClasses:nil];
    [database excuteWithBlock:^(FMDatabase *db) {
        NSString *sql = nil;
        if (_certType == 1) {
            sql = [NSString stringWithFormat:@"select * from dt_question where cert_type&%zd>0 and course=%zd", _certType, _course];
        } else {
            sql = [NSString stringWithFormat:@"select * from dt_question where (cert_type&%zd>0 and cert_type&1=0) and course=%zd", _certType, _course];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            FFQuestionItem *item = [FFQuestionItem itemFromResultSet:rs];
            [array addObject:item];
        }
    }];
    NSLog(@"##############certType = %zd, course = %zd, questions = %zd", _certType, _course, array.count);
    return array;
}

- (void)prepare
{
    limit_size = 1;
    
    other_ids = [NSMutableArray array];
    
    kjz_questions = [NSMutableDictionary dictionary];
    other_questions = [NSMutableDictionary dictionary];
    
    same_ids = [NSMutableDictionary dictionary];
    likeness_ids = [NSMutableDictionary dictionary];
    
    medias = [NSMutableDictionary dictionary];
    
    realQuestions = [NSMutableDictionary dictionary];
    otherRealQuestions = [NSMutableDictionary dictionary];
    
    FFDatabase *database;
    
    NSString *otherPath = (self.compareLast ? [_item cldb_pathWithFromId:_item.lastId] : _item.cldb_path);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:otherPath]) {
        NSLog(@"对比路径不存在\n%@", otherPath);
        return;
    }
    
    BOOL isCompareSelf = NO;
    isCompareSelf = YES;
    if (isCompareSelf) {
        otherPath = self.cldb_path;
    }
    isCompareSelf = YES;
    if (self.course == 1) {
        otherPath = PATH(DB(@"guangdong"));
    } else {
        otherPath = PATH(DB(@"cl_jiaoguanju_4"));
    }
    
    
    for (int i=0; i<2; i++) {
        database = [[FFDatabase alloc] initWithPath:(i==0?self.cldb_path: otherPath)
                                     supportClasses:nil];
        [database excuteWithBlock:^(FMDatabase *db) {
            NSString *sql = nil;
            if (_certType == 1) {
                sql = [NSString stringWithFormat:@"select question_id, question, media from dt_question where cert_type&%zd>0 and course=%zd", _certType, _course];
            } else {
                sql = [NSString stringWithFormat:@"select question_id, question from dt_question where (cert_type&%zd>0) and course=%zd", _certType, _course];
            }
            
            if (i == 1) {
                if (isCompareSelf) {
                    if (_certType == 1) {
                        sql = [NSString stringWithFormat:@"select question_id, question, media from dt_question where cert_type&%zd>0 and course=%zd and chapter=3", _certType, 1];
                    } else {
                        sql = [NSString stringWithFormat:@"select question_id, question from dt_question where (cert_type&%zd>0) and course=%zd", _certType, 1];
                    }
                } else {
                    if (_certType == 1) {
                        sql = [NSString stringWithFormat:@"select question_id, question, media from dt_question where cert_type&%zd>0 and course=%zd", _certType, _course];
                        sql = [NSString stringWithFormat:@"select question_id, question, media from dt_question where question_id in (914000,1102300,1102600,1102700,1102800,1103000,1106400,1106800,1107900,1108700,1109300,1110000,1110400,1110500,1110800,1111900,1116100,1142200) and cert_type&%zd>0 and course=%zd", _certType, _course];
                    } else {
                        sql = [NSString stringWithFormat:@"select question_id, question from dt_question where (cert_type&%zd>0) and course=%zd", _certType, _course];
                    }
                }
            }
            
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString *question_id = [rs stringForColumn:@"question_id"];
                NSString *question = [rs stringForColumn:@"question"];
                NSMutableArray *chars = [NSMutableArray array];
                [question enumerateSubstringsInRange:NSMakeRange(0, question.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    int src = [substring characterAtIndex:0];
                    BOOL hanzi = (src >= 0x4e00 && src <= 0x9fff);
                    BOOL shuzi = (src >= 0x30 && src <= 0x39);
                    BOOL zimu  = (src >= 0x41 && src <= 0x5a) || (src >= 0x61 && src <= 0x7a);
                    if (hanzi || shuzi || zimu) {
                        [chars addObject:substring];
                    }
                }];
                
                
                if (i==0) {
                    [kjz_questions setObject:chars forKey:question_id];
                    NSString *media = [rs stringForColumn:@"media"];
                    if (media) {
                        [medias setObject:media forKey:question_id];
                    }
                    [realQuestions setObject:question forKey:question_id];
                } else {
                    [other_questions setObject:chars forKey:question_id];
                    [otherRealQuestions setObject:question forKey:question_id];
                }
            }
            [rs close];
        }];
    }
    
    NSLog(@"准备完毕");
}

- (void)compare
{
    NSArray *allKeys = other_ids.count>0 ? [other_ids copy] : other_questions.allKeys;
    [other_ids removeAllObjects];
    
    BOOL showSameLog = NO;
//    showSameLog = YES;
    
    NSInteger otherCarryId = 0;
    NSInteger kjzCarryId = 0;
    
    [allKeys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop1) {
        if (otherCarryId > 0) {
            NSString *otherCarryIdStr = [NSString stringWithFormat:@"%zd", otherCarryId];
            if ([obj isEqualToString:otherCarryIdStr]) {
                NSLog(@"other - %zd", otherCarryId);
            }
        }
        NSArray *obj1 = other_questions[obj];
        NSMutableArray *question1 = [obj1 mutableCopy];
        NSString *str1 = [obj1 componentsJoinedByString:@""];
        
        __block NSMutableArray *ques = [NSMutableArray array];
        __block NSMutableArray *queIds = [NSMutableArray array];
        [kjz_questions enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj2, BOOL * _Nonnull stop) {
            if (kjzCarryId > 0) {
                NSString *kjzCarryIdStr = [NSString stringWithFormat:@"%zd", kjzCarryId];
                if ([key isEqualToString:kjzCarryIdStr]) {
                    NSLog(@"kjz - %zd", kjzCarryId);
                }
            }
            __block NSUInteger score = 0;
            NSMutableArray *question2 = [obj2 mutableCopy];
            if (labs((NSInteger)(question1.count - question2.count)) < 3) {
                
                for (NSInteger i=0; i<question1.count; i++) {
                    NSString *cha1 = question1[i];
                    NSUInteger index = [question2 indexOfObject:cha1];
                    if (index != NSNotFound) {
                        if (labs((NSInteger)(index - i)) < 3) {
                            [question2 replaceObjectAtIndex:index withObject:@"#"];
                        } else {
                            score += 1;
                        }
                    } else {
                        score += 1;
                    }
                }
            } else {
                //是否包含
                BOOL isContains = NO;
                NSMutableArray *que = nil;
                NSMutableArray *bigQue = (question1.count > question2.count ? question1 : question2);
                NSMutableArray *smallQue = (question1.count < question2.count ? question1 : question2);
                que = [bigQue mutableCopy];
                [que removeObjectsInArray:smallQue];
                if (que.count == 3 || que.count == 4) {
                    if ([@"如图所示、如图所时" rangeOfString:[que componentsJoinedByString:@""]].length) {
                        isContains = YES;
                        score = 0;
                    }
                }
                if (!isContains) {
                    if (que.count <= limit_size || que.count < smallQue.count/6.f) {
                        isContains = YES;
                        score = que.count;
                    }
                }
                
                if (!isContains) {
                    score = 100;
                }
            }
            if (score < limit_size) {
                NSString *str2 = [obj2 componentsJoinedByString:@""];
                [ques addObject:str2];
                [queIds addObject:key];
            }
        }];
        
        __block int max = 1;
        __block NSString *str2 = nil;
        __block NSString *str2Id = nil;
        [ques enumerateObjectsUsingBlock:^(NSString *obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
            for (int i=0; i<obj3.length; i++) {
                for (int j=max; j<=obj3.length-i; ) {
                    NSString *substr = [obj3 substringWithRange:NSMakeRange(i, j++)];
                    if ([str1 rangeOfString:substr].location != NSNotFound) {
                        max = j;
                        str2 = obj3;
                        str2Id = [queIds objectAtIndex:idx3];
                    }
                }
            }
        }];
        if (str2) {
            if (![str1 isEqualToString:str2]) {
                if (limit_size>3) {
                    if (labs((long)(str1.length-str2.length))<=2) {
                        NSMutableArray *array = [NSMutableArray array];
                        [str2 enumerateSubstringsInRange:NSMakeRange(0, str2.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                            [array addObject:substring];
                        }];
                        if (![KJZ_DB isSameQuestion:question1 withOther:array]) {
//                            NSLog(@"%@ - %@\n%@\n%@", obj, str2Id, str1, str2);
//                            NSLog(@"%@ - %@\n%@\n%@", obj, str2Id, [otherRealQuestions objectForKey:obj], [realQuestions objectForKey:str2Id]);
//                            if ([[medias allKeys] containsObject:str2Id]) {
//                                printf("%s\n", [[medias objectForKey:str2Id] UTF8String]);
//                            }
                            [likeness_ids setObject:str2Id forKey:obj];
                        } else {
                            //转换后一致的
                            if (showSameLog) {
                                NSLog(@"转换一致：%@ - %@\n%@\n%@", obj, str2Id, str1, str2);
                                if ([[medias allKeys] containsObject:str2Id]) {
                                    printf("%s\n", [[medias objectForKey:str2Id] UTF8String]);
                                }
                            }
                            [same_ids setObject:str2Id forKey:obj];
                        }
                    } else {
//                        NSLog(@"%@ - %@\n%@\n%@", obj, str2Id, str1, str2);
//                        NSLog(@"%@ - %@\n%@\n%@", obj, str2Id, [otherRealQuestions objectForKey:obj], [realQuestions objectForKey:str2Id]);
//                        if ([[medias allKeys] containsObject:str2Id]) {
//                            printf("%s\n", [[medias objectForKey:str2Id] UTF8String]);
//                        }
                        [likeness_ids setObject:str2Id forKey:obj];
                    }
                } else {
                    NSMutableArray *array = [NSMutableArray array];
                    [str2 enumerateSubstringsInRange:NSMakeRange(0, str2.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                        [array addObject:substring];
                    }];
                    if (![KJZ_DB isSameQuestion:question1 withOther:array]) {
                        if (showSameLog) {
//                            NSLog(@"很相近的：%@ - %@\n%@\n%@", obj, str2Id, str1, str2);
                            NSLog(@"很相近的：%@ - %@\n%@\n%@", obj, str2Id, [otherRealQuestions objectForKey:obj], [realQuestions objectForKey:str2Id]);
                            if ([[medias allKeys] containsObject:str2Id]) {
                                printf("%s\n", [[medias objectForKey:str2Id] UTF8String]);
                            }
                        }
//                        [likeness_ids setObject:str2Id forKey:obj];
                        [same_ids setObject:str2Id forKey:obj];
                    } else {
                        //转换后一致的
                        if (showSameLog) {
                            NSLog(@"转换一致：%@ - %@\n%@\n%@", obj, str2Id, str1, str2);
                            if ([[medias allKeys] containsObject:str2Id]) {
                                printf("%s\n", [[medias objectForKey:str2Id] UTF8String]);
                            }
                        }
                        [same_ids setObject:str2Id forKey:obj];
                    }
                }
            } else {
                //完全一致
                if (showSameLog) {
                    NSLog(@"完全一致：%@ - %@\n%@\n%@", obj, str2Id, str1, str2);
                    if ([[medias allKeys] containsObject:str2Id]) {
                        printf("%s\n", [[medias objectForKey:str2Id] UTF8String]);
                    }
                }
                [same_ids setObject:str2Id forKey:obj];
            }
        } else {
            [other_ids addObject:obj];
        }
        
        if (same_ids.count) {
            [kjz_questions removeObjectsForKeys:[same_ids allValues]];
        }
        if (likeness_ids.count) {
            [kjz_questions removeObjectsForKeys:[likeness_ids allValues]];
        }
    }];
    
    // 逐级增加筛选精确度（初始1，递增1）
    limit_size += 1;
    if (limit_size <= 10 && other_ids.count > 0) {
        [self compare];
    } else {
        [other_ids sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue]<=[obj2 integerValue]) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        
        NSLog(@"比对完毕");
        NSLog(@"same = %zd, likeness = %zd, diffent = %zd", same_ids.count, likeness_ids.count, other_ids.count);
        if (other_ids.count) {
            NSLog(@"select * from ""dt_question"" where question_id in (%@)", [other_ids componentsJoinedByString:@","]);
        }
        
        NSMutableString *diffStr = [NSMutableString string];
        for (NSString *otherId in other_ids) {
            [diffStr appendFormat:@"%@\t%@\n", otherId, [otherRealQuestions objectForKey:otherId]];
        }
        
        writeTxtToPath(diffStr, PATH(([NSString stringWithFormat:@"%@_diff_%zd.txt", _item.name, self.course])));
        
        NSMutableString *likeStr = [NSMutableString string];
        [likeness_ids enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            [likeStr appendFormat:@"%@\t%@\n", key, [otherRealQuestions objectForKey:key]];
            [likeStr appendFormat:@"%@\t%@\n", obj, [realQuestions objectForKey:obj]];
            if ([medias.allKeys containsObject:obj]) {
                [likeStr appendFormat:@"%@\n", [medias objectForKey:obj]];
            }
            
            [likeStr appendString:@"\n"];
        }];
        
        writeTxtToPath(likeStr, PATH(([NSString stringWithFormat:@"%@_like_%zd.txt", _item.name, self.course])));
        
        if (!_compareLast) {
            writeTxtToPath([same_ids JSONString_ff], PATH(([NSString stringWithFormat:@"%@_same_%zd.txt", _item.name, self.course])));
        } else {
            writeTxtToPath([same_ids JSONString_ff], PATH(([NSString stringWithFormat:@"%@_last_same_%zd.txt", _item.name, self.course])));
        }
    }
}

- (void)compareCourse:(NSInteger)course
{
    self.course = course;
    
    NSLog(@"比对%@:certType = %zd, course = %zd", _item.appName, _certType, course);
    
    [self prepare];
    
    [self compare];
}

- (void)foundCourse1andCourse4Same
{
    //jkbd679_last_same_3
    
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.cldb_path];
    
    __block NSInteger i =0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *idArray = [NSMutableArray array];
        
        NSString *sql = [NSString stringWithFormat:@"select question_id from dt_question where cert_type&1>0 and course = 1 order by chapter, question_id"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"question_id"];
            [idArray addObject:string];
        }
        [rs close];
        
        NSMutableArray *idArray2 = [NSMutableArray array];
        
        sql = [NSString stringWithFormat:@"select question_id from dt_question where cert_type&1>0 and course = 3 order by chapter, question_id"];
        rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *string = [rs stringForColumn:@"question_id"];
            [idArray2 addObject:string];
        }
        [rs close];
        
        NSLog(@"count1 = %zd, count2 = %zd", idArray.count, idArray2.count);
        
        NSMutableString *result = [NSMutableString string];
        NSArray *rowName = @[@"序号", @"题目ID", @"章节", @"题目", @"选项A", @"选项B", @"选项C", @"选项D", @"答案", @"图片"];
        NSString *string = [rowName componentsJoinedByString:@"\t"];
        [result appendFormat:@"%@\n", string];
        NSDictionary *dict = [readTxtFromPath(PATH(@"jkbd679_last_same_3.txt")) JSONObject_ff];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            NSString *sql = [NSString stringWithFormat:@"select * from dt_question where cert_type&1>0 and course = 1 and question_id=%@", key];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                FFQuestionItem *item = [FFQuestionItem itemFromResultSet:rs];
                item.id = (int)[idArray indexOfObject:key]+1;
                
                NSString *string = [NSString stringWithFormat:@"%zd\t%zd\t%zd\t%@\t%@\t%@\t%@\t%@\t%@\t%@\n", item.id, item.question_id, item.chapter, item.question, item.option_a, item.option_b, item.option_c, item.option_d, item.answer, item.media?:@""];
                [result appendString:string];
            }
            [rs close];
            
            sql = [NSString stringWithFormat:@"select * from dt_question where cert_type&1>0 and course = 3 and question_id=%@", obj];
            rs = [db executeQuery:sql];
            while ([rs next]) {
                FFQuestionItem *item = [FFQuestionItem itemFromResultSet:rs];
                item.id = (int)[idArray2 indexOfObject:obj]+1;
                NSString *string = [NSString stringWithFormat:@"%zd\t%zd\t%zd\t%@\t%@\t%@\t%@\t%@\t%@\t%@\n", item.id, item.question_id, item.chapter, item.question, item.option_a, item.option_b, item.option_c, item.option_d, item.answer, item.media?:@""];
                [result appendString:string];
            }
            [rs close];
            [result appendString:@"\n"];
            i ++;
        }];
        NSLog(@"i = %zd", i);
        writeTxtToPath(result, PATH(@"sametxt.txt"));
    }];
}

+ (BOOL)isSameQuestion:(NSArray *)question withOther:(NSArray *)other
{
    BOOL big = question.count>= other.count;
    NSArray *bigArray = big?question:other;
    NSArray *smallArray = !big?question:other;
    
    NSMutableArray *mArray = [smallArray mutableCopy];
    [mArray removeObjectsInArray:bigArray];
    
    NSMutableArray *nArray = [bigArray mutableCopy];
    [nArray removeObjectsInArray:smallArray];
    if ([mArray count]==0||[nArray count]==0) {
        NSString *string = @"的 应 当 该 段 时 气 限 行 位 慢 车 图 要 公 明 什么 责任 机关 安全 过程 专用 标志 行驶 前方 提拉 以下 插头 导致 图中 车辆 所示 如图";
        if (nArray.count==mArray.count) {
            return YES;
        } else if (nArray.count==1||nArray.count==2) {
            NSString *str = [nArray firstObject];
            if (nArray.count>1) {
                str = [str stringByAppendingString:[nArray lastObject]];
            }
            if ([string rangeOfString:str].length>0) {
                return YES;
            }
        } else if (mArray.count==1||mArray.count==2) {
            
            NSString *str = [mArray firstObject];
            if (mArray.count>1) {
                str = [str stringByAppendingString:[mArray lastObject]];
            }
            if ([string rangeOfString:str].length>0) {
                return YES;
            }
        } else if (nArray.count == 4 || mArray.count == 4) {
            NSArray *array = (nArray.count ? nArray : mArray);
            if ([[array componentsJoinedByString:@""] isEqualToString:@"如图所示"]) {
                return YES;
            }
        }
    } else if (mArray.count==1&&nArray.count==1) {
        /*地点 地方  通行 通过  短信 信息   事故 故障  哪 那  说法 做法  近 进  是  时  使用 适用  能 者  减小 减少 表明 表示  关于 机动  面 当  车辆 车牌 以下 下列  如下图 在下图 情形 情况*/
        NSString *string = @"点方 方点 行过 过行 短息 息短 事障 障事 哪那 那哪 说做 做说 进近 近进 是时 时是 使适 适使 能者 者能 小少 少小 示明 明示 关机 机关 面当 当面 牌辆 辆牌 以列 列以 如在 在如 形况 况形";
        NSString *str = [[nArray firstObject] stringByAppendingString:[mArray firstObject]];
        if ([string rangeOfString:str].length>0) {
            return YES;
        }
    } else if (abs((int)(mArray.count-nArray.count))==2) {
        /*这个符号 亮时*/
        NSString *string = @"这亮 亮这";
        NSString *str = [[nArray firstObject] stringByAppendingString:[mArray firstObject]];
        if ([string rangeOfString:str].length>0) {
            return YES;
        }
    } else if (mArray.count==2&&nArray.count==2) {
        /*图中 这个*/
        NSString *string = @"这图 图这";
        NSString *str = [[nArray firstObject] stringByAppendingString:[mArray firstObject]];
        if ([string rangeOfString:str].length>0) {
            return YES;
        }
    } else if ((mArray.count == 1 && nArray.count==2) || (mArray.count == 2 && nArray.count==1)) {
        /*及 或者*/
        NSString *string = @"及或 或及";
        NSString *str = [[nArray firstObject] stringByAppendingString:[mArray firstObject]];
        if ([string rangeOfString:str].length>0) {
            return YES;
        }
    }
    return NO;
}

+ (void)updateKJZWithItem:(Base_DB *)item
{
    KJZ_DB *kjz = [KJZ_DB new];
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:kjz.cldb_path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", PATH(CLDB(@"jiaoguanju"))];
        [db executeUpdate:sql];
    }];
    
    __block NSInteger i =0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        //根据比对结果 写对应的sql
        NSString *sql = @"select * from Q.dt_question";
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
            //自己定义本次导入的 question_id 起始值
//            obj.question_id = (uint32_t)(44000 +i);
//            obj.question_id = (uint32_t)(50000 +i);
            NSString *sql = sqlStringWithItem(obj);
            [db executeUpdate:sql];
            if (obj.media_type > 0) {
                NSLog(@"%@", obj.media);
            }
            i++;
        }
        
        [rs close];
//        NSString *sql = @"select * from Q.dt_question";
//        FMResultSet *rs = [db executeQuery:sql];
//        while ([rs next]) {
//            NSString *index = [rs stringForColumn:@"question_id"];
//            sql = [NSString stringWithFormat:@"update Q.dt_question set media='%@.jpg' where question_id = %@", index, index];
//            [db executeUpdate:sql];
//        }
    }];
    
//    [KJZChapter resetKaojiazhaoChapter];

    NSLog(@"+++++++++++++++插入成功:%zd", i);
}

+ (void)updateSQL
{
    BOOL isJM = NO;
//    isJM = YES;
    
    KJZ_DB *kjz = [KJZ_DB new];
    NSString *path = isJM ?  PATH((DB(([NSString stringWithFormat:@"%@_jm", kjz.name])))) : kjz.cldb_path;
    FFDatabase *kjz_db = [[FFDatabase alloc] initWithPath:path
                                             supportClasses:nil];
    
    __block NSInteger i =0;
    NSMutableString *mString = [NSMutableString string];
    [kjz_db excuteTransactionWithBlock:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from dt_question where question_id>=5400 and question_id<5500 and course=3 order by id"];
        FMResultSet *rs = [db executeQuery:sql];//
        
        while ([rs next]) {
            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
            
//            [mString appendString:sqlPHPStringWithItem(obj, !isJM)];
            [mString appendString:sqlPHPStringWithItem(obj, NO)];
            [mString appendString:@";\n"];
            
            i++;
        }
        [rs close];
        
        //更新题目
//        sql = [NSString stringWithFormat:@"select * from dt_question where question_id in (1000, 1001)"];
//        rs = [db executeQuery:sql];
//        
//        while ([rs next]) {
//            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
//            
//            NSString *string = [NSString stringWithFormat:@"update dt_question set question = %@, answer = %@ where question_id = %zd;\n", sqlString(obj.question), sqlString(obj.answer), obj.question_id];
//            [mString appendString:sql];
//            
//            i++;
//        }
//        [rs close];
        
        NSLog(@"i = %zd", i);
        
        //插入sql
        if (isJM) {
            writeTxtToPath(mString, PATH([KJZ stringByAppendingString:@"_sql_jm.sql"]));
        } else {
            writeTxtToPath(mString, PATH([KJZ stringByAppendingString:@"_sql"]));
            
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setObject:@"小车、客车、货车新增：2道\n货运资格证新增：228道\n客运资格证新增：826道" forKey:@"content"];
//            
//            NSString *sql = [NSString stringWithFormat:@"select count (*) as count, course, cert_type, city_id from dt_question where id >= %zd group by course, cert_type, city_id", 3053147];
//            FMResultSet *rs = [db executeQuery:sql];//
//            while ([rs next]) {
//                int qc = [rs intForColumn:@"course"];
//                NSString *key = [NSString stringWithFormat:@"course_%zd", qc == 1 ? qc : 4];
//                if (![rs columnIsNull:@"city_id"]) {
//                    key = [key stringByAppendingFormat:@"_%@", [rs stringForColumn:@"city_id"]];
//                }
//                NSMutableDictionary *course = [dict objectForKey:key];
//                if (![dict objectForKey:key]) {
//                    course = [NSMutableDictionary dictionary];
//                    [dict setObject:course forKey:key];
//                }
//                [course setObject:[NSString stringWithFormat:@"%zd", [rs intForColumn:@"count"]] forKey:[NSString stringWithFormat:@"%zd", [rs intForColumn:@"cert_type"]]];
//            }
//            writeTxtToPath([dict JSONString_ff], PATH(@"ex_info.txt"));
        }
        
        //章节sql
//        [KJZChapter deal];
    }];
    
//    [self wholeTxt:YES];
}

+ (void)wholeTxt:(BOOL)encrypt {
    if (!encrypt) {
        NSLog(@"解密题库已存在");
        return;
    }
    
    NSString *path = PATH(DB([KJZ stringByAppendingString:@"_jiami"]));
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSLog(@"加密题库已存在");
        return;
    }
    
    KJZ_DB *kjz = [KJZ_DB new];
    
    [[NSFileManager defaultManager] copyItemAtPath:kjz.cldb_path toPath:path error:nil];
    NSLog(@"开始加密题库");
    
    // 关联题库
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//    [dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:@"select course, question_id, question, answer, comments from dt_question"];
//        while ([rs next]) {
//            NSString *course = [rs stringForColumnIndex:0];
//            NSString *question_id = [rs stringForColumnIndex:1];
//            NSString *question;
//            NSString *answer;
//            NSString *comments;
//            if (encrypt) {
//                question = sell_coffee([rs stringForColumnIndex:2], questionWrapper);
//                answer   = sell_coffee([rs stringForColumnIndex:3], answerWrapper);
//                comments = sell_coffee([rs stringForColumnIndex:4], commentsWrapper);
//            } else {
//                question = buy_coffee([rs stringForColumnIndex:2], questionWrapper);
//                answer   = buy_coffee([rs stringForColumnIndex:3], answerWrapper);
//                comments = buy_coffee([rs stringForColumnIndex:4], commentsWrapper);
//            }
//            NSString *sql = [NSString stringWithFormat:@"update dt_question set question='%@', answer='%@', comments=%@ where course=%@ and question_id=%@", question, answer, comments?[NSString stringWithFormat:@"'%@'", comments]:@"null", course, question_id];
//            [db executeUpdate:sql];
//        }
//        [rs close];
//        NSLog(@"加密题库完成");
//    }];
    
    //===================================================================================================================
    
    __block NSInteger i = 0;
    NSMutableString *mString = [NSMutableString string];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSLog(@"加密题库sql");
        NSString *sql = [NSString stringWithFormat:@"select * from dt_question where question_id >= %zd", 10000];
        FMResultSet *rs = [db executeQuery:sql];//
        
        while ([rs next]) {
            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
            
            [mString appendString:sqlPHPStringWithItem(obj, NO)];
            [mString appendString:@"\n"];
            
            i++;
        }
        [rs close];
        
        //插入sql
        writeTxtToPath(mString, PATH([KJZ stringByAppendingString:@"_sql_jiami"]));
        
        NSLog(@"加密题库sql 完成");
    }];
}

- (void)updateKaojiazhao
{
    //每次更新 需要重新调整 （插入章节）
    NSString *path = PATH(DB(KJZ));
    NSString *dir_other = PATH(CLDB(@"jkbd679"));
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", dir_other];
        [db executeUpdate:sql];
    }];
    
    //新增评论
    //    NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nocomment" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    //    NSArray *array = [text componentsSeparatedByString:@"\n"];
    //    NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
    //    for (NSString *str in array) {
    //        NSArray *array = [str componentsSeparatedByString:@"\t"];
    //        if (array.count==2) {
    //            FFQuestionItem *item = [FFQuestionItem new];
    //            item.question_id = [[array objectAtIndex:0] integerValue];
    //            item.comments    = [array objectAtIndex:1];
    //            [questions addObject:item];
    //        }
    //    }
    //
    //    [_dbQueue inDatabase:^(FMDatabase *db) {
    //        for (FFQuestionItem *item in questions) {
    //            if (item.comments.length) {
    //                NSString *sql = [NSString stringWithFormat:@"update dt_question set comments = '%@' where question_id = %d", item.comments, 36000+item.question_id];
    //                [db executeUpdate:sql];
    //            }
    //        }
    //    }];
    //
    //
    //    return;
    
    //    //查询
    //
    //    [_dbQueue inDatabase:^(FMDatabase *db) {
    //        FMResultSet *rs = [db executeQuery:@"select a.id as aid, a.chapter as achapter, a.question as aquestion, b.id as bid, b.chapter, b.question from Q.dt_question a left join dt_question b on a.question = b.question"];
    //        while ([rs next]) {
    //            NSInteger chapter = [rs intForColumn:@"achapter"];
    //            if (chapter==221) {
    //                NSLog(@"==== %d == %d == %d", [rs intForColumn:@"aid"], [rs intForColumn:@"bid"], [rs intForColumn:@"chapter"]);
    //            }
    //        }
    //        [rs close];
    //    }];
    //    return;
    
    //
    //    [_dbQueue inDatabase:^(FMDatabase *db) {
    //        FMResultSet *rs = [db executeQuery:@"select * from Q.dt_question where id >=9894 and id <=9913"];
    //        while ([rs next]) {
    //            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
    //            NSString *sql = [NSString stringWithFormat:@"update dt_question set comments = '%@' where id = %d", obj.comments, 1050019+(obj.itemId-9894)];
    //            [db executeUpdate:sql];
    //        }
    //        [rs close];
    //    }];
    //    return;
    
    //    __block NSInteger i =0;
    //    [_dbQueue inDatabase:^(FMDatabase *db) {
    //        //@"select * from Q.dt_question where chapter in (223, 224)"
    //        FMResultSet *rs = [db executeQuery:@"select * from Q.dt_question"];
    //        while ([rs next]) {
    //            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
    //            //自己定义本次导入的 question_id 起始值
    //            obj.question_id = (uint32_t)(44000 +i);
    //            NSString *sql = [NSString stringWithFormat:@"insert into dt_question (course, question_id, chapter, category, type, cert_type, question, media_type, media, option_a, option_b, option_c, option_d, answer, difficulty, comments, city_id) values (%d, %d, %d, %d, %d, %d, %@, %d, %@, %@, %@, %@, %@, %@, %d, %@, %@)", obj.course, obj.question_id, obj.chapter, obj.category, obj.type, obj.cert_type, sqlString(obj.question), obj.media_type, sqlString(obj.media), sqlString(obj.option_a), sqlString(obj.option_b), sqlString(obj.option_c), sqlString(obj.option_d), sqlString(obj.answer), obj.difficulty, sqlString(obj.comments), sqlString(obj.city_id)];
    //            [db executeUpdate:sql];
    //            i++;
    //        }
    ////        [db executeUpdate:@"update dt_question set question_id = id where question_id is null"];
    //        [rs close];
    //    }];
    
    NSString *txt = readTxtFromPath(PATH(@"kesixinzeng.txt"));
    
    NSArray *array = [txt componentsSeparatedByString:@"\n"];
    if (array.count < 3) {
        array = [txt componentsSeparatedByString:@"\r"];
    }
//    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *idArray1 = [NSMutableArray array];
    NSMutableArray *idArray2 = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = [obj componentsSeparatedByString:@"\t"];
        if (arr.count == 2) {
            if ([[arr lastObject] rangeOfString:@"安全行车常识"].length) {
                [idArray1 addObject:[arr firstObject]];
            } else {
                [idArray2 addObject:[arr firstObject]];
            }
        }
    }];
    
    __block NSInteger i =0;
    NSMutableString *mString = [NSMutableString string];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //@"select * from Q.dt_question where chapter in (223, 224)"
        NSString *sqlStr = [NSString stringWithFormat:@"select * from dt_question where course=1 and question_id in (%@)", [idArray1 componentsJoinedByString:@","]];
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
            //自己定义本次导入的 question_id 起始值
            obj.question_id = (uint32_t)(5400 +i);
            obj.chapter = 2;
            obj.course = 3;
            obj.cert_type = 7;
            NSString *sql = [NSString stringWithFormat:@"insert into dt_question (course, question_id, chapter, category, type, cert_type, question, media_type, media, option_a, option_b, option_c, option_d, answer, difficulty, comments, city_id) values (%d, %d, %d, %d, %d, %d, %@, %d, %@, %@, %@, %@, %@, %@, %d, %@, %@)", obj.course, obj.question_id, obj.chapter, obj.category, obj.type, obj.cert_type, sqlString(obj.question), obj.media_type, sqlString(obj.media), sqlString(obj.option_a), sqlString(obj.option_b), sqlString(obj.option_c), sqlString(obj.option_d), sqlString(obj.answer), obj.difficulty, sqlString(obj.comments), sqlString(obj.city_id)];
//            NSString *sql = [NSString stringWithFormat:@"update dt_question set question = %@, answer = %@ where question_id = %zd;\n", sqlString(obj.question), sqlString(obj.answer), obj.question_id];
            [mString appendString:sql];
            
            [db executeUpdate:sql];
            i++;
        }
        
        [rs close];
        
//        [mString writeToFile:PATH(@"sql682_shanghai") atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }];
    
//    i =0;
//    mString = [NSMutableString string];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"select * from dt_question where course=1 and question_id in (%@)", [idArray2 componentsJoinedByString:@","]];
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            FFQuestionItem *obj = [FFQuestionItem itemFromResultSet:rs];
            //自己定义本次导入的 question_id 起始值
            obj.question_id = (uint32_t)(5400 +i);
            obj.chapter = 4;
            obj.course = 3;
            obj.cert_type = 7;
            NSString *sql = [NSString stringWithFormat:@"insert into dt_question (course, question_id, chapter, category, type, cert_type, question, media_type, media, option_a, option_b, option_c, option_d, answer, difficulty, comments, city_id) values (%d, %d, %d, %d, %d, %d, %@, %d, %@, %@, %@, %@, %@, %@, %d, %@, %@)", obj.course, obj.question_id, obj.chapter, obj.category, obj.type, obj.cert_type, sqlString(obj.question), obj.media_type, sqlString(obj.media), sqlString(obj.option_a), sqlString(obj.option_b), sqlString(obj.option_c), sqlString(obj.option_d), sqlString(obj.answer), obj.difficulty, sqlString(obj.comments), sqlString(obj.city_id)];
            //            NSString *sql = [NSString stringWithFormat:@"update dt_question set question = %@, answer = %@ where question_id = %zd;\n", sqlString(obj.question), sqlString(obj.answer), obj.question_id];
            [mString appendString:sql];
            
            [db executeUpdate:sql];
            i++;
        }
        
        [rs close];
        
        [mString writeToFile:PATH(@"sql690_3") atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }];
    
    NSLog(@"+++++++++++++++插入成功:%zd", i);
}

+ (void)updateDB
{
    KJZ_DB *kjz = [KJZ_DB new];
//    NSString *path = kjz.cldb_path;
//    NSString *otherPath = PATH(DB(@"question_686_jm"));
//    
//    NSDictionary *dict = [readTxtFromPath(PATH(@"know_id13.txt")) JSONObject_ff];
//    [self updateDBPath:path attachOtherPath:otherPath block:^(FMDatabase *db) {
//        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString * obj, BOOL * _Nonnull stop) {
//            NSString *sql = [NSString stringWithFormat:@"UPDATE Q.dt_question_knowledge SET knowledge_id = %@ WHERE knowledge_id=%@ and course=3", obj, key];
//            [db executeUpdate:sql];
//        }];
//    }];

    NSString *path = PATH(DB(@"question_686_know"));
    NSString *otherPath = PATH(DB(@"question_686_jm"));
    
    [self updateDBPath:path attachOtherPath:otherPath block:^(FMDatabase *db) {
        if (![db tableExists:@"Q.dt_question_knowledge"]) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE Q.dt_question_knowledge (id integer primary key,question_id integer,knowledge_id integer,course integer)"];
            [db executeUpdate:sql];
        }
        NSString *sql = [NSString stringWithFormat:@"select * from dt_question_knowledge"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *insertSql = [NSString stringWithFormat:@"insert into Q.dt_question_knowledge (question_id, knowledge_id, course) values (%zd,%zd,%zd)", [rs intForColumn:@"question_id"], [rs intForColumn:@"knowledge_id"], [rs intForColumn:@"course"]];
            [db executeUpdate:insertSql];
        }
        [rs close];
    }];
    
}

+ (void)updateDBPath:(NSString *)path attachOtherPath:(NSString *)otherPath block:(void (^)(FMDatabase *db))block
{
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", otherPath];
        [db executeUpdate:sql];
    }];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (block) {
            block(db);
        }
    }];
}

@end
