//
//  LogCellPopView.m
//  QuestionTools
//
//  Created by 林 on 2017/5/25.
//  Copyright © 2017年 林. All rights reserved.
//

#import "LogCellPopView.h"

@interface LogCellPopView ()

@end

@implementation LogCellPopView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)action1:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_POP_ACTION_1 object:nil];
}

- (IBAction)action2:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_POP_ACTION_2 object:nil];
}

@end
