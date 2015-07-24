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
#import "Macro.h"
#import "DemandDetailController.h"

static NSUInteger const CELL_COUNT = 20;
static NSString * const CELL_IDENTIFIER =  @"WaterfallCell";

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *demandCollectionView;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, strong) NSMutableArray *desStringArray;

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
    
    // 标题改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProjectTitle:) name:kCurrentTitleChangeNotification object:nil];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0]}];
    self.navigationController.navigationBar.translucent = NO;
    
    // leftBarButtonItem
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    // collectionView
    self.demandCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.demandCollectionView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    
    // rightBarButtonItem
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 25);
    rightBtn.layer.cornerRadius = 6.0;
    rightBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    rightBtn.layer.borderWidth = 1.0;
    [rightBtn setTitle:@"项目推广" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [rightBtn addTarget:self action:@selector(gotoCardMode:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
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

- (void)changeProjectTitle:(NSNotification *)sender
{
    self.title = sender.object;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemandCollectionViewCell *cell = (DemandCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    if (0 == indexPath.row) {
        cell.image = [UIImage imageNamed:@"addBtn"];
        cell.hideDesView = YES;
    }
    else {
    cell.image = nil;
    cell.desString = [self.desStringArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DemandCollectionViewCell *cell = (DemandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    DemandDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemandDetailVC"];
    vc.demandIdString = cell.demandIdString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Accessors

- (UICollectionView *)demandCollectionView {
    if (!_demandCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15*3)/2, (SCREEN_WIDTH - 15*3)/2);
        
        _demandCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _demandCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _demandCollectionView.dataSource = self;
        _demandCollectionView.delegate = self;
        _demandCollectionView.backgroundColor = [UIColor whiteColor];
        [_demandCollectionView registerClass:[DemandCollectionViewCell class]
                  forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _demandCollectionView;
}

- (NSMutableArray *)desStringArray {
    if (!_desStringArray) {
        _desStringArray = [NSMutableArray array];
        for (int i = 0; i < CELL_COUNT; i ++) {
            NSMutableString *string = [[NSMutableString alloc] init];
            for (int j = arc4random()%(i +1) ; j < i + 1; j ++) {
                [string appendString:@"任务 alias"];
            }
            [_desStringArray addObject:string];
        }
    }
    return _desStringArray;
}

@end
