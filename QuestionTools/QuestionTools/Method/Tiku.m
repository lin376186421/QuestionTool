//
//  Tiku.m
//  333
//
//  Created by cheng on 2017/9/28.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "Tiku.h"

@implementation Tiku

+ (void)deal
{
//    [self zhejiang];
//    [self jinan];
//    [self beijing];
//    [self guangdong];
//    [self jiaoguanju];
}

+ (void)zhejiang
{
    NSString *string = readTxtFromPath(BUNDLE(@"zhejiangnocomment", @"txt"));
    NSArray *array = [string componentsSeparatedByString:@"\r"];
    NSLog(@"questions count = %zd", array.count);
    NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
    NSInteger rowCount = 18;
    for (NSString *obj in array) {
        NSArray *question = [obj componentsSeparatedByString:@"\t"];
        
        if (question.count == rowCount) {
            FFQuestionItem *item = [FFQuestionItem new];
            item.id = [[question objectSafeAtIndex:0] intValue];
            item.question_id = item.id;
            item.type = [[question objectSafeAtIndex:6] intValue];
            item.course = 1;
            item.cert_type = 1;
            item.question = [question objectSafeAtIndex:8];
            if (item.type == 0) {
                item.option_a = @"正确";
                item.option_b = @"错误";
                item.answer = ([[question objectSafeAtIndex:16] intValue] == 1 ? @"A" : @"B");
            } else {
                item.option_a = [question objectSafeAtIndex:12];
                item.option_b = [question objectSafeAtIndex:13];
                item.option_c = [question objectSafeAtIndex:14];
                item.option_d = [question objectSafeAtIndex:15];
                int  ans = [[question objectSafeAtIndex:16] intValue];
                if (ans > 4) {
                    ans = 4;
                } else if (ans < 1){
                    ans = 1;
                }
                ans -= 1;
                item.answer = [@"ABCD" substringWithRange:NSMakeRange(ans, 1)];
            }
            item.difficulty = [[question objectSafeAtIndex:17] intValue];
            item.comments = [question objectSafeAtIndex:18];
            [questions addObject:item];
        } else {
            NSLog(@"%@ = %zd : %@", [question objectSafeAtIndex:0], question.count, [question JSONString_ff]);
        }
    }
    writeDbWithFileName(questions, @"zhejiang");
}

+ (void)jinan
{
    NSLog(@"开始处理济南考题");
    
    NSString *strin = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jinan" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [strin componentsSeparatedByString:@"\n"];
    NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array) {
        NSArray *arr = [string componentsSeparatedByString:@"\t"];
        if (arr.count == 7) {
            FFQuestionItem *item = [FFQuestionItem new];
            item.question = arr[2];
            NSString *op = arr[3];
            if ([op rangeOfString:@"A"].length) {
                item.type = 1;
                NSArray *opa = [op componentsSeparatedByString:@" "];
                int i = 0;
                for (NSString * opaa in opa) {
                    if ([opaa rangeOfString:@"、"].length) {
                        NSString *aa = [opaa substringFromIndex:[opaa rangeOfString:@"、"].location + 1];
                        if (i == 0) {
                            item.option_a = aa;
                        } else if (i == 1) {
                            item.option_b = aa;
                        } else if (i == 2) {
                            item.option_c = aa;
                        } else if (i == 3) {
                            item.option_d = aa;
                        }
                        i++;
                    }
                }
                item.answer = arr[4];
            } else {
                item.type = 0;
                item.option_a = @"正确";
                item.option_b = @"错误";
                NSString *an = arr[4];
                if ([[an lowercaseString] rangeOfString:@"y"].length) {
                    item.answer = @"A";
                } else {
                    item.answer = @"B";
                }
            }
            
            item.difficulty = [arr[5] intValue];
            item.comments = arr[6];
            [questions addObject:item];
        }
    }
    NSLog(@"#####  =  %zd", questions.count);
    
    NSInteger i = 0;
    for (FFQuestionItem *item in questions) {
        item.id              = (int)i;
        item.question_id = 45000 + (int)i;
        item.course = 1;
        item.cert_type = 1;
        item.chapter = 104;
        item.city_id = @"364";
        i++;
    }
    
    writeDbWithFileName(questions, @"jinan");
}

+ (void)beijing
{
    NSLog(@"开始处理北京考题");
    
    NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beijing" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [text componentsSeparatedByString:@"\r"];
    NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
    
    FFQuestionItem *item = nil;
    for (NSString *obj in array) {
        NSString *string = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfString:@"、"].length && [@"123456789" rangeOfString:[string substringToIndex:1]].length) {
            item = [FFQuestionItem new];
            item.course = 3;
            item.chapter = 105;
            item.city_id = @"27";
            item.difficulty = 1;
            item.question_id = 46000 + (int)questions.count;
            item.id = (int)questions.count;
            item.cert_type = 1;
            item.question = [[string componentsSeparatedByString:@"、"] lastObject];
        } else if (item && string.length) {
            if ([string rangeOfString:@"答案"].length) {
                NSString *ans = [[string componentsSeparatedByString:@"答案"] lastObject];
                if ([ans rangeOfString:@"正确"].length) {
                    item.option_a = @"正确";
                    item.option_b = @"错误";
                    item.answer = @"A";
                } else if ([ans rangeOfString:@"错误"].length) {
                    item.option_a = @"正确";
                    item.option_b = @"错误";
                    item.answer = @"B";
                } else if ([ans rangeOfString:@"A"].length) {
                    item.answer = @"A";
                } else if ([ans rangeOfString:@"B"].length) {
                    item.answer = @"B";
                } else if ([ans rangeOfString:@"C"].length) {
                    item.answer = @"C";
                } else if ([ans rangeOfString:@"D"].length) {
                    item.answer = @"D";
                }
                if (item.option_c.length) {
                    item.type = 1;
                } else {
                    item.type = 0;
                }
                [questions addObject:item];
                item = nil;
            } else if ([@"ABCD" rangeOfString:[string substringToIndex:1]].length){
                if ([string rangeOfString:@"A"].length) {
                    item.option_a = [[[[string componentsSeparatedByString:@"A"] lastObject] componentsSeparatedByString:@"B"] firstObject];
                }
                if ([string rangeOfString:@"B"].length) {
                    item.option_b = [[[[string componentsSeparatedByString:@"B"] lastObject] componentsSeparatedByString:@"C"] firstObject];
                }
                
                if ([string rangeOfString:@"C"].length) {
                    item.option_c = [[[[string componentsSeparatedByString:@"C"] lastObject] componentsSeparatedByString:@"D"] firstObject];
                }
                
                if ([string rangeOfString:@"D"].length) {
                    item.option_d = [[string componentsSeparatedByString:@"D"] lastObject];
                }
            }
        }
    }
    writeDbWithFileName(questions, @"cl_beijing");
    NSLog(@"北京题处理结束 count = %zd", questions.count);
}

+ (void)guangdong
{
    NSArray *array = readExcelTxtFromPath(BUNDLE(@"guangdong", @"txt"));
    
    NSMutableArray *result = [NSMutableArray array];
    int i =0;
    for (NSArray *arr in array) {
        FFQuestionItem *item = [FFQuestionItem new];
        item.id = i;
        item.cert_type = 1;
        item.course = 1;
        item.question = [arr objectAtIndex:6];
        item.answer = [arr objectAtIndex:8];
        item.comments = [arr objectAtIndex:9];
        item.type = (item.option_c ?  1 : 0);
        item.question_id = ++i;
        [result addObject:item];
    }
    
    writeDbWithFileName(result, @"guangdong");
}

+ (void)jiaoguanju
{
//    NSLog(@"开始处理交管局图片");
//    
//    [self pathContentsImage];
//    
//    return;
    
    for (int c = 1; c<=4; c += 4) {
        NSLog(@"开始处理交管局题库");
        NSString *name = [@"xinzheng" stringByAppendingFormat:@"%zd", c];
        NSString *text = readTxtFromPath(BUNDLE(name, @"txt"));
        
        NSArray *array = [text componentsSeparatedByString:@"\n"];
        NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
        
        FFQuestionItem *item = nil;
        int chapter = 0;
        int i =0;
        for (NSString *obj in array) {
            NSString *string = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (([string rangeOfString:@"．"].length || [string rangeOfString:@"."].length) && [@"123456789" rangeOfString:[string substringToIndex:1]].length) {
                item = [FFQuestionItem new];
                item.course = 1;
                item.chapter = chapter;
                item.difficulty = arc4random_uniform(4) + 1;
                item.question_id = 50000 + (int)questions.count;
                item.id = (int)questions.count + 1;
                item.cert_type = 0;
                
                NSRange tuRange = [string rangeOfString:@"（图"];
                if ([string hasSuffix:@"）"] && tuRange.length && tuRange.location > 3) {
                    string = [string substringToIndex:tuRange.location];
                }
                if ([string rangeOfString:@"．"].length) {
                    NSArray *array = [string componentsSeparatedByString:@"．"];
                    if (array.count > 2) {
                        NSString *que = [array objectAtIndex:1];
                        item.question = que;
                    } else {
                        item.question = [array lastObject];
                    }
                } else if ([string rangeOfString:@"."].length) {
                    NSArray *array = [string componentsSeparatedByString:@"."];
                    if (array.count > 2) {
                        NSString *que = [array objectAtIndex:1];
                        item.question = que;
                    } else {
                        item.question = [array lastObject];
                    }
                }
            } else if (item && string.length) {
                if ([string rangeOfString:@"答案"].length) {
                    NSString *ans = [[string componentsSeparatedByString:@"答案"] lastObject];
                    if ([ans rangeOfString:@"正确"].length) {
                        item.option_a = @"正确";
                        item.option_b = @"错误";
                        item.answer = @"A";
                    } else if ([ans rangeOfString:@"错误"].length) {
                        item.option_a = @"正确";
                        item.option_b = @"错误";
                        item.answer = @"B";
                    } else if ([ans rangeOfString:@"A"].length) {
                        item.answer = @"A";
                    } else if ([ans rangeOfString:@"B"].length) {
                        item.answer = @"B";
                    } else if ([ans rangeOfString:@"C"].length) {
                        item.answer = @"C";
                    } else if ([ans rangeOfString:@"D"].length) {
                        item.answer = @"D";
                    }
                    if (item.option_c.length) {
                        item.type = 1;
                    } else {
                        item.type = 0;
                    }
                    [questions addObject:item];
                    item = nil;
                    i ++;
                } else if ([@"ABCD" rangeOfString:[string substringToIndex:1]].length){
                    if ([string rangeOfString:@"A."].length) {
                        item.option_a = [[string componentsSeparatedByString:@"."] lastObject];
                    } else if ([string rangeOfString:@"B."].length) {
                        item.option_b = [[string componentsSeparatedByString:@"."] lastObject];
                    } else if ([string rangeOfString:@"C."].length) {
                        item.option_c = [[string componentsSeparatedByString:@"."] lastObject];
                    } else if ([string rangeOfString:@"D."].length) {
                        item.option_d = [[string componentsSeparatedByString:@"."] lastObject];
                    }
                }
            } else if (string.length) {

            }
        }
        
        NSLog(@"chapter = %zd, i = %zd, count = %zd", chapter, i, questions.count);
        
        if (questions.count) {
            NSString *name = [@"cl_jiaoguanju_" stringByAppendingFormat:@"%zd", c];
            writeDbWithFileName(questions, name);
        }
        
        NSLog(@"交管局题处理结束1 count = %zd", questions.count);
    }
    
    return;

//    NSLog(@"开始处理交管局考题");
//    
//    NSString *text = readTxtFromPath(BUNDLE(@"jiaoguanju", @"txt"));
//    NSArray *array = [text componentsSeparatedByString:@"\n"];
//    NSMutableArray *questions = [NSMutableArray arrayWithCapacity:array.count];
//    
//    FFQuestionItem *item = nil;
//    int chapter = 0;
//    int i =0;
//    for (NSString *obj in array) {
//        NSString *string = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if (([string rangeOfString:@"．"].length || [string rangeOfString:@"."].length) && [@"123456789" rangeOfString:[string substringToIndex:1]].length) {
//            item = [FFQuestionItem new];
//            item.course = 1;
//            item.chapter = chapter;
//            item.difficulty = arc4random_uniform(4) + 1;
//            item.question_id = 50000 + (int)questions.count;
//            item.id = (int)questions.count + 1;
//            item.cert_type = 0;
//            if ([string rangeOfString:@"．"].length) {
//                item.question = [[string componentsSeparatedByString:@"．"] lastObject];
//            } else if ([string rangeOfString:@"."].length) {
//                item.question = [[string componentsSeparatedByString:@"."] lastObject];
//            }
//        } else if (item && string.length) {
//            if ([string rangeOfString:@"答案"].length) {
//                NSString *ans = [[string componentsSeparatedByString:@"答案"] lastObject];
//                if ([ans rangeOfString:@"正确"].length) {
//                    item.option_a = @"正确";
//                    item.option_b = @"错误";
//                    item.answer = @"A";
//                } else if ([ans rangeOfString:@"错误"].length) {
//                    item.option_a = @"正确";
//                    item.option_b = @"错误";
//                    item.answer = @"B";
//                } else if ([ans rangeOfString:@"A"].length) {
//                    item.answer = @"A";
//                } else if ([ans rangeOfString:@"B"].length) {
//                    item.answer = @"B";
//                } else if ([ans rangeOfString:@"C"].length) {
//                    item.answer = @"C";
//                } else if ([ans rangeOfString:@"D"].length) {
//                    item.answer = @"D";
//                }
//                if (item.option_c.length) {
//                    item.type = 1;
//                } else {
//                    item.type = 0;
//                }
//                [questions addObject:item];
//                item = nil;
//                i ++;
//            } else if ([@"ABCD" rangeOfString:[string substringToIndex:1]].length){
//                if ([string rangeOfString:@"A."].length) {
//                    item.option_a = [[string componentsSeparatedByString:@"."] lastObject];
//                } else if ([string rangeOfString:@"B."].length) {
//                    item.option_b = [[string componentsSeparatedByString:@"."] lastObject];
//                } else if ([string rangeOfString:@"C."].length) {
//                    item.option_c = [[string componentsSeparatedByString:@"."] lastObject];
//                } else if ([string rangeOfString:@"D."].length) {
//                    item.option_d = [[string componentsSeparatedByString:@"."] lastObject];
//                }
//            }
//        } else if (string.length) {
//            NSArray *ar = [string componentsSeparatedByString:@"）"];
//            if (ar.count > 1) {
//                NSString *str = [ar firstObject];
//                str = [str substringFromIndex:str.length - 1];
//                if ([@"一二三四五六七八九" rangeOfString:str].length) {
//                    if (chapter > 0) {
//                        NSLog(@"chapter = %zd, i = %zd, count = %zd", chapter, i, questions.count);
//                        i = 0;
//                    }
//                    chapter = (int)[@"一二三四五六七八九" rangeOfString:str].location + 1;
//                    if (chapter <= 0) {
//                        NSLog(@"fuck chapter %@", string);
//                    }
//                }
//            }
//            
//        }
//    }
//    
//    NSLog(@"chapter = %zd, i = %zd, count = %zd", chapter, i, questions.count);
//    
//    if (questions.count == 100) {
//        writeDbWithPath(questions, @"cl_jiaoguanju");
//    }
//    
//    NSLog(@"交管局题处理结束 count = %zd", questions.count);
    
}


+ (void)pathContentsImage
{
    //    NSLog(@"path == %@", path);
    NSString *fileName = @"100image";
    NSString *path = PATH(fileName);
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *contents = [manager contentsOfDirectoryAtPath:path error:NULL];
//    NSLog(@"contentsOfDirectoryAtPath %@", contents);
    
    NSString *toPath = PATH(@"cl_100image");
    if (![manager fileExistsAtPath:toPath]) {
        [manager createDirectoryAtPath:toPath attributes:nil];
    }
    
    [contents enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@".jpg"] || [obj hasSuffix:@".png"]) {
            NSArray *array = [obj componentsSeparatedByString:@"."];
            NSString *imageType = [array lastObject];
            int index = [[[array firstObject] substringFromIndex:[@"image" length]] intValue] / 2;
            
            NSString *oldPath = [path stringByAppendingPathComponent:obj];
            NSString *newPath = [toPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd.%@", index , imageType]];
            
            [manager copyItemAtPath:oldPath toPath:newPath error:NULL];
        }
    }];
}

+ (BOOL)verifyChapter:(NSString *)string
{
    if (string.length<= 0) {
        return NO;
    }
    NSString *regex = @"（[一二三四五六七八九]）";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:string];
}

@end
