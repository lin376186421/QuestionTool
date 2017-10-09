//
//  FFQuestionItem.h
//  333
//
//  Created by PageZhang on 16/1/15.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

typedef enum {
    DTCertTypeXiaoche = 1, // 小车
    DTCertTypeKeche = 2, // 客车
    DTCertTypeHuoche = 4, // 货车
    DTCertTypeMotoche = 8, // 摩托车
    DTCertTypeTaxi = 16, // 出租车
    DTCertTypeHuoyun = 32, // 货运
    DTCertTypeJiaolian = 64, // 教练
    DTCertTypeKeyun = 128, // 客运
    DTCertTypeWeixian = 256, // 危险品
    DTCertTypeTaxiInternet = 512, //网约车
} DTCertType;

@interface FFQuestionItem : FFDBObject

JProperty(uint32_t  , id);
JProperty(uint32_t  , itemId);
JProperty(uint16_t  , course);
JProperty(uint32_t  , question_id);
JProperty(uint16_t  , chapter);
JProperty(uint16_t  , category);
JProperty(uint16_t  , type);
JProperty(uint16_t  , cert_type);
JProperty(NSString *, question);
JProperty(uint16_t  , media_type);
JProperty(NSString *, media);
JProperty(NSString *, option_a);
JProperty(NSString *, option_b);
JProperty(NSString *, option_c);
JProperty(NSString *, option_d);
JProperty(NSString *, option_e);
JProperty(NSString *, option_f);
JProperty(NSString *, option_g);
JProperty(NSString *, option_h);
JProperty(NSString *, answer);
JProperty(uint16_t  , difficulty);
JProperty(NSString *, comments);
JProperty(NSString *, city_id);

@property (nonatomic, strong) NSArray *commentTextArray;

+ (FFQuestionItem *)itemFromResultSet:(FMResultSet *)rs;

- (NSString *)answerText;
- (NSString *)answerTextIndex:(int)index;

- (BOOL)isSameAnswerQuestion:(FFQuestionItem *)item;
//- (BOOL)isSameCommentQuestion:(FFQuestionItem *)item;

/* 比较解释
 * 0 不同， 1 相同， 2 相似
 */
- (BOOL)isSameCommentQuestion:(FFQuestionItem *)item;

//差异度，0 为完全相同，数值越大 差异越大
- (NSInteger)scoreForCompareCommentQuestion:(FFQuestionItem *)item;

@end

@interface FFQuestionChapterItem : FFDBObject

JProperty(uint32_t  , id);
JProperty(uint16_t  , course);
JProperty(uint16_t  , chapter);
JProperty(uint16_t  , cert_type);
JProperty(NSString *, title);
JProperty(NSString *, city_id);

+ (FFQuestionChapterItem *)itemFromResultSet:(FMResultSet *)rs;

+ (NSString *)titleForChapter:(NSInteger)chapter inCourse:(NSInteger)course certType:(NSInteger)certType;

@end


@interface FFQuestionSameExamPointItem : FFDBObject

JProperty(uint32_t  , id);
JProperty(uint32_t  , question_id);
JProperty(NSString *, indexId);//
JProperty(uint16_t  , course);
JProperty(NSString *, same_question);
JProperty(NSString *, same_comments);
JProperty(NSString *, comments);

+ (FFQuestionSameExamPointItem *)itemFromResultSet:(FMResultSet *)rs;

+ (NSArray *)getValidItems:(NSArray *)array;

@end

@interface FFKnowledgeItem : FFDBObject

@property (nonatomic) NSString * itemId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;

+ (FFKnowledgeItem *)itemFromDict:(NSDictionary *)dict;
- (NSDictionary *)dict;

@end

@interface FFKnowledgeClassifyItem : FFDBObject

@property (nonatomic) NSString* itemId;
@property (nonatomic) NSInteger course;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *knowledgeIds;
@property (nonatomic, strong) NSMutableArray *childList;

+ (FFKnowledgeClassifyItem *)itemFromDict:(NSDictionary *)dict;
- (NSDictionary *)dict;

@end
