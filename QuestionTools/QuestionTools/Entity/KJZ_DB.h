//
//  KJZ_DB.h
//  333
//
//  Created by cheng on 17/5/8.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "Base_DB.h"
#import "KJZChapter.h"

@interface KJZ_DB : Base_DB

@property (nonatomic, strong) Base_DB *item;
@property (nonatomic) NSInteger certType;
@property (nonatomic) NSInteger course;

@property (nonatomic) BOOL compareLast;

+ (KJZ_DB *)itemWith:(Base_DB *)item;

- (void)compareCourse:(NSInteger)course;

- (NSMutableArray *)questions;

- (NSString *)bundleJMPath;

+ (void)updateKJZWithItem:(Base_DB *)item;
+ (void)updateSQL;
+ (void)updateDB;

- (void)updateKaojiazhao;

- (void)foundCourse1andCourse4Same;

@end
