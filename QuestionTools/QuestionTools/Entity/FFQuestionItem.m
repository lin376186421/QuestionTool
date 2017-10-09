//
//  FFQuestionItem.m
//  333
//
//  Created by PageZhang on 16/1/15.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFQuestionItem.h"

@implementation FFQuestionItem
+ (NSString *)tableName {
    return @"dt_question";
}
+ (NSString *)primaryKey {
    return @"id";
}
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER"      forKey:@"id"];
        [version0 setObject:@"INTEGER"      forKey:@"course"];
        [version0 setObject:@"INTEGER"      forKey:@"question_id"];
        [version0 setObject:@"INTEGER"      forKey:@"chapter"];
        [version0 setObject:@"INTEGER"      forKey:@"category"];
        [version0 setObject:@"INTEGER"      forKey:@"type"];
        [version0 setObject:@"INTEGER"      forKey:@"cert_type"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"question"];
        [version0 setObject:@"INTEGER"      forKey:@"media_type"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"media"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_a"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_b"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_c"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_d"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_e"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_f"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_g"];
        [version0 setObject:@"VARCHAR(255)" forKey:@"option_h"];
        [version0 setObject:@"VARCHAR(10)"  forKey:@"answer"];
        [version0 setObject:@"INTEGER"      forKey:@"difficulty"];
        [version0 setObject:@"TEXT"         forKey:@"comments"];
        [version0 setObject:@"VARCHAR(20)"         forKey:@"city_id"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.id = 0;
        self.category = 0;
        self.media_type = 0;
        self.difficulty = 1;
    }
    return self;
}

+ (FFQuestionItem *)itemFromResultSet:(FMResultSet *)rs needDecode:(BOOL)decode
{
    if (!rs) return nil;
    
    FFQuestionItem *item = [[FFQuestionItem alloc] init];
    item.itemId = [rs intForColumn:@"id"];
    item.course = [[rs stringForColumn:@"course"] intValue];
    item.question_id = [rs intForColumn:@"question_id"];
    item.chapter = [rs intForColumn:@"chapter"];
    item.category = [rs intForColumn:@"category"];
    item.type = [rs intForColumn:@"type"];
    item.cert_type = [rs intForColumn:@"cert_type"];
    item.media_type = [rs intForColumn:@"media_type"];
    item.media = [rs stringForColumn:@"media"];
    item.option_a = [rs stringForColumn:@"option_a"];
    item.option_b = [rs stringForColumn:@"option_b"];
    item.option_c = [rs stringForColumn:@"option_c"];
    item.option_d = [rs stringForColumn:@"option_d"];
    item.difficulty = [rs intForColumn:@"difficulty"];
    
    // 解密内容
    NSString *question = [rs stringForColumn:@"question"];
    NSString *answer   = [rs stringForColumn:@"answer"];
    NSString *comments = [rs stringForColumn:@"comments"];
    item.question = question;
    item.answer   = answer;
    item.comments = comments;
    
    item.city_id = [rs stringForColumn:@"city_id"];
    return item;
}

+ (FFQuestionItem *)itemFromResultSet:(FMResultSet *)rs
{
    return [self itemFromResultSet:rs needDecode:NO];
}

- (NSString *)answerText
{
    if (_type == 1) {
        if ([_answer isEqualToString:@"A"]) {
            return _option_a;
        } else if ([_answer isEqualToString:@"B"]) {
            return _option_b;
        } else if ([_answer isEqualToString:@"C"]) {
            return _option_c;
        } else if ([_answer isEqualToString:@"D"]) {
            return _option_d;
        }
    } else if (_type == 2) {
        NSMutableString *mstring = [NSMutableString string];
        if ([_answer rangeOfString:@"A"].length) {
            [mstring appendFormat:@"+%@", _option_a];
        }
        if ([_answer rangeOfString:@"B"].length) {
            [mstring appendFormat:@"+%@", _option_b];
        }
        if ([_answer rangeOfString:@"C"].length) {
            [mstring appendFormat:@"+%@", _option_c];
        }
        if ([_answer rangeOfString:@"D"].length) {
            [mstring appendFormat:@"+%@", _option_d];
        }
        return mstring;
    } else {
        if ([_answer isEqualToString:@"A"]) {
            return @"正确";
        } else {
            return @"错误";
        }
    }
    return nil;
}

- (NSString *)answerTextIndex:(int)index
{
    if (index < _answer.length) {
        NSString *option = [_answer substringWithRange:NSMakeRange(index, 1)];
        if ([option isEqualToString:@"A"]) {
            return _option_a;
        } else if ([option isEqualToString:@"B"]) {
            return _option_b;
        } else if ([option isEqualToString:@"C"]) {
            return _option_c;
        } else if ([option isEqualToString:@"D"]) {
            return _option_d;
        }
    }
    return nil;
}

- (BOOL)isSameAnswerQuestion:(FFQuestionItem *)item
{
    if (item.type == _type && _type != 0) {
        if (_type == 1) {
            return [item.answerText isEqualToString:self.answerText];
        } else if (item.answer.length == self.answer.length) {
            NSString *string = self.answerText;
            NSInteger n = item.answer.length;
            for (int i=0; i<n; i++) {
                NSString *ans = [item answerTextIndex:i];
                if (ans && [string rangeOfString:ans].length <= 0) {
                    return NO;
                }
            }
            return YES;
        }
    }
    return NO;
}

- (NSArray *)commentTextArray
{
    if (_commentTextArray == nil) {
        _commentTextArray = [MethodObject chineseCharsFromString:self.comments];
    }
    return _commentTextArray;
}

- (BOOL)isSameCommentQuestion:(FFQuestionItem *)item
{
    if (!self.comments) {
        if (!item.comments) {
            return YES;
        }
    } else if (!item.comments) {
        return NO;
    } else {
        if ([item.comments isEqualToString:self.comments]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)scoreForCompareCommentQuestion:(FFQuestionItem *)item
{
    if ([self isSameCommentQuestion:item]) {
        return 0;
    } else {
        return [MethodObject compareArray:self.commentTextArray withOther:item.commentTextArray];
    }
}

+ (id)itemFromTxtArray:(NSArray *)array
{
    if (!array || !array.count) {
        return nil;
    }
    
    if (array.count >= 22) {
        FFQuestionItem *item = [FFQuestionItem new];
        //id	course	question_id	chapter	category	type	cert_type	question	media_type	media	option_a	option_b	option_c	option_d	option_e	option_f	option_g	option_h	answer	difficulty	comments	city_id
        item.course = [[array objectAtIndex:1] intValue];
        item.question_id = [[array objectAtIndex:2] intValue];
        item.chapter = [[array objectAtIndex:3] intValue];
        item.category = [[array objectAtIndex:4] intValue];
        item.type = [[array objectAtIndex:5] intValue];
        item.cert_type = [[array objectAtIndex:6] intValue];
        item.question = [self stringFromArray:array index:7];
        item.media_type = [[array objectAtIndex:8] intValue];
        item.media = [self stringFromArray:array index:9];
        item.option_a = [self stringFromArray:array index:10];
        item.option_b = [self stringFromArray:array index:11];
        item.option_c = [self stringFromArray:array index:12];
        item.option_d = [self stringFromArray:array index:13];
        item.answer = [self stringFromArray:array index:18];
        
        item.difficulty = [[array objectAtIndex:19] intValue];
        
        item.comments = [self stringFromArray:array index:20];
        item.city_id = [self stringFromArray:array index:21];
        
        return item;
    }
    
    return nil;
}

+ (NSString *)stringFromArray:(NSArray *)array index:(NSInteger)index
{
    if (index < array.count) {
        NSString *string = [array objectAtIndex:index];
        if (string.length ) {
            return string;
        }
    }
    return nil;
}

@end


@implementation FFQuestionChapterItem
+ (NSString *)tableName {
    return @"dt_chapter";
}
+ (NSString *)primaryKey {
    return @"id";
}
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER"      forKey:@"id"];
        [version0 setObject:@"INTEGER"      forKey:@"course"];
        [version0 setObject:@"INTEGER"      forKey:@"chapter"];
        [version0 setObject:@"INTEGER"      forKey:@"cert_type"];
        [version0 setObject:@"VARCHAR(255)"         forKey:@"title"];
        [version0 setObject:@"VARCHAR(20)"         forKey:@"city_id"];
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

+ (FFQuestionChapterItem *)itemFromResultSet:(FMResultSet *)rs needDecode:(BOOL)decode
{
    if (!rs) return nil;
    
    FFQuestionChapterItem *item = [[FFQuestionChapterItem alloc] init];
    if ([[rs columnNameToIndexMap] objectForKey:@"id"]) {
        item.id = [rs intForColumn:@"id"];
    }
    
    item.course = [[rs stringForColumn:@"course"] intValue];
    item.chapter = [rs intForColumn:@"chapter"];
    item.cert_type = [rs intForColumn:@"cert_type"];
    item.city_id = [rs stringForColumn:@"city_id"];
    if ([[rs columnNameToIndexMap] objectForKey:@"title"]) {
        if (![rs columnIsNull:@"title"]) {
            item.title = [rs stringForColumn:@"title"];
        }
    }
    
    if (item.title.length <=0 ) {
        item.title = [self titleForChapter:item.chapter inCourse:item.course certType:item.cert_type];
    }
    return item;
}

+ (FFQuestionChapterItem *)itemFromResultSet:(FMResultSet *)rs
{
    return [self itemFromResultSet:rs needDecode:NO];
}

+ (NSString *)titleForChapter:(NSInteger)chapter inCourse:(NSInteger)course certType:(NSInteger)certType {
    switch (chapter) {
        case 101: return @"上海地方题库";
        case 102: return @"武汉地方题库";
        case 103: return @"福州地方题库";
        case 104: return @"济南违法停车集中整治行动测试题";
        case 105: return @"北京斑马线礼让题";
        case 106: return @"四川省地方性法规解析题";
            
        case 201: return @"宿迁客运地方题库";//客运
        case 202: return @"宿迁货运地方题库";//货运
        case 203: return @"成都货运地方题库";//货运
        default: break;
    }
    switch (certType) {
        case DTCertTypeXiaoche:
        case DTCertTypeKeche:
        case DTCertTypeHuoche:
        case 7: {
            if (course==1) {
                switch (chapter) {
                    case 1: return @"道路交通安全法律、法规和规章";
                    case 2: return @"交通信号";
                    case 3: return @"安全行车、文明驾驶基础知识";
                    case 4: return @"机动车驾驶操作相关基础知识";
                    case 5: return @"客车专题";
                    case 6: return @"货车专题";
                    default: return nil;
                }
            } else {
                switch (chapter) {
                    case 1: return @"违法行为综合判断与案例分析";
                    case 2: return @"安全行车常识";
                    case 3: return @"常见交通标志、标线和交警手势辨识";
                    case 4: return @"驾驶职业道德和文明驾驶常识";
                    case 5: return @"恶劣气候和复杂道路条件下驾驶常识";
                    case 6: return @"紧急情况下避险常识";
                    case 7: return @"交通事故救护及常见危化品处置常识";
                    default: return nil;
                }
            }
        } break;
            
        case DTCertTypeMotoche: {
            switch (chapter) {
                case 1: return @"道路交通安全法";
                case 2: return @"摩托车安全文明驾驶";
                case 3: return @"交通信号";
                case 4: return @"安全行车、文明驾驶";
                default: return nil;
            }
        } break;
            
        case DTCertTypeTaxi:
        case DTCertTypeTaxiInternet:
        case 528: {
            switch (chapter) {
                case 1: return @"职业道德与服务规范";
                case 2: return @"安全运营与治安防范";
                case 3: return @"汽车使用与常见故障处理";
                case 4: return @"节能驾驶";
                case 5: return @"运价知识与计价器使用";
                case 6: return @"道路交通事故处理与应急救护";
                case 7: return @"出租车汽车政策、法规、标准";
                case 8: return @"出租车服务质量信誉考核";
                case 9: return @"网约车全国公共科目";
                default: return nil;
            }
        } break;
            
        case DTCertTypeKeyun: {
            switch (chapter) {
                case 1: return @"职业道德和法律法规";
                case 2: return @"安全行车";
                case 3: return @"应急处置和紧急救护";
                case 4: return @"汽车使用技术";
                case 5: return @"客运知识";
                default: return nil;
            }
        } break;
            
        case DTCertTypeHuoyun: {
            switch (chapter) {
                case 1: return @"职业道德和法律法规";
                case 2: return @"安全行车";
                case 3: return @"应急处置和紧急救护";
                case 4: return @"汽车使用技术";
                case 5: return @"货运知识";
                default: return nil;
            }
        } break;
            
        case DTCertTypeJiaolian: {
            switch (chapter) {
                case 1: return @"教练员职责";
                case 2: return @"道路交通安全法律法规";
                case 3: return @"道路运输法律法规";
                case 4: return @"交通安全心理与安全意识";
                case 5: return @"教育学、教育心理学及其应用";
                case 6: return @"驾驶员培训教学大纲";
                case 7: return @"教学方法及规范化教学";
                case 8: return @"教学手段";
                case 9: return @"教案的编写";
                case 10: return @"典型交通事故案例分析";
                case 11: return @"车辆结构与安全性能";
                case 12: return @"车辆维护与故障处理";
                case 13: return @"车辆安全检视";
                case 14: return @"环保与节能驾驶";
                case 15: return @"特殊环境安全驾驶方法";
                case 16: return @"应急驾驶";
                case 17: return @"事故现场应急处理";
                case 18: return @"驾驶职业道德与文明驾驶知识";
                default: return nil;
            }
        } break;
            
        case DTCertTypeWeixian: {
            switch (chapter) {
                case 1: return @"法规";
                case 2: return @"特性";
                case 3: return @"运装";
                case 4: return @"车辆";
                case 5: return @"应急";
                default: return nil;
            }
        } break;
        case 0:
        {
            switch (chapter) {
                case 1:
                    return @"驾驶证申领和使用规定";
                    break;
                case 2:
                    return @"道路交通信号";
                    break;
                case 3:
                    return @"道路通行规定";
                    break;
                    
                default:
                    return nil;
                    break;
            }
        }
            break;
            
        default: return nil;
    }
    return nil;
}

@end

@implementation FFQuestionSameExamPointItem

+ (NSString *)tableName {
    return @"dt_vipsame";
}
+ (NSString *)primaryKey {
    return @"id";
}
+ (BOOL)AUTOINCREMENT
{
    return YES;
}

+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER"      forKey:@"id"];
        [version0 setObject:@"INTEGER"      forKey:@"question_id"];
        [version0 setObject:@"INTEGER"      forKey:@"course"];
        [version0 setObject:@"TEXT"         forKey:@"same_question"];
        [version0 setObject:@"TEXT"         forKey:@"vip_comments"];
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

+ (FFQuestionSameExamPointItem *)itemFromResultSet:(FMResultSet *)rs
{
    FFQuestionSameExamPointItem *item = [FFQuestionSameExamPointItem new];
    item.id = [rs intForColumn:@"id"];
    item.question_id = [rs intForColumn:@"question_id"];
    item.course = [rs intForColumn:@"course"];
    item.same_question = [rs stringForColumn:@"same_question"];
    item.same_comments = [rs stringForColumn:@"same_comments"];
    return item;
}

+ (id)itemFromTxtArray:(NSArray *)array
{
    if (!array || !array.count) {
        return nil;
    }
    
    if (array.count >= 3) {
        FFQuestionSameExamPointItem *item = [FFQuestionSameExamPointItem new];
        item.question_id = [[array objectAtIndex:0] intValue];
        item.indexId = [array objectAtIndex:1];
        item.course = [[array objectAtIndex:2] intValue];
        item.comments = [self stringFromArray:array index:3];
        item.same_question = [self stringFromArray:array index:4];
        item.same_comments = [self stringFromArray:array index:5];
        
        if (item.same_comments && [item.same_comments isEqualToString:item.comments]) {
            item.same_comments = nil;
        }
        
        return item;
    }
    
    return nil;
}

+ (NSString *)stringFromArray:(NSArray *)array index:(NSInteger)index
{
    if (index < array.count) {
        NSString *string = [array objectAtIndex:index];
        if (string.length ) {
            return string;
        }
    }
    return nil;
}

+ (NSArray *)getValidItems:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *result = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(FFQuestionSameExamPointItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.same_question.length) {
            if ([obj.same_question isEqualToString:obj.indexId]) {
                obj.same_question = nil;
            } else {
                [arr addObject:obj];
            }   
        }
        [dict setObject:obj forKey:obj.indexId];
    }];
    
    [arr enumerateObjectsUsingBlock:^(FFQuestionSameExamPointItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.same_question.length && ![obj.same_question isEqualToString:obj.indexId]) {
            FFQuestionSameExamPointItem *item = [dict objectForKey:obj.same_question];
            if (item) {
                if (![result containsObject:item]) {
                    item.same_question = nil;
                    [result addObject:item];
                }
                if (item.same_question.length) {
                    item.same_question = [item.same_question stringByAppendingFormat:@",%zd", obj.question_id];
                } else {
                    item.same_question = [NSString stringWithFormat:@"%zd", obj.question_id];
                }
            } else {
                NSLog(@"same question : %@", obj.same_question);
            }
        } else {
            NSLog(@"same question equal: %@", obj.same_question);
        }
    }];
    
    return result;
}

@end

@implementation FFKnowledgeItem

+ (FFKnowledgeItem *)itemFromDict:(NSDictionary *)dict
{
    if (dict) {
        FFKnowledgeItem *item = [FFKnowledgeItem new];
        item.itemId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        item.name = [dict objectForKey:@"name"];
        item.desc = [dict objectForKey:@"description"];
        return item;
    }
    return nil;
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.itemId forKey:@"id"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.desc forKey:@"description"];
    return dict;
}

@end

@implementation FFKnowledgeClassifyItem

+ (FFKnowledgeClassifyItem *)itemFromDict:(NSDictionary *)dict
{
    if (dict) {
        FFKnowledgeClassifyItem *item = [FFKnowledgeClassifyItem new];
        item.itemId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        item.name = [dict objectForKey:@"name"];
        NSArray *array = [dict objectForKey:@"childList"];
        item.childList = [NSMutableArray array];
        item.knowledgeIds = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FFKnowledgeItem *kitem = [FFKnowledgeItem itemFromDict:obj];
            if (kitem) {
                [item.childList addObject:kitem];
                [item.knowledgeIds addObject:kitem.itemId];
            }
        }];
        
        return item;
    }
    return nil;
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.itemId forKey:@"id"];
    [dict setObject:[NSString stringWithFormat:@"%zd", self.course] forKey:@"course"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:[self.knowledgeIds componentsJoinedByString:@","] forKey:@"knowledgeIds"];
    return dict;
}

@end
