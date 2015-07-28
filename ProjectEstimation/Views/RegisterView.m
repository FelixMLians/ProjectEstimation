//
//  RegisterView.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *obtainCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

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
    [self removeFromSuperview];
}

- (IBAction)confirmRegisterAction:(id)sender {
}

- (IBAction)sendIdentifyingCode:(id)sender {
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

@end
