//
//  RegisterView.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "RegisterView.h"
#import "CLTools.h"
#import "CLProgressHUD.h"
#import "Macro.h"

@interface RegisterView()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *obtainCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (assign, nonatomic) NSInteger countDownNumber;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        
        self.accountTextField.delegate = self;
        self.passwordTextField.delegate = self;
    }
    return self;
}

#pragma mark - button click actions

- (IBAction)gobackToLastPage {
    if ([self.delegate respondsToSelector:@selector(dismissRegisterView)]) {
        [self.delegate dismissRegisterView];
    }
}

- (IBAction)confirmRegisterAction:(id)sender {
    if ([self.accountTextField.text isEqualToString:@""]||[self.passwordTextField.text isEqualToString:@""] || [self.codeTextField.text isEqualToString:@""])
    {
        [CLProgressHUD showErrorInView:self delegate:self title:@"手机号码,密码或验证码不能为空" duration:kCommonDurantion];
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
            if ([self.delegate respondsToSelector:@selector(registerViewDidRegisterWithAccount:password:verifyCode:)]) {
                [self.delegate registerViewDidRegisterWithAccount:self.accountTextField.text password:self.passwordTextField.text verifyCode:self.codeTextField.text];
            }
        }
    }
}

- (IBAction)sendIdentifyingCode:(UIButton *)sender {
    
    self.countDownNumber = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCodeButtonState) userInfo:nil repeats:YES];
    
    if ([self.delegate respondsToSelector:@selector(registerViewDidSendVerifyCode)]) {
        [self.delegate registerViewDidSendVerifyCode];
    }
}

- (void)updateCodeButtonState
{
    self.countDownNumber --;
    
    if (self.countDownNumber < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.obtainCodeButton.userInteractionEnabled = YES;
        [self.obtainCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else {
        self.obtainCodeButton.userInteractionEnabled = NO;
        [self.obtainCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%zd)",self.countDownNumber] forState:UIControlStateNormal];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (300 == textField.tag) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    else if (301 == textField.tag) {
        [textField resignFirstResponder];
        [self.accountTextField becomeFirstResponder];
    }
    else if (302 == textField.tag) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (300 == textField.tag) {
        self.accountIcon.highlighted = YES;
    }
    else if (301 == textField.tag) {
        self.passwordIcon.highlighted = YES;
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (300 == textField.tag) {
        if (textField.text && ![textField.text isEqualToString:@""]) {
            self.accountIcon.highlighted = YES;
        }
        else {
            self.accountIcon.highlighted = NO;
        }
    }
    else if (301 == textField.tag) {
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
    if (301 == textField.tag)
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
    
    if (300 == textField.tag)
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
