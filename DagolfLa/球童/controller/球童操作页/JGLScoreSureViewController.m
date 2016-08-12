//
//  JGLScoreSureViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/8/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLScoreSureViewController.h"

@interface JGLScoreSureViewController ()

@end

@implementation JGLScoreSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setData];
    
    [self createScore];
    
}

-(void)setData
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 200 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
    imageV.image = [UIImage imageNamed:@"bg-shy"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, screenWidth, 30 * ProportionAdapter)];
    label.text = @"添加客户李逍遥成功";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [self.view addSubview:label];
    
    UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 370 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter)];
    detailLB.text = @"点击开始记分，进入客户记分模式，完成记分后，成绩自动存入客户历史记分卡";
    detailLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
    detailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    detailLB.numberOfLines = 0;
    [self.view addSubview:detailLB];
}

-(void)createScore
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, 130*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)finishClick{
    
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
