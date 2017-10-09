//
//  FFDBObject.m
//  XiMi
//
//  Created by BaeCheung on 15/1/20.
//  Copyright (c) 2015年 BaeCheung. All rights reserved.
//

#import "FFDBObject.h"
#import "FFJSONHelper.h"
#import "NSDictionary+Utils.h"

static NSString *DBAutoIncrementPrimaryKey = @"_id";

// 数据安全
id DBSafeObject(id object) {
    if (object) {
        if ([object respondsToSelector:@selector(JSONData_ff)]) {
            return [object JSONData_ff];
        }
        return object;
    }
    return nil;
}
id DBSafeNullObject(id object) {
    return DBSafeObject(object) ?: [NSNull null];
}


// 系统保留字策略
@implementation FFRFJModel : RFJModel
+ (NSDictionary *)system_reserved_words {
    static NSDictionary *mapper = nil;
    if (mapper == nil) {
        mapper = @{@"description" : @"desc",
                   @"group"       : @"groups"};
    }
    return mapper;
}
+ (NSDictionary *)keywordReplacementStrategy:(NSDictionary *)jsonDict {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:jsonDict.count];
    [jsonDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self.system_reserved_words.allKeys containsObject:key]) {
            [result setObject:obj forKeyedSubscript:self.system_reserved_words[key]];
        } else {
            [result setObject:obj forKeyedSubscript:key];
        }
    }];
    return result;
}
// 初始化
- (id)initWithJsonDict:(NSDictionary *)jsonDict {
    NSDictionary *safeJsonDict = [self.class keywordReplacementStrategy:jsonDict];
    if (self = [super initWithJsonDict:safeJsonDict]) {
        [self setupConfig:jsonDict];
    }
    return self;
}
- (void)fillWithJsonDict:(NSDictionary *)jsonDict {
    NSDictionary *safeJsonDict = [self.class keywordReplacementStrategy:jsonDict];
    [super fillWithJsonDict:safeJsonDict];
}
- (void)setupConfig:(NSDictionary *)jsonDict {}
@end


@implementation FFDBObject

// basic
+ (NSString *)tableName {return nil;}
+ (FFOrderedDictionary *)versions {
    /* example: PRIMARY KEY、AUTOINCREMENT 不需要自己配置；TYPE NOT NULL DEFAULT ('value') 单独配置
     static FFOrderedDictionary *versions = nil;
     if (versions == nil) {
     FFOrderedDictionary *version0 = [FFOrderedDictionary new];
     [version0 setObject:@"TYPE" forKey:@"COLUMN1"];
     [version0 setObject:@"TYPE" forKey:@"COLUMN2"];
     
     FFOrderedDictionary *version1 = [FFOrderedDictionary new];
     [version0 setObject:@"TYPE" forKey:@"COLUMN3"];
     [version0 setObject:@"TYPE" forKey:@"COLUMN4"];
     
     versions = [FFOrderedDictionary new];
     [versions setObject:version0 forKey:@(0)];
     [versions setObject:version1 forKey:@(1)];
     }
     return versions;
     */
    return nil;
}

// basic
+ (BOOL)AUTOINCREMENT {return NO;}
+ (NSString *)primaryKey {return nil;}
+ (NSString *)uniqueIndex {return nil;}
+ (void)patch:(FMDatabase *)db version:(NSUInteger)version {
    /* example: 不需要break，逐条更新
    switch (version) {
        case 0: {}
        case 1: {}
        case 2: {}
        default: break;
     }
     */
};

// column
+ (FFOrderedDictionary *)createColumns {
    static NSMutableDictionary *classes = nil;
    if (classes == nil) {
        classes = [NSMutableDictionary dictionary];
    }
    NSString *class = NSStringFromClass(self.class);
    FFOrderedDictionary *columns = classes[class];
    if (columns == nil) {
        columns = [FFOrderedDictionary new];
        FFOrderedDictionary *versions = [self versions];
        [versions.allKeys enumerateObjectsUsingBlock:^(id version, NSUInteger idx, BOOL *stop) {
            FFOrderedDictionary *versionColumns = [versions objectForKey:version];
            [versionColumns.keyArray enumerateObjectsUsingBlock:^(id column, NSUInteger idx, BOOL *stop) {
                [columns setObject:[versionColumns objectForKey:column] forKey:column];
            }];
        }];
        // 配置主键
        NSString *primaryKey = [self primaryKey];
        if (primaryKey || [self AUTOINCREMENT]) {
            NSString *type;
            if ([self AUTOINCREMENT]) {
                type = @"INTEGER PRIMARY KEY AUTOINCREMENT";
            } else {
                type = [NSString stringWithFormat:@"%@ PRIMARY KEY", [columns objectForKey:primaryKey]];
            }
            [columns insertObject:type forKey:primaryKey ?: DBAutoIncrementPrimaryKey atIndex:0];
        }
        // 存储
        classes[class] = columns;
    }
    return columns;
}
+ (FFOrderedDictionary *)updateColumns:(NSUInteger)prev {
    if (prev < FFDB_VERSION) {
        FFOrderedDictionary *versions = [self versions];
        FFOrderedDictionary *columns = [FFOrderedDictionary new];
        [versions.keyArray enumerateObjectsUsingBlock:^(id version, NSUInteger idx, BOOL *stop) {
            if ([version integerValue] > prev) {
                FFOrderedDictionary *versionColumns = [versions objectForKey:version];
                [versionColumns.keyArray enumerateObjectsUsingBlock:^(id column, NSUInteger idx, BOOL *stop) {
                    [columns setObject:[versionColumns objectForKey:column] forKey:column];
                }];
            }
        }];
        return columns.count ? [columns copy] : nil;
    }
    return nil;
}

// convert
+ (NSArray *)allKeys {
    static NSMutableDictionary *classes = nil;
    if (classes == nil) {
        classes = [NSMutableDictionary dictionary];
    }
    NSString *class = NSStringFromClass(self.class);
    NSArray *allkeys = classes[class];
    if (allkeys == nil) {
        FFOrderedDictionary *columns = [self createColumns];
        NSMutableArray *keys = [columns.keyArray mutableCopy];
        if ([self AUTOINCREMENT]) {
            [keys removeObject:[self primaryKey] ?: DBAutoIncrementPrimaryKey];
        }
        allkeys = [keys copy];
        // 存储
        classes[class] = allkeys;
    }
    return allkeys;
}
+ (NSArray *)blobKeys {
    static NSMutableDictionary *classes = nil;
    if (classes == nil) {
        classes = [NSMutableDictionary dictionary];
    }
    NSString *class = NSStringFromClass(self.class);
    NSArray *allkeys = classes[class];
    if (allkeys == nil) {
        FFOrderedDictionary *columns = [self createColumns];
        NSMutableArray *keys = [NSMutableArray array];
        [columns.keyArray enumerateObjectsUsingBlock:^(id column, NSUInteger idx, BOOL *stop) {
            if ([[columns objectForKey:column] rangeOfString:@"BLOB" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [keys addObject:column];
            }
        }];
        allkeys = [keys copy];
        // 存储
        classes[class] = allkeys;
    }
    return allkeys;
}
- (NSString *)specifiedKey {
    __block NSString *key = nil;
    if ([self.class AUTOINCREMENT]) {
        key = [self.class uniqueIndex];
    } else {
        key = [self.class primaryKey];
    }
    // 如果不存在唯一条件的key，随便取一个有值的key
    if (key == nil) {
        NSArray *allKeys = [self.class allKeys];
        [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([self valueForKey:obj]) {
                key = obj;
                *stop = YES;
            }
        }];
    }
    return key;
}

- (NSArray *)allValues {
    NSArray *allKeys = [self.class allKeys];
    NSMutableArray *values = [NSMutableArray array];
    if ([self.class AUTOINCREMENT]) {
        [values addObject:[NSNull null]];
    }
    [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [values addObject:DBSafeNullObject([self valueForKey:obj])];
    }];
    return [values copy];
}
- (NSDictionary *)values:(NSArray *)columns {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [columns enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [values setObject:DBSafeNullObject([self valueForKey:obj]) forKey:obj];
    }];
    return [values copy];
}

#pragma mark - Init

// 把NSData转化为JSON对象
+ (NSDictionary *)normalizedResult:(FMResultSet *)resultSet {
    NSDictionary *result = [resultSet resultDictionary];
    NSArray *blobKeys = [self blobKeys];
    if (blobKeys.count) {
        result = [result filterEntriesUsingBlock:^BOOL(id key, id value) {
            return value != [NSNull null];
        }];
        result = [result mappedValuesUsingBlock:^id(id key, id value) {
            if ([blobKeys containsObject:key]) {
//MARK: - 驾考宝典扒数据逻辑 -
                if ([key isEqualToString:@"media_content"]) {
                    return value;
                }
                
                NSString *string = @"_jiakaobaodian.com_";
                const char *cBuffer = [string UTF8String];
                size_t len = strlen(cBuffer);
                
                size_t lenOut = [value length];
                char cOutBuf[lenOut];
                [value getBytes:cOutBuf length:lenOut];
                for (int i=0; i<lenOut; i++) {
                    cOutBuf[i] =  cOutBuf[i]^cBuffer[i%len];
                }
                
                NSData *data = [[NSData alloc] initWithBytes:cOutBuf length:lenOut];
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                return [value JSONObject_ff] ?: value;
            }
            return value;
        }];
    }
    return result;
}

// BLOB对象需要转换
- (instancetype)initWithResultSet:(FMResultSet *)resultSet {
    NSDictionary *safeJsonDict = [self.class normalizedResult:resultSet];
    if (self = [super initWithJsonDict:safeJsonDict]) {
    }
    return self;
}

+ (NSArray *)itemsFromResultSet:(FMResultSet *)rs
{
    if (!rs) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    while ([rs next]) {
        id item = [self itemFromResultSet:rs];
        if (item) {
            [result addObjectSafe:item];
        }
    }
    return result;
}

+ (instancetype)itemFromResultSet:(FMResultSet *)rs
{
    return nil;
}

@end
