//
//  FFDatabase.m
//  XiMi
//
//  Created by BaeCheung on 15/1/11.
//  Copyright (c) 2015年 BaeCheung. All rights reserved.
//

#import "FFDatabase.h"
#import "FFDBObject.h"
#import <objc/runtime.h>

@interface FFDatabase ()
// FMDatabase is created with a path to a SQLite database file
//@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@end

@implementation FFDatabase

+ (NSArray *)allDatabaseClasses {
    static NSArray *allClasses = nil;
    if (allClasses == nil) {
        int numberOfClasses = objc_getClassList(NULL, 0);
        Class *classes = (Class *)malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);
        
        // 取出所有继承自FFDBObject的类
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < numberOfClasses; i++) {
            Class candidateClass = classes[i];
            if (class_getSuperclass(candidateClass) == [FFDBObject class]) {
                [array addObject:candidateClass];
            }
        }
        allClasses = [array copy];
        
        free(classes);
    }
    return allClasses;
}

- (instancetype)initWithPath:(NSString *)path
              supportClasses:(NSArray *)classes {
    if (self = [super init]) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:path.stringByDeletingLastPathComponent]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //        _db = [FMDatabase databaseWithPath:path];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        // 检查更新数据库
        [self excuteWithBlock:^(FMDatabase *db) {
            // 当前版本号
            uint32_t userVersion = [db userVersion];
            // 遍历所有类
            [classes enumerateObjectsUsingBlock:^(Class class, NSUInteger idx, BOOL *stop) {
                NSString *table = [class tableName];
                if (![db tableExists:table]) {
                    // 创建表
                    [db create:table columns:[class createColumns]];
                    // 创建唯一索引
                    NSString *column = [class uniqueIndex];
                    if (column) {
                        [db create:table uniqueColumn:column];
                    }
                } else {
                    // 更新表
                    FFOrderedDictionary *columns = [class updateColumns:userVersion];
                    if (columns.count) {
                        [db add:table columns:columns];
                    }
                }
                // 额外操作
                if (userVersion < FFDB_VERSION) {
                    [class patch:db version:userVersion];
                }
            }];
            // 配置新版本号
            [db setUserVersion:FFDB_VERSION];
        }];
    }
    return self;
}

- (void)excuteWithBlock:(void (^)(FMDatabase *db))block {
    //    if ([_db open]) {
    //        block(_db);
    //        [_db close];
    //    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        block(db);
    }];
}
- (void)excuteTransactionWithBlock:(void (^)(FMDatabase *db))block {
    //    if ([_db open]) {
    //        [_db beginTransaction];
    //        BOOL isRollBack = NO;
    //        @try {
    //            block(_db);
    //        }
    //        @catch (NSException *exception) {
    //            isRollBack = YES;
    //            [_db rollback];
    //            NSLog(@"transaction with exception");
    //        }
    //        @finally {
    //            if (!isRollBack) {
    //                [_db commit];
    //            }
    //        }
    //        [_db close];
    //    }
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            block(db);
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
    }];
}

@end
