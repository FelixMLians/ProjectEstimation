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
#import "ProjectManager.h"
#import "ProjectModel.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource, ProjectCellButtonDelegate>

@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, assign) NSIndexPath *currentEditModeCellIndexPath;
@property (nonatomic, strong) NSMutableArray *tableDataSource;

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isEditMode = NO;
    
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
    [self removeCellButtons:cell];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count + 1;
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
    
     if (indexPath.row > 0) {
    ProjectModel *model = self.tableDataSource[indexPath.row - 1];
    cell.projectView.nameString = model.nameString;
    cell.projectView.imageIndex = [model.bgColorString integerValue];
    cell.projectView.selected = [model.isSelected boolValue];
    cell.projectIdString = model.projectIdString;
        
    cell.cellIndexPath = indexPath;
    // 添加长按手势
    UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
    longGr.minimumPressDuration = 0.8;
    [cell addGestureRecognizer:longGr];
    
    cell.delegate = self;
     }
     else {
         cell.projectView.imageIndex = 0;
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
    if (indexPath.row == 0) {
        [ProjectManager addProjectWithName:[NSString stringWithFormat:@"项目%zd",self.tableDataSource.count + 1]
                               imageString:@"3"
                                isSelected:@"1"
                                createDate:[NSDate date]];
        [tableView reloadData];
    }
    else {
    if (!self.isEditMode) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    }
    else {
        ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
        [self removeCellButtons:cell];
    }
    }
}

#pragma mark - gesture method

- (void)handleLongPressAction:(UILongPressGestureRecognizer *)sender
{
    if (self.isEditMode) {
        ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
        [cell setCurrentProjectMode:ProjectCellModeNormal];
    }
    
    self.isEditMode = YES;
    ProjectTableViewCell *cell = (ProjectTableViewCell *)sender.view;
    self.currentEditModeCellIndexPath = cell.cellIndexPath;
    [cell addEditButtonAndDeleteButton];

}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (self.isEditMode) {
//        ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
//        
//        UITouch *touch = [touches anyObject];
//        CGPoint touchPoint = [touch locationInView:self.view];
//        
//        if (!CGRectContainsPoint(cell.editButton.frame, touchPoint)) {
//        [cell setCurrentProjectMode:ProjectCellModeNormal];
//        }
//    }
//}

#pragma mark - ProjectCellButtonDelegate

- (void)editProjectCell:(ProjectTableViewCell *)cell {
    NSLog(@"%@ edit", cell);
    [self removeCellButtons:cell];
}

- (void)deleteProjectCell:(ProjectTableViewCell *)cell {
    NSLog(@"%@ delete", cell);
//    [self removeCellButtons:cell];
    [ProjectManager deleteProjectFromDataBaseByIdentifier:cell.projectIdString];
    [self.tableview reloadData];
}

- (void)removeCellButtons:(ProjectTableViewCell *)cell
{
    [cell setCurrentProjectMode:ProjectCellModeNormal];
    self.isEditMode = NO;
}

#pragma mark - 

- (NSMutableArray *)tableDataSource {
    if (_tableDataSource) {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    
    _tableDataSource = [ProjectManager fetchProjects];
    return _tableDataSource;
}

@end
