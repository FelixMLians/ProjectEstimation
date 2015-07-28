//
//  LoginView.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "LoginView.h"

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
    if ([self.delegate respondsToSelector:@selector(loginViewDidLoginWithAccount:password:)]) {
        [self.delegate loginViewDidLoginWithAccount:self.accountTextField.text password:self.passwordTextField.text];
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


@end
