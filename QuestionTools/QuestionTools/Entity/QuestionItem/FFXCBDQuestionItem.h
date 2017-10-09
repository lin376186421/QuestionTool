//
//  FFXCBDQuestionItem.h
//  333
//
//  Created by PageZhang on 16/7/7.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

@interface FFXCBDQuestionItem : FFDBObject

JProperty(uint32_t  , subject_id); // 科目 1、4
JProperty(uint32_t  , question_type_id); // 答案类型 判断1、3  单选2、4  多选5
JProperty(uint32_t  , content_type_id); // 题目类型 文字1、3  图片2、4  视频5
JProperty(uint32_t  , exam_driver_type_id); // 驾照类型  1、3、2、4

JProperty(NSString *, content);
JProperty(NSString *, media);
JProperty(NSString *, right_answers);
JProperty(NSString *, explain);

JProperty(NSString *, option1);
JProperty(NSString *, option2);
JProperty(NSString *, option3);
JProperty(NSString *, option4);

@property (assign, nonatomic) uint16_t course;
@property (assign, nonatomic) uint16_t category;
@property (assign, nonatomic) uint16_t type;
@property (assign, nonatomic) uint16_t media_type;
@property (strong, nonatomic) NSString *answer;
// select * from chapter where id=(select chapter_id from question where content like '%%' )
@end
