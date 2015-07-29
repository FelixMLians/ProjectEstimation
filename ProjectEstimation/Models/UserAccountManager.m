//
//  UserAccountManager.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/29.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "UserAccountManager.h"

@implementation UserAccountManager

+ (void)addUserAccountByAccount:(NSString *)account password:(NSString *)password {
    NSString *tableName = @"userAccount";
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"userAccount.db"];
    [store createTableWithName:tableName];
    NSString *key = account;
    NSDictionary *user = @{@"account": account, @"password": password};
    [store putObject:user withId:key intoTable:tableName];
}

+ (NSDictionary *)obtainUserAccountByAccount:(NSString *)account
{
    NSString *tableName = @"userAccount";
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"userAccount.db"];
    
    NSDictionary *dict = [store getObjectById:account fromTable:tableName];
    if (dict) {
        return dict;
    }
    return nil;
}
@end
