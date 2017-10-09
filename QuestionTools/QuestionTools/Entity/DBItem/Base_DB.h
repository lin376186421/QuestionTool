//
//  Base_DB.h
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base_DB : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *oldName;

@property (nonatomic, strong) NSString *appName;

@property (nonatomic) NSInteger lastId;

@property (nonatomic, readonly) NSString *cldb_path;

+ (instancetype)itemWithName:(NSString *)name;

- (void)removeCLDB;

//子类重写
- (void)setUp;

- (void)compareSelf:(NSString *)path withOldPath:(NSString *)oldPath;

- (NSString *)cldb_pathWithFromId:(NSInteger)fromId;
- (void)changeToCLDB;
- (void)changeToCLDBFromLast:(BOOL)fromLast;
- (void)changeToCLDBWithFromId:(NSInteger)fromId;

@end
