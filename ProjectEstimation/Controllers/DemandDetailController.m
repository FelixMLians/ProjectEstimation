//
//  DemandDetailController.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/24.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandDetailController.h"

@interface DemandDetailController ()

@end

@implementation DemandDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - 



#pragma mark - private method

- (void)initUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    imageView.image = [UIImage imageNamed:@"demandBg.jpg"];
    [self.view addSubview:imageView];
}

@end
