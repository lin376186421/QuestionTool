//
//  KJZSameComment.h
//  333
//
//  Created by cheng on 17/5/18.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJZSameComment : NSObject

@end

@interface KJZSameCommentResult : NSObject

@property (nonatomic) NSInteger score;

@property (nonatomic, strong) NSArray *diffCommentQues;

@property (nonatomic, strong) NSDictionary *sameCommentDict;
@property (nonatomic, strong) NSDictionary *diffCommentDict;

@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger sameCount;

- (NSString *)desc;

@end
