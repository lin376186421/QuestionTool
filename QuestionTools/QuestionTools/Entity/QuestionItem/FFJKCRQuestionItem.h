//
//  FFJKCRQuestionItem.h
//  333
//
//  Created by PageZhang on 16/7/12.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

@interface FFJKCRQuestionItem : FFDBObject

JProperty(uint16_t  , question_type);
JProperty(uint16_t  , kemu);
JProperty(NSString *, license_type);
JProperty(uint16_t  , chapter_id);

JProperty(NSString *, question);
JProperty(NSString *, true_answer);

JProperty(NSString *, answer_1);
JProperty(NSString *, answer_2);
JProperty(NSString *, answer_3);
JProperty(NSString *, answer_4);

JProperty(NSString *, answer_5);
JProperty(NSString *, answer_6);
JProperty(NSString *, answer_7);

JProperty(NSString *, image);
JProperty(NSString *, video);

JProperty(NSString *, explain);
JProperty(uint16_t  , diff_degree);

@property (assign, nonatomic) uint16_t course;
@property (assign, nonatomic) uint16_t cert_type;

@property (assign, nonatomic) uint16_t category;
@property (assign, nonatomic) uint16_t type;
@property (assign, nonatomic) uint16_t media_type;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *answer;
// select * from chapter where mid=(select chapter_id from web_note where question like '%%' )
@end
