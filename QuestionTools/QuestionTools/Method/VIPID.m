//
//  VIPID.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "VIPID.h"
#import "KeyVipCategory.h"

@implementation VIPID

NSMutableArray *sameIds_kjz;
NSMutableArray *sameIds_jkbd;

NSDictionary *jxydt_vipSource;
NSDictionary *jxydt_vipCourse;
NSMutableArray *vipQ1, *vipQ4;

NSMutableDictionary *fuck_id;

+ (void)deal
{
    [self chapter3Vip];
    return;
//    [self updateVipCourseTxt];
    [self dealVIPLoacalQuestion];
    return;
    
    NSString *path = PATH(DB(KJZ));
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *id7Array = [NSMutableArray array];
        NSArray *cert_types =@[@"7",@"2", @"4", @"8"];
        NSMutableDictionary *vipDict = [NSMutableDictionary dictionary];
        for (NSString *certType in cert_types) {
            for (NSInteger i = 1; i<4; i+=2) {
                
                NSMutableArray *diffArray = [NSMutableArray array];
                int num = 0;
                for (NSInteger j = 1; j<6; j++) {
                    NSString *sql = [NSString stringWithFormat:@"select question_id from dt_question where cert_type=%@ and city_id is null and course = %zd and difficulty = %zd  and question_id not in (4,9,18,29,1294,75,76,77,125,148,165,1270,166,167,1337,199,1234,291,295,297,303,306,1339,1257,1207,311,2001,250,251,252,253,254,263,1344,324,1275,269,1284,346,1115,1127,1138,1145,36,174,207,290,1220,1130,2101,98,111,202,1566,1547,2587,2469,2538,2621,1627,1639,2554,1704,1720,2509,2559,2351,2392,1967,1975,1979,2542,1996,1558,1579,1598,1582,1589,1591,1599,2535,2466,1605,1606,1699,1664) order by random()", certType, i, j];
                    
                    FMResultSet *rs = [db executeQuery:sql];
                    NSMutableArray *idArray = [NSMutableArray array];
                    while ([rs next]) {
                        [idArray addObject:[rs stringForColumnIndex:0]];
                    }
                    [rs close];
                    
                    NSInteger m = 30;
                    if (idArray.count % 30 <= 15 && idArray.count > 30) {
                        int n = ceilf(idArray.count *1.f / 30);
                        m = ceilf(idArray.count *1.f / n);
                    }
                    if ([certType integerValue] == 2 ||[certType integerValue] == 4) {
                        if (idArray.count > 10) {
                            m = 3;
                        } else {
                            m = 2;
                        }
                    }
                    
                    NSMutableArray *array = [NSMutableArray array];
                    int index = 0;
                    int pos = 0;
                    if (i == 1 && ([certType integerValue] == 2 ||[certType integerValue] == 4)) {
                        NSMutableArray *dif = [[id7Array objectAtIndex:j-1] mutableCopy];
                        while (pos < dif.count) {
                            NSArray *sub = nil;
                            NSString *string = [dif objectAtIndex:pos];
                            if (index + m < idArray.count) {
                                sub = [idArray subarrayWithRange:NSMakeRange(index, m)];
                                [array addObject:[NSString stringWithFormat:@"%@,%@", string, [sub componentsJoinedByString:@","]]];
                            } else if (index < idArray.count){
                                sub = [idArray subarrayWithRange:NSMakeRange(index, idArray.count - index)];
                                [array addObject:[NSString stringWithFormat:@"%@,%@", string, [sub componentsJoinedByString:@","]]];
                            } else {
                                [array addObject:string];
                            }
                            index += m;
                            pos ++;
                        }
                    } else {
                        while (index < idArray.count) {
                            if (index + m < idArray.count) {
                                NSArray *sub = [idArray subarrayWithRange:NSMakeRange(index, m)];
                                [array addObject:[sub componentsJoinedByString:@","]];
                            } else {
                                NSArray *sub = [idArray subarrayWithRange:NSMakeRange(index, idArray.count - index)];
                                [array addObject:[sub componentsJoinedByString:@","]];
                            }
                            index += m;
                            pos ++;
                        }
                    }
                    
                    
                    [diffArray addObject:array];
                    num += idArray.count;
                    
                }
                if ([certType integerValue] == 7 && i == 1) {
                    id7Array = [diffArray mutableCopy];
                }
                if (num > 0) {
                    [vipDict setObject:diffArray forKey:[NSString stringWithFormat:@"%@_%zd",certType, i]];
                }
            }
        }
        [[vipDict JSONString_ff] writeToFile:PATH(@"question_vipcourse.json") atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }];
}

+ (void)chapter3Vip
{
    NSString *path = PATH(DB(KJZ));
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db){
        NSDictionary *vipSource = [readTxtFromPath(BUNDLE(@"question_vipcourse_chapter3", @"json")) JSONObject_ff];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        [vipSource enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSArray* obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"1_1"] || [key isEqualToString:@"2_1"] || [key isEqualToString:@"4_1"]) {
                NSMutableArray *obj1 = [NSMutableArray array];
                [obj enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableArray *arr1 = [NSMutableArray array];
                    [arr enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *sql = [NSString stringWithFormat:@"select question_id from dt_question where chapter=1000 and question_id in (%@)", string];
                        
                        NSMutableArray *restult1 = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@","]];
                        FMResultSet *rs = [db executeQuery:sql];
                        while ([rs next]) {
                            [restult1 removeObject:[rs stringForColumnIndex:0]];
                        }
                        
                        if (restult1.count) {
                            [arr1 addObject:[restult1 componentsJoinedByString:@","]];
                        } else {
                            [arr1 addObject:@""];
                        }
                    }];
                    [obj1 addObject:arr1];
                }];
                
                [result setObject:obj1 forKey:key];
            }
        }];
        
        writeTxtToPath([result JSONString_ff], PATH(@"chapter3_vip_new"));
    }];
}

+ (void)updateVipCourseTxt
{
    NSString *path = BUNDLE(@"question_vipcourse", @"json");
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableDictionary *dict = [[string JSONObject_ff] mutableCopy];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        for (int course = 1; course < 4; course += 2) {
            NSString *key = nil;
            int certType = 1;
            if (course == 1) {
                key = [NSString stringWithFormat:@"%zd_1", certType];
            } else {
                key = [NSString stringWithFormat:@"%zd_3", certType==DTCertTypeMotoche?certType:7];
            }
            NSMutableArray *array = [[dict objectForKey:key] mutableCopy];
            
            NSString *fileName = [NSString stringWithFormat:@"all_same_id_%zd", course];
            NSString *sameIdStr = readTxtFromPath(BUNDLE(fileName, @"txt"));
            NSArray *sameIds = [sameIdStr componentsSeparatedByString:@","];
            
            NSMutableArray *result = [NSMutableArray array];
            
            [array enumerateObjectsUsingBlock:^(NSArray * sub, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *subResult = [NSMutableArray array];
                for (NSString *str in sub) {
                    NSMutableArray *subArray = [[str componentsSeparatedByString:@","] mutableCopy];
                    [subArray removeObjectsInArray:sameIds];
                    if (subArray.count > 0) {
                        [subResult addObject:[subArray componentsJoinedByString:@","]];
                    }
                }
                if (subResult.count) {
                    [result addObject:subResult];
                }
            }];
            
            [dict setObject:result forKey:key];
        }
        
        writeTxtToPath([dict JSONString_ff], PATH(@"vip_id1.json"));
    }
}

- (void)shanchuId
{
    NSString *path = BUNDLE(@"shanchu4", @"txt");
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [string componentsSeparatedByString:@"\r"];
    NSMutableArray *idArray = [NSMutableArray array];
    for (NSString *str in array) {
        NSArray *arr = [str componentsSeparatedByString:@"\t"];
        if (arr.count >= 2) {
            if ([[arr objectAtIndex:1] isEqualToString:@"0"]) {
                [idArray addObject:[arr objectAtIndex:0]];
            }
        }
    }
    string = [idArray componentsJoinedByString:@","];
    [string writeToFile:PATH(@"shanchu4Id") atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)getSameId
{
    sameIds_kjz = [NSMutableArray array];
    sameIds_jkbd = [NSMutableArray array];
    NSMutableDictionary *fuckId = [NSMutableDictionary dictionary];
    NSString *string = readTxtFromPath(PATH(@"qid.txt"));
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    for (NSString *str in array) {
        NSArray *arr = [str componentsSeparatedByString:@"\t"];
        if (arr.count >= 2) {
            if ([sameIds_kjz containsObject:arr[0]]) {
                if ([fuckId objectForKey:arr[0]]) {
                    NSMutableString *fid = [NSMutableString stringWithString:[fuckId objectForKey:arr[0]]];
                    [fid appendFormat:@",%@", arr[1]];
                    [fuckId setObject:fid forKey:arr[0]];
                } else {
                    NSString *qqid = [sameIds_jkbd objectAtIndex:[sameIds_kjz indexOfObject:arr[0]]];
                    if (![qqid isEqualToString:arr[1]]) {
                        NSMutableString *fid = [NSMutableString stringWithString:qqid];
                        [fid appendFormat:@",%@", arr[1]];
                        [fuckId setObject:fid forKey:arr[0]];
                    }
                    
                }
                //                continue;
            }
            [sameIds_kjz addObject:arr[0]];
            [sameIds_jkbd addObject:arr[1]];
        } else {
            NSLog(@"str = %@", str);
        }
    }
    //    [[fuckId JSONString_ff] writeToFile:PATH(@"fuckId.txt") atomically:YES encoding:NSUTF8StringEncoding error:nil];
    fuck_id = fuckId;
}

+ (void)dealVIPLoacalQuestion
{
    //VIP 地方题库
    NSString *path = PATH(DB(KJZ));
    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_dbQueue inDatabase:^(FMDatabase *db) {
      
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
//        NSMutableArray *cityIds = [NSMutableArray array];
//        NSString *sql = [NSString stringWithFormat:@"select distinct city_id from dt_question"];
//        
//        FMResultSet *rs = [db executeQuery:sql];
//        while ([rs next]) {
//            NSString *city = [rs stringForColumnIndex:0];
//            if (city.length) {
//                [cityIds addObject:city];
//            }
//        }
        
        NSArray *cert_types =@[@"1",@"2", @"4", @"8"];
        
        for (NSString *certType in cert_types) {
            for (NSInteger i = 1; i<4; i+=2) {
                NSString *sql = [NSString stringWithFormat:@"select * from dt_question where cert_type&%@>0 and course = %zd and city_id is not null order by random()", certType, i];
                
                FMResultSet *rs = [db executeQuery:sql];
                
                while ([rs next]) {
                    NSString *key = [NSString stringWithFormat:@"%@_%zd_%@", certType, i, [rs stringForColumn:@"city_id"]];
                    NSInteger qid = [rs intForColumn:@"question_id"];
                    NSString *string = [result objectForKey:key];
                    if (string) {
                        string = [string stringByAppendingFormat:@",%zd", qid];
                        [result setObject:string forKey:key];
                    } else {
                        [result setObject:[NSString stringWithFormat:@"%zd", qid] forKey:key];
                    }
                }
                [rs close];
            }
        }
        
        NSMutableDictionary *rrr = [NSMutableDictionary dictionary];
        [result enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL * _Nonnull stop) {
            
            NSArray *idArray = [obj componentsSeparatedByString:@","];
            
            NSInteger m = 30;
            if (idArray.count % 30 <= 15 && idArray.count > 30) {
                int n = ceilf(idArray.count *1.f / 30);
                m = ceilf(idArray.count *1.f / n);
            }
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i=0; i<idArray.count; i+=m) {
                
                NSString *string = [[idArray subarrayWithRange:NSMakeRange(i, MIN(idArray.count - i, m))] componentsJoinedByString:@","];
                [array addObject:string];
            }
            [rrr setObject:array forKey:key];
        }];
        
        
        writeTxtToPath([result JSONString_ff], PATH(@"vip_local.txt"));
        writeTxtToPath([rrr JSONString_ff], PATH(@"vip_local_id.txt"));
    }];
}

- (void)dealJXYDTVipJson
{
    if (jxydt_vipSource == nil) {
        NSString *path = BUNDLE(@"vipCategoryJsons", @"json");
        if (path) {
            NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            if (string) {
                jxydt_vipSource = [[string JSONObject_ff] objectForKey:@"KeyVipCategory"];
            }
        }
        path = BUNDLE(@"vipJsons", @"json");
        if (path) {
            NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            if (string) {
                jxydt_vipCourse = [string JSONObject_ff];
            }
        }
    } else {
        return;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    if (jxydt_vipSource) {
        NSLog(@"source : %@", [jxydt_vipSource allKeys]);
        for (NSString *key in [jxydt_vipSource allKeys]) {
            [items addObject:[KeyVipCategory itemFromDict:jxydt_vipSource forKey:key]];
        }
    }
    
    NSMutableArray *course = [NSMutableArray array];
    if (jxydt_vipCourse) {
        NSLog(@"course : %@", [jxydt_vipCourse allKeys]);
        for (NSString *key in [jxydt_vipCourse allKeys]) {
            
            [course addObject:[KeyVipCourse itemFromDict:jxydt_vipCourse forKey:key]];
        }
        //    CarTypeCar  CarTypeTruck  CarTypeBus  CarTypeMotorcycle
        // SubjectType1st   SubjectType4th
    }
    
    //    NSString *path = PATH(CLDB(@"jxydt"));
    //    FMDatabaseQueue *_dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    NSMutableArray *noFindArray = [NSMutableArray array];
    NSMutableDictionary *fuckId = [NSMutableDictionary dictionary];
    //转换ID
    NSMutableDictionary *excCourse = [NSMutableDictionary dictionary];
    for (KeyVipCourse *item in course) {
        NSInteger n = 1;
        if ([[item.key lowercaseString] rangeOfString:@"bus"].length) {
            n = 2;
        } else if ([[item.key lowercaseString] rangeOfString:@"truck"].length) {
            n = 4;
        } else if ([[item.key lowercaseString] rangeOfString:@"moto"].length) {
            n = 8;
        } else {
            continue;
        }
        
        NSMutableArray *marray = [NSMutableArray array];
        for (NSArray *array in item.course1) {
            NSMutableArray *mmarray = [NSMutableArray array];
            for (NSString *string in array) {
                NSArray *queIds = [string componentsSeparatedByString:@","];
                NSMutableString *qidStr = [NSMutableString string];
                for (NSString *qid in queIds) {
                    if (qidStr.length) {
                        [qidStr appendString:@","];
                    }
                    if ([sameIds_jkbd containsObject:qid]) {
                        NSString *kjzqid = [sameIds_kjz objectAtIndex:[sameIds_jkbd indexOfObject:qid]];
                        [qidStr appendString:kjzqid];
                        if ([[fuck_id allKeys] containsObject:kjzqid]) {
                            [fuckId setObject:[fuck_id objectForKey:kjzqid] forKey:kjzqid];
                        }
                    } else {
                        [qidStr appendString:[NSString stringWithFormat:@"(%@)", qid]];
                        if (![noFindArray containsObject:qid]) {
                            [noFindArray addObject:qid];
                        }
                    }
                }
                [mmarray addObject:qidStr];
            }
            [marray addObject:mmarray];
        }
        
        [excCourse setObject:marray forKey:[NSString stringWithFormat:@"%zd_1", n]];
        
        marray = [NSMutableArray array];
        for (NSArray *array in item.course4) {
            NSMutableArray *mmarray = [NSMutableArray array];
            for (NSString *string in array) {
                NSArray *queIds = [string componentsSeparatedByString:@","];
                NSMutableString *qidStr = [NSMutableString string];
                for (NSString *qid in queIds) {
                    if (qidStr.length) {
                        [qidStr appendString:@","];
                    }
                    if ([sameIds_jkbd containsObject:qid]) {
                        NSString *kjzqid = [sameIds_kjz objectAtIndex:[sameIds_jkbd indexOfObject:qid]];
                        [qidStr appendString:kjzqid];
                        if ([[fuck_id allKeys] containsObject:kjzqid]) {
                            [fuckId setObject:[fuck_id objectForKey:kjzqid] forKey:kjzqid];
                        }
                        [qidStr appendString:kjzqid];
                    } else {
                        [qidStr appendString:[NSString stringWithFormat:@"(%@)", qid]];
                        if (![noFindArray containsObject:qid]) {
                            [noFindArray addObject:qid];
                        }
                    }
                }
                [mmarray addObject:qidStr];
            }
            [marray addObject:mmarray];
        }
        [excCourse setObject:marray forKey:[NSString stringWithFormat:@"%zd_3", n]];
    }
    [excCourse setObject:[noFindArray componentsJoinedByString:@","] forKey:@"not_find"];
    [excCourse setObject:fuckId forKey:@"fuck_id"];
    
    NSString *string = [excCourse JSONString_ff];
    [string writeToFile:PATH(@"vipcourse.txt") atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    //专家课程
    //    [_dbQueue inDatabase:^(FMDatabase *db) {
    //        for (KeyVipCourse *item in course) {
    //            NSMutableString *mstring = [NSMutableString string];
    //            [mstring appendFormat:@"%@ 科一", item.key];
    //            NSInteger i = 0;
    //            for (NSArray *array in item.course1) {
    //                [mstring appendFormat:@"\n\n第%zd阶段(一)\n\n", i+1];
    //                for (NSString *string in array) {
    //                    NSString *str = [NSString stringWithFormat:@"select question, id from dt_question where id in (%@)", string];
    //                    FMResultSet *rs = [db executeQuery:str];
    //                    while ([rs next]) {
    //                        NSString *qid = [NSString stringWithFormat:@"%zd", [rs intForColumn:@"id"]];
    //                        [mstring appendFormat:@"%@\t%@\t%zd\n", [rs stringForColumn:@"question"], qid, [sameIds_jkbd containsObject:qid]];
    //                    }
    //                    [rs close];
    //                    [mstring appendString:@"\n"];
    //                }
    //                i++;
    //            }
    //            i = 0;
    //            [mstring appendFormat:@"%@ 科四", item.key];
    //            for (NSArray *array in item.course4) {
    //                [mstring appendFormat:@"\n\n第%zd阶段(四)\n\n", i+1];
    //                for (NSString *string in array) {
    //                    NSString *str = [NSString stringWithFormat:@"select question, id from dt_question where id in (%@)", string];
    //                    FMResultSet *rs = [db executeQuery:str];
    //                    while ([rs next]) {
    //                        NSString *qid = [NSString stringWithFormat:@"%zd", [rs intForColumn:@"id"]];
    //                        [mstring appendFormat:@"%@\t%@\t%zd\n", [rs stringForColumn:@"question"], qid, [sameIds_jkbd containsObject:qid]];
    //                    }
    //                    [rs close];
    //                    [mstring appendString:@"\n"];
    //                }
    //                i++;
    //            }
    //            NSString *name = [item.key stringByAppendingString:@".txt"];
    //            [mstring writeToFile:PATH(name) atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //        }
    //    }];
    
    
    //专家分类
    //    NSMutableArray *sameQue = [NSMutableArray array];
    //    vipQ1 = [NSMutableArray array];
    //    vipQ4 = [NSMutableArray array];
    //
    //    [_dbQueue inDatabase:^(FMDatabase *db) {
    //        for (KeyVipCategory *item in items) {
    //            for (NSArray *array in item.subject1) {
    //
    //            }
    //        }
    //    }];
    //    for (KeyVipCategory *item in items) {
    //        [vipQ1 removeAllObjects];
    //        [vipQ4 removeAllObjects];
    //        for (NSArray *array in item.subject1) {
    //            for (KeyVipCategoryItem *sub in array) {
    //                if (sub.questionMark) {
    //                    NSArray *arr = [sub.questionMark componentsSeparatedByString:@","];
    //                    for (NSString *string in arr) {
    //                        if (![vipQ1 containsObject:string]) {
    //                            NSInteger n =0;
    //                            for (NSInteger i=0; i<vipQ1.count; i++) {
    //                                if ([string integerValue] < [vipQ1[i] integerValue]) {
    //                                    break;
    //                                }
    //                                n ++;
    //                            }
    //                            [vipQ1 insertObject:string atIndex:n];
    //                        } else {
    //                            NSInteger n =0;
    //                            for (NSInteger i=0; i<sameQue.count; i++) {
    //                                if ([string integerValue] < [sameQue[i] integerValue]) {
    //                                    break;
    //                                }
    //                                n ++;
    //                            }
    //                            [sameQue insertObject:string atIndex:n];
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        for (NSArray *array in item.subject4) {
    //            for (KeyVipCategoryItem *sub in array) {
    //                if (sub.questionMark) {
    //                    NSArray *arr = [sub.questionMark componentsSeparatedByString:@","];
    //                    for (NSString *string in arr) {
    //                        if (![vipQ4 containsObject:string]) {
    //                            NSInteger n =0;
    //                            for (NSInteger i=0; i<vipQ4.count; i++) {
    //                                if ([string integerValue] < [vipQ4[i] integerValue]) {
    //                                    break;
    //                                }
    //                                n ++;
    //                            }
    //                            [vipQ4 insertObject:string atIndex:n];
    //                        } else {
    //                            NSInteger n =0;
    //                            for (NSInteger i=0; i<sameQue.count; i++) {
    //                                if ([string integerValue] < [sameQue[i] integerValue]) {
    //                                    break;
    //                                }
    //                                n ++;
    //                            }
    //                            [sameQue insertObject:string atIndex:n];
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //        if (vipQ1.count + vipQ4.count > 0) {
    //            NSMutableArray *array = [NSMutableArray array];
    //            NSMutableArray *arrayNot = [NSMutableArray array];
    //            for (NSString *string in vipQ1) {
    //                if ([sameIds_jkbd containsObject:string]) {
    //                    NSInteger i = [sameIds_jkbd indexOfObject:string];
    //                    [array addObject:[sameIds_kjz objectAtIndex:i]];
    //                } else {
    //                    [arrayNot addObject:string];
    //                }
    //            }
    //            [array addObject:@"fuck/n"];
    //            [arrayNot addObject:@"fuckNot/n"];
    //            for (NSString *string in vipQ4) {
    //                if ([sameIds_jkbd containsObject:string]) {
    //                    NSInteger i = [sameIds_jkbd indexOfObject:string];
    //                    [array addObject:[sameIds_kjz objectAtIndex:i]];
    //                } else {
    //                    [arrayNot addObject:string];
    //                }
    //            }
    //            NSMutableString *str = [NSMutableString string];
    //            for (NSInteger i = 0; i<array.count; i++) {
    //                [str appendFormat:@"%@,",array[i]];
    //            }
    //            [str appendString:@"=============\n"];
    //            for (NSInteger i = 0; i<arrayNot.count; i++) {
    //                [str appendFormat:@"%@,",arrayNot[i]];
    //            }
    //            NSString *string = [NSString stringWithFormat:@"%@.txt", item.key];
    //            [str writeToFile:PATH(string) atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //        }
    //    }
    
    //    NSLog(@"questions1(%zd) = %@", vipQ1.count, [vipQ1 componentsJoinedByString:@","]);
    //    NSLog(@"questions4(%zd) = %@", vipQ4.count, [vipQ4 componentsJoinedByString:@","]);
    //    NSLog(@"same questions(%zd) = %@", sameQue.count, [sameQue componentsJoinedByString:@","]);
}

@end
