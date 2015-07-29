//
//  LoginView.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "LoginView.h"
#import "CLProgressHUD.h"
#import "Macro.h"
#import "CLTools.h"

@interface LoginView()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        
        self.accountTextField.delegate = self;
        self.passwordTextField.delegate = self;
    }
    return self;
}

#pragma mark - button click actions

- (IBAction)gobackToLastPage {
    if ([self.delegate respondsToSelector:@selector(dismissLoginView)]) {
        [self.delegate dismissLoginView];
    }
}

- (IBAction)confirmLoginAction:(id)sender {
    if ([self.accountTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""])
    {
        [CLProgressHUD showErrorInView:self delegate:self title:@"手机号码或密码不能为空" duration:kCommonDurantion];
        return;
    }
    else{
        if (self.accountTextField.text.length != 11 || ![CLTools isValidatePhoneNumber:self.accountTextField.text])
        {
            [CLProgressHUD showErrorInView:self delegate:self title:@"手机号码格式不对" duration:kCommonDurantion];
            return;
        }
        else if (self.passwordTextField.text.length < 6 || ![CLTools isValidateString:self.passwordTextField.text])
        {
            [CLProgressHUD showErrorInView:self delegate:self title:@"密码由6-15位字符或字母组成" duration:kCommonDurantion];
            return;
        }
        else {
            if ([self.delegate respondsToSelector:@selector(loginViewDidLoginWithAccount:password:)]) {
                [self.delegate loginViewDidLoginWithAccount:self.accountTextField.text password:self.passwordTextField.text];
            }
        }
    }
}

- (IBAction)gotoRegisterPage {
    if ([self.delegate respondsToSelector:@selector(loginViewDidGotoRegisterView)]) {
        [self.delegate loginViewDidGotoRegisterView];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (200 == textField.tag) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    else if (201 == textField.tag) {
    [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
    if (200 == textField.tag) {
        self.accountIcon.highlighted = YES;
    }
    else if (201 == textField.tag) {
        self.passwordIcon.highlighted = YES;

    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (200 == textField.tag) {
        if (textField.text && ![textField.text isEqualToString:@""]) {
            self.accountIcon.highlighted = YES;
        }
        else {
            self.accountIcon.highlighted = NO;
        }
    }
    else if (201 == textField.tag) {
        if (textField.text && ![textField.text isEqualToString:@""]) {
            self.passwordIcon.highlighted = YES;
        }
        else {
            self.passwordIcon.highlighted = NO;
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (201 == textField.tag)
    {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            char character = [string characterAtIndex:loopIndex];
            NSString *characterStr = [NSString stringWithFormat:@"%c",character];
            NSString *totalStr = @"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            if (!([totalStr rangeOfString:characterStr].length > 0)) return NO;
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 16) return NO;
        return YES;
    }
    
    if (200 == textField.tag)
    {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) return NO;//限制长度
        return YES;
    }
    
    else
        return YES;
}

@end
