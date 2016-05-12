//
//  JGTeamDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamDetailViewController.h"
#import "JGTeamDetailView.h"

@interface JGTeamDetailViewController ()

@end

@implementation JGTeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    JGTeamDetailView *teamDetaliV = [[JGTeamDetailView alloc] initWithFrame:self.view.bounds];
    teamDetaliV.teamIntroductionLB.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。火车上的第一个晚上，我沉沉地睡去，梦境中，我看到了13岁的齐铭，眼睛大大的，头发柔软，漂亮得如同女孩子。他孤单地站在站台上，猜着火车，他问我哪列火车可以到北京去，可是我动不了，说不出话，于是他蹲在地上哭了。我想走过去抱着他，可是我却动不了，齐铭望着我，一直哭不肯停。可是我连话都说不出来，我难过得像要死掉了。梦中开过了一列火车，轰隆隆，轰隆隆，碾碎了齐铭的面容，碾碎了我留在齐铭身上的青春，碾碎了那几个明媚的夏天，碾碎了那面白色的墙，碾碎了齐铭那辆帅气的单车，碾碎了他的素描，碾碎了我最后的梦境。";
//    [teamDetaliV.teamIntroductionLB sizeToFit];
    [teamDetaliV resetUI];
    [self.view addSubview:teamDetaliV];
    teamDetaliV.contentSize = CGSizeMake(screenWidth, teamDetaliV.applyJoin.frame.origin.y + 70);
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
