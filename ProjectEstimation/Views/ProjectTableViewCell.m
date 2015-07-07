//
//  ProjectTableViewCell.m
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

- (id)init
{
    self = [super init];
    if (self) {
    self.projectView = [[ProjectView alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
    self.projectView.selected = YES;
    self.projectView.backgroundColor = [UIColor orangeColor];
    self.projectView.nameString = @"";
    [self.contentView addSubview:self.projectView];
        
    self.projectView.center = CGPointMake(([UIScreen mainScreen].bounds.size.width - 100)/2, self.center.y);
    NSLog(@"%f",self.center.x);
    }
    return self;
}

- (void)awakeFromNib {
//    self.projectView = [[ProjectView alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
//    self.projectView.selected = YES;
//    self.projectView.backgroundColor = [UIColor orangeColor];
//    self.projectView.nameString = @"点金盒项目";
//    [self.contentView addSubview:self.projectView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
