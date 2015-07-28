//
//  DemandEditController.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/27.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandEditController.h"
#import "Macro.h"
#import "DemandManager.h"

@interface DemandEditController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *stepTextFields;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) NSMutableString *picPathString;

@end

@implementation DemandEditController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillLayoutSubviews {
    
    if (SCREEN_HEIGHT < 667) {
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 667);
    }
    else {
        self.mainScrollView.contentSize = self.view.bounds.size;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    }
    
    for (UITextField *textField in self.stepTextFields) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UI

- (void)initialSetup
{
    self.titleTextField.delegate = self;
    for (UITextField *textField in self.stepTextFields) {
        textField.delegate = self;
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.mainScrollView addGestureRecognizer:tapGr];
    
    if (self.currentMode == DemandModeAdd) {
        self.title = @"添加任务";
        self.demandIdString = [NSUUID UUID].UUIDString;
    }
    else {
        self.title = @"编辑任务";
        [self addFormerInfo];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保 存" style:UIBarButtonItemStylePlain target:self action:@selector(confirmEditAction:)];
}

- (void)addFormerInfo
{
        NSMutableArray *labelDataSource = [[NSMutableArray alloc] init];
        DemandModel *model = [DemandManager fetchModelByDemandId:self.demandIdString];
        
        if (model) {
            self.titleTextField.text = model.titleString;
            
            if (model.picPathString && ![model.picPathString isEqualToString:@""]) {
                NSString *path = [self pathOfCollectionImageByString:model.picPathString];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.imageView setImage:image];
                    });
                });

            }
            
            if (model.desString && ![model.desString isEqualToString:@""]) {
                [labelDataSource setArray:[model.desString componentsSeparatedByString:@";"]];
                for (int i = 0 ; i < labelDataSource.count; i ++) {
                    UITextField *textField = (UITextField *)[self.mainScrollView viewWithTag:101 + i];
                    textField.text = labelDataSource[i];
                }
            }
            
        }

}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.tag < 105) {
        UITextField *nextTextField = (UITextField *)[self.mainScrollView viewWithTag:textField.tag + 1];
        [nextTextField becomeFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (SCREEN_HEIGHT < 667) {
        if (textField.tag > 100) {
        [self.mainScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y + textField.frame.size.height + 10) animated:YES];
        }
    }
    else {
        if (textField.tag >= 104) {
            [self.mainScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y + textField.frame.size.height + 20) animated:YES];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (SCREEN_HEIGHT < 667) {
    }
    else {
        if (105 == textField.tag) {
            [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [self saveImageToFile:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - button click action

- (IBAction)openCameraAction:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                              message:@"当前摄像头不可用！"
                                                             delegate:self
                                                    cancelButtonTitle:@"知道了"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    else {
        [self showImagePickerControllerBysoureType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (IBAction)openPhotoAlbum:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                              message:@"当前相册不可用！"
                                                             delegate:self
                                                    cancelButtonTitle:@"知道了"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    else {
        [self showImagePickerControllerBysoureType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    }
    
    for (UITextField *textField in self.stepTextFields) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)confirmEditAction:(UIBarButtonItem *)sender {
    
    NSMutableString *desString = [[NSMutableString alloc] init];
    for (int i = 101; i < 106; i ++) {
        UITextField *textField = (UITextField *)[self.mainScrollView viewWithTag:i];
        if (![textField.text isEqualToString:@""]) {
        [desString appendFormat:@"%@;",textField.text];
        }
    }
    if (desString.length > 1) {
    [desString replaceCharactersInRange:NSMakeRange(desString.length - 1, 1) withString:@""];
    }
    
    if (self.currentMode == DemandModeAdd) {
        [DemandManager addDemandWithTitle:self.titleTextField.text
                            picPathString:self.picPathString
                                desString:desString
                               createDate:[NSDate date]
                                 parentId:self.projectIdString
                               identifier:self.demandIdString];
    }
    else {
        [DemandManager editDemandWithTitle:self.titleTextField.text
                             picPathString:self.picPathString
                                 desString:desString
                                identifier:self.demandIdString];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method

- (void)showImagePickerControllerBysoureType:(UIImagePickerControllerSourceType )sourceType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//保存图片到沙盒
- (void)saveImageToFile:(UIImage *)image
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.png",self.demandIdString, [NSDate date]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    CLog(@"filepath:%@",filePath);
    
    NSData *data;
    if (UIImagePNGRepresentation(image)) {
        data = UIImagePNGRepresentation(image);
    }
    else {
        if (UIImageJPEGRepresentation(image, 1)) {
            data = UIImageJPEGRepresentation(image, 1);
        }
    }
    
    if ([fileManager createFileAtPath:filePath contents:data attributes:nil])
    {
        [data writeToFile:filePath atomically:YES];
        [self.picPathString setString:fileName];
    }
}

- (NSString *)pathOfCollectionImageByString:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:string];
    return filePath;
}

#pragma mark - getter method

- (NSMutableString *)picPathString {
    if (!_picPathString) {
        _picPathString = [[NSMutableString alloc] init];
    }
    return _picPathString;
}

@end
