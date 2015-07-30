//
//  OfferWallController.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/30.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "OfferWallController.h"
#import "Macro.h"
#import "OfferWallTableViewCell.h"

static CGFloat const kRowCount = 25;
static NSString * const kCellIdentifier = @"OfferWallCell";

@interface OfferWallController ()<UITableViewDataSource, UITableViewDelegate, OfferWallTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation OfferWallController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfferWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[OfferWallTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    int x = arc4random()%5;
    int y = arc4random()%100;
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"app%zd",x + 1]];
    cell.titleLabel.text = [NSString stringWithFormat:@"任务集中营"];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%zd.%zd MB",y,x];
    cell.desLabel.text = [NSString stringWithFormat:@"全国首家轻威客任务平台，任务轻而有趣，奖励多到流泪！"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bian-cheng-xiao-zhu-shou-xue/id1007208297?mt=8"]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH*2/3, 0);
   
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark - OfferWallTableViewCellDelegate

- (void)OfferWallCellWillDownloadByItemId:(NSString *)identifier {
    
}

#pragma mark - button click actions

- (IBAction)gobackToLastPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)refreshContent:(id)sender {
    CLog(@"Refresh content!");
}

#pragma mark - initial setup

- (void)initialSetUp
{
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
}

@end
