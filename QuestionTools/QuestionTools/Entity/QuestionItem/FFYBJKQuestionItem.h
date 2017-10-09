//
//  FFYBJKQuestionItem.h
//  333
//
//  Created by PageZhang on 16/7/6.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

@interface FFYBJKQuestionItem : FFDBObject

JProperty(NSString *, tm); // 题目+选项
JProperty(NSString *, tp); // 图片
JProperty(NSString *, da); // 答案
JProperty(uint32_t  , tx); // 类型
JProperty(NSString *, fx); // 解释

JProperty(NSString *, TikuID);
JProperty(NSString *, DriveType);
JProperty(uint32_t  , EasyRank);

@property (assign, nonatomic) uint16_t course;
@property (assign, nonatomic) uint16_t cert_type;

@property (assign, nonatomic) uint16_t category;
@property (assign, nonatomic) uint16_t type;
@property (assign, nonatomic) uint16_t media_type;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *option_a;
@property (strong, nonatomic) NSString *option_b;
@property (strong, nonatomic) NSString *option_c;
@property (strong, nonatomic) NSString *option_d;
@property (strong, nonatomic) NSString *answer;
// select * from app_exam_sort where sortID= ( select sortID from app_exam_main where baseID= (select baseID from app_exam_base where tm like '%%' ))
@end
