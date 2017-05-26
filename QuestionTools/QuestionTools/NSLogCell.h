//
//  NSLogCell.h
//  QuestionTools
//
//  Created by 林 on 2017/5/22.
//  Copyright © 2017年 林. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSLogCell : NSViewController

@property (nonatomic, strong) NSString *log;

@property (strong) IBOutlet NSTextField *logLabel;

+ (CGFloat)cellHeightWithItem:(NSString *)log windowFrame:(NSRect)windowFrame;

@end
