//
//  KeyVipCategory.m
//  333
//
//  Created by cheng on 17/2/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KeyVipCategory.h"

@implementation KeyVipCategory

+ (id)itemFromDict:(NSDictionary *)dict forKey:(NSString *)key
{
    KeyVipCategory *item = [self itemFromDict:[dict objectForKey:key]];
    item.key = key;
    return item;
}

+ (id)itemFromDict:(NSDictionary *)dict
{
    if (dict==nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    KeyVipCategory *item = [KeyVipCategory new];
    item.course1 = [dict objectForKey:@"SubjectType1stTitles"];
    item.course4 = [dict objectForKey:@"SubjectType4thTitles"];
    item.subject1 = [KeyVipCategoryItem itemsFromArrayArray:[dict objectForKey:@"SubjectType1st"]];
    item.subject4 = [KeyVipCategoryItem itemsFromArrayArray:[dict objectForKey:@"SubjectType4th"]];
    return item;
}

@end

@implementation KeyVipCategoryItem

+ (id)itemFromDict:(NSDictionary *)dict {
    if (dict==nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    KeyVipCategoryItem *item = [KeyVipCategoryItem new];
    item.keyName = [dict objectForKey:@"keyName"];
    item.keyDesc = [dict objectForKey:@"keyDesc"];
    item.questionMark = [dict objectForKey:@"questionMark"];
    return item;
}

+ (NSArray *)itemsFromArray:(NSArray *)array {
    if (array == nil || ![array isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        if ((id)dict == [NSNull null]) {
            continue;
        }
        id item = [self itemFromDict:dict];
        if (item)
            [mArray addObject:item];
    }
    return mArray;
}

+ (NSArray *)itemsFromArrayArray:(NSArray *)array {
    if (array == nil || ![array isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSArray *arr in array) {
        if ((id)arr == [NSNull null]) {
            continue;
        }
        id item = [self itemsFromArray:arr];
        if (item)
            [mArray addObject:item];
    }
    return mArray;
}

@end

@implementation KeyVipCourse

+ (id)itemFromDict:(NSDictionary *)dict forKey:(NSString *)key
{
    KeyVipCourse *item = [self itemFromDict:[dict objectForKey:key]];
    item.key = key;
    return item;
}

+ (id)itemFromDict:(NSDictionary *)dict
{
    if (dict==nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    KeyVipCourse *item = [KeyVipCourse new];
    item.course1 = [dict objectForKey:@"SubjectType1st"];
    item.course4 = [dict objectForKey:@"SubjectType4th"];
    return item;
}


@end
