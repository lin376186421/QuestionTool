//
//  FFCXTQuestionItem.m
//  333
//
//  Created by PageZhang on 16/7/1.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFCXTQuestionItem.h"

@implementation FFCXTQuestionItem

+ (BOOL)AUTOINCREMENT {
    return YES;
}
+ (NSString *)tableName {
    return @"t_question";
}
// 仅用于对照数据关系，不参与使用
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER" forKey:@"project_id"];
        [version0 setObject:@"TEXT" forKey:@"project_name"];
        
        [version0 setObject:@"TEXT" forKey:@"course_id"];
        [version0 setObject:@"TEXT" forKey:@"course_list"];
        
        [version0 setObject:@"INTEGER" forKey:@"exam_id"];
        [version0 setObject:@"TEXT" forKey:@"exam_title"];
        [version0 setObject:@"TEXT" forKey:@"exam_pic"];
        [version0 setObject:@"TEXT" forKey:@"exam_type"];
        
        [version0 setObject:@"TEXT" forKey:@"answer"];
        [version0 setObject:@"TEXT" forKey:@"options"];
        [version0 setObject:@"INTEGER" forKey:@"answer_count"];
        [version0 setObject:@"INTEGER" forKey:@"option_count"];
        
        [version0 setObject:@"TEXT"    forKey:@"analytical"];
        [version0 setObject:@"INTEGER" forKey:@"difficulty"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

@end
