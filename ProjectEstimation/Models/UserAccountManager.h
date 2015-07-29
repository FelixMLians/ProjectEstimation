//
//  UserAccountManager.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/29.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"

@interface UserAccountManager : NSObject

+ (void)addUserAccountByAccount:(NSString *)account password:(NSString *)password;

+ (NSDictionary *)obtainUserAccountByAccount:(NSString *)account;

@end
