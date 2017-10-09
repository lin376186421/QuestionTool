
//
//  FFJSONHelper.m
//  FanHu
//
//  Created by PageZhang on 15/7/15.
//  Copyright (c) 2015年 PG. All rights reserved.
//

#import "FFJSONHelper.h"

@implementation NSString (JSON)
- (id)JSONObject_ff {
    NSData *json = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [json JSONObject_ff];
}
@end

@implementation NSData (JSON)
- (id)JSONObject_ff {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}
@end


@implementation NSArray (JSON)
- (NSData *)JSONData_ff {
    return self.count ? [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] : nil;
}
- (NSString *)JSONString_ff {
    NSData *data = [self JSONData_ff];
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}
@end

@implementation NSDictionary (JSON)
- (NSData *)JSONData_ff {
    return self.count ? [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] : nil;
}
- (NSString *)JSONString_ff {
    NSData *data = [self JSONData_ff];
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}
@end

