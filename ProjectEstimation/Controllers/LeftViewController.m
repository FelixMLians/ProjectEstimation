//
//  LeftViewController.m
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "ProjectTableViewCell.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LeftViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableview = tableview;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    label.center = CGPointMake(self.view.center.x, self.view.frame.size.height - label.frame.size.height/2);
    label.text = @"长按编辑或者删除项目";
    label.textColor = [UIColor lightTextColor];
    label.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:label];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[ProjectTableViewCell alloc] init];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.projectView.nameString = @"开通会员";
    } else if (indexPath.row == 1) {
        cell.projectView.nameString = @"QQ钱包";
    } else if (indexPath.row == 2) {
        cell.projectView.nameString = @"网上营业厅";
    } else if (indexPath.row == 3) {
        cell.projectView.nameString = @"个性装扮";
    } else if (indexPath.row == 4) {
        cell.projectView.nameString = @"我的收藏";
    } else if (indexPath.row == 5) {
        cell.projectView.nameString = @"我的相册";
    } else if (indexPath.row == 6) {
        cell.projectView.nameString = @"我的文件";
    }
    
    if (arc4random() % 3 > 1) {
        cell.selected = YES;
    }
    else {
        cell.selected = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    
    //相关页面
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 30, 60, 60);
    button.layer.cornerRadius = button.frame.size.width / 2;
    
    [button setImage:[UIImage imageNamed:@"menu_headview"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"menu_headview_pressed"] forState:UIControlStateHighlighted];
    
    [view addSubview:button];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 60)];
    view.backgroundColor = [UIColor clearColor];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    otherViewController *vc = [[otherViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    //    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}

@end
