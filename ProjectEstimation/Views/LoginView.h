//
//  LoginView.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

- (void)dismissLoginView;
- (void)loginViewDidLoginWithAccount:(NSString *)account password:(NSString *)password;
- (void)loginViewDidGotoRegisterView;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end
