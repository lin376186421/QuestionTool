//
//  FFJKCRQuestionItem.m
//  333
//
//  Created by PageZhang on 16/7/12.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFJKCRQuestionItem.h"

@implementation FFJKCRQuestionItem

+ (BOOL)AUTOINCREMENT {
    return YES;
}
+ (NSString *)tableName {
    return @"web_note";
}
// 仅用于对照数据关系，不参与使用
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER" forKey:@"question_type"];
        [version0 setObject:@"INTEGER" forKey:@"kemu"];
        [version0 setObject:@"TEXT"    forKey:@"license_type"];
        [version0 setObject:@"INTEGER" forKey:@"chapter_id"];
        
        [version0 setObject:@"TEXT"    forKey:@"question"];
        [version0 setObject:@"TEXT"    forKey:@"true_answer"];
        [version0 setObject:@"TEXT"    forKey:@"answer_1"];
        [version0 setObject:@"TEXT"    forKey:@"answer_2"];
        [version0 setObject:@"TEXT"    forKey:@"answer_3"];
        [version0 setObject:@"TEXT"    forKey:@"answer_4"];
        [version0 setObject:@"TEXT"    forKey:@"answer_5"];
        [version0 setObject:@"TEXT"    forKey:@"answer_6"];
        [version0 setObject:@"TEXT"    forKey:@"answer_7"];
        [version0 setObject:@"TEXT"    forKey:@"image"];
        [version0 setObject:@"TEXT"    forKey:@"video"];
        [version0 setObject:@"TEXT"    forKey:@"explain"];
        [version0 setObject:@"INTEGER" forKey:@"diff_degree"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

- (void)setupConfig:(NSDictionary *)jsonDict {
    if (self.kemu == 1) {
        self.course = 1;
    } else {
        self.course = 3;
    }
    
    if (self.image.length) {
        self.media = self.image;
        self.category = 1;
        self.media_type = [self.image hasSuffix:@"gif"] ? 2 : 1;
    } else if (self.video.length) {
        self.media = self.video;
        self.category = 1;
        self.media_type = 2;
    } else {
        self.category = 0;
        self.media_type = 0;
    }
    
    self.answer = [[[[self.true_answer stringByReplacingOccurrencesOfString:@"1" withString:@"A"]
                     stringByReplacingOccurrencesOfString:@"2" withString:@"B"]
                    stringByReplacingOccurrencesOfString:@"3" withString:@"C"]
                   stringByReplacingOccurrencesOfString:@"4" withString:@"D"];
    
    self.type = self.question_type - 1;
    
    if ([self.license_type isEqualToString:@"DEF"]) {
        self.cert_type = 8;
    } else if ([self.license_type isEqualToString:@"D"]) {
        self.cert_type = 16;
    } else if ([self.license_type isEqualToString:@"ZB"]) {
        self.cert_type = 32;
    } else if ([self.license_type isEqualToString:@"ZABCDJ"]) {
        self.cert_type = 64;
    } else if ([self.license_type isEqualToString:@"ZA"]) {
        self.cert_type = 128;
    } else if ([self.license_type isEqualToString:@"ZC"]) {
        self.cert_type = 256;
    } else {
        NSUInteger cert_type=0;
        if ([self.license_type rangeOfString:@"C1"].location != NSNotFound ||
            [self.license_type rangeOfString:@"C2"].location != NSNotFound ||
            [self.license_type rangeOfString:@"C3"].location != NSNotFound) {
            cert_type += 1;
        }
        if ([self.license_type rangeOfString:@"A1"].location != NSNotFound ||
            [self.license_type rangeOfString:@"A3"].location != NSNotFound ||
            [self.license_type rangeOfString:@"B1"].location != NSNotFound) {
            cert_type += 2;
        }
        if ([self.license_type rangeOfString:@"A2"].location != NSNotFound ||
            [self.license_type rangeOfString:@"B2"].location != NSNotFound) {
            cert_type += 4;
        }
        self.cert_type = cert_type;
    }
}

@end
