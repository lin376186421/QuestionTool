//
//  NSLogCell.m
//  QuestionTools
//
//  Created by 林 on 2017/5/22.
//  Copyright © 2017年 林. All rights reserved.
//

#import "NSLogCell.h"

@interface NSLogCell ()
{
    
}

@end

@implementation NSLogCell

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logLabel.maximumNumberOfLines = 0;
    // Do view setup here.
}

- (void)setLog:(NSString *)log
{
    self.logLabel.stringValue = log;
}

+ (CGFloat)cellHeightWithItem:(NSString *)log
{
    //todo 未搞懂
    CGRect rect = [log boundingRectWithSize:CGSizeMake(472.f, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontNameAttribute:[NSFont boldSystemFontOfSize:11]}];
    return rect.size.height;
}

@end
