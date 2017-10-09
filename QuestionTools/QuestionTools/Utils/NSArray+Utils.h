//
//  NSArray+Utils.h
//  FFStory
//
//  Created by BaeCheung on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

// 返回符合条件的obj集合
- (NSArray *)filteredArrayUsingBlock:(BOOL(^)(id obj))block;
- (NSArray *)filteredArrayWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL(^)(id obj))block;
- (NSArray *)filteredArrayWithFailedObjects:(NSArray **)failedObjects usingBlock:(BOOL(^)(id obj))block;
- (NSArray *)filteredArrayWithOptions:(NSEnumerationOptions)opts failedObjects:(NSArray **)failedObjects usingBlock:(BOOL(^)(id obj))block;

// 修改obj，返回修改后的数组
- (NSArray *)mappedArrayUsingBlock:(id (^)(id obj))block;
- (NSArray *)mappedArrayWithOptions:(NSEnumerationOptions)opts usingBlock:(id (^)(id obj))block;

// 排序
- (NSArray *)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending;

// 返回通过测试的obj
- (id)objectPassingTest:(BOOL (^)(id obj, NSUInteger index, BOOL *stop))predicate;
- (id)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger index, BOOL *stop))predicate;

/**
 * 将数组 以group的数量 划分 ,返回第index 个子数组
 */
- (NSArray *)subArrayWithIndex:(NSInteger)index group:(NSInteger)group;

//
- (id)objectSafeAtIndex:(NSUInteger)index;

@end


@interface NSMutableArray (Utils)

// anObject maybe nil
- (void)addObjectSafe:(id)anObject;

// 筛选数据
- (void)filterUsingBlock:(BOOL(^)(id obj))block;

// 交换相应位置的对象
- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;

@end

// 合并数组，如果有相同的obj，仍会添加
extern NSArray *FFMergeArraies(NSArray *first, NSArray *second);

