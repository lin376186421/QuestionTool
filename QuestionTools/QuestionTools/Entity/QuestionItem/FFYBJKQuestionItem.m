//
//  FFYBJKQuestionItem.m
//  333
//
//  Created by PageZhang on 16/7/6.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFYBJKQuestionItem.h"
#import "NSArray+Utils.h"

@implementation FFYBJKQuestionItem

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
        [version0 setObject:@"TEXT"    forKey:@"tm"];
        [version0 setObject:@"TEXT"    forKey:@"tp"];
        [version0 setObject:@"TEXT"    forKey:@"da"];
        [version0 setObject:@"INTEGER" forKey:@"tx"];
        [version0 setObject:@"TEXT"    forKey:@"fx"];
        
        [version0 setObject:@"TEXT"    forKey:@"TikuID"];
        [version0 setObject:@"TEXT"    forKey:@"DriveType"];
        [version0 setObject:@"INTEGER" forKey:@"EasyRank"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

- (void)setupConfig:(NSDictionary *)jsonDict {
    if ([self.TikuID isEqualToString:@"kmy"]) {
        self.course = 1;
    } else {
        self.course = 3;
    }
    
    self.type = self.tx - 1;
    
    if (self.tp.length) {
        self.category = 1;
        self.media_type = [self.tp hasSuffix:@"mp4"] ? 2 : 1;
    } else {
        self.category = 0;
        self.media_type = 0;
    }
    self.media = self.tp;
    
    if ([self.da isEqualToString:@"正确"]) {
        self.answer = @"A";
    } else if ([self.da isEqualToString:@"错误"]) {
        self.answer = @"B";
    } else {
        self.answer = self.da;
    }
    
    
    if ([self.DriveType isEqualToString:@"mtc"]) {
        self.cert_type = 8;
    } else {
        NSUInteger cert_type=0;
        if ([self.DriveType rangeOfString:@"xc"].location != NSNotFound) {
            cert_type += 1;
        }
        if ([self.DriveType rangeOfString:@"kc"].location != NSNotFound) {
            cert_type += 2;
        }
        if ([self.DriveType rangeOfString:@"hc"].location != NSNotFound) {
            cert_type += 4;
        }
        self.cert_type = cert_type;
    }
    
    NSArray *coms = [self.tm componentsSeparatedByString:@"<br/>"];
    if (coms.count == 1) {
        self.question = self.tm;
        self.option_a = @"正确";
        self.option_b = @"错误";
    } else {
        self.question = [coms objectSafeAtIndex:0];
        self.option_a = [coms objectSafeAtIndex:1];
        self.option_b = [coms objectSafeAtIndex:2];
        self.option_c = [coms objectSafeAtIndex:3];
        self.option_d = [coms objectSafeAtIndex:4];
    }
    
}

@end
