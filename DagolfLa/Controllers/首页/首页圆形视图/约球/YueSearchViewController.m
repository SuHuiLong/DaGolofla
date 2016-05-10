//
//  YueSearchViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/3.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueSearchViewController.h"

@interface YueSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
}
@end

@implementation YueSearchViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//    self.view.backgroundColor=[UIColor greenColor];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    [self createDaoHangTiao];
    
}



-(void)createDaoHangTiao{
    UIView *dao=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    dao.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:dao];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(10, 27, 30, 30);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.tintColor=[UIColor lightGrayColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    view.frame=CGRectMake(60, 27, ScreenWidth-130, 30);
    [self.view addSubview:view];
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:15.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    UITextField *tf=[[UITextField alloc] initWithFrame:CGRectMake(67.5, 28, ScreenWidth-145, 28)];
    tf.tag=1000;
    tf.text=_seachText;
    [self.view addSubview:tf];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(ScreenWidth-50, 20, 50, 44);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(seachButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)seachButtonClick{
    UITextField *tf=(UITextField *)[self.view viewWithTag:1000];
    _seachText=tf.text;

}

@end
