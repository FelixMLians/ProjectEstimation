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
#import "UserAccountManager.h"
#import "AccountView.h"

@interface LoginViewController ()<LoginViewDelegate, RegisterViewDelegate, AccountViewDelegate>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) AccountView *accountView;

@end

@implementation LoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - intial ui

- (void)initialUI
{
    if ([ClientState shareInstance].currentAccountState == AccountStateLogout) {
        [self addLoginView];
        [self.view addSubview:self.loginView];
    }
    else if ([ClientState shareInstance].currentAccountState == AccountStateLogin) {
        [self addAccountView];
        [self.view addSubview:self.accountView];
    }
}

#pragma mark - LoginViewDelegate

- (void)dismissLoginView {
    [self gobackToLastPage];
}

- (void)loginViewDidLoginWithAccount:(NSString *)account password:(NSString *)password {
    
    NSMutableString *accountString = [[NSMutableString alloc] initWithString:@"15858286609"];
    NSMutableString *passString = [[NSMutableString alloc] initWithString:@"123456"];
    NSDictionary *dict = [UserAccountManager obtainUserAccountByAccount:account];
    if (dict && ![dict[@"account"] isEqualToString:@""]) {
        [accountString setString:dict[@"account"]];
        [passString setString:dict[@"password"]];
    }
    if ([account isEqualToString:accountString] && [password isEqualToString:passString]) {
        [CLProgressHUD showSuccessInView:self.view
                                delegate:self
                                   title:@"登陆成功"
                                duration:kCommonDurantion];
        [ClientState shareInstance].currentAccountState = AccountStateLogin;
        
        [self addAccountView];
        [UIView transitionFromView:self.loginView
                            toView:self.accountView
                          duration:1.0
                           options: (UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCurlUp)
                        completion:^(BOOL finished) {
                            [self.view addSubview:self.accountView];
                        }];
    }
    else {
        [CLProgressHUD showErrorInView:self.view
                              delegate:self
                                 title:@"登陆失败"
                              duration:kCommonDurantion];
    }
}

- (void)loginViewDidGotoRegisterView {
    
    RegisterView *registerView = [[RegisterView alloc] initWithFrame:self.view.bounds];
    registerView.tag = 400;
    registerView.delegate = self;
    
    [UIView transitionFromView:self.loginView
                        toView:registerView
                      duration:1.0
                       options: (UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCurlUp)
                    completion:^(BOOL finished) {
                        [self.view addSubview:registerView];
                    }];
}

#pragma mark - RegisterViewDelegate

- (void)dismissRegisterView {
    RegisterView *view = (RegisterView *)[self.view viewWithTag:400];
    
    [UIView transitionFromView:view
                        toView:self.loginView
                      duration:1.0
                       options: (UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
}

- (void)registerViewDidRegisterWithAccount:(NSString *)account
                                  password:(NSString *)password
                                verifyCode:(NSString *)code {
    if ([code isEqualToString:@"123456"]) {
        [UserAccountManager addUserAccountByAccount:account password:password];
        [CLProgressHUD showSuccessInView:self.view
                                delegate:self
                                   title:@"注册成功！"
                                duration:kCommonDurantion];
        
        [self performSelector:@selector(dismissRegisterView)
                   withObject:nil
                   afterDelay:kCommonDurantion];
        
    }
    else {
        [CLProgressHUD showErrorInView:self.view
                              delegate:self
                                 title:@"手机验证码不正确！"
                              duration:kCommonDurantion];
    }
}

- (void)registerViewDidSendVerifyCode {
    CLog(@"Send verify code to your iphone!");
}

#pragma mark - AccountViewDelegate

- (void)dismissAccountView {
    [self gobackToLastPage];
}

- (void)accountViewChangeIcon
{
    
}

- (void)accountViewChangeNickName
{
    
}

- (void)logOut
{
    [self addLoginView];
    [UIView transitionFromView:self.accountView
                        toView:self.loginView
                      duration:1.0
                       options: (UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        [self.view addSubview:self.loginView];
                    }];
    [ClientState shareInstance].currentAccountState = AccountStateLogout;
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
}

- (void)addAccountView
{
    self.accountView = [[AccountView alloc] initWithFrame:self.view.bounds];
    self.accountView.delegate = self;
}
@end
