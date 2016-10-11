//
//  JGLTeamSignUpSuccViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeamSignUpSuccViewController.h"
#import "JGLSignSuccFinishViewController.h"
@interface JGLTeamSignUpSuccViewController ()

@end

@implementation JGLTeamSignUpSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队报名";
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    [self createSignTeam];
    [self createContectTeam];
    
    [self createBtn];
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10*ScreenWidth/375, screenHeight - 54*screenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)finishClick{
    JGLSignSuccFinishViewController* finVc = [[JGLSignSuccFinishViewController alloc]init];
    [self.navigationController pushViewController:finVc animated:YES];
}

-(void)createContectTeam
{
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 87*ProportionAdapter, 80*ProportionAdapter, 20*ProportionAdapter)];
    labelName.text = @"球队联系人";
    labelName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:labelName];
    
    
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(90*ProportionAdapter, 80*ProportionAdapter, screenWidth - 100*ProportionAdapter, 34*ProportionAdapter)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"手机号";
    [self.view addSubview:textField];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 34*ProportionAdapter, screenWidth-100*ProportionAdapter, 1*ProportionAdapter)];
    view.backgroundColor = [UIColor darkGrayColor];
    [textField addSubview:view];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 160*ProportionAdapter, screenWidth - 20*ProportionAdapter, 20*ProportionAdapter)];
    label.text = @"提交完成后，即可在球队内部发起赛事报名！";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:label];
    
}
-(void)createSignTeam
{
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 27*ProportionAdapter, 80*ProportionAdapter, 20*ProportionAdapter)];
    labelName.text = @"报名球队";
    labelName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [self.view addSubview:labelName];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(90*ProportionAdapter, 20*ProportionAdapter, screenWidth - 100*ProportionAdapter, 34*ProportionAdapter);
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 6*ProportionAdapter;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor whiteColor];
    //selectright
    UILabel* labelBall = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth - 140*ProportionAdapter, 34*ProportionAdapter)];
    labelBall.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    labelBall.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    labelBall.text = @"北京九松山高尔夫俱乐部";
    labelBall.layer.cornerRadius = 6*ProportionAdapter;
    labelBall.layer.masksToBounds = YES;
    [btn addSubview:labelBall];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 140*ProportionAdapter, 0, 40*ProportionAdapter, 34*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"selectright"];
    [btn addSubview:imgv];
    
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
