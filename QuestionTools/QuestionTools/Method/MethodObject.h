//
//  MethodObject.h
//  333
//
//  Created by cheng on 17/4/18.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FFJSONHelper.h"
#import "FFDatabase.h"
#import "NSArray+Utils.h"
#import "FFQuestionItem.h"
#import "FFJSONHelper.h"
#import "GTMBase64.h"

#define KJZ         @"question_690_100"
#define KJZ_JM      [NSString stringWithFormat:@"%@_jm", KJZ]

#define DB(name)    [NSString stringWithFormat:@"%@.db", name]
#define CLDB(name)  [NSString stringWithFormat:@"cl_%@.db", name]
#define PATH_DIR    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define PATH(name)  [PATH_DIR stringByAppendingPathComponent:name]
#define BUNDLE(name, type)  [[NSBundle mainBundle] pathForResource:name ofType:type]

extern NSString * sqlString(NSString *string);

extern NSString * readTxtFromPath(NSString *path);

extern NSArray * readExcelTxtFromPath(NSString *path);

extern NSString * sqlStringWithItem(FFQuestionItem *obj);
extern NSString * sqlPHPStringWithItem(FFQuestionItem *obj, BOOL php);

extern void writeTxtToPath(NSString *text, NSString *path);
extern void writeDbToPath(NSArray * array, NSString *path);
extern void writeTxtWithFileName(NSString *text, NSString *name);
extern void writeDbWithFileName(NSArray * array, NSString *name);
extern void writeSQLWithFileName(NSArray * questions, NSString *name);
extern void writeSQLPHPWithFileName(NSArray * questions, NSString *name, BOOL php);

@interface MethodObject : NSObject

+ (void)sqlFromDbPath:(NSString *)dbpath beginId:(NSInteger)beginId fileName:(NSString *)name php:(BOOL)php;

//返回差异度
+ (NSInteger)compareArray:(NSArray *)array1 withOther:(NSArray *)array2;

+ (NSInteger)compareString:(NSString *)string1 withOther:(NSString *)string2;

+ (NSArray *)chineseCharsFromString:(NSString *)string;

@end

@interface NSObject (Deal)

+ (void)deal;
+ (id)dealItem;

+ (NSArray *)itemsFromExcelTxtArray:(NSArray *)array;
+ (id)itemFromTxtArray:(NSArray *)array;

@end
