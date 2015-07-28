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
#import "DemandManager.h"

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
}

- (void)viewWillLayoutSubviews {
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.scrollViewContentHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initialDataSource];
}

#pragma mark - 

- (void)initialDataSource
{
    self.labelDataSource = [[NSMutableArray alloc] init];
    DemandModel *model = [DemandManager fetchModelByDemandId:self.demandIdString];
    
    if (model) {
        
        self.title = model.titleString;
        
        if (model.picPathString && ![model.picPathString isEqualToString:@""]) {
            NSString *path = [self pathOfCollectionImageByString:model.picPathString];
            self.hasImage = YES;
            [self addDemandImageViewBySting:path];
        }
        else {
            self.hasImage = NO;
        }
        
        if (model.desString && ![model.desString isEqualToString:@""]) {
            [self.labelDataSource setArray:[model.desString componentsSeparatedByString:@";"]];
            [self addDemandLabels];
        }
        
    }
}

#pragma mark - private method

- (void)initUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    imageView.image = [UIImage imageNamed:@"demandBg.jpg"];
    [self.view addSubview:imageView];
    
    self.title = @"任务需求";
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

- (void)addDemandImageViewBySting:(NSString *)path
{
    if (self.hasImage) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpaceLength, kSpaceLength, SCREEN_WIDTH - kSpaceLength * 2, SCREEN_WIDTH - kSpaceLength * 2)];
        self.imageView.image = [UIImage imageNamed:@"background1"];
        self.imageView.layer.cornerRadius = 6.0;
        self.imageView.clipsToBounds = YES;
        [self.mainScrollView addSubview:self.imageView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImage:image];
            });
        });
    }
}

- (void)removeAllSubviewsOfScrollView
{
    for (UIView *view in self.mainScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
        [view removeFromSuperview];
        }
    }
}

- (void)addDemandLabels
{
    [self removeAllSubviewsOfScrollView];
    
    CGFloat labelYPosition = self.imageView.frame.size.height + self.imageView.frame.origin.y + kSpaceLength;
    if (1) {
        for (int i = 0 ; i < self.labelDataSource.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceLength, labelYPosition + i*45, SCREEN_WIDTH - kSpaceLength * 2, 30)];
            label.text = [NSString stringWithFormat:@" 0%d %@", i + 1, self.labelDataSource[i]];
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

- (NSString *)pathOfCollectionImageByString:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:string];
    return filePath;
}

@end
