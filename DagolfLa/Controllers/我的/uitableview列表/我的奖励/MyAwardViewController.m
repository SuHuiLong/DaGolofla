//
//  MyAwardViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/25.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyAwardViewController.h"

@interface MyAwardViewController ()

@end

@implementation MyAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    
    [self createLabelView];
}


-(void)createLabelView
{
    UILabel* labelView = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 50*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375)];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.text = @"您暂时还没有奖励记录";
    labelView.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [self.view addSubview:labelView];
    labelView.numberOfLines = 0;
    
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
