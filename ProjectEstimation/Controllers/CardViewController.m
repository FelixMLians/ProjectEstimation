//
//  CardViewController.m
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "CardViewController.h"


@interface CardViewController ()


@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpButtons];
}

- (void)setUpButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.center = self.view.center;
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMainPage) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
}

- (void)backToMainPage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
