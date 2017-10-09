//
//  JKBD_DB.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "JKBD_DB.h"
#import "FFJKBDQuestionItem.h"
#import "KJZ_DB.h"

@implementation JKBD_DB

- (void)setUp
{
    self.name = @"jkbd679";
    self.oldName = @"jkbd6611";
    self.appName = @"驾考宝典";
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
    NSString *bundlePath = BUNDLE(self.name, @"db");
    NSMutableArray *items = [NSMutableArray array];
    FFDatabase *db_other = [[FFDatabase alloc] initWithPath:bundlePath
                                             supportClasses:nil];
    [db_other excuteTransactionWithBlock:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from t_question where _id > %zd", fromId];
        FMResultSet *rs = [db executeQuery:sql];//
        while ([rs next]) {
            FFJKBDQuestionItem *item = [[FFJKBDQuestionItem alloc] initWithResultSet:rs];
            
            // 获取包含的标签
            __block BOOL start;
            __block NSString *exc;
            __block NSMutableArray *excs = [NSMutableArray array];
            void(^LABEL_TEST)(NSString *) = ^(NSString *substring) {
                if ([substring isEqualToString:@"<"]) {
                    start = YES;
                    exc = @"";
                } else if (start) {
                    if ([substring isEqualToString:@">"]) {
                        start = NO;
                        exc = [NSString stringWithFormat:@"<%@>", exc];
                        if (![excs containsObject:exc]) {
                            [excs addObject:exc];
                        }
                    } else {
                        exc = [exc stringByAppendingString:substring];
                    }
                }
            };
            void(^CHAR_TEST)(NSString *) = ^(NSString *substring) {
                if ([substring isEqualToString:@"&"]) {
                    start = YES;
                    exc = @"";
                } else if (start) {
                    if ([substring isEqualToString:@";"]) {
                        start = NO;
                        exc = [NSString stringWithFormat:@"&%@;", exc];
                        if (![excs containsObject:exc]) {
                            [excs addObject:exc];
                        }
                    } else {
                        exc = [exc stringByAppendingString:substring];
                    }
                }
            };
            
            // 替换包含的标签
            NSArray *keys = @[@"question", @"explain", @"option_a", @"option_b", @"option_c", @"option_d"];
            [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop1) {
                __block NSString *value = [item valueForKey:key];
                [value enumerateSubstringsInRange:NSMakeRange(0, value.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    LABEL_TEST(substring);
                }];
                [value enumerateSubstringsInRange:NSMakeRange(0, value.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    CHAR_TEST(substring);
                }];
                [excs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop2) {
                    value = [value stringByReplacingOccurrencesOfString:obj withString:@""];
                }];
                [excs removeAllObjects];
                // 重新赋值
                value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [item setValue:value forKey:key];
            }];
            [items addObject:item];
        }
        [rs close];
        NSLog(@"读取考题成功，共%zd题", items.count);
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
        [items enumerateObjectsUsingBlock:^(FFJKBDQuestionItem *obj, NSUInteger idx, BOOL *top) {
            // 转换考题对象
            FFQuestionItem *item = [FFQuestionItem new];
            item.id              = (int)idx+1;
            item.course          = obj.course;
            item.question_id     = obj.question_id;
            item.chapter         = obj.chapter_id;
            item.category        = obj.media_content ? 1 : 0;
            item.type            = obj.option_type;
            item.cert_type       = obj.cert_type;
            item.question        = obj.question;
            item.media           = obj.media;
            item.media_type      = obj.media_type;
            item.option_a        = obj.option_a;
            item.option_b        = obj.option_b;
            item.option_c        = obj.option_c;
            item.option_d        = obj.option_d;
            item.option_e        = obj.option_e;
            item.option_f        = obj.option_f;
            item.option_g        = obj.option_g;
            item.option_h        = obj.option_h;
            item.answer          = obj.answer_char;
            item.difficulty      = obj.difficulty;
            item.comments        = obj.explain;
            
            // 存储图片
            if (obj.media_content) {
                if (obj.media_type == 1) {
//                    NSData *data = obj.media_content;
//                    NSData* imageData = [[NSData alloc] initWithBytes:[data bytes] length: [data length]];
//                    UIImage* image = [[UIImage alloc] initWithData:imageData];
//                    [self tosaveData:image withPath:[dir_image stringByAppendingPathComponent:obj.media]];

//                    [obj.media_content writeToFile:[dir_image stringByAppendingPathComponent:obj.media]
//                                        atomically:YES];
                    NSString *path = PATH(([NSString stringWithFormat:@"jkbd_png/%zd.png", obj.question_id]));
                    [manager copyItemAtPath:path toPath:[dir_image stringByAppendingPathComponent:obj.media] error:NULL];
                } else {
                    [obj.media_content writeToFile:[dir_image stringByAppendingPathComponent:obj.media]
                                        atomically:YES];
                }
                
            }
            [db insertObject:item];
        }];
        NSLog(@"转换考题成功:共%zd题", items.count);
    }];
}

//- (void)tosaveData:(UIImage *)image withPath:(NSString *)path
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager createFileAtPath:path contents:UIImageJPEGRepresentation(image, 1.f) attributes:nil];
//}

- (void)dealJKBDKnowledgeId
{
    NSString *string1 = readTxtFromPath(PATH(@"jkbd679_same_1.txt"));
    NSString *string3 = readTxtFromPath(PATH(@"jkbd679_same_3.txt"));
    NSDictionary *course1 = [string1 JSONObject_ff];
    NSDictionary *course3 = [string3 JSONObject_ff];
    NSMutableDictionary *foundId1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *foundId3 = [NSMutableDictionary dictionary];
    NSMutableArray *notfoundId = [NSMutableArray array];
    NSMutableArray *items = [NSMutableArray array];
    
//    FFDatabase *db_other = [[FFDatabase alloc] initWithPath:BUNDLE(self.name, @"db")
//                                             supportClasses:nil];
//    [db_other excuteTransactionWithBlock:^(FMDatabase *db) {
//        
//    }];
//    
    
    KJZ_DB *kjz = [KJZ_DB new];
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:BUNDLE(self.name, @"db")];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS Q", PATH(DB(@"question_686_jm"))];
        [db executeUpdate:sql];
    }];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from t_question_knowledge"];
        while ([rs next]) {
            FFJKBDKnowledgeIdItem *item = [FFJKBDKnowledgeIdItem itemFromResultSet:rs];
            NSString *qid = [rs stringForColumn:@"question_id"];
            if ([course1 objectForKey:qid]) {
                [foundId1 setObject:[course1 objectForKey:qid] forKey:qid];
                item.course = 1;
                [items addObject:item];
            } else if ([course3 objectForKey:qid]) {
                [foundId3 setObject:[course3 objectForKey:qid] forKey:qid];
                item.course = 3;
                [items addObject:item];
            } else {
                [notfoundId addObject:qid];
            }
        }
        [rs close];
        
        NSMutableString *mstr = [NSMutableString string];
        [mstr appendFormat:@"found1 = %zd\n", foundId1.count];
        if (foundId1) {
            [mstr appendString:[foundId1 JSONString_ff]];
        }
        [mstr appendString:@"\n==========================================\n\n"];
        [mstr appendFormat:@"found3 = %zd\n", foundId3.count];
        if (foundId3) {
            [mstr appendString:[foundId3 JSONString_ff]];
        }
        [mstr appendString:@"\n==========================================\n\n"];
        [mstr appendFormat:@"notfound = %zd\n", notfoundId.count];
        if (notfoundId) {
            [mstr appendString:[notfoundId JSONString_ff]];
        }
        writeTxtToPath(mstr, PATH(([NSString stringWithFormat:@"%@_knowledge_id.txt", self.name])));
        
        if (![db tableExists:@"dt_question_knowledge"]) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE Q.dt_question_knowledge (id integer primary key,question_id integer,knowledge_id integer,course integer)"];
            [db executeUpdate:sql];
        } else {
            [db executeUpdate:@"DROP TABLE Q.dt_question_knowledge"];
            
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE Q.dt_question_knowledge (id integer primary key,question_id integer,knowledge_id integer,course integer)"];
            [db executeUpdate:sql];
        }
        [items enumerateObjectsUsingBlock:^(FFJKBDKnowledgeIdItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            /*
             NSString *sql = [NSString stringWithFormat:@"INSERT INTO dt_question (course, question_id, chapter, category, type, cert_type, question, media_type, media, option_a, option_b, option_c, option_d, answer, difficulty, comments, city_id) VALUES (%d, %d, %d, %d, %d, %d, %@, %d, %@, %@, %@, %@, %@, %@, %d, %@, %@)", obj.course, obj.question_id, obj.chapter, obj.category, obj.type, obj.cert_type, sqlString(obj.question), obj.media_type, sqlString(obj.media), sqlString(obj.option_a), sqlString(obj.option_b), sqlString(obj.option_c), sqlString(obj.option_d), sqlString(obj.answer), obj.difficulty, sqlString(obj.comments), sqlString(obj.city_id)];
             */
            NSString *qid = [NSString stringWithFormat:@"%zd", obj.question_id];
            NSString *sql = nil;
            if (obj.course == 1) {
                sql = [NSString stringWithFormat:@"INSERT INTO Q.dt_question_knowledge (id, question_id, knowledge_id, course) VALUES (%zd, %zd, %zd, %zd)", idx+1, [[foundId1 objectForKey:qid] integerValue], obj.knowledge_id, obj.course];
            } else {
                sql = [NSString stringWithFormat:@"INSERT INTO Q.dt_question_knowledge (id, question_id, knowledge_id, course) VALUES (%zd, %zd, %zd, %zd)", idx+1, [[foundId3 objectForKey:qid] integerValue], obj.knowledge_id, obj.course];
            }
            [db executeUpdate:sql];
        }];
    }];
}

- (void)dealJKBDKnowledge
{
    NSLog(@"开始处理考题知识点");
    
    NSMutableArray *items = [NSMutableArray array];
    FFDatabase *db_other = [[FFDatabase alloc] initWithPath:BUNDLE(self.name, @"db")
                                             supportClasses:nil];
    [db_other excuteTransactionWithBlock:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from t_dictionary"];
        while ([rs next]) {
            FFJKBDKnowledgeItem *item = [[FFJKBDKnowledgeItem alloc] initWithResultSet:rs];
            
            // 获取包含的标签
            __block BOOL start;
            __block NSString *exc;
            __block NSMutableArray *excs = [NSMutableArray array];
            void(^LABEL_TEST)(NSString *) = ^(NSString *substring) {
                if ([substring isEqualToString:@"<"]) {
                    start = YES;
                    exc = @"";
                } else if (start) {
                    if ([substring isEqualToString:@">"]) {
                        start = NO;
                        exc = [NSString stringWithFormat:@"<%@>", exc];
                        if (![excs containsObject:exc]) {
                            [excs addObject:exc];
                        }
                    } else {
                        exc = [exc stringByAppendingString:substring];
                    }
                }
            };
            void(^CHAR_TEST)(NSString *) = ^(NSString *substring) {
                if ([substring isEqualToString:@"&"]) {
                    start = YES;
                    exc = @"";
                } else if (start) {
                    if ([substring isEqualToString:@";"]) {
                        start = NO;
                        exc = [NSString stringWithFormat:@"&%@;", exc];
                        if (![excs containsObject:exc]) {
                            [excs addObject:exc];
                        }
                    } else {
                        exc = [exc stringByAppendingString:substring];
                    }
                }
            };
            
            // 替换包含的标签
            NSArray *keys = @[@"value"];
            [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop1) {
                __block NSString *value = [item valueForKey:key];
                [value enumerateSubstringsInRange:NSMakeRange(0, value.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    LABEL_TEST(substring);
                }];
                [value enumerateSubstringsInRange:NSMakeRange(0, value.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    CHAR_TEST(substring);
                }];
                [excs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop2) {
                    value = [value stringByReplacingOccurrencesOfString:obj withString:@""];
                }];
                [excs removeAllObjects];
                // 重新赋值
                value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [item setValue:value forKey:key];
            }];
            
            [items addObject:item];
        }
        [rs close];
        NSLog(@"解析知识点成功，共%zd条", items.count);
    }];
    
    NSMutableString *text = [NSMutableString string];
    [items enumerateObjectsUsingBlock:^(FFJKBDKnowledgeItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [text appendFormat:@"\n\n%@\n\n%@\n\n%@\n\n", obj.name, obj.value, obj.groups];
    }];
    
    writeTxtToPath(text, PATH([self.name stringByAppendingString:@"_knowledge.txt"]));
}

- (void)dealJKBDKnowledgeItem
{
    NSString *string1 = readTxtFromPath(PATH(@"jkbd679_knowledge_1.txt"));
    NSString *string3 = readTxtFromPath(PATH(@"jkbd679_knowledge_3.txt"));
    NSArray *array1 = [string1 JSONObject_ff];
    NSArray *array3 = [string3 JSONObject_ff];
    
    
    NSMutableArray *cla1 = [NSMutableArray array];
    NSMutableArray *k1 = [NSMutableArray array];
    [array1 enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FFKnowledgeClassifyItem *item = [FFKnowledgeClassifyItem itemFromDict:obj];
        if (item) {
            item.course = 1;
            [cla1 addObject:[item dict]];
            [k1 addObjectsFromArray:item.childList];
        }
    }];
    
    NSMutableArray *cla3 = [NSMutableArray array];
    NSMutableArray *k3 = [NSMutableArray array];
    [array3 enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FFKnowledgeClassifyItem *item = [FFKnowledgeClassifyItem itemFromDict:obj];
        if (item) {
            item.course = 3;
            [cla3 addObject:[item dict]];
            [k3 addObjectsFromArray:item.childList];
        }
    }];
    
    NSMutableDictionary *k13 = [NSMutableDictionary dictionary];
    NSMutableArray *kArray = [NSMutableArray array];
    for (FFKnowledgeItem *item in k1) {
        FFKnowledgeItem *foundItem = nil;
        for (FFKnowledgeItem *item3 in k3) {
            if ([item3.name isEqualToString:item.name]) {
                foundItem = item3;
                if (![item.desc isEqualToString:item.desc]) {
                    NSLog(@"id1-3 = %@-%@\n%@\n%@", item.itemId, item3.itemId, item.desc, item3.desc);
                }
                break;
            }
        }
        if (foundItem) {
            [k13 setObject:item.itemId forKey:foundItem.itemId];
            [k3 removeObject:foundItem];
        } else {
//            NSLog(@"not found %@", item.name);
        }
        [kArray addObject:[item dict]];
    }
    if (k3.count) {
        NSLog(@"k3 count = %zd", k3.count);
        for (FFKnowledgeItem *item in k3) {
            [kArray addObject:[item dict]];
        }
    }
    
    [kArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        int id1 = [[obj1 objectForKey:@"id"] intValue];
        int id2 = [[obj2 objectForKey:@"id"] intValue];
        return [@(id1) compare:@(id2)];
    }];
    
    NSMutableDictionary *claDict = [NSMutableDictionary dictionary];
    [claDict setObject:cla1 forKey:@"1"];
    [claDict setObject:cla3 forKey:@"3"];
//    writeTxtToPath([claDict JSONString_ff], PATH(@"know_class.txt"));
    
    writeTxtToPath([kArray JSONString_ff], PATH(@"know_detail.txt"));
    
//    writeTxtToPath([k13 JSONString_ff], PATH(@"know_id13.txt"));
}

@end
