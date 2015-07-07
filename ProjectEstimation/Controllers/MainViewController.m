//
//  MainViewController.m
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "CardViewController.h"
#import "ProjectView.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"估算模式" style:UIBarButtonItemStyleDone target:self action:@selector(gotoCardMode:)];
    
    ProjectView *view = [[ProjectView alloc] initWithFrame:CGRectMake(80, 80, 75, 100)];
    view.selected = YES;
    view.backgroundColor = [UIColor orangeColor];
    view.nameString = @"点金盒项目";
    [self.view addSubview:view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}


#pragma mark - private method

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)gotoCardMode:(UIBarButtonItem *)sender {
    CardViewController *cardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CardVC"];
    [self.navigationController presentViewController:cardVC animated:YES completion:^{
        
    }];
}

@end
