//
//  KuaiChuYiPei.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "XuanZeAndPanDuan.h"

@implementation XuanZeAndPanDuan

+ (void)deal
{
    NSLog(@"开始处理新增考题");
    
    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xuanzeti" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [string componentsSeparatedByString:@"\n\n"];
    NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array) {
        NSArray *arr = [string componentsSeparatedByString:@"\n"];
        if (arr.count == 6) {
            NSString *ques = arr[0];
            NSRange range1 = [ques rangeOfString:@")\t"];
            if (range1.length) {
                FFQuestionItem *item = [FFQuestionItem new];
                item.type = 1;
                item.question = [ques substringFromIndex:range1.location + range1.length];
                ques = arr[1];
                range1 = [ques rangeOfString:@".  "];
                if (range1.length) {
                    item.option_a = [ques substringFromIndex:range1.location + range1.length];
                }
                
                ques = arr[2];
                range1 = [ques rangeOfString:@".  "];
                if (range1.length) {
                    item.option_b = [ques substringFromIndex:range1.location + range1.length];
                }
                
                ques = arr[3];
                range1 = [ques rangeOfString:@".  "];
                if (range1.length) {
                    item.option_c = [ques substringFromIndex:range1.location + range1.length];
                }
                
                ques = arr[4];
                range1 = [ques rangeOfString:@".  "];
                if (range1.length) {
                    item.option_d = [ques substringFromIndex:range1.location + range1.length];
                }
                
                ques = arr[5];
                if ([ques rangeOfString:@"A"].length) {
                    item.answer = @"A";
                } else if ([ques rangeOfString:@"B"].length) {
                    item.answer = @"B";
                } else if ([ques rangeOfString:@"C"].length) {
                    item.answer = @"C";
                } else if ([ques rangeOfString:@"D"].length) {
                    item.answer = @"D";
                }
                if (item.option_a && item.option_b && item.option_c && item.option_d && item.answer) {
                    [questions addObject:item];
                } else {
                    NSLog(@"111111===## %@", string);
                }
            } else {
                NSLog(@"111===## %@", string);
            }
        } else {
            NSLog(@"1===## %@", string);
        }
    }
    NSLog(@"#####  =  %zd", questions.count);
    
    string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"panduanti2" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    array = [string componentsSeparatedByString:@"\n\n"];
    for (NSString *string in array) {
        NSArray *arr = [string componentsSeparatedByString:@"\n"];
        if (arr.count == 2) {
            NSString *ques = arr[0];
            NSRange range1 = [ques rangeOfString:@")\t"];
            if (range1.length) {
                FFQuestionItem *item = [FFQuestionItem new];
                item.question = [ques substringFromIndex:range1.location + range1.length];
                item.option_a = @"正确";
                item.option_b = @"错误";
                ques = arr[1];
                if ([ques rangeOfString:@"对"].length || [ques rangeOfString:@"正确"].length) {
                    item.answer = @"A";
                } else {
                    item.answer = @"B";
                }
                [questions addObject:item];
            } else {
                NSLog(@"222===## %@", string);
            }
        } else {
            NSLog(@"2===## %@", string);
        }
    }
    NSLog(@"#####  =  %zd", questions.count);
    
    string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"panduan" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    array = [string componentsSeparatedByString:@"\n\n"];
    for (NSString *string in array) {
        NSArray *arr = [string componentsSeparatedByString:@"\n"];
        if (arr.count >= 2) {
            NSString *ques = arr[0];
            FFQuestionItem *item = [FFQuestionItem new];
            item.question = ques;
            item.option_a = @"正确";
            item.option_b = @"错误";
            
            ques = arr[1];
            if ([ques rangeOfString:@"对"].length || [ques rangeOfString:@"正确"].length) {
                item.answer = @"A";
            } else {
                item.answer = @"B";
            }
            [questions addObject:item];
        } else {
            NSLog(@"3===## %@", string);
        }
    }
    
    NSLog(@"#####  =  %zd", questions.count);
    
    NSInteger i = 0;
    for (FFQuestionItem *item in questions) {
        item.id              = (int)i;
        item.course = 1;
        item.cert_type = 1;
        item.chapter = 101;
        item.city_id = @"377";
        i++;
    }
    
    writeDbWithFileName(questions, @"xinzeng");
}

@end
