//
//  FFCXTCourseItem.m
//  333
//
//  Created by PageZhang on 16/7/1.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFCXTCourseItem.h"

@implementation FFCXTCourseItem

+ (BOOL)AUTOINCREMENT {
    return YES;
}
+ (NSString *)tableName {
    return @"t_course";
}
// 仅用于对照数据关系，不参与使用
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER" forKey:@"course_id"];
        [version0 setObject:@"TEXT" forKey:@"course_name"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

@end