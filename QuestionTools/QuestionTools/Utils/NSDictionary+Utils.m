//
//  NSDictionary+Utils.m
//  FFStory
//
//  Created by BaeCheung on 14/11/18.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <libkern/OSAtomic.h>
#import "NSDictionary+Utils.h"

static Boolean FFCaseInsensitiveEqualCallback(const void *a, const void *b) {
    id objA = (__bridge id)a, objB = (__bridge id)b;
    Boolean ret = FALSE;
    if ([objA isKindOfClass:NSString.class] && [objB isKindOfClass:NSString.class]) {
        ret = ([objA compare:objB options:NSCaseInsensitiveSearch|NSLiteralSearch] == NSOrderedSame);
    }else {
        ret = [objA isEqual:objB];
    }
    return ret;
}

static CFHashCode FFCaseInsensitiveHashCallback(const void *value) {
    id idValue = (__bridge id)value;
    CFHashCode ret = 0;
    if ([idValue isKindOfClass:NSString.class]) {
        ret = [[idValue lowercaseString] hash];
    }else {
        ret = [(NSObject *)idValue hash];
    }
    return ret;
}

@implementation NSDictionary (Utils)

+ (NSDictionary *)dictionaryFromURLQuery:(NSString *)query {
    if (query.length == 0) return nil;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *elements = [query componentsSeparatedByString:@"&"];
    
    for (NSString *element in elements) {
        NSArray *pair = [element componentsSeparatedByString:@"="];
        if (pair.count != 2) {
            continue;
        }
        
        NSString *key = [pair[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pair[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dictionary[key] = value;
    }
    return [dictionary copy];
}

- (NSDictionary *)caseInsensitiveDictionary {
    CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
    keyCallbacks.equal = FFCaseInsensitiveEqualCallback;
    keyCallbacks.hash  = FFCaseInsensitiveHashCallback;
    
    void *keys = NULL, *values = NULL;
    CFIndex count = CFDictionaryGetCount((CFDictionaryRef)self);
    if (count) {
        keys   = malloc(count * sizeof(void *));
        values = malloc(count * sizeof(void *));
        if (!keys || !values) {
            free(keys), free(values);
            return self;
        }
        CFDictionaryGetKeysAndValues((CFDictionaryRef)self, keys, values);
    }
    
    CFDictionaryRef caseInsensitiveDict = CFDictionaryCreate(kCFAllocatorDefault, keys, values, count, &keyCallbacks, &kCFTypeDictionaryValueCallBacks);
    
    free(keys);
    free(values);
    
    return CFBridgingRelease(caseInsensitiveDict);
}

#pragma mark - key-value

- (NSString *)stringForKey:(id)aKey {
    id object = self[aKey];
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object respondsToSelector:@selector(stringValue)]) {
        return [object stringValue];
    } else {
        return nil;
    }
}

- (NSArray *)arrayForKey:(id)aKey {
    id object = self[aKey];
    if ([object isKindOfClass:NSArray.class]) {
        return object;
    } else {
        return nil;
    }
}

- (NSDictionary *)dictionaryForKey:(id)aKey {
    id object = self[aKey];
    if ([object isKindOfClass:NSDictionary.class]) {
        return object;
    } else {
        return nil;
    }
}

- (NSURL *)urlForKey:(id)aKey {
    id object = self[aKey];
    if ([object isKindOfClass:NSURL.class]) {
        return object;
    }
    
    NSString *string = [self stringForKey:aKey];
    if (string) {
        return [NSURL URLWithString:string];
    } else {
        return nil;
    }
}

- (NSNumber *)numberForKey:(id)aKey {
    id object = self[aKey];
    if ([object isKindOfClass:NSNumber.class]) {
        return object;
    } else if ([object isKindOfClass:NSString.class]) {
        static NSNumberFormatter *formatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        });
        return [formatter numberFromString:object];
    } else {
        return nil;
    }
}
- (NSInteger)integerForKey:(id)aKey {
    return [[self numberForKey:aKey] integerValue];
}
- (BOOL)boolForKey:(id)aKey {
    NSString *stringValue = [self stringForKey:aKey].lowercaseString;
    if ([@[@"true", @"yes", @"1"] containsObject:stringValue]) {
        return YES;
    }
    return [[self numberForKey:aKey] boolValue];
}

#pragma mark - objects

- (NSDictionary *)filterEntriesUsingBlock:(BOOL (^)(id key, id value))block {
    return [self filterEntriesWithOptions:0 usingBlock:block];
}
- (NSDictionary *)filterEntriesWithOptions:(NSEnumerationOptions)opts usingBlock:(BOOL (^)(id key, id value))block {
    NSSet *matchingKeys = [self keysOfEntriesWithOptions:opts passingTest:^(id key, id value, BOOL *stop) {
        return block(key, value);
    }];
    
    NSArray *keys = [matchingKeys allObjects];
    NSArray *values = [self objectsForKeys:keys notFoundMarker:NSNull.null];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (NSDictionary *)filterEntriesWithFailedEntries:(NSDictionary **)failedEntries usingBlock:(BOOL(^)(id key, id value))block {
    return [self filterEntriesWithOptions:0 failedEntries:failedEntries usingBlock:block];
}
- (NSDictionary *)filterEntriesWithOptions:(NSEnumerationOptions)opts failedEntries:(NSDictionary **)failedEntries usingBlock:(BOOL(^)(id key, id value))block {
    NSUInteger originalCount = self.count;
    BOOL concurrent = (opts&NSEnumerationConcurrent);
    
    __unsafe_unretained volatile id *keys = (__unsafe_unretained id *)calloc(originalCount, sizeof(*keys));
    if (keys == NULL) return nil;
    
    __unsafe_unretained volatile id *values = (__unsafe_unretained id *)calloc(originalCount, sizeof(*values));
    if (values == NULL) {
        free((void *)keys);
        return nil;
    }
    
    volatile int64_t nextSuccessIndex = 0;
    volatile int64_t *nextSuccessIndexPtr = &nextSuccessIndex;
    
    volatile int64_t nextFailureIndex = originalCount - 1;
    volatile int64_t *nextFailureIndexPtr = &nextFailureIndex;
    
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id value, BOOL *stop) {
        BOOL result = block(key, value);
        
        int64_t index;
        
        // find the index to store into the arrays
        if (result) {
            int64_t indexPlusOne = OSAtomicIncrement64Barrier(nextSuccessIndexPtr);
            index = indexPlusOne - 1;
        }else {
            int64_t indexMinusOne = OSAtomicDecrement64Barrier(nextFailureIndexPtr);
            index = indexMinusOne + 1;
        }
        
        keys[index] = key;
        values[index] = value;
    }];
    
    if (concurrent) {
        // finish all assignments into the 'keys' and 'values' arrays
        OSMemoryBarrier();
    }
    
    NSUInteger successCount = (NSUInteger)nextSuccessIndex;
    NSUInteger failureCount = originalCount - 1 - (NSUInteger)nextFailureIndex;
    
    if (failedEntries) {
        size_t objectsOffset = (size_t)(nextFailureIndex + 1);
        
        *failedEntries = [NSDictionary dictionaryWithObjects:(__unsafe_unretained id *)(values + objectsOffset) forKeys:(__unsafe_unretained id *)(keys + objectsOffset) count:failureCount];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:(id *)values forKeys:(id *)keys count:successCount];
    free((void *)keys);
    free((void *)values);
    
    return dict;
}


- (NSDictionary *)mappedValuesUsingBlock:(id (^)(id key, id value))block {
    return [self mappedValuesWithOptions:0 usingBlock:block];
}
- (NSDictionary *)mappedValuesWithOptions:(NSEnumerationOptions)opts usingBlock:(id (^)(id key, id value))block {
    NSUInteger originalCount = self.count;
    BOOL concurrent = (opts & NSEnumerationConcurrent);
    
    // we don't need to retain the individual keys, since the original dictionary is already doing so, and the keys themselves won't change
    __unsafe_unretained volatile id *keys = (__unsafe_unretained id *)calloc(originalCount, sizeof(*keys));
    if (keys == NULL) return nil;
    
    __strong volatile id *values = (__strong id *)calloc(originalCount, sizeof(*values));
    if (values == NULL) {
        free((void *)keys);
        return nil;
    }
    
    // declare these variables way up here so that they can be used in the
    // @onExit block below (avoiding unnecessary iteration)
    volatile int64_t nextIndex = 0;
    volatile int64_t *nextIndexPtr = &nextIndex;
    
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id value, BOOL *stop) {
        id newValue = block(key, value);
        
        // don't increment the index, go on to the next object
        if (newValue == nil) return;
        
        // find the index to store into the array -- 'nextIndex' is updated to
        // reflect the total number of elements
        int64_t indexPlusOne = OSAtomicIncrement64Barrier(nextIndexPtr);
        
        keys[indexPlusOne - 1] = key;
        values[indexPlusOne - 1] = newValue;
    }];
    
    // finish all assignments into the 'keys' and 'values' arrays
    if (concurrent) OSMemoryBarrier();
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:(id *)values forKeys:(id *)keys count:(NSUInteger)nextIndex];
    
    free((void *)keys);
    // nil out everything in the 'values' array to make sure ARC releases everything appropriately
    NSUInteger actualCount = (NSUInteger)*nextIndexPtr;
    for (NSUInteger i = 0; i < actualCount; ++i) values[i] = nil;
    free((void *)values);
    
    return dict;
}

- (id)keyOfEntryPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    return [self keyOfEntryWithOptions:0 passingTest:predicate];
}
- (id)keyOfEntryWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    BOOL concurrent = (opts&NSEnumerationConcurrent);
    
    void *volatile match = NULL;
    void *volatile *matchPtr = &match;
    
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id obj, BOOL *stop) {
        BOOL passed = predicate(key, obj, stop);
        if (!passed) return;
        
        if (concurrent) {
            // we don't use a barrier because it doesn't really matter if we overwrite a previous value, since we can match any object from the set
            OSAtomicCompareAndSwapPtr(*matchPtr, (__bridge void *)key, matchPtr);
        }else {
            *matchPtr = (__bridge void *)key;
        }
    }];
    
    // make sure that any compare-and-swaps complete
    if (concurrent) OSMemoryBarrier();
    
    // call through -self to remove a bogus analyzer warning about returning a stack-local object (we're not)
    return [(__bridge id)match self];
}

@end


@implementation NSMutableDictionary (Utils)

- (void)setObjectSafe:(id)anObject forKey:(id <NSCopying>)aKey {
    if (anObject)
        [self setObject:anObject forKey:aKey];
}

@end


NSDictionary *FFMergeDictionaries(NSDictionary *first, NSDictionary *second) {
    if (first && second.count == 0) return [first copy];  // Fast Path.
    if (second && first.count == 0) return [second copy]; // Fast Path.
    
    NSMutableDictionary *merged = [NSMutableDictionary dictionaryWithDictionary:first];
    [merged addEntriesFromDictionary:second];
    return [merged copy];
}


