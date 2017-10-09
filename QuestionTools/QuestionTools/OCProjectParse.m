//
//  OCProjectParse.m
//  333
//
//  Created by cheng on 2017/9/29.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "OCProjectParse.h"

@implementation OCProjectParse

+ (NSString *)parseProjectWithPath:(NSString *)path targetName:(NSString *)targetName1 andTargetName:(NSString *)targetName2
{
//   NSString *path = @"/Users/wangcheng/Desktop/Test/ProjectHelper/ProjectHelper.xcodeproj/project.pbxproj";
    
//    NSString *path = @"/Users/wangcheng/Desktop/Test/ProjectHelper/ProjectHelper.xcodeproj";
//    path = @"/Users/wangcheng/Desktop/交接内容/333/333.xcodeproj";
//    path = @"/Users/wangcheng/Documents/Git/chelun/DrivingTest/DrivingTest.xcodeproj";
    NSString *realpath = [path stringByAppendingPathComponent:@"project.pbxproj"];
    
    NSString *txt = readTxtFromPath(realpath);
    
//    NSString *name = [[path pathComponents] objectAtIndex:[path pathComponents].count - 3];
//    writeTxtWithFileName(txt, name);
    
    return [self foundDiffFileWithTarget:targetName1 andTarget:targetName2 fromText:txt];
}

+ (NSString *)nameWithType:(NSInteger)type
{
    NSString *name = nil;
    switch (type) {
        case 0:
            name = @"PBXNativeTarget";
            break;
        case 1:
            name = @"PBXSourcesBuildPhase";
            break;
        case 2:
            name = @"PBXResourcesBuildPhase";
            break;
        default:
            break;
    }
    return name;
}

+ (NSString *)keyOfPBXBuildPhase:(NSString *)name begin:(BOOL)begin
{
    return [NSString stringWithFormat:@"/* %@ %@ section */", begin ? @"Begin" : @"End", name];
}

+ (NSString *)contentStringWithKeyName:(NSString *)name formText:(NSString *)text
{
    if (text && name) {
        NSRange beginRange = [text rangeOfString:[self keyOfPBXBuildPhase:name begin:YES]];
        NSRange endRange = [text rangeOfString:[self keyOfPBXBuildPhase:name begin:NO]];
        
        if (beginRange.length && endRange.length) {
            return [text substringWithRange:NSMakeRange(beginRange.location + beginRange.length, endRange.location - beginRange.location - beginRange.length)];
        }
    }
    return nil;
}

+ (NSDictionary *)itemsFromContentString:(NSString *)string key:(NSString *)key keySep:(NSString *)keySep indexCode:(BOOL)indexCode
{
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *groupSepStr = @"};";
    NSString *newStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([newStr hasSuffix:groupSepStr]) {
        newStr = [newStr substringToIndex:newStr.length - groupSepStr.length];
    }
    
    NSArray *array = [newStr componentsSeparatedByString:groupSepStr];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *indexName = [[obj componentsSeparatedByString:@" */"] firstObject];
        if (indexCode) {
            indexName = [[indexName componentsSeparatedByString:@" /* "] firstObject];
        } else {
            indexName = [[indexName componentsSeparatedByString:@" /* "] lastObject];
        }
        
        NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
        NSString *keyName = [NSString stringWithFormat:@"%@ = (", key];
        NSString *fileString = [[obj componentsSeparatedByString:keyName] lastObject];
        NSArray *fileArray = [fileString componentsSeparatedByString:@" */,"];
        [fileArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = [obj componentsSeparatedByString:@" /* "];
            if (array.count == 2) {
                NSString *keyStr = nil;
                if (keySep) {
                    NSArray *arr = [array.lastObject componentsSeparatedByString:keySep];
                    keyStr = [arr firstObject];
                } else {
                    keyStr = [array lastObject];
                }
                [fileDict setObject:[array firstObject] forKey:[keyStr clearString]];
            }
        }];
        
        [result setObject:fileDict forKey:[indexName clearString]];
    }];
    return result;
}

+ (NSDictionary *)targetsFromtext:(NSString *)text
{
    NSString *keyName = [self nameWithType:0];
    NSString *content = [self contentStringWithKeyName:keyName formText:text];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (content) {
        return [self itemsFromContentString:content key:@"buildPhases" keySep:nil indexCode:NO];
    }
    return result;
}

+ (NSString *)foundCodeWithName:(NSString *)name fromDict:(NSDictionary *)dict
{
    __block NSString *code = nil;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyName = [@"PBX" stringByAppendingString:key];
        if ([name rangeOfString:keyName].length) {
            code = obj;
            *stop = YES;
        }
    }];
    code = [code clearString];
    return code;
}

+ (NSString *)foundDiffFileWithTarget:(NSString *)target1 andTarget:(NSString *)target2 fromText:(NSString *)text
{
    NSDictionary *targets = [self targetsFromtext:text];
    
    NSDictionary *dict1 = [targets objectForKey:target1];
    NSDictionary *dict2 = [targets objectForKey:target2];
    
    if (dict1 && dict2) {
        NSMutableString *mstring = [NSMutableString string];
        [mstring appendString:@"\n"];
        for (int i=1; i<=2; i++) {
            NSString *keyName = [self nameWithType:i];
            [mstring appendFormat:@"%@\n", keyName];
            
            NSString *code1 = [self foundCodeWithName:keyName fromDict:dict1];
            NSString *code2 = [self foundCodeWithName:keyName fromDict:dict2];
            
            if (code1 && code2) {
                NSString *content = [self contentStringWithKeyName:keyName formText:text];
                if (content) {
                    NSDictionary *dict = [self itemsFromContentString:content key:@"files" keySep:@" in " indexCode:YES];
                    
                    NSArray *file1 = [[dict objectForKey:code1] allKeys];
                    NSArray *file2 = [[dict objectForKey:code2] allKeys];
                    
                    NSMutableArray *array1 = [file1 mutableCopy];
                    NSMutableArray *array2 = [file2 mutableCopy];
                    [array1 removeObjectsInArray:file2];
                    [array2 removeObjectsInArray:file1];
                    
                    [mstring appendFormat:@"file count: %@ = %zd, %@ = %zd\n",target1, file1.count, target2, file2.count];
                    
                    if (array1.count && file2.count) {
                        [mstring appendFormat:@"%@\n%@\n\n", target1, [array1 JSONString_ff]];
                    }
                    
                    if (array2.count && file1.count) {
                        [mstring appendFormat:@"%@\n%@\n\n", target2, [array2 JSONString_ff]];
                    }
                    
                    if (array1.count == 0 && array2.count == 0) {
                        [mstring appendString:@"未找到不同文件\n\n"];
                    }
                    
                    [mstring appendString:@"\n"];
                }
            }
        }
//        NSLog(@"\n%@", mstring);
//        writeTxtWithFileName(mstring, [NSString stringWithFormat:@"%@-%@", target1, target2]);
        return mstring;
    } else {
        NSString *string = [NSString stringWithFormat:@"未找到target = %@", (dict1?target2:target1)];
//        NSLog(@"%@", string);
        return string;
    }
}

+ (NSDictionary *)propertyListWithString:(NSString *)string
{
    NSPropertyListFormat format;
    NSError *errorDesc = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
    
    NSString *name = [NSString stringWithFormat:@"%.0f", CFAbsoluteTimeGetCurrent()];
    writeTxtWithFileName([dict JSONString_ff], [name stringByAppendingString:@"_dict"]);
    
    return dict;
}

+ (NSDictionary *)propertyListWithPath:(NSString *)path
{
    NSPropertyListFormat format;
    NSError *errorDesc = nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
    
    NSString *name = [NSString stringWithFormat:@"%.0f", CFAbsoluteTimeGetCurrent()];
    writeTxtWithFileName([dict JSONString_ff], [name stringByAppendingString:@"_dict"]);
    
    return dict;
}

@end

@implementation NSString (ClearString)

- (NSString *)clearString
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return str;
}

@end
