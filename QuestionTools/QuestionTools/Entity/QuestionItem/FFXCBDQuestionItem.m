//
//  FFXCBDQuestionItem.m
//  333
//
//  Created by PageZhang on 16/7/7.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFXCBDQuestionItem.h"

@implementation FFXCBDQuestionItem

+ (BOOL)AUTOINCREMENT {
    return YES;
}
+ (NSString *)tableName {
    return @"app_exam_base";
}
// 仅用于对照数据关系，不参与使用
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER" forKey:@"subject_id"];
        [version0 setObject:@"INTEGER" forKey:@"question_type_id"];
        [version0 setObject:@"INTEGER" forKey:@"content_type_id"];
        [version0 setObject:@"INTEGER" forKey:@"exam_driver_type_id"];
        
        [version0 setObject:@"TEXT" forKey:@"content"];
        [version0 setObject:@"TEXT" forKey:@"media"];
        [version0 setObject:@"TEXT" forKey:@"right_answers"];
        [version0 setObject:@"TEXT" forKey:@"explain"];
        
        [version0 setObject:@"TEXT" forKey:@"option1"];
        [version0 setObject:@"TEXT" forKey:@"option2"];
        [version0 setObject:@"TEXT" forKey:@"option3"];
        [version0 setObject:@"TEXT" forKey:@"option4"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

- (void)setupConfig:(NSDictionary *)jsonDict {
    if (self.subject_id == 1) {
        self.course = 1;
    } else {
        self.course = 3;
    }
    
    if (self.content_type_id==1 || self.content_type_id==3) {
        self.category = 0;
        self.media_type = 0;
    } else if (self.content_type_id==2 || self.content_type_id==4) {
        self.category = 1;
        self.media_type = 1;
    } else if (self.content_type_id==5) {
        self.category = 1;
        self.media_type = 2;
    }
    
    if (self.question_type_id==1 || self.question_type_id==3) {
        self.type = 0;
    } else if (self.question_type_id==2 || self.question_type_id==4) {
        self.type = 1;
    } else if (self.question_type_id==5) {
        self.type = 2;
    }
    
    self.answer = [[[[self.right_answers stringByReplacingOccurrencesOfString:@"1" withString:@"A"]
                                         stringByReplacingOccurrencesOfString:@"2" withString:@"B"]
                                         stringByReplacingOccurrencesOfString:@"3" withString:@"C"]
                                         stringByReplacingOccurrencesOfString:@"4" withString:@"D"];
}

@end
