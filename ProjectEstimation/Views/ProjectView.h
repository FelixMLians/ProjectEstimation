//
//  ProjectView.h
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectView : UIView

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, getter = isSelected) BOOL selected;

@end
