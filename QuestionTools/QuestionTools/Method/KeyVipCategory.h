//
//  KeyVipCategory.h
//  333
//
//  Created by cheng on 17/2/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyVipCategory : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSArray *course1;
@property (nonatomic, strong) NSArray *course4;
@property (nonatomic, strong) NSArray *subject1;
@property (nonatomic, strong) NSArray *subject4;

+ (id)itemFromDict:(NSDictionary *)dict forKey:(NSString *)key;

@end


@interface KeyVipCategoryItem : NSObject

@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *keyDesc;
@property (nonatomic, strong) NSString *questionMark;

+ (NSArray *)itemsFromArray:(NSArray *)array;
+ (NSArray *)itemsFromArrayArray:(NSArray *)array;

@end

@interface KeyVipCourse : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSArray *course1;
@property (nonatomic, strong) NSArray *course4;

+ (id)itemFromDict:(NSDictionary *)dict forKey:(NSString *)key;

@end


