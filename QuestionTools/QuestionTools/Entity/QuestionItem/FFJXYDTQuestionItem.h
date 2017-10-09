//
//  FFJXYDTQuestionItem.h
//  333
//
//  Created by PageZhang on 16/7/5.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

@interface FFJXYDTQuestionItem : FFDBObject

JProperty(uint16_t  , ID);
JProperty(uint16_t  , Type);
JProperty(uint16_t  , kemu);
JProperty(NSString *, LicenseType);
JProperty(uint16_t  , chapterid);

JProperty(NSString *, Question);
JProperty(NSString *, AnswerTrue);

JProperty(NSString *, An1);
JProperty(NSString *, An2);
JProperty(NSString *, An3);
JProperty(NSString *, An4);

JProperty(NSString *, An5);
JProperty(NSString *, An6);
JProperty(NSString *, An7);

JProperty(NSString *, sinaimg);
JProperty(NSString *, video_url);

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
