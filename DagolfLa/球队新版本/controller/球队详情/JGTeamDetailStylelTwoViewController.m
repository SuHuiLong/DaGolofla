//
//  JGTeamDetailStylelTwoViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamDetailStylelTwoViewController.h"
#import "JGTeamDetailStyleTwoView.h"

@interface JGTeamDetailStylelTwoViewController ()

@end

@implementation JGTeamDetailStylelTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    
    JGTeamDetailStyleTwoView *teamDetailV = [[JGTeamDetailStyleTwoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:teamDetailV];
    teamDetailV.teamIntroductionLB.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。";
    [teamDetailV resetUI];
    teamDetailV.contentSize = CGSizeMake(screenWidth, teamDetailV.applyJoin.frame.origin.y + 70);

    // Do any additional setup after loading the view.
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
