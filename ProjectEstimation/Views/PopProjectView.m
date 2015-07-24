//
//  PopProjectView.m
//  ProjectEstimation
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "PopProjectView.h"

@interface PopProjectView()

@property (nonatomic, strong) UIImageView *selectImgView;

@end

@implementation PopProjectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PopProjectView" owner:self options:nil];
        [self addSubview:self.contentView];
        
        self.contentView.layer.cornerRadius = 6.0;
        self.titleTextField.delegate = self;
    }
    return self;
}

- (void)awakeFromNib {
    for (UIImageView *view in self.lineImageView) {
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0.5)];
    }
    
    CGRect frame = self.vertialLineImageView.frame;
    frame.size.width = 0.5;
    [self.vertialLineImageView setFrame:frame];
}

#pragma mark - setup Background Image Selected

- (void)setupBackgroundImage {
    
    if (self.imageIndex && self.imageIndex > 0) {
        
        if ([self.selectImgView respondsToSelector:@selector(removeFromSuperview)]) {
            [self.selectImgView respondsToSelector:@selector(removeFromSuperview)];
        }
        for (UIButton *button in self.bgColorButton) {
            
            if (button.tag == 200 + self.imageIndex - 1) {
                
                [button addSubview:self.selectImgView];
            }
        }
    }
}

#pragma mark - outlet methods

- (IBAction)chooseBackgroundColor:(UIButton *)sender {
    NSUInteger index = sender.tag - 200 + 1;
    self.imageIndex = index;
    
    [self setupBackgroundImage];
}

- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelPopProjectView)]) {
        [self.delegate cancelPopProjectView];
    }
}

- (IBAction)confirmAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(confirmPopProjectViewWithTitle:index:isEdit:)]) {
        
        if (![self.titleTextField.text isEqualToString:@""]) {
            [self.titleString setString:self.titleTextField.text];
        }
        else {
            [self.titleString setString:@"项目 X计划"];
        }
        
        if (!self.imageIndex || self.imageIndex == 0) {
            self.imageIndex = 2;
        }
        
        [self.delegate confirmPopProjectViewWithTitle:self.titleString index:self.imageIndex isEdit:self.isEdit];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [self.titleString setString:textField.text];
    }
    else {
        [self.titleString setString:@"项目 X计划"];
    }
    
    [self.titleTextField resignFirstResponder];
}

#pragma mark -

- (NSMutableString *)titleString {
    if (!_titleString) {
        _titleString = [[NSMutableString alloc] init];
    }
    return  _titleString;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 10, 16)];
        _selectImgView.image = [UIImage imageNamed:@"menu_selected_icon"];
    }
    return _selectImgView;
}

@end
