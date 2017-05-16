//
//  JGDOpenContactViewController.m
//  DagolfLa
//
//  Created by 東 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDOpenContactViewController.h"

@interface JGDOpenContactViewController ()

@end

@implementation JGDOpenContactViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)becomeActive{
    
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"AAAAAA-AAAAA");
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 65 * ProportionAdapter)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#FCFCFC"];
    [self.view addSubview:topView];
    
    UILabel *lineLB = [Helper lableRect:CGRectMake(0, 64 * ProportionAdapter, screenWidth, 1 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:17 * ProportionAdapter text:@"”" textAlignment:(NSTextAlignmentCenter)];
    lineLB.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [topView addSubview:lineLB];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 35 * ProportionAdapter, 35 * ProportionAdapter, 15 * ProportionAdapter)];
    [backBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(cancelAct) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setTitleColor:[UIColor colorWithHexString:@"#131313"] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [topView addSubview:backBtn];
    
    
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65 * ProportionAdapter, 167 * ProportionAdapter, 246 * ProportionAdapter, 178 * ProportionAdapter)];
    picImageView.image = [UIImage imageNamed:@"bg_set_photo"];
    [self.view addSubview:picImageView];
    
    UILabel *tipLB1 = [Helper lableRect:CGRectMake(25 * ProportionAdapter, 365 * ProportionAdapter, 324 * ProportionAdapter, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:17 * ProportionAdapter text:@"尚未授权应用打开您的“通讯录”" textAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:tipLB1];
    
    UILabel *tipLB2 = [Helper lableRect:CGRectMake(25 * ProportionAdapter, 400 * ProportionAdapter, 324 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:15 * ProportionAdapter text:@"点击「 设置 」授权君高高尔夫访问您的“通讯录”" textAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:tipLB2];
    
    
    UIButton *openBtn = [[UIButton alloc] initWithFrame:CGRectMake(169 * ProportionAdapter, 475 * ProportionAdapter, 39 * ProportionAdapter, 20 * ProportionAdapter)];
    [openBtn setTitle:@"设置" forState:(UIControlStateNormal)];
    [openBtn setTitleColor:[UIColor colorWithHexString:@"#32B14D"] forState:(UIControlStateNormal)];
    openBtn.titleLabel.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [openBtn addTarget:self action:@selector(openAct) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:openBtn];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)openAct{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}

- (void)cancelAct{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}

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
