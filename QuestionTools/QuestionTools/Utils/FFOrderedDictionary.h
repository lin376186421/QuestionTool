//
//  FFOrderedDictionary.h
//  FFStory
//
//  Created by BaeCheung on 14/11/17.
//  Copyright (c) 2014年 FF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFOrderedDictionary : NSMutableDictionary

/// Internal array for ordering. Only move, do not add/remove items here,
/// or the dictionary will get into an inconsistent state.
/// Can be used for sorting.
@property (nonatomic, strong, readonly) NSMutableArray *keyArray;

/// Insert key for object at index.
- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;

/// Get index for key
- (NSUInteger)indexForKey:(id)aKey;

/// Get key at index.
- (id)keyAtIndex:(NSUInteger)anIndex;

/// Get object at index.
- (id)objectAtIndex:(NSUInteger)anIndex;

/// Reverse object enumerator.
- (NSEnumerator *)reverseKeyEnumerator;

@end
