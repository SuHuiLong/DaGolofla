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
#import "JGNotTeamMemberDetailViewController.h"
#import "JGNewCreateTeamTableViewController.h"
#import "JGTeamActivityCell.h"
#import <CoreLocation/CLLocation.h>
#import "EnterViewController.h"
#import "Helper.h"

#import "HomeHeadView.h"  // topscrollView
#import "ChangePicModel.h"


@interface JGTeamChannelViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIImageView *topView;
@property (nonatomic, strong)HomeHeadView *topScrollView;
@property (nonatomic, strong)NSMutableArray *scrillViewArray;

@property (nonatomic, strong)JGTeamChannelTableView *tableView;
@property (nonatomic, strong)NSMutableArray *buttonArray;

@property (nonatomic, strong)NSMutableArray *teamArray;
@property (nonatomic, strong)NSMutableArray *myTeamArray;
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
    creatTeam.titleLabel.font = [UIFont systemFontOfSize:15  * screenWidth / 320];
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160 * screenWidth / 320)];
    self.topView.image = [UIImage imageNamed:@"jianbian"];
    self.topView.userInteractionEnabled = YES;
//    [self.view addSubview:self.topView];
    [self.topView addSubview:backBtn];
    [self.topView addSubview:creatTeam];
    
    self.topScrollView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160 * screenWidth / 320)];
    self.topScrollView.userInteractionEnabled = YES;
    [self createScrollView];
    [self.view addSubview:self.topScrollView];
    
    [self.topScrollView addSubview:backBtn];
    [self.topScrollView addSubview:creatTeam];
    
    self.buttonArray = [NSMutableArray arrayWithObjects:@"我的球队", @"球队活动", @"球队大厅", nil];
    
    for (int i = 0; i < 3; i ++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, (165 + i * 35) * screenWidth / 320, screenWidth, 30 * screenWidth / 320);
        button.tag = 200 + i;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font =[UIFont systemFontOfSize:15 * screenWidth / 320];

        [button addTarget:self action:@selector(team:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:self.buttonArray[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 200 * screenWidth / 320);
        [self.view addSubview:button];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 6 * screenWidth / 320, 20 * screenWidth / 320, 20 * screenWidth / 320)];
        NSArray *arra = [NSArray arrayWithObjects:@"qd", @"hd-1", @"dt", nil];
        imageV.image = [UIImage imageNamed:arra[i]];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:imageV];
    }
    
    self.tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 300 * screenWidth / 320, screenWidth, screenHeight - 300 * screenWidth / 320) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.rowHeight = 83 * screenWidth / 320;
    
    [self.view addSubview:self.tableView];
    
    [self setData];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 270 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
    [self.view addSubview:self.titleLB];
    
    // Do any additional setup after loading the view.
}

//创建首页页面滚动视图
-(void)createScrollView
{
    //    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [[PostDataRequest sharedInstance] postDataRequest:@"scroll/queryAll.do" parameter:@{@"scrollClass":@0} success:^(id respondsData) {
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            NSMutableArray* arrayIcon = [[NSMutableArray alloc]init];
            NSMutableArray* arrayUrl = [[NSMutableArray alloc]init];
            NSMutableArray* arrayTitle = [[NSMutableArray alloc]init];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                ChangePicModel *model = [[ChangePicModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [self.scrillViewArray addObject:model];
                [arrayIcon addObject:model.pic];
                [arrayUrl addObject:model.nexturl];
                [arrayTitle addObject:model.title];
            }
            //            //NSLog(@"%@",arrayIcon[0]);
            
            [self.topScrollView config:arrayIcon data:arrayUrl title:arrayTitle];
            self.topScrollView.delegate = self;
            [self.topScrollView setClick:^(UIViewController *vc) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)setData{
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {

    
    NSMutableDictionary *getMyTeam = [NSMutableDictionary dictionary];
    [getMyTeam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
//    [getMyTeam setObject:@192 forKey:@"teamKey"];
    [getMyTeam setValue:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamList" JsonKey:nil withData:getMyTeam requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {

        self.myTeamArray =  [data[@"teamList"] mutableCopy];
        
        if ([self.myTeamArray count] != 0) {
            self.titleLB.text = @" 近期活动";
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:DEFAULF_USERID forKey:@"userKey"];
            [dic setValue:@0 forKey:@"offset"];
//            [getMyTeam setObject:@192 forKey:@"teamKey"];
            [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
                [Helper alertViewNoHaveCancleWithTitle:@"获取活动列表失败" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
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
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([user objectForKey:@"lng"]) {
                [dic setObject:[user objectForKey:@"lng"] forKey:@"longitude"];
            }
            else
            {
                [dic setObject:@121.605072 forKey:@"longitude"];
            }
            
            if ([user objectForKey:@"lat"]) {
                [dic setObject:[user objectForKey:@"lat"] forKey:@"latitude"];
            }
            else
            {
                [dic setObject:@31.156063 forKey:@"latitude"];
            }
            NSString *str = [user objectForKey:@"currentCity"];
            if (![user objectForKey:@"currentCity"]) {
                str = @"上海";
            }
            [dic setValue:str forKey:@"crtyName"];
            [dic setValue:@0 forKey:@"offset"];
            [[JsonHttp jsonHttp] httpRequest:@"team/getTeamList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
                [Helper alertViewNoHaveCancleWithTitle:@"获取推荐球队列表失败" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            } completionBlock:^(id data) {
                self.teamArray = data[@"teamList"];


                [self.tableView reloadData];
                
            }];
            
        }
    }];
    }else{
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


- (void)creatTeam{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    
    
    if ([user objectForKey:@"cacheCreatTeamDic"]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [user setObject:0 forKey:@"cacheCreatTeamDic"];
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            [self.navigationController pushViewController:creatteamVc animated:YES];
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            creatteamVc.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
            creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
            

            [self.navigationController pushViewController:creatteamVc animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
        [self.navigationController pushViewController:creatteamVc animated:YES];
    }
    
    
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
    
    
    
    if (([self.myTeamArray count] == 0)) {
               return [self.teamArray count];
    }else{
        if ([self.myActivityArray count] == 0) {
            return 0;
        }else{
            return [self.myActivityArray count];
        }
    }
    
    
    
    
//    if (([self.teamArray count] != 0) || ([self.myTeamArray count] != 0)) {
//            return [self.teamArray count] != 0 ? [self.teamArray count] : [self.myTeamArray count];
//    }else{
//        if ([self.myActivityArray count] == 0) {
//            return 0;
//        }else{
//            return [self.myActivityArray count];
//        }
//    }
    
//    return ([self.myActivityArray count] != 0 ? [self.myActivityArray count] : [self.teamArray count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    if (([self.myTeamArray count] == 0)) {
        JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.teamModel = self.teamArray[indexPath.row];
             cell.nameLabel.text = [self.teamArray[indexPath.row] objectForKey:@"name"];
        cell.adressLabel.text = [self.teamArray[indexPath.row] objectForKey:@"crtyName"];
        cell.describLabel.text = [self.teamArray[indexPath.row] objectForKey:@"info"];
        [cell.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[[self.teamArray[indexPath.row] objectForKey:@"timeKey"] integerValue]] placeholderImage:[UIImage imageNamed:@"logo"]];
        ;
        return cell;
    }else{
            if ([self.myActivityArray count] == 0) {
            return nil;
        }else{
        JGTeamActivityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JGTeamActivityCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setJGTeamActivityCellWithModel:self.myActivityArray[indexPath.row]];
        return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.myActivityArray count] == 0) {

        JGNotTeamMemberDetailViewController *detailV = [[JGNotTeamMemberDetailViewController alloc] init];
        detailV.detailDic = self.teamArray[indexPath.row];
        
        [self.navigationController pushViewController:detailV animated:YES];
    }else{
        //频道首页cell
        JGTeamActibityNameViewController *teamActivityVC = [[JGTeamActibityNameViewController alloc] init];
        JGTeamAcitivtyModel *model = self.myActivityArray[indexPath.row];
        teamActivityVC.isTeamChannal = 1;
        teamActivityVC.model = model;
        teamActivityVC.teamActivityKey = model.teamActivityKey;
        [self.navigationController pushViewController:teamActivityVC animated:YES];

    }
}

- (NSMutableArray *)scrillViewArray{
    if (!_scrillViewArray) {
        _scrillViewArray = [[NSMutableArray alloc] init];
    }
    return _scrillViewArray;
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

- (NSMutableArray *)myTeamArray{
    if (!_myTeamArray) {
        _myTeamArray = [[NSMutableArray alloc] init];
    }
    return _myTeamArray;
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
