//
//  ClientState.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "ClientState.h"
#import "Macro.h"

@implementation ClientState

+ (instancetype)shareInstance
{
    static ClientState *g_clientState;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_clientState = [[ClientState alloc] init];
    });
    return  g_clientState;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *index = [userdefault valueForKey:kCurrentAccoutStateKey];
        if (index == nil || 10 == [index integerValue])
        {
            self.currentAccountState  = AccountStateLogout;
        }
        else if (11 == [index integerValue]) {
            self.currentAccountState = AccountStateLogin;
        }
    }
    return self;
}

@end
