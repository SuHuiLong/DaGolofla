//
//  JGHRegisteredViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRegisteredViewController.h"

@interface JGHRegisteredViewController ()

@end

@implementation JGHRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"注册";
    
    
    [self createAllView];
}

- (void)createAllView{
    //手机号
    UIView *mobileView = [[UIView alloc]initWithFrame:CGRectMake(8 *ProportionAdapter, 10 *ProportionAdapter, 50 *ProportionAdapter, 50 *ProportionAdapter)];
    mobileView.backgroundColor = [UIColor whiteColor];
    mobileView.layer.masksToBounds = YES;
    mobileView.layer.borderWidth = 1;
    mobileView.layer.borderColor = [UIColor colorWithHexString:Line_Color].CGColor;
    mobileView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    UIButton *regionBtn = [[UIButton alloc]initWithFrame:CGRectMake(8 *ProportionAdapter, 10 *ProportionAdapter, 50*ProportionAdapter, 50 *ProportionAdapter)];
    regionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    regionBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [regionBtn setTitle:@"+86" forState:UIControlStateNormal];
    [mobileView addSubview:regionBtn];
    
    UILabel *regionLine = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 0, 1, 50 *ProportionAdapter)];
    regionLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [mobileView addSubview:regionLine];
    
    UITextField *mobileText = [[UITextField alloc]initWithFrame:CGRectMake(50*ProportionAdapter +1, 10 *ProportionAdapter, screenWidth - ((16 +50)*ProportionAdapter +1), 50 *ProportionAdapter)];
    mobileText.placeholder = @"请输入手机号";
    mobileText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [mobileView addSubview:mobileText];
    
    [self.view addSubview:mobileView];
    
    //
    
    
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
