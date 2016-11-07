//
//  MeViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MeViewController.h"
//表头大按钮
#import "SelfViewController.h"
//表头小按钮
#import "MyAttentionController.h"
#import "MyFootViewController.h"
//列表点击视图
#import "MyAccountViewController.h"
#import "MyTradeViewController.h"
#import "ScreenViewController.h"


#import "MySetViewController.h"

#import "MeTableViewCell.h"
#import "MBProgressHUD.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MeselfModel.h"
#import "UIImageView+WebCache.h"

//登录注册
#import "UserDataInformation.h"

#import "PersonHomeController.h"
//融云会话列表
#import "ChatListViewController.h"

#import "MyNewsBoxViewController.h"
#import "MySetAboutController.h"
#import "ContactViewController.h"
#import "UITabBar+badge.h"

#import "MeHeadTableViewCell.h"
#import "MeDetailTableViewCell.h"

#import "PersonHomeController.h"
#import "JGDPrivateAccountViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"

//#import "JGDPrizeViewController.h"


#import "JGTeamActibityNameViewController.h"
#import "JGNotTeamMemberDetailViewController.h"
#import "JGTeamMemberORManagerViewController.h"
#import "DetailViewController.h"
#import "JGLPushDetailsViewController.h"
#import "UseMallViewController.h"

#import "JGMyBarCodeViewController.h"
#import "JGNewCreateTeamTableViewController.h"

#import "JGMeMoreViewController.h" // 更多


@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSArray* _arrayTitle;
    NSArray* _arrayPic;
    
    MeselfModel* _model;
    MBProgressHUD* _progressView;
    //头像
    UIImageView* _imgvIcon;
    //保存用户名的字符串
    NSString* _aString;
    //用户名
    UILabel* _labelnickName;
    //用户名宽度
    CGSize _titleSize;
    //性别图标
    UIImageView* _activeIcon;
}
@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = nil;
    
  
    
    //监听分组页面返回，刷新数据
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(PushJGTeamActibityNameViewController:) name:@"PushJGTeamActibityNameViewController" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:self];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
        _progressView = [[MBProgressHUD alloc] initWithView:self.view];
        _progressView.mode = MBProgressHUDModeIndeterminate;
        _progressView.labelText = @"正在刷新...";
        [self.view addSubview:_progressView];
        [_progressView show:YES];
        //
        
        NSMutableDictionary* dictUser = [[NSMutableDictionary alloc]init];
        [dictUser setObject:DEFAULF_USERID forKey:@"userKey"];
        NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
        [dictUser setObject:strMD forKey:@"md5"];
        
        [[JsonHttp jsonHttp]httpRequest:@"user/getUserInfo" JsonKey:nil withData:dictUser requestMethod:@"GET" failedBlock:^(id errType) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } completionBlock:^(id data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[data objectForKey:@"packSuccess"]boolValue]) {
                [_model setValuesForKeysWithDictionary:[data objectForKey:@"user"]];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                if (![Helper isBlankString:[[data objectForKey:@"user"] objectForKey:@"pic"]]) {
                    [user setObject:[[data objectForKey:@"user"] objectForKey:@"pic"] forKey:@"pic"];
                }
                if (![Helper isBlankString:[[data objectForKey:@"user"] objectForKey:@"userName"]])
                {
                    [user setObject:[[data objectForKey:@"user"] objectForKey:@"userName"] forKey:@"userName"];
                }
                [user setObject:[[data objectForKey:@"user"] objectForKey:@"sex"] forKey:@"sex"];
                [user synchronize];
            }
        }];

        
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        _imgvIcon.image = [UIImage imageNamed:@"zwt"];
        _labelnickName.text = nil;
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        return;
    }
}

#pragma mark -- 网页 跳转活动详情
- (void)PushJGTeamActibityNameViewController:(NSNotification *)not{
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        return;
    }
    
    
    if ([not.userInfo[@"details"] isEqualToString:@"activityKey"]) {
        //活动
        JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
        teamCtrl.teamKey = [not.userInfo[@"timekey"] integerValue];
        teamCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teamCtrl animated:YES];
        return;
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"teamKey"])
    {
        //球队
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
        [dic setObject:@([not.userInfo[@"timekey"] integerValue]) forKey:@"teamKey"];
        
        [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                
                if (![data objectForKey:@"teamMember"]) {
                    JGNotTeamMemberDetailViewController *detailVC = [[JGNotTeamMemberDetailViewController alloc] init];
                    detailVC.detailDic = [data objectForKey:@"team"];
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else{
                    
                    if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
                        JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                        detailVC.detailDic = [data objectForKey:@"team"];
                        detailVC.isManager = YES;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }else{
                        JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                        detailVC.detailDic = [data objectForKey:@"team"];
                        detailVC.isManager = NO;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                    
                    
                }
                
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
            
        }];
        
        return;
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"goodKey"])
    {
        //商城
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        UseMallViewController* userVc = [[UseMallViewController alloc]init];
        userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td",[not.userInfo[@"timekey"] integerValue]];
        [self.navigationController pushViewController:userVc animated:YES];
        return;
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"url"])
    {
        //h5
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        JGLPushDetailsViewController* puVc = [[JGLPushDetailsViewController alloc]init];
        puVc.strUrl = [NSString stringWithFormat:@"%@",not.userInfo[@"timekey"]];
        [self.navigationController pushViewController:puVc animated:YES];
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"moodKey"])
    {
        //社区
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        
        DetailViewController * comDevc = [[DetailViewController alloc]init];
        
        comDevc.detailId = [NSNumber numberWithInteger:[not.userInfo[@"timekey"] integerValue]];
        
        [self.navigationController pushViewController:comDevc animated:YES];
        
    }
    //创建球队
    else if ([not.userInfo[@"details"] isEqualToString:@"createTeam"]) {
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
    else{
        
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
        vc.reloadCtrlData = ^(){
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    
    _model = [[MeselfModel alloc] init];
    [self createTableView];
    

}



-(void)createTableView
{
    
    _dataArray = [[NSMutableArray alloc]init];
    _arrayTitle = [[NSArray alloc]init];
    _arrayPic = [[NSArray alloc]init];
//    _arrayTitle = @[@[@"我的聊天",@"我的消息",@"交易中心",@"我的活动",@"推荐有礼"],@[@"设置"]];
    _arrayTitle = @[@[@""],@[@"球友",@"足迹",@"我的二维码"],@[@"个人帐户",@"交易中心"],@[@"推荐有礼",@"设置",@"更多"]];
    _arrayPic = @[@[@""],@[@"qyIcon",@"zuji",@"saomiao"],@[@"gerenzhanghu",@"jyIcon"],@[@"tjIcon",@"setIcon",@"btn_more"]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*8*ScreenWidth/375+40*ScreenWidth/375+80*ScreenWidth/375)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    
    [_tableView registerClass:[MeHeadTableViewCell class] forCellReuseIdentifier:@"MeHeadTableViewCell"];
    [_tableView registerClass:[MeDetailTableViewCell class] forCellReuseIdentifier:@"MeDetailTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;//返回标题数组中元素的个数来确定分区的个数
    
}
//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10*ScreenWidth/375;
    if (section == 0) {
        height = 0;
    }
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section == 0)
    {
        count = 1;
    }
    else if (section == 1)
    {
        count = 3;
    }
    else if (section == 2)
    {
        count = 2;
    }
    else if (section == 3)
    {
        count = 3;
    }
    
    return count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 90*ScreenWidth/375 : 44*ScreenWidth/375;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MeHeadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MeHeadTableViewCell"];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
            
            NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/%@/head/%td.jpg@200w_200h",@"user",[DEFAULF_USERID integerValue]];
            [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
            [cell.iconImgv sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[DEFAULF_USERID integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
            cell.nameLabel.text = _model.userName;
            if (![Helper isBlankString:_model.pic] && ![Helper isBlankString:_model.userName] && ![Helper isBlankString:_model.userSign]) {
                cell.detailLabel.text = _model.userSign;
            }
            else
            {
                cell.detailLabel.text = @"您的资料还未完善，点击完善资料。";
            }
            if ([_model.sex integerValue] == 0) {
                cell.imgvSex.image = [UIImage imageNamed:@"xb_n"];
            }
            else
            {
                cell.imgvSex.image = [UIImage imageNamed:@"xb_nn"];
            }
        }
        else
        {
            [cell.iconImgv setImage:[UIImage imageNamed:@"zwt"]];
            cell.nameLabel.text = @"";
            cell.detailLabel.text = @"您还没有登录，赶快登陆哦";
            cell.imgvSex.image = [UIImage imageNamed:@"xb_n"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        MeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeDetailTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _arrayTitle[indexPath.section][indexPath.row];
        cell.iconImgv.image = [UIImage imageNamed:_arrayPic[indexPath.section][indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
//        NSArray *titleArr = @[@"我的聊天",@"我的消息",@"交易中心",@"我的活动",@"推荐有礼",@"设置"];
        NSArray *titleArr = @[@"个人资料",@"球友",@"我的二维码",@"足迹",@"交易中心",@"交易中心",@"推荐有礼",@"设置", @"更多"];
//PersonHomeController   PersonHomeController
        NSArray* VcArr = @[@"PersonHomeController",@"ContactViewController",@"JGMyBarCodeViewController",@"MyFootViewController",@"JGDPrivateAccountViewController",@"MyTradeViewController",@"MyRecomViewController",@"MySetViewController", @"JGMeMoreViewController"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < VcArr.count; i++) {
//            if (i != 8) {
                ViewController* vc = [[NSClassFromString(VcArr[i]) alloc]init];
                vc.title = titleArr[i];
                [arr addObject:vc];
//            }
            
        }
        
        if (indexPath.section == 0) {
            PersonHomeController* selfVc = [[PersonHomeController alloc]init];
            selfVc.sexType = [_model.sex integerValue];
            selfVc.strMoodId = _model.userId;
            [self.navigationController pushViewController:selfVc animated:YES];
        }
        else if (indexPath.section == 1)
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[1] animated:YES];
                    break;
                }
                case 1:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[3] animated:YES];
                    break;
                }
                case 2:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[2] animated:YES];
                    break;
                }
                default:
                    break;
            }
        }
        else if (indexPath.section == 2)
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[4] animated:YES];
                    break;
                }
                case 1:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[5] animated:YES];
                    break;
                }
                default:
                    break;
            }
        }
        else if (indexPath.section == 3)
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[6] animated:YES];
                    break;
                }
                    
                case 1:{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[7] animated:YES];
                    
                    break;
                }
                    
                case 2:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[8] animated:YES];

                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            [self.navigationController pushViewController:arr[8] animated:YES];
        }
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
 
}


@end
