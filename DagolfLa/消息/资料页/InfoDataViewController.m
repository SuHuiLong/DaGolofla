//
//  InfoDataViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/4/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "InfoDataViewController.h"


@interface InfoDataViewController ()
{
    UIScrollView* _scrollView;
}
@end

@implementation InfoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //界面滑动
    [self creatScrollView];
    
    //界面搭建,头部界面
    [self createHeader];
    
    //界面搭建，主体部分
    [self createBody];
    
}

-(void)creatScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
}

-(void)createHeader
{
    
}

-(void)createBody
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
