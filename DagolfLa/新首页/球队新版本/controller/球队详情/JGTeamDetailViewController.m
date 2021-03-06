//
//  JGTeamDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamDetailViewController.h"
#import "JGTeamDetailView.h"
#import "JGApplyMaterialViewController.h"
#import "JGTeamPhotoViewController.h" // 球队相册
#import "JGTeamActivityViewController.h" // 球队活动
#import "JGApplyMaterialViewController.h"

@interface JGTeamDetailViewController ()

@property (nonatomic, strong)JGTeamDetailView *teamDetaliV;

@end

@implementation JGTeamDetailViewController

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
    self.teamDetaliV = [[JGTeamDetailView alloc] initWithFrame:self.view.bounds];
    JGTeamDetail *model = [[JGTeamDetail alloc] init];
    [model setValuesForKeysWithDictionary:self.teamDetailDic];
    self.teamDetaliV.teamDetailModel = model;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //    teamDetaliV.teamIntroductionLB.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。火车上的第一个晚上，我沉沉地睡去，梦境中，我看到了13岁的齐铭，眼睛大大的，头发柔软，漂亮得如同女孩子。他孤单地站在站台上，猜着火车，他问我哪列火车可以到北京去，可是我动不了，说不出话，于是他蹲在地上哭了。我想走过去抱着他，可是我却动不了，齐铭望着我，一直哭不肯停。可是我连话都说不出来，我难过得像要死掉了。梦中开过了一列火车，轰隆隆，轰隆隆，碾碎了齐铭的面容，碾碎了我留在齐铭身上的青春，碾碎了那几个明媚的夏天，碾碎了那面白色的墙，碾碎了齐铭那辆帅气的单车，碾碎了他的素描，碾碎了我最后的梦境。";

//    [self.teamDetaliV.applyJoin addTarget:self action:@selector(apply) forControlEvents:(UIControlEventTouchUpInside)];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [self.teamDetaliV.buttonBackView viewWithTag:200 + i];
        [button addTarget:self action:@selector(buttons:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0 , 20, 30 * screenWidth / 320, 30 * screenWidth / 320);
    [backBtn addTarget:self action:@selector(backBut) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"backL"] forState:(UIControlStateNormal)];
    [self.teamDetaliV.topBackImageV addSubview:backBtn];
    [self.teamDetaliV.applyBtn addTarget:self action:@selector(applyCreat) forControlEvents:(UIControlEventTouchUpInside)];
    [self.teamDetaliV.applyJoin addTarget:self action:@selector(applyJoin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.teamDetaliV resetUI];
    [self.view addSubview:self.teamDetaliV];
    self.teamDetaliV.contentSize = CGSizeMake(screenWidth, self.teamDetaliV.applyBtn.frame.origin.y + 70);
    // Do any additional setup after loading the view.
}

//


// 申请加入
- (void)applyJoin{
    JGApplyMaterialViewController *apVC = [[JGApplyMaterialViewController alloc] init];
    apVC.teamKey = [[self.teamDetailDic objectForKey:@"timeKey"] integerValue];
    [self.navigationController pushViewController:apVC animated:YES];
}

// 创建球队
- (void)applyCreat{
        [[JsonHttp jsonHttp] httpRequest:@"team/createTeam" JsonKey:@"team" withData:self.teamDetailDic requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"error");
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
        }];
    NSLog(@"%@", self.teamDetailDic);
}

- (void)backBut{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttons:(UIButton *)button{
    if (button.tag == 200) {
        // 活动
        JGTeamActivityViewController *activityVC = [[JGTeamActivityViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }else if (button.tag == 201){
        // 相册
        JGTeamPhotoViewController *photoVC = [[JGTeamPhotoViewController alloc] init];
        [self.navigationController pushViewController:photoVC animated:YES];

    }
}

//- (void)apply{
//    JGApplyMaterialViewController *apVC = [[JGApplyMaterialViewController alloc] init];
//    [self.navigationController pushViewController:apVC animated:YES];
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
