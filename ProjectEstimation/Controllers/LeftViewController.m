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
#import "PopProjectView.h"
#import "Macro.h"
#import "LoginViewController.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource, ProjectCellButtonDelegate, PopProjectViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, strong) ProjectTableViewCell *currentCell;
@property (nonatomic, strong) NSMutableArray *tableDataSource;

@end

@implementation LeftViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge1.jpg"];
    [self.view addSubview:imageview];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableview = tableview;
    tableview.dataSource = self;
    tableview.delegate  = self;
    self.tableview.bounces = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    label.center = CGPointMake(self.view.center.x - 50, self.view.frame.size.height - label.frame.size.height/2);
    label.text = @"长按编辑或者删除项目";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:label];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isEditMode = NO;
    
    //    ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
    [self removeCellButtons:self.currentCell];
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

        cell.projectView.selected = NO;
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentSelectedCell]) {
        NSString *currentIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentSelectedCell];
            
            if (![currentIdentifier isEqualToString:@""] && [currentIdentifier isEqualToString:model.projectIdString]) {
                cell.projectView.selected = YES;
            }
        }
        
        cell.projectIdString = model.projectIdString;
        
        // 添加长按手势
        UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
        longGr.minimumPressDuration = 0.8;
        [cell addGestureRecognizer:longGr];
        
        cell.delegate = self;
    }
    else {
        cell.projectView.imageIndex = 0;
        cell.projectView.selected = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
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
    [button addTarget:self action:@selector(gotoLoginPage:) forControlEvents:UIControlEventTouchUpInside];
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
        [self popProjectEditViewByMode:NO WithTitle:nil index:0];
    }
    else {
        if (!self.isEditMode) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            
            //让cell处于选中状态
            ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selected = YES;
            
            NSString *identifierString = cell.projectIdString;
            
            [[NSUserDefaults standardUserDefaults] setObject:identifierString forKey:kCurrentSelectedCell];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentTitleChangeNotification object:[identifierString mutableCopy]];
            
            [self.tableview reloadData];
            
            
        }
        else {
            //        ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
            [self removeCellButtons:self.currentCell];
        }
    }
}


#pragma mark - gesture method

- (void)handleLongPressAction:(UILongPressGestureRecognizer *)sender
{
    if (self.isEditMode) {
        //        ProjectTableViewCell *cell = (ProjectTableViewCell *)[self.tableview cellForRowAtIndexPath:self.currentEditModeCellIndexPath];
        if (self.currentCell) {
        [self.currentCell setCurrentProjectMode:ProjectCellModeNormal];
        }
    }
    
    self.isEditMode = YES;
    ProjectTableViewCell *cell = (ProjectTableViewCell *)sender.view;
    self.currentCell = cell;
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
    
    [self removeCellButtons:cell];
    
    [self popProjectEditViewByMode:YES WithTitle:cell.projectView.nameString index:cell.projectView.imageIndex];
}

- (void)deleteProjectCell:(ProjectTableViewCell *)cell {
   
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:@"您是否确定要删除所选账本"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [view show];
}

- (void)removeCellButtons:(ProjectTableViewCell *)cell
{
    [cell setCurrentProjectMode:ProjectCellModeNormal];
    self.isEditMode = NO;
}

- (void)gotoLoginPage:(UIButton *)sender {
    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:loginVC
                       animated:YES
                     completion:^{
    }];
    
}

#pragma mark - PopProjectViewDelegate

- (void)cancelPopProjectView {
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:300];
    
    if (view) {
        [view removeFromSuperview];
    }
}

- (void)confirmPopProjectViewWithTitle:(NSString *)title index:(NSUInteger)index isEdit:(BOOL)isEdit {
    
    [self cancelPopProjectView];
    
    if (isEdit) {
        [ProjectManager editProjectWithName:[NSString stringWithFormat:@"%@",title]
                                imageString:[NSString stringWithFormat:@"%zd",index]
                               ByIdentifier:self.currentCell.projectIdString];
    }
    else {
        [ProjectManager addProjectWithName:[NSString stringWithFormat:@"%@",title]
                               imageString:[NSString stringWithFormat:@"%zd",index]
                                createDate:[NSDate date]];
    }
    [self.tableview reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [ProjectManager deleteProjectFromDataBaseByIdentifier:self.currentCell.projectIdString];
        [self.tableview reloadData];
    }
}

#pragma mark -

- (NSMutableArray *)tableDataSource {
    if (_tableDataSource) {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    
    _tableDataSource = [ProjectManager fetchProjects];
    return _tableDataSource;
}

#pragma mark - Private Methods

- (void)popProjectEditViewByMode:(BOOL)isEdit WithTitle:(NSString *)title index:(NSUInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    PopProjectView *popView = [[PopProjectView alloc] initWithFrame:CGRectMake((self.view.frame.size.width -315)/2, (self.view.frame.size.height - 210 - 226)/2, 315, 210)];
    popView.delegate = self;
    
    if (isEdit) {
        popView.titleTextField.text = title;
        popView.titleString = [NSMutableString stringWithString:title];
        popView.imageIndex = index;
        popView.isEdit = YES;
    }
    
    [popView setupBackgroundImage];
    
    [view addSubview:popView];
    view.tag = 300;
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}
@end
