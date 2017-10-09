//
//  FMDatabase+Utils.m
//  XiMi
//
//  Created by BaeCheung on 15/1/5.
//  Copyright (c) 2015年 BaeCheung. All rights reserved.
//

#import "FMDatabase+Utils.h"
#import "NSArray+Utils.h"

NSString *DB_IN_ConditionString(NSArray *values) {
    NSArray *objects = [values mappedArrayUsingBlock:^id(id obj) {
        return [NSString stringWithFormat:@"'%@'",obj];
    }];
    return [NSString stringWithFormat:@"(%@)", [objects componentsJoinedByString:@","]];
}

NSString *DB_Values_ConditionString(NSString *value, NSUInteger count) {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:count];
    while (count--) {
        [objects addObject:value];
    }
    return [NSString stringWithFormat:@"(%@)", [objects componentsJoinedByString:@","]];
}

@implementation FMDatabase (Utils)

#pragma mark - 数据操作

// 插入数据：REPLACE INTO的逻辑是先做删除、然后插入
- (BOOL)insertObject:(FFDBObject *)object
{
    if (object == nil)
        return YES;
    
    NSArray *values = [object allValues];
    NSString *valueString = DB_Values_ConditionString(@"?", values.count);
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ VALUES %@", [object.class tableName], valueString];
    return [self executeUpdate:sql
          withArgumentsInArray:values];
}
- (BOOL)insertObject:(FFDBObject *)object
             columns:(NSArray *)columns
{
    return [self insert:[object.class tableName]
             withObject:[object values:columns]];
}
- (BOOL)insert:(NSString *)table
    withObject:(NSDictionary *)object
{
    if (object.count == 0)
        return YES;
    
    NSString *keyString = [object.allKeys componentsJoinedByString:@","];
    NSString *valueString = DB_Values_ConditionString(@"?", object.count);
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) VALUES %@", table, keyString, valueString];
    return [self executeUpdate:sql
          withArgumentsInArray:object.allValues];
}

// 更新数据：防止AUTOINCREMENT表的主键值变动
- (BOOL)updateObject:(FFDBObject *)object
{
    if ([object.class AUTOINCREMENT]) {
        return [self updateObject:object
                          columns:[object.class allKeys]];
    } else {
        return [self insertObject:object];
    }
}
- (BOOL)updateObject:(FFDBObject *)object
             columns:(NSArray *)columns
{
    if (columns.count == 0) {
        columns = [object.class allKeys];
    }
    
    NSString *key = [object specifiedKey];
    if ([columns containsObject:key]) {
        columns = [columns filteredArrayUsingBlock:^BOOL(id obj) {
            return ![obj isEqualToString:key];
        }];
    }
    return [self update:[object.class tableName]
          withCondition:@{key : [object valueForKey:key]}
               toObject:[object values:columns]];
}
- (BOOL)update:(NSString *)table
 withCondition:(NSDictionary *)condition
      toObject:(NSDictionary *)object
{
    if (object.count == 0)
        return YES;
    
    NSArray *allKeys = object.allKeys;
    allKeys = [allKeys mappedArrayUsingBlock:^id(id obj) {
        return [NSString stringWithFormat:@"%@=?", obj];
    }];
    NSString *updateString = [allKeys componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@", table, updateString];
    return [self executeSQL:sql
              withCondition:condition
                  arguments:[object.allValues mutableCopy]];
}

// 删除数据
- (BOOL)removeObject:(FFDBObject *)object
{
    NSString *key = [object specifiedKey];
    return [self remove:[object.class tableName]
          withCondition:@{key : [object valueForKey:key]}];
}
- (BOOL)remove:(NSString *)table
 withCondition:(NSDictionary *)condition
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", table];
    return [self executeSQL:sql
              withCondition:condition
                  arguments:nil];
}

// 组装查询条件
- (BOOL)executeSQL:(NSString *)sql
     withCondition:(NSDictionary *)condition
         arguments:(NSMutableArray *)arguments
{
    // 确保有筛选条件才进入
    if (condition.count) {
        // 如果不存在，初始化
        if (!arguments) {
            arguments = [NSMutableArray array];
        }
        // 格式化参数
        NSArray *allKeys = condition.allKeys;
        allKeys = [allKeys mappedArrayUsingBlock:^id(id obj) {
            // 跳过非法字段
            if ([obj length] == 0)
                return @"";
            
            id value = condition[obj];
            if ([value isKindOfClass:[NSArray class]]) {
                // 如果数组里没有元素，忽略这个条件
                if ([value count]) {
                    [arguments addObjectsFromArray:value];
                    
                    NSString *valuesString = DB_Values_ConditionString(@"?", [value count]);
                    return [NSString stringWithFormat:@"%@ IN %@", obj, valuesString];
                }
                return @"";
            } else {
                [arguments addObject:value];
                return [NSString stringWithFormat:@"%@=?", obj];
            }
        }];
        // 筛选非法字段
        allKeys = [allKeys filteredArrayUsingBlock:^BOOL(id obj) {
            return [obj length] > 0;
        }];
        if (allKeys.count) {
            NSString *conditionString = [allKeys componentsJoinedByString:@" AND "];
            sql = [sql stringByAppendingFormat:@" WHERE %@", conditionString];
        }
    }
    
    // 执行sql
    if (arguments.count) {
        return [self executeUpdate:sql withArgumentsInArray:arguments];
    } else {
        return [self executeUpdate:sql];
    }
}

#pragma mark - 表操作

// 创建表
- (BOOL)create:(NSString *)table columns:(FFOrderedDictionary *)columns {
    NSMutableArray *parameters = [NSMutableArray array];
    [columns.keyArray enumerateObjectsUsingBlock:^(id column, NSUInteger idx, BOOL *stop) {
        [parameters addObject:[NSString stringWithFormat:@"%@ %@", column, [columns objectForKey:column]]];
    }];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", table, [parameters componentsJoinedByString:@", "]];
    return [self executeUpdate:sql];
}

// 创建唯一索引
- (BOOL)create:(NSString *)table uniqueColumn:(NSString *)column {
    NSString *uniqueIndex =[NSString stringWithFormat:@"unique_%@_%@", table, column];
    NSString *sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX %@ ON %@ (%@)", uniqueIndex, table, column];
    return [self executeUpdate:sql];
}

// 插入字段
- (BOOL)add:(NSString *)table columns:(FFOrderedDictionary *)columns {
    __block BOOL success = YES;
    [columns.keyArray enumerateObjectsUsingBlock:^(id column, NSUInteger idx, BOOL *stop) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", table, column, [columns objectForKey:column]];
        if (![self executeUpdate:sql]) {
            success = NO;
        }
    }];
    return success;
}

// 删除表
- (BOOL)drop:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", table];
    return [self executeUpdate:sql];
}

// 删除唯一索引
- (BOOL)drop:(NSString *)table uniqueColumn:(NSString *)column {
    NSString *uniqueIndex =[NSString stringWithFormat:@"unique_%@_%@", table, column];
    NSString *sql = [NSString stringWithFormat:@"DROP INDEX %@", uniqueIndex];
    return [self executeUpdate:sql];
}

// 重命名表
- (BOOL)rename:(NSString *)table to:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", table, name];
    return [self executeUpdate:sql];
}

#pragma mark - Helper

// 返回特定数值
- (NSUInteger)value:(NSString *)table forColumn:(NSString *)column type:(DBValueType)type {
    return [self value:table forColumn:column withCondition:nil type:type];
}
- (NSUInteger)value:(NSString *)table forColumn:(NSString *)column withCondition:(NSDictionary *)condition type:(DBValueType)type {
    NSString *sql;
    switch (type) {
        case DBValueTypeMAX: sql = [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@", column, table]; break;
        case DBValueTypeMIN: sql = [NSString stringWithFormat:@"SELECT MIN(%@) FROM %@", column, table]; break;
        case DBValueTypeAVG: sql = [NSString stringWithFormat:@"SELECT AVG(%@) FROM %@", column, table]; break;
        case DBValueTypeSUM: sql = [NSString stringWithFormat:@"SELECT SUM(%@) FROM %@", column, table]; break;
        default: break;
    }
    return [self intForQuery:SQLStringByAppendingCondition(sql, condition)];
}

// 数据条数
- (NSUInteger)count:(NSString *)table {
    return [self count:table withCondition:nil];
}
- (NSUInteger)count:(NSString *)table withCondition:(NSDictionary *)condition {
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", table];
    return [self intForQuery:SQLStringByAppendingCondition(sql, condition)];
}

// 增加请求条件
NSString *SQLStringByAppendingCondition(NSString *sql, NSDictionary *condition) {
    if (condition.count == 0) {
        return sql;
    } else {
        NSMutableArray *parameters = [NSMutableArray array];
        [condition enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [parameters addObject:[NSString stringWithFormat:@"%@='%@'", key, obj]];
        }];
        NSString *conditionString = [parameters componentsJoinedByString:@" AND "];
        return [sql stringByAppendingFormat:@" WHERE %@", conditionString];
    }
}

@end

