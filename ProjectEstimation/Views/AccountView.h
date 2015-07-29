//
//  AccountView.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountViewDelegate <NSObject>

- (void)dismissAccountView;
- (void)accountViewChangeIcon;
- (void)accountViewChangeNickName;
- (void)logOut;

@end

@interface AccountView : UIView

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIButton *nicknameButton;
@property (weak, nonatomic) IBOutlet UILabel *projectNumberLabel;

@property (nonatomic, weak) id<AccountViewDelegate> delegate;

@end
