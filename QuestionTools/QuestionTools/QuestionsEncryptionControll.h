//
//  QuestionsEncryptionControll.h
//  QuestionTools
//
//  Created by 林 on 2017/5/19.
//  Copyright © 2017年 林. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QuestionsEncryptionControll : NSViewController

@property (strong) IBOutlet NSProgressIndicator *barProgress;

@property (strong) IBOutlet NSTextField *textInput;
@property (strong) IBOutlet NSButton *eBtn;
@property (strong) IBOutlet NSButton *dBtn;

@property (assign) NSUInteger totalCount;
@property (strong) IBOutlet NSTextField *resultLb;

@property (strong) IBOutlet NSButton *makeBtn;
@property (assign) BOOL isWork;

@end
