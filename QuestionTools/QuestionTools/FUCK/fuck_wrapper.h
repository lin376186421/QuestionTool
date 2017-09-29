//
//  fuck_wrapper.h
//  Secret
//
//  Created by PageZhang on 16/4/6.
//  Copyright © 2016年 PageZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, fuckWrapper) {
    questionWrapper,
    answerWrapper,
    commentsWrapper
};

NSString *buy_coffee(NSString *material, fuckWrapper wrapper); // 解密
NSString *sell_coffee(NSString *material, fuckWrapper wrapper); // 加密