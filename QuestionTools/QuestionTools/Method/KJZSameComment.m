//
//  KJZSameComment.m
//  333
//
//  Created by cheng on 17/5/18.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "KJZSameComment.h"
#import "KJZ_DB.h"

@implementation KJZSameComment

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
    NSMutableArray *diff = [NSMutableArray array];
    
    int score = 0;
    NSArray *questions = kjz.questions;
    while (score <= 10 && questions.count) {
        KJZSameCommentResult *result = [self foundSameQuestion:questions score:score];
        questions = result.diffCommentQues;
        
        
//        [diff addObject:[result desc]];
        [diff addObject:result.sameCommentDict];

        if (score == 10) {
            [diff addObject:result.diffCommentDict];
        }
        
        score ++;
    }
    
    NSString *string = [diff JSONString_ff];
    
    writeTxtToPath(string, PATH(([NSString stringWithFormat:@"same_comment_%zd.txt", kjz.course])));
}

+ (KJZSameCommentResult *)foundSameQuestion:(NSArray *)questions score:(NSInteger)score
{
    NSInteger sameCount = 0;
    NSMutableArray *diffCommentQues = [NSMutableArray array];
    
    NSMutableDictionary *sameCommentDict = [NSMutableDictionary dictionary];//相同
    NSMutableDictionary *diffCommentDict = [NSMutableDictionary dictionary];//不同
    
    for (FFQuestionItem *item in questions) {
        FFQuestionItem *result = [self foundItem:item fromArray:diffCommentQues sameAs:score];
        if (result) {
            NSString *key = result.comments?:@"null";
            NSString *str = [sameCommentDict objectForKey:key];
            if (str) {
                str = [str stringByAppendingFormat:@",%zd", item.question_id];
                sameCount++;
            } else {
                str = [NSString stringWithFormat:@"%zd,%zd", result.question_id, item.question_id];
                sameCount += 2;
            }
            [sameCommentDict setObject:str forKey:key];
            [diffCommentDict removeObjectForKey:key];
        } else {
            NSString *key = item.comments?:@"null";
            NSString *str = [NSString stringWithFormat:@"%zd", item.question_id];
            [diffCommentDict setObject:str forKey:key];
            
            [diffCommentQues addObject:item];
        }
    }
    
    KJZSameCommentResult *result = [KJZSameCommentResult new];
    result.diffCommentQues = diffCommentQues;
    result.sameCommentDict = sameCommentDict;
    result.diffCommentDict = diffCommentDict;
    result.sameCount = sameCount;
    result.totalCount = questions.count;
    result.score = score;
    
    NSLog(@"%@", [result desc]);
    
    return result;
}

+ (FFQuestionItem *)foundItem:(FFQuestionItem *)item fromArray:(NSArray *)array sameAs:(NSInteger)score
{
    for (FFQuestionItem *que in array) {
        if ([item scoreForCompareCommentQuestion:que] <= score) {
            return que;
        }
    }
    return nil;
}

@end


@implementation KJZSameCommentResult

- (NSString *)desc
{
    NSString *string = [NSString stringWithFormat:@"\n\n本次查询差异度为 %zd\n总题数 %zd, 不同题数 %zd, 相同题数(%zd - %zd)\n\n", _score, _totalCount, _diffCommentDict.count, _sameCount, _sameCommentDict.count];
    return string;
}


@end
