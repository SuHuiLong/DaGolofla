//
//  JGLScoreOverViewViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreOverViewViewController.h"

@interface JGLScoreOverViewViewController ()<UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
}
@end

@implementation JGLScoreOverViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队成绩总览";
    
    
    
    
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
