//
//  PlistFileExchangeController.m
//  QuestionTools
//
//  Created by cheng on 2017/10/16.
//  Copyright © 2017年 林. All rights reserved.
//

#import "PlistFileExchangeController.h"

@interface PlistFileExchangeController () {
    
    IBOutlet NSTextField *PathTextField;
    IBOutlet NSButton *submitBtn;
    IBOutlet NSTextView *resultLogView;
}

@end

@implementation PlistFileExchangeController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    
}

- (NSString *)newPath:(NSString *)path withFileType:(NSString *)fileType
{
    NSMutableArray *names = [[[path lastPathComponent] componentsSeparatedByString:@"."] mutableCopy];
    if (names.count > 1) {
        [names removeLastObject];
    }
    [names addObject:fileType];
    NSString *newPath = [path stringByDeletingLastPathComponent];
    newPath = [newPath stringByAppendingPathComponent:[names componentsJoinedByString:@"."]];
    return newPath;
}

- (IBAction)submitAction:(id)sender {
    NSString *path = [PathTextField stringValue];
    if (path.length <= 0) {
        [self setResultString:@"path 为空"];
        return;
    }
    
    if ([path hasSuffix:@".plist"]) {
        id obj = [NSDictionary dictionaryWithContentsOfFile:path];
        if (!obj) {
            obj = [NSArray arrayWithContentsOfFile:path];
        }
        if (obj) {
            NSString *string = [(NSDictionary *)obj JSONString_ff];
            if (string) {
                NSString *newPath = [self newPath:path withFileType:@"txt"];
                writeTxtToPath(string, newPath);
                [self setResultString:newPath];
            }
        } else {
            [self setResultString:@"obj 为空"];
        }
    } else if ([path hasSuffix:@".txt"] || [path hasSuffix:@".json"]) {
        NSString *string = readTxtFromPath(path);
        id obj = [string JSONObject_ff];
        if (obj) {
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                NSString *newPath = [self newPath:path withFileType:@"plist"];
                [(NSDictionary *)obj writeToFile:newPath atomically:YES];
                [self setResultString:newPath];
            }
        } else {
            [self setResultString:@"json 格式不正确"];
        }
    } else {
        [self setResultString:@"无法识别的格式"];
    }
}

- (void)setResultString:(NSString *)result
{
    [resultLogView setString:result];
}

@end
