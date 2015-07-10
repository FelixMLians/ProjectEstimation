//
//  ProjectTableViewCell.h
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectView.h"

@protocol ProjectCellButtonDelegate <NSObject>

- (void)editProjectCell;
- (void)deleteProjectCell;

@end

@interface ProjectTableViewCell : UITableViewCell

@property (nonatomic, strong) ProjectView *projectView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, weak) id<ProjectCellButtonDelegate> delegate;

@end
