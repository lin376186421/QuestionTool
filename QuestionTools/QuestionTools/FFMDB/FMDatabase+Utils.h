//
//  FMDatabase+Utils.h
//  XiMi
//
//  Created by BaeCheung on 15/1/5.
//  Copyright (c) 2015年 BaeCheung. All rights reserved.
//

#import "FFDBObject.h"

// 查找操作时，IN条件格式化内容
extern NSString *DB_IN_ConditionString(NSArray *values);


typedef NS_ENUM(NSInteger, DBValueType) {
    DBValueTypeMAX,
    DBValueTypeMIN,
    DBValueTypeAVG,
    DBValueTypeSUM
};

@interface FMDatabase (Utils)

// 插入数据
- (BOOL)insertObject:(FFDBObject *)object;
- (BOOL)insertObject:(FFDBObject *)object columns:(NSArray *)columns;
- (BOOL)insert:(NSString *)table withObject:(NSDictionary *)object;

// 更新数据
- (BOOL)updateObject:(FFDBObject *)object;
- (BOOL)updateObject:(FFDBObject *)object columns:(NSArray *)columns;
- (BOOL)update:(NSString *)table withCondition:(NSDictionary *)condition toObject:(NSDictionary *)object;

// 删除数据（只支持 = IN 两种查询条件）
- (BOOL)removeObject:(FFDBObject *)object;
- (BOOL)remove:(NSString *)table withCondition:(NSDictionary *)condition;


// 创建表
- (BOOL)create:(NSString *)table columns:(FFOrderedDictionary *)columns;
// 创建唯一索引
- (BOOL)create:(NSString *)table uniqueColumn:(NSString *)column;

// 插入字段（不支持删除及修改）{@"column" : @"type"}
- (BOOL)add:(NSString *)table columns:(FFOrderedDictionary *)columns;

// 删除表（不支持清空）
- (BOOL)drop:(NSString *)table;
// 删除唯一索引
- (BOOL)drop:(NSString *)table uniqueColumn:(NSString *)column;

// 重命名表
- (BOOL)rename:(NSString *)table to:(NSString *)name;


/*
 MAX、MIN、AVG、SUM
 RANDOM：返回一个伪随机整数
 COUNT：数据条数
 ABS：返回数值参数的绝对值
 UPPER、LOWER：把字符串转换为大小写字母
 LENGTH：返回字符串的长度
 */
- (NSUInteger)value:(NSString *)table forColumn:(NSString *)column type:(DBValueType)type;
- (NSUInteger)value:(NSString *)table forColumn:(NSString *)column withCondition:(NSDictionary *)condition type:(DBValueType)type;

// 数据条数
- (NSUInteger)count:(NSString *)table;
- (NSUInteger)count:(NSString *)table withCondition:(NSDictionary *)condition;

@end


/* TODO:
 1、关联查询
 test1 -> test2 (with c1 column)
 test2 -> test3 (with c2 column).
 
 SELECT *
 FROM test1 a
 LEFT OUTER JOIN test2 b ON b.c1=a.c1
 LEFT OUTER JOIN test3 c ON c.c2=b.c2
 
 2、消除所有重复的记录，并只获取唯一一次记录
 SELECT DISTINCT .. FROM ..
 
 3、查找条件：WHERE
 WHERE CONDITION-1 {AND|OR} CONDITION-2;
 WHERE column_name {<|=|>|<=|>=} 'val';
 WHERE column_name BETWEEN val-1 AND val-2;
 WHERE column_name LIKE { PATTERN };
 WHERE column_name IN (val-1, val-2,...val-N);
 WHERE column_name NOT IN (val-1, val-2,...val-N);
 
 4、排序条件：ORDER BY
 ASC
 DESC
 RANDOM()
 
 
 SELECT *
 FROM test1 a
 LEFT OUTER JOIN test2 b ON b.c1=a.c1 AND b.c2=a.c2
 WHERE a.c3=%zd AND a.c4 IN
 (
 SELECT DISTINCT c.c1
 FROM test3 c
 WHERE c.c2=%zd OR c.c3&%zd>0
 UNION
 SELECT DISTINCT d.c1
 FROM test4 d
 WHERE d.c2=%zd AND LENGTH(d.c3)>0
 )
 ORDER BY RANDOM()
 
 */






