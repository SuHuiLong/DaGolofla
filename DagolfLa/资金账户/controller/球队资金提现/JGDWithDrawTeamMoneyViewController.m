//
//  JGDWithDrawTeamMoneyViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/30.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLabel.h"

#import "JGDWithDrawTeamMoneyViewController.h"
#import "JGDTakeTeamMoneyViewController.h"

@interface JGDWithDrawTeamMoneyViewController ()

@end

@implementation JGDWithDrawTeamMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球队资金提现步骤";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 188 * ProportionAdapter)];
    topView.image = [UIImage imageNamed:@"tixianbuzhoutupian"];
    [self.view addSubview:topView];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 198 * ProportionAdapter, screenWidth, 45 * ProportionAdapter)];
    labelTitle.backgroundColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    labelTitle.text = @"［球队资金提现说明］";
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.textColor = [UIColor colorWithHexString:@"#f39b07"];
    [self.view addSubview:labelTitle];
    
    
    
    JGLabel *labelCont=[[JGLabel alloc]  initWithFrame:CGRectMake(0 * ProportionAdapter, 243 * ProportionAdapter, screenWidth, 135 * ProportionAdapter)];
    [labelCont setInsets:UIEdgeInsetsMake(0, 15 * ProportionAdapter, 70 * ProportionAdapter, 15 * ProportionAdapter)];
    labelCont.backgroundColor = [UIColor whiteColor];
    labelCont.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    labelCont.text = @"  为了保障球队资金安全，对球队账户资金提现时，需先将球队账户资金转至球队资金管理人“个人账户”，然后从个人账户提现到资金管理人个人银行。";
    labelCont.numberOfLines = 0;
    [self.view addSubview:labelCont];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(20 * ProportionAdapter, 403 * ProportionAdapter, screenWidth - 40, 45 * ProportionAdapter);
    [button setTitle:@"提现至个人帐户" forState:(UIControlStateNormal)];
    button.backgroundColor = [UIColor orangeColor];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 6.f;
    [button addTarget:self action:@selector(takeMoney) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}

- (void)takeMoney{
    JGDTakeTeamMoneyViewController *takeVC = [[JGDTakeTeamMoneyViewController alloc] init];
    takeVC.teamKey = self.teamKey;
    [self.navigationController pushViewController:takeVC animated:YES];
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
