//
//  AccountView.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "AccountView.h"

@interface AccountView()

@end

@implementation AccountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - button click action

- (IBAction)gobackToLastPage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dismissAccountView)]) {
        [self.delegate dismissAccountView];
    }
}

- (IBAction)changeIconAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountViewChangeIcon)]) {
        [self.delegate accountViewChangeIcon];
    }
}

- (IBAction)changeNicknameAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountViewChangeNickName)]) {
        [self.delegate accountViewChangeNickName];
    }
}

- (IBAction)logOutAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(logOut)]) {
        [self.delegate logOut];
    }
}

@end
