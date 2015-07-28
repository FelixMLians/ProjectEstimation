//
//  LoginViewController.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import "ClientState.h"
#import "CLProgressHUD.h"
#import "Macro.h"
#import "RegisterView.h"

@interface LoginViewController ()<LoginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
}

#pragma mark - intial ui

- (void)initialUI
{
    if ([ClientState shareInstance].currentAccountState == AccountStateLogout) {
        [self addLoginView];
    }
}

#pragma mark - LoginViewDelegate

- (void)dismissLoginView {
    [self gobackToLastPage];
}

- (void)loginViewDidLoginWithAccount:(NSString *)account password:(NSString *)password {
    if ([account isEqualToString:@"123"] && [password isEqualToString:@"123"]) {
        [CLProgressHUD showSuccessInView:self.view delegate:self title:@"登陆成功" duration:kCommonDurantion];
    }
    else {
        [CLProgressHUD showErrorInView:self.view delegate:self title:@"登陆失败" duration:kCommonDurantion];
    }
}

- (void)loginViewDidGotoRegisterView {
    [UIView animateWithDuration:kCommonDurantion animations:^{
        RegisterView *registerView = [[RegisterView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:registerView];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - private method

- (void)gobackToLastPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addLoginView
{
    self.loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    self.loginView.delegate = self;
    [self.view addSubview:self.loginView];
}
@end
