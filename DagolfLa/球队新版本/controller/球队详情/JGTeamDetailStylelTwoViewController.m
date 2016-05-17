//
//  JGTeamDetailStylelTwoViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamDetailStylelTwoViewController.h"
#import "JGTeamDetailStyleTwoView.h"
#import "JGTeamManageViewController.h"
#import "JGLSelfSetViewController.h"
#import "JGTeamPhotoViewController.h"
#import "JGTeamMemberController.h"
#import "JGTeamActivityViewController.h" //球队活动

@interface JGTeamDetailStylelTwoViewController ()


@end

@implementation JGTeamDetailStylelTwoViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;

    JGTeamDetailStyleTwoView *teamDetailV = [[JGTeamDetailStyleTwoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:teamDetailV];
    teamDetailV.teamIntroductionLB.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。";
    teamDetailV.isManager = YES;
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0 , 20, 30 * screenWidth / 320, 30 * screenWidth / 320);
    [backBtn addTarget:self action:@selector(backBut) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"backL"] forState:(UIControlStateNormal)];
    [teamDetailV.topBackImageV addSubview:backBtn];

    [teamDetailV resetUI];
    teamDetailV.contentSize = CGSizeMake(screenWidth, teamDetailV.applyJoin.frame.origin.y + 70);
    [teamDetailV.teamManage addTarget:self action:@selector(manageTeam) forControlEvents:(UIControlEventTouchUpInside)];
    [teamDetailV.setButton addTarget:self action:@selector(set) forControlEvents:(UIControlEventTouchUpInside)];
    
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [teamDetailV.buttonBackView viewWithTag:200 + i];
        [button addTarget:self action:@selector(photos:) forControlEvents:(UIControlEventTouchUpInside)];
    }

    // Do any additional setup after loading the view.
}

- (void)backBut{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photos:(UIButton *)button{
    if (button.tag == 200) {
        // 成员
        JGTeamMemberController *memberVC = [[JGTeamMemberController alloc] init];
        [self.navigationController pushViewController:memberVC animated:YES];
        
    }else if (button.tag == 201){
        // 活动
        JGTeamActivityViewController *activityVC = [[JGTeamActivityViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }else{
        // 相册
        JGTeamPhotoViewController *photoVC = [[JGTeamPhotoViewController alloc] init];
        [self.navigationController pushViewController:photoVC animated:YES];
 
    }
}

// 个人设置
- (void)set{
    JGLSelfSetViewController *selfSetVC = [[JGLSelfSetViewController alloc] init];
    [self.navigationController pushViewController:selfSetVC animated:YES];
}

- (void)manageTeam{
    JGTeamManageViewController *teamManager = [[JGTeamManageViewController alloc] init];
    [self.navigationController pushViewController:teamManager animated:YES];
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
