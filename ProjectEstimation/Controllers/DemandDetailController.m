//
//  DemandDetailController.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/24.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandDetailController.h"
#import "Macro.h"
#import "DemandEditController.h"

static CGFloat const kSpaceLength = 10;

@interface DemandDetailController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL hasImage;
@property (nonatomic, strong) NSMutableArray *labelDataSource;
@property (nonatomic, assign) CGFloat scrollViewContentHeight;

@end

@implementation DemandDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.hasImage = NO;
    [self addDemandImageView];
    self.labelDataSource = [[NSMutableArray alloc] initWithCapacity:9];
    [self addDemandLabels];
}

- (void)viewWillLayoutSubviews {
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.scrollViewContentHeight);
}
#pragma mark - 



#pragma mark - private method

- (void)initUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    imageView.image = [UIImage imageNamed:@"demandBg.jpg"];
    [self.view addSubview:imageView];
    
    self.title = @"任务需求标题";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:NULL];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editDemand:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainScrollView];
}

- (void)addDemandImageView
{
    if (self.hasImage) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpaceLength, kSpaceLength, SCREEN_WIDTH - kSpaceLength * 2, SCREEN_WIDTH - kSpaceLength * 2)];
        self.imageView.image = [UIImage imageNamed:@"background1"];
        self.imageView.layer.cornerRadius = 6.0;
        self.imageView.clipsToBounds = YES;
        [self.mainScrollView addSubview:self.imageView];
    }
}

- (void)addDemandLabels
{
    CGFloat labelYPosition = self.imageView.frame.size.height + self.imageView.frame.origin.y + kSpaceLength;
    if (1) {
        for (int i = 0 ; i < 9; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceLength, labelYPosition + i*45, SCREEN_WIDTH - kSpaceLength * 2, 30)];
            label.text = [NSString stringWithFormat:@" 步骤 %d 每天都要做任务，做锻炼", i];
            label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            label.layer.cornerRadius = 6.0;
            label.clipsToBounds = YES;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15.0];
            [self.mainScrollView addSubview:label];
        }
    }
    
    self.scrollViewContentHeight = labelYPosition + 9*45 + 20 + 64;
}

- (void)editDemand:(UIButton *)sender
{
    DemandEditController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DemandEditVC"];
    vc.demandIdString = self.demandIdString;
    vc.currentMode = DemandModeEdit;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
