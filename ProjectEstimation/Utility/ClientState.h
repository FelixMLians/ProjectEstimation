//
//  ClientState.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AccountState) {
    AccountStateLogout,      //10
    AccountStateLogin,       //11
};

@interface ClientState : NSObject

@property (nonatomic, assign) AccountState currentAccountState;

+ (instancetype)shareInstance;

@end
