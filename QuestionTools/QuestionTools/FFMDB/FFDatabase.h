//
//  FFDatabase.h
//  XiMi
//
//  Created by BaeCheung on 15/1/11.
//  Copyright (c) 2015年 BaeCheung. All rights reserved.
//

#import "FMDatabase+Utils.h"

@interface FFDatabase : NSObject

// 数据类
+ (NSArray *)allDatabaseClasses;

// 初始化
- (instancetype)initWithPath:(NSString *)path
              supportClasses:(NSArray *)classes;

// 直接操作数据库，不需要open close
- (void)excuteWithBlock:(void (^)(FMDatabase *db))block;
// 批量处理才使用事务，查询或对少量数据的操作使用上面方法
- (void)excuteTransactionWithBlock:(void (^)(FMDatabase *db))block;

@end
