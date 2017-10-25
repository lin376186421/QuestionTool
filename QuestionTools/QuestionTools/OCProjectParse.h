//
//  OCProjectParse.h
//  333
//
//  Created by cheng on 2017/9/29.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCProjectParse : NSObject

+ (BOOL)isValidProjectPath:(NSString *)path;

+ (NSArray *)targetsFromProjectPath:(NSString *)path;

+ (NSString *)parseProjectWithPath:(NSString *)path targetName:(NSString *)targetName1 andTargetName:(NSString *)targetName2;

@end


@interface NSString (ClearString)

- (NSString *)clearString;

@end
