//
//  FFJKBDQuestionItem.h
//  333
//
//  Created by PageZhang on 16/1/15.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

//typedef enum {
//    DTCertTypeXiaoche = 1, // 小车
//    DTCertTypeKeche = 2, // 客车
//    DTCertTypeHuoche = 4, // 货车
//    DTCertTypeMotoche = 8, // 摩托车
//    DTCertTypeTaxi = 16, // 出租车
//    DTCertTypeHuoyun = 32, // 货运
//    DTCertTypeJiaolian = 64, // 教练
//    DTCertTypeKeyun = 128, // 客运
//    DTCertTypeWeixian = 256, // 危险品
//    DTCertTypeTaxiInternet = 512, //网约车
//} DTCertType;

// 驾考宝典
@interface FFJKBDQuestionItem : FFDBObject

JProperty(uint32_t  , question_id);
JProperty(uint16_t  , media_type);
JProperty(uint16_t  , chapter_id);

JProperty(NSString *, label);
JProperty(NSString *, question);

//JProperty(NSData   *, media_content); 
JProperty(uint16_t  , media_width);
JProperty(uint16_t  , media_height);

JProperty(uint16_t  , answer);

JProperty(NSString *, option_a);
JProperty(NSString *, option_b);
JProperty(NSString *, option_c);
JProperty(NSString *, option_d);

JProperty(NSString *, option_e);
JProperty(NSString *, option_f);
JProperty(NSString *, option_g);
JProperty(NSString *, option_h);

JProperty(NSString *, explain);
JProperty(uint16_t  , difficulty);
JProperty(double    , wrong_rate);

JProperty(uint16_t  , option_type);

@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSData *media_content;

@property (assign, nonatomic) uint16_t course;
@property (assign, nonatomic) uint16_t cert_type;
@property (strong, nonatomic) NSString *answer_char;

@end

@interface FFJKBDKnowledgeItem : FFDBObject

JProperty(NSString *, name);
JProperty(NSString *, value);
JProperty(NSString *, groups);

@end

@interface FFJKBDKnowledgeIdItem : FFDBObject {
    
}

JProperty(NSString *, _id);
JProperty(uint32_t, question_id);
JProperty(uint16_t, knowledge_id);

@property (nonatomic) NSInteger course;

@end
