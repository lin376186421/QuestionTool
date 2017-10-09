//
//  NSDictionary+Utils.h
//  FFStory
//
//  Created by BaeCheung on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

// 忽视大小写
- (NSDictionary *)caseInsensitiveDictionary;

// 从URL Query中提取字典
+ (NSDictionary *)dictionaryFromURLQuery:(NSString *)query;


// key对应的value（数据类型安全）
- (NSString *)stringForKey:(id)aKey;
- (NSArray *)arrayForKey:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey;
- (NSURL *)urlForKey:(id)aKey;

- (NSNumber *)numberForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (BOOL)boolForKey:(id)aKey;

// 返回符合条件的key-value对字典
- (NSDictionary *)filterEntriesUsingBlock:(BOOL (^)(id key, id value))block;
- (NSDictionary *)filterEntriesWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(id key, id value))block;
- (NSDictionary *)filterEntriesWithFailedEntries:(NSDictionary **)failedEntries usingBlock:(BOOL(^)(id key, id value))block;
- (NSDictionary *)filterEntriesWithOptions:(NSEnumerationOptions)opts failedEntries:(NSDictionary **)failedEntries usingBlock:(BOOL(^)(id key, id value))block;

// 修改key和value，返回修改后的字典
- (NSDictionary *)mappedValuesUsingBlock:(id (^)(id key, id value))block;
- (NSDictionary *)mappedValuesWithOptions:(NSEnumerationOptions)opts usingBlock:(id (^)(id key, id value))block;

// 返回通过测试的key
- (id)keyOfEntryPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate;
- (id)keyOfEntryWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate;

@end


@interface NSMutableDictionary (Utils)

// anObject maybe nil
- (void)setObjectSafe:(id)anObject forKey:(id <NSCopying>)aKey;

@end

// 合并字典，如果有相同的key，second中的value会把first的覆盖
extern NSDictionary *FFMergeDictionaries(NSDictionary *first, NSDictionary *second);


