//
//  FFCXTQuestionItem.h
//  333
//
//  Created by PageZhang on 16/7/1.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

// 车学堂
@interface FFCXTQuestionItem : FFDBObject

JProperty(uint32_t  , project_id);
JProperty(NSString *, project_name);

JProperty(NSString *, course_id); // array
JProperty(NSString *, course_list); // array

JProperty(uint32_t  , exam_id); // number
JProperty(NSString *, exam_title);
JProperty(NSString *, exam_pic);
JProperty(uint32_t  , exam_type);

JProperty(NSString *, answer); // items.answer array
JProperty(NSString *, options); // items.title array
JProperty(uint16_t  , answer_count);
JProperty(uint16_t  , option_count);

JProperty(NSString *, analytical);
JProperty(uint16_t  , difficulty);
// select course_list from t_question where exam_title like '%的救护车驶来时，以下做法正%'
@end
