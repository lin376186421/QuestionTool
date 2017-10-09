//
//  FFDBObject.h
//  XiMi
//
//  Created by BaeCheung on 15/1/20.
//  Copyright (c) 2015年 BaeCheung. All rights reserved.
//

#import "FMDB.h"
#import "RFJModel.h"
#import "FFOrderedDictionary.h"
//#import <UIKit/UIKit.h>

#define FFDB_VERSION     0

@interface FFRFJModel : RFJModel
- (void)setupConfig:(NSDictionary *)jsonDict; // 初始化时会触发
@end


@protocol FFDBObjectProtocal <NSObject>

+ (NSString *)tableName; // 表名
+ (FFOrderedDictionary *)versions; // 按version归类

@optional

+ (BOOL)AUTOINCREMENT; // 自增长（如果没设置主键，默认为_id）
+ (NSString *)primaryKey; // 主键
+ (NSString *)uniqueIndex; // 唯一索引

// 进行一些额外的操作，比如创建时候默认插入几条数据
+ (void)patch:(FMDatabase *)db version:(NSUInteger)version;

@end

@interface FFDBObject : FFRFJModel <FFDBObjectProtocal>

// Columns
+ (FFOrderedDictionary *)createColumns; // versions包含的全部columns
+ (FFOrderedDictionary *)updateColumns:(NSUInteger)version; // 更新表

// Keys
+ (NSArray *)allKeys;
+ (NSArray *)blobKeys;
- (NSString *)specifiedKey;
// Values
- (NSArray *)allValues;
- (NSDictionary *)values:(NSArray *)columns;

// 通过FMResultSet对象直接生成DBObject
+ (NSDictionary *)normalizedResult:(FMResultSet *)resultSet;
- (instancetype)initWithResultSet:(FMResultSet *)resultSet;

+ (instancetype)itemFromResultSet:(FMResultSet *)rs;
+ (NSArray *)itemsFromResultSet:(FMResultSet *)rs;

// VERSION:0
// ....Propertys
// VERSION:1
// ....Propertys
// VERSION:2
// ....Propertys

@end
