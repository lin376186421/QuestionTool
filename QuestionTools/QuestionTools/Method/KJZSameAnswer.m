//
//  KJZSameQuestion.m
//  333
//
//  Created by cheng on 17/5/16.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZSameAnswer.h"
#import "KJZ_DB.h"

@implementation KJZSameAnswer

+ (void)deal
{
    KJZ_DB *kjz = [KJZ_DB new];
    
    for (int course = 1; course < 4; course += 2) {
        kjz.course = course;
        [self foundSameForKJZ:kjz];
    }
}

+ (void)foundSameForKJZ:(KJZ_DB *)kjz
{
    NSMutableArray *questions = kjz.questions;
    
    NSMutableDictionary *sameAnswerDict = [NSMutableDictionary dictionary];//相同
    NSMutableDictionary *diffAnswerDict = [NSMutableDictionary dictionary];//不同
    
    NSMutableArray *diffAnswerQues = [NSMutableArray array];
    
    int tureOrFalse = 0;
    NSInteger sameCount = 0;
    
    for (FFQuestionItem *item in questions) {
        if (item.type != 0) {
            FFQuestionItem *result = nil;
            for (FFQuestionItem *que in diffAnswerQues) {
                if ([que isSameAnswerQuestion:item]) {
                    result = que;
                    break;
                }
            }
            
            if (result) {
                NSString *key = result.answerText;
                NSString *str = [sameAnswerDict objectForKey:key];
                if (str) {
                    str = [str stringByAppendingFormat:@",%zd", item.question_id];
                    sameCount++;
                } else {
                    str = [NSString stringWithFormat:@"%zd,%zd", result.question_id, item.question_id];
                    sameCount += 2;
                }
                [sameAnswerDict setObject:str forKey:key];
                [diffAnswerDict removeObjectForKey:key];
            } else {
                NSString *key = item.answerText;
                NSString *str = [NSString stringWithFormat:@"%zd", item.question_id];
                [diffAnswerDict setObject:str forKey:key];
                
                [diffAnswerQues addObject:item];
            }
        } else {
            tureOrFalse ++;
        }
    }
    
    NSString *result = [NSString stringWithFormat:@"答案相同查找结束(%@)：总共%zd道题，判断题%zd道，不同答案题%zd道, 有相同答案的(%zd - %zd)道,", (kjz.course==3 ? @"科四" : @"科一"), questions.count, tureOrFalse, diffAnswerQues.count, sameCount, sameAnswerDict.count];
    
    NSLog(@"#############%@", result);
    
    
    
//    result = [result stringByAppendingFormat:@"\n############\n\n\n%@\n", [sameAnswerDict JSONString_ff]];
    result = [sameAnswerDict JSONString_ff];
    
    writeTxtToPath(result, PATH(([NSString stringWithFormat:@"same_answer_%zd.txt", kjz.course])));
}

@end
