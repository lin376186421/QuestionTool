//
//  FFCXTCourseItem.h
//  333
//
//  Created by PageZhang on 16/7/1.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFDBObject.h"

@interface FFCXTCourseItem : FFDBObject
JProperty(NSString *, course_id);
JProperty(NSString *, course_name);
@end
