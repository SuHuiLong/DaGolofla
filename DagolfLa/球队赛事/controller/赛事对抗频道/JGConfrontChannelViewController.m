//
//  JGConfrontChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/9/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGConfrontChannelViewController.h"

@interface JGConfrontChannelViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGConfrontChannelViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0 , 20, 30 * screenWidth / 320, 30 * screenWidth / 320);
    [backBtn addTarget:self action:@selector(backBut) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"backL"] forState:(UIControlStateNormal)];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    
    // 发布按钮
    UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(260 * ProportionAdapter, 20 * ProportionAdapter, 80 * ProportionAdapter, 30 * ProportionAdapter)];
    [postButton setTitle:@"发布赛事" forState:(UIControlStateNormal)];
    [postButton addTarget:self action:@selector(postAct) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200 * ProportionAdapter)];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.userInteractionEnabled = YES;
   
    [imageView addSubview: postButton];
    [imageView addSubview:backBtn];
    
    self.tableView.tableHeaderView = imageView;
    
    // Do any additional setup after loading the view.
}

- (void)backBut{
    [self.navigationController popViewControllerAnimated:YES];
}

// 发布赛事
- (void)postAct{
    NSLog(@"fa  bu  sai  shi");
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
