//
//  JGCreateTeamViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGCreateTeamViewController.h"
#import "JGCreateTeamView.h"
#import "JGTeamDetailViewController.h"


@interface JGCreateTeamViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)JGCreateTeamView *creatTeamV;

@end

@implementation JGCreateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建球队";
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    
    self.creatTeamV = [[JGCreateTeamView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.creatTeamV];
    [self.creatTeamV.previewBtn addTarget:self action:@selector(preview) forControlEvents:(UIControlEventTouchUpInside)];
    [self.creatTeamV.addIconBtn addTarget:self action:@selector(usePhonePhotoAndCamera) forControlEvents:(UIControlEventTouchUpInside)];
    // Do any additional setup after loading the view.
}

- (void)preview{
    JGTeamDetailViewController *detailV = [[JGTeamDetailViewController alloc] init];
    [self.navigationController pushViewController:detailV animated:YES];
}

#pragma mark - 调用手机相机和相册
- (void)usePhonePhotoAndCamera {
   
    UIActionSheet *selestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
   
    [selestSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self usePhonCamera];
    }else if (buttonIndex == 1) {
        [self usePhonePhoto];
    }
}

#pragma mark - 调用相机
- (void)usePhonCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 调用相册
- (void)usePhonePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.creatTeamV.addIconBtn setImage:image forState:(UIControlStateNormal)];
    [self dismissViewControllerAnimated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
