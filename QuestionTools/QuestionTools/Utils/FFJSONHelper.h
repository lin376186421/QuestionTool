//
//  FFJSONHelper.h
//  FanHu
//
//  Created by PageZhang on 15/7/15.
//  Copyright (c) 2015年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>

// JSON对象
@interface NSString (JSON)
- (id)JSONObject_ff;
@end

@interface NSData (JSON)
- (id)JSONObject_ff;
@end


// JSON数据
@interface NSArray (JSON)
- (NSData *)JSONData_ff;
- (NSString *)JSONString_ff;
@end

@interface NSDictionary (JSON)
- (NSData *)JSONData_ff;
- (NSString *)JSONString_ff;
@end