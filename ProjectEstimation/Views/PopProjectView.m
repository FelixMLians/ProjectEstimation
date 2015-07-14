//
//  PopProjectView.m
//  ProjectEstimation
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "PopProjectView.h"

@implementation PopProjectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PopProjectView" owner:self options:nil];
        [self addSubview:self.contentView];
        
        self.contentView.layer.cornerRadius = 6.0;
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

- (IBAction)chooseBackgroundColor:(UIButton *)sender {
}

- (IBAction)cancelAction:(id)sender {
}

- (IBAction)confirmAction:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
@end
