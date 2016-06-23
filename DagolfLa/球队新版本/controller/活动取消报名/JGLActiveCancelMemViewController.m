//
//  JGLActiveCancelMemViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActiveCancelMemViewController.h"

@interface JGLActiveCancelMemViewController ()

@end

@implementation JGLActiveCancelMemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"XXXXX活动";
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"分组管理" style:UIBarButtonItemStylePlain target:self action:@selector(groupClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    [self uiConfig];
    
}

#pragma mark --分组管理点击事件

-(void)groupClick
{
    
}


#pragma mark --uitableview创建
-(void)uiConfig
{
    
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
