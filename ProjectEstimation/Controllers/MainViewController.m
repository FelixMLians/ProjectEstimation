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
#import "DemandCollectionViewCell.h"

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *demandCollectionView;

@end

@implementation MainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
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

- (void)setUpUI
{
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"估算模式"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(gotoCardMode:)];
    
    // leftBarButtonItem
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    // collectionView
    UICollectionViewLayout *collectionLayout = [[UICollectionViewLayout alloc] init];
    
    
    self.demandCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)
                                                   collectionViewLayout:collectionLayout];
    self.demandCollectionView.delegate = self;
    self.demandCollectionView.dataSource = self;
    [self.view addSubview:self.demandCollectionView];
}

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemandCollectionViewCell *cell = (DemandCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DemandCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate


@end
