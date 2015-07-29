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
#import "DemandEditController.h"
#import "DemandManager.h"
#import "ProjectManager.h"

static NSString * const CELL_IDENTIFIER =  @"WaterfallCell";
static NSUInteger const ADDBUTTON_WIDTH = 40;

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, DemandCollectionCellDelegate>

@property (nonatomic , strong) UICollectionView *demandCollectionView;
@property (nonatomic, strong) NSMutableArray *demandArray;
@property (nonatomic, strong) UIButton *addDemandButton;
@property (nonatomic, copy) NSMutableString *projectIdString;
@property (nonatomic, strong) ProjectModel *projectModel;

@end

@implementation MainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self setupAddButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
    // 标题改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProjectTitle:) name:kCurrentTitleChangeNotification object:nil];
    
    [self.demandCollectionView reloadData];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主界面" style:UIBarButtonItemStylePlain target:self action:NULL];
    
    
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

- (void)setupAddButton
{
    self.addDemandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addDemandButton.frame = CGRectMake(SCREEN_WIDTH - ADDBUTTON_WIDTH - 10, SCREEN_HEIGHT - ADDBUTTON_WIDTH - 10 - 64, ADDBUTTON_WIDTH, ADDBUTTON_WIDTH);
    [self.addDemandButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.addDemandButton.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.addDemandButton.layer setShadowOpacity:1];
    [self.addDemandButton.layer setShadowRadius:6.0];
    [self.addDemandButton setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
    [self.addDemandButton addTarget:self action:@selector(addDemandAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addDemandButton];
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
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    CardViewController *cardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CardVC"];
    [vc presentViewController:cardVC animated:YES completion:^{
        
    }];
}

- (void)changeProjectTitle:(NSNotification *)sender
{
    self.projectModel = [ProjectManager fetchModelByIdentifier:sender.object];
    [self.projectIdString setString:[sender.object mutableCopy]];
    self.title = self.projectModel.nameString;
    
    [self.demandCollectionView reloadData];
}

- (void)addDemandAction:(UIButton *)sender
{
    if (self.projectIdString && ![self.projectIdString isEqualToString:@""]) {
    DemandEditController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemandEditVC"];
    vc.currentMode = DemandModeAdd;
    vc.projectIdString = self.projectIdString;
    [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先在左边创建项目，并选中项目！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)obtainDemandModels
{
    [self.demandArray removeAllObjects];
    
    NSMutableArray *array = [DemandManager fetchProjectsByParentId:[self.projectIdString mutableCopy]];
    for (DemandModel *model in array) {
        if (![self.demandArray containsObject:model]) {
            [self.demandArray addObject:model];
        }
    }
    
}

- (NSString *)pathOfCollectionImageByString:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:string];
    return filePath;
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
    [self obtainDemandModels];
    return self.demandArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemandCollectionViewCell *cell = (DemandCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@",CELL_IDENTIFIER]
                                                                                                           forIndexPath:indexPath];
    
    cell.image = nil;
    
    if (self.demandArray.count > indexPath.row) {
        DemandModel *model = self.demandArray[indexPath.row];
        cell.desString = model.titleString;
        
        if (model.picPathString && ![model.picPathString isEqualToString:@""]) {
            NSString *path = [self pathOfCollectionImageByString:model.picPathString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setImage:image];
            });
        });
        }
        cell.demandIdString = model.demandIdString;
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DemandCollectionViewCell *cell = (DemandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    DemandDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemandDetailVC"];
    vc.demandIdString = cell.demandIdString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DemandCollectionCellDelegate

- (void)deleteDemandCellByIdentifier:(NSString *)identifier {
    [DemandManager deleteDemandFromDataBaseByIdentifier:identifier];
    [self.demandCollectionView reloadData];
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

- (NSMutableArray *)demandArray {
    if (!_demandArray) {
        _demandArray = [NSMutableArray array];
    }
    return _demandArray;
}

- (NSMutableString *)projectIdString {
    if (!_projectIdString) {
        _projectIdString = [[NSMutableString alloc] init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentSelectedCell]) {
            [_projectIdString setString:[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentSelectedCell]];
        }
    }
    return _projectIdString;
}

@end
