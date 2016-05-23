//
//  JGTeamChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelViewController.h"
#import "JGTeamChannelTableView.h"
#import "JGTeamChannelTableViewCell.h"
#import "JGTeamDetailViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGTeamDetailStylelTwoViewController.h"
#import "JGApplyMaterialViewController.h"
#import "JGTeamDetailViewController.h"
#import "JGCreateTeamViewController.h"
#import "JGTeamChannelActivityTableViewCell.h"
#import "JGTeamActivityViewController.h"
#import "JGLMyTeamViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamDetail.h"
#import "JGTeamActivityCell.h"
#import "JGTeamActibityNameViewController.h"


@interface JGTeamChannelViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIImageView *topView;

@property (nonatomic, strong)JGTeamChannelTableView *tableView;
@property (nonatomic, strong)NSMutableArray *buttonArray;

@property (nonatomic, strong)NSMutableArray *teamArray;
@property (nonatomic, strong)NSMutableArray *myActivityArray;
@property (nonatomic, strong)UILabel *titleLB;

@end

@implementation JGTeamChannelViewController

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
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0 , 20, 30 * screenWidth / 320, 30 * screenWidth / 320);
    [backBtn addTarget:self action:@selector(backBut) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"backL"] forState:(UIControlStateNormal)];
    
    UIButton *creatTeam = [UIButton buttonWithType:(UIButtonTypeCustom)];
    creatTeam.frame = CGRectMake(screenWidth - 80 * screenWidth / 320 , 20 * screenWidth / 320, 80 * screenWidth / 320, 30 * screenWidth / 320);
    [creatTeam addTarget:self action:@selector(creatTeam) forControlEvents:(UIControlEventTouchUpInside)];
    [creatTeam setTitle:@"创建球队" forState:(UIControlStateNormal)];
    
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130 * screenWidth / 320)];
    self.topView.image = [UIImage imageNamed:@"jianbian"];
    self.topView.userInteractionEnabled = YES;
    [self.view addSubview:self.topView];
    
    [self.topView addSubview:backBtn];
    [self.topView addSubview:creatTeam];
    
    self.buttonArray = [NSMutableArray arrayWithObjects:@"我的球队", @"球队活动", @"球队大厅", nil];
    
    for (int i = 0; i < 3; i ++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, (135 + i * 35) * screenWidth / 320, screenWidth, 30 * screenWidth / 320);
        button.tag = 200 + i;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(team:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:self.buttonArray[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 200 * screenWidth / 320);
        [self.view addSubview:button];
        UIImageView *iamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30 * screenWidth / 320, 30 * screenWidth / 320)];
        iamgeV.backgroundColor = [UIColor orangeColor];
        [button addSubview:iamgeV];
    }
    
    self.tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 270 * screenWidth / 320, screenWidth, screenHeight - 270 * screenWidth / 320) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.rowHeight = 83 * screenWidth / 320;
    
    [self.view addSubview:self.tableView];
    
    [self setData];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 240 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
    [self.view addSubview:self.titleLB];
    
    // Do any additional setup after loading the view.
}


- (void)setData{
    
    NSMutableDictionary *getMyTeam = [NSMutableDictionary dictionary];
    [getMyTeam setObject:@244 forKey:@"userKey"];
    [getMyTeam setValue:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamList" JsonKey:nil withData:getMyTeam requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        
        for (NSDictionary *dicModel in data[@"teamList"]) {
            JGTeamDetail *model = [[JGTeamDetail alloc] init];
            [model setValuesForKeysWithDictionary:dicModel];
            [self.teamArray addObject:model];
        }
        [self.tableView reloadData];
        if ([_teamArray count] != 0) {
            self.titleLB.text = @" 近期活动";
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@244 forKey:@"userKey"];
            [dic setValue:@0 forKey:@"offset"];
            [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
                NSLog(@"getMyTeamActivityList ***** error");
            } completionBlock:^(id data) {
                
                for (NSDictionary *dicModel in data[@"activityList"]) {
                    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicModel];
                    [self.myActivityArray addObject:model];
                }
                [self.tableView reloadData];
            }];
        }else{
            self.titleLB.text = @" 推荐球队";
            [[JsonHttp jsonHttp] httpRequest:@"team/getTeamList" JsonKey:nil withData:nil requestMethod:@"POST" failedBlock:^(id errType) {
                NSLog(@"getTeamList ***** error");
            } completionBlock:^(id data) {
                
                for (NSDictionary *dicModel in data[@"getTeamList"]) {
                    JGTeamDetail *model = [[JGTeamDetail alloc] init];
                    [model setValuesForKeysWithDictionary:dicModel];
                    [self.teamArray addObject:model];
                }
                [self.tableView reloadData];
            }];
            
        }
    }];
    
}

- (void)creatTeam{
    
    JGCreateTeamViewController *creatteamVc = [[JGCreateTeamViewController alloc] init];
    [self.navigationController pushViewController:creatteamVc animated:YES];
    
}


- (void)backBut{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)team:(UIButton *)button{
    
    if (button.tag == 200) {
        //        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //        [dic setObject:@244 forKey:@"userKey"];
        //        [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamList" withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        //            NSLog(@"erro");
        //        } completionBlock:^(id data) {
        //            NSLog(@"%@", data);
        //        }];
        JGLMyTeamViewController* myVc = [[JGLMyTeamViewController alloc]init];
        [self.navigationController pushViewController:myVc animated:YES];
    }else if (button.tag == 201) {
        JGTeamActivityViewController* teamVc = [[JGTeamActivityViewController alloc]init];
        [self.navigationController pushViewController:teamVc animated:YES];
    }else if (button.tag == 202) {
        
        JGTeamMainhallViewController *MainhallTeamVC = [[JGTeamMainhallViewController alloc] init];
        [self.navigationController pushViewController:MainhallTeamVC animated:YES];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ([self.myActivityArray count] != 0 ? [self.myActivityArray count] : [self.teamArray count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.myActivityArray count] == 0) {
        JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.teamModel = self.teamArray[indexPath.row];
        return cell;
        
    }else{
        
        JGTeamChannelActivityTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellActivity"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.activityModel = self.myActivityArray[indexPath.row];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.teamArray count] == 0) {
        JGTeamActibityNameViewController *teamActivityVC = [[JGTeamActibityNameViewController alloc] init];
        JGTeamAcitivtyModel *model = self.myActivityArray[indexPath.row];
        teamActivityVC.teamActivityKey = model.timeKey;
        [self.navigationController pushViewController:teamActivityVC animated:YES];
        
    }else{
        
        if (indexPath.row == 0) {
            JGTeamDetailStylelTwoViewController *detailV = [[JGTeamDetailStylelTwoViewController alloc] init];
            [self.navigationController pushViewController:detailV animated:YES];
        }else{
            JGTeamDetailViewController *detailVC = [[JGTeamDetailViewController alloc] init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

- (NSMutableArray *)myActivityArray{
    if (!_myActivityArray) {
        _myActivityArray = [[NSMutableArray alloc] init];
    }
    return _myActivityArray;
}

- (NSMutableArray *)teamArray{
    if (!_teamArray) {
        _teamArray = [[NSMutableArray alloc] init];
    }
    return _teamArray;
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
