//
//  FFOrderedDictionary.m
//  FFStory
//
//  Created by BaeCheung on 14/11/17.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import "FFOrderedDictionary.h"

static NSString *TSDescriptionForObject(NSObject *object, id locale, NSUInteger indent) {
    NSString *objectString;
    if ([object isKindOfClass:NSString.class]) {
        objectString = (NSString *)object;
    }
    else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
        objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
    }
    else if ([object respondsToSelector:@selector(descriptionWithLocale:)]) {
        objectString = [(NSSet *)object descriptionWithLocale:locale];
    }
    else {
        objectString = [object description];
    }
    return objectString;
}

@implementation FFOrderedDictionary {
    NSMutableArray *_keyArray;
    NSMutableDictionary *_dictionary;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:0];
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}
- (id)initWithCapacity:(NSUInteger)capacity {
    if ((self = [super init])) {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:capacity];
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    }
    return self;
}
- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    if ((self = [self initWithCapacity:objects.count])) {
        _keyArray = [keys mutableCopy];
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            _dictionary[keys[idx]] = obj;
        }];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSCopying

- (id)copy {
    return [self mutableCopy];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableDictionary

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!_dictionary[aKey]) {
        [_keyArray addObject:aKey];
    }
    _dictionary[aKey] = anObject;
}

- (void)removeObjectForKey:(id)aKey {
    [_keyArray removeObject:aKey];
    [_dictionary removeObjectForKey:aKey];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    [_keyArray removeObjectsInArray:keyArray];
    [_dictionary removeObjectsForKeys:keyArray];
}

- (void)removeAllObjects {
    [_keyArray removeAllObjects];
    [_dictionary removeAllObjects];
}

- (NSUInteger)count {
    return _dictionary.count;
}

- (id)objectForKey:(id)aKey {
    return _dictionary[aKey];
}

- (NSEnumerator *)keyEnumerator {
    return [_keyArray objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator {
    return [_keyArray reverseObjectEnumerator];
}

- (NSArray *)allKeys {
    return [_keyArray copy];
}

- (NSArray *)allValues {
    return _dictionary.allValues;
}

#pragma mark - additional

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex {
    if (_dictionary[aKey]) {
        [self removeObjectForKey:aKey];
    }
    [_keyArray insertObject:aKey atIndex:anIndex];
    _dictionary[aKey] = anObject;
}

- (NSUInteger)indexForKey:(id)aKey {
    return [_keyArray indexOfObject:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex {
    return _keyArray[anIndex];
}

- (id)objectAtIndex:(NSUInteger)anIndex {
    return _dictionary[[self keyAtIndex:anIndex]];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *indentString = [NSMutableString string];
    NSUInteger i, count = level;
    for (i = 0; i < count; i++) {
        [indentString appendFormat:@"    "];
    }
    
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@{\n", indentString];
    for (NSObject *key in self) {
        [description appendFormat:@"%@    %@ = %@;\n",
         indentString,
         TSDescriptionForObject(key, locale, level),
         TSDescriptionForObject(self[key], locale, level)];
    }
    [description appendFormat:@"%@}\n", indentString];
    return description;
}

@end
