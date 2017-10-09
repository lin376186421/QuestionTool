//
//  Base_DB.m
//  333
//
//  Created by cheng on 17/5/5.
//  Copyright © 2017年 Chelun. All rights reserved.
//

#import "Base_DB.h"

@implementation Base_DB

+ (id)dealItem
{
    Base_DB *item = [self new];
    
    NSLog(@"deal item %@", item.appName);
    
    [item compareSelfWithOld];
    
//    [item changeToCLDBFromLast:NO];
//    [item changeToCLDBFromLast:YES];
    
    return item;
}

+ (instancetype)itemWithName:(NSString *)name
{
    Base_DB *item = [self new];
    item.name = name;
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastId = 0;
        
        [self setUp];
    }
    return self;
}

- (NSString *)cldb_path
{
    return PATH(CLDB(_name));
}

- (NSString *)cldb_pathWithFromId:(NSInteger)fromId
{
    if (fromId > 0) {
        NSString *string = [NSString stringWithFormat:@"%@_%zd", _name, fromId];
        return PATH(CLDB(string));
    }
    return self.cldb_path;
}

- (void)compareSelfWithOld
{
    NSString *path = BUNDLE(_name, @"db");
    NSString *oldPath = BUNDLE(_oldName, @"db");
    
    self.lastId = 0;
    if (path.length <= 0) {
        NSLog(@"path为空，无效比对");
        return;
    } else if (oldPath.length <= 0) {
        NSLog(@"oldPath为空，无须比对");
        return;
    }
    
    [self compareSelf:path withOldPath:oldPath];
}

- (void)changeToCLDBFromLast:(BOOL)fromLast
{
    NSInteger fromId = (fromLast ? _lastId : 0);
    NSString *path = [self cldb_pathWithFromId:fromId];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSLog(@"cl_db 已存在");
        return;
    }
    
    NSLog(@"fromId : %zd", _lastId);
    
    [self changeToCLDBWithFromId:fromId];
}

- (void)removeCLDB
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:self.cldb_path error:nil];
}

#pragma mark - sub class method

- (void)setUp
{
    //_name
    
    //_oldName
    
    NSLog(@"base_db setup");
}

- (void)compareSelf:(NSString *)path withOldPath:(NSString *)oldPath
{
    NSLog(@"base_db compareSelf withOld");
    NSLog(@"path : %@", path);
    NSLog(@"oldPath : %@", oldPath);
}

- (void)changeToCLDB
{
    [self changeToCLDBFromLast:NO];
}

- (void)changeToCLDBWithFromId:(NSInteger)fromId
{
    NSLog(@"base_db changeToCLDBWithFromId:%zd", fromId);
}

@end
