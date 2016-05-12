//
//  JGPhotoAlbumViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGPhotoAlbumViewController.h"

#import "JGTeamMemberController.h"


@interface JGPhotoAlbumViewController ()

@end

@implementation JGPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队相册";
    
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(upDataClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    [self uiConfig];
    
}


-(void)uiConfig
{
    
}

-(void)upDataClick
{
    JGTeamMemberController* teamVc = [[JGTeamMemberController alloc]init];
    [self.navigationController pushViewController:teamVc animated:YES];
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
