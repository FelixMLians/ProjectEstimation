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
        
        [self setUpUI];
    
        
    }
    return self;
}

#pragma mark - 设置视图

- (void)setUpUI {
    
    // 添加项目视图
    self.projectView = [[ProjectView alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
    self.projectView.selected = YES;
    self.projectView.backgroundColor = [UIColor clearColor];
    self.projectView.nameString = @"";
    //    self.projectView.layer.shadowColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //    self.projectView.layer.shadowOpacity = 0.5;
    //    self.projectView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    //    self.projectView.layer.shadowRadius = 3.0;
    [self.contentView addSubview:self.projectView];
    self.projectView.center = CGPointMake(([UIScreen mainScreen].bounds.size.width - 100)/2, self.center.y);
    
    self.currentProjectMode = ProjectCellModeNormal;
}

- (void)addEditButtonAndDeleteButton
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(self.projectView.frame.origin.x - 15 - 44, self.projectView.frame.origin.y + self.projectView.frame.size.height /2 - 22, 40, 40);
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_book_del"] forState:UIControlStateNormal];
    self.deleteButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(self.projectView.frame.origin.x + self.projectView.frame.size.width + 15, self.projectView.frame.origin.y + self.projectView.frame.size.height /2 - 22, 40, 40);
    [self.editButton setImage:[UIImage imageNamed:@"btn_book_edit"] forState:UIControlStateNormal];
    self.editButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.editButton];
    [self.editButton addTarget:self action:@selector(editButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - private methods

- (void)deleteButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteProjectCell:)]) {
        [self.delegate deleteProjectCell:self];
    }
}

- (void)editButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editProjectCell:)]) {
        [self.delegate editProjectCell:self];
    }
}

- (void)setCurrentProjectMode:(ProjectCellMode)currentProjectMode {
    _currentProjectMode = currentProjectMode;
    
    if (currentProjectMode == ProjectCellModeNormal) {
        [self.deleteButton removeFromSuperview];
        [self.editButton removeFromSuperview];
    }
}

#pragma mark - 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
