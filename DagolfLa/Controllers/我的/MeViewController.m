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
#import "NewsDetailController.h"
#import "MyTradeViewController.h"
#import "MyActivityViewController.h"
#import "MyAwardViewController.h"
#import "MyRecomViewController.h"
#import "ScreenViewController.h"


#import "MySetViewController.h"

#import "MeTableViewCell.h"
#import "MBProgressHUD.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MeselfModel.h"
#import "UIImageView+WebCache.h"

//登录注册
#import "EnterViewController.h"
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:self];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
        _progressView = [[MBProgressHUD alloc] initWithView:self.view];
        _progressView.mode = MBProgressHUDModeIndeterminate;
        _progressView.labelText = @"正在刷新...";
        [self.view addSubview:_progressView];
        [_progressView show:YES];
        //
        [[PostDataRequest sharedInstance] postDataRequest:@"user/queryById.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"]boolValue] == 1) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [_model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];

                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                if (![Helper isBlankString:[[dict objectForKey:@"rows"] objectForKey:@"pic"]]) {
                    [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
                }
                if (![Helper isBlankString:[[dict objectForKey:@"rows"] objectForKey:@"userName"]])
                {
                    [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"userName"] forKey:@"userName"];
                }
                [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"sex"] forKey:@"sex"];
                [user synchronize];
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        _imgvIcon.image = [UIImage imageNamed:@"zwt"];
        _labelnickName.text = nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        EnterViewController *vc = [[EnterViewController alloc] init];
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
    _arrayTitle = @[@[@""],@[@"球友",@"足迹"],@[@"个人帐户",@"交易中心"],@[@"推荐有礼",@"关于我们",@"产品评价"],@[@"设置"]];
    _arrayPic = @[@[@""],@[@"qyIcon",@"zuji"],@[@"hdIcon",@"jyIcon"],@[@"tjIcon",@"gyIcon",@"proIcon"],@[@"setIcon"]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*8*ScreenWidth/375+40*ScreenWidth/375+90*ScreenWidth/375)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    
    [_tableView registerClass:[MeHeadTableViewCell class] forCellReuseIdentifier:@"MeHeadTableViewCell"];
    [_tableView registerClass:[MeDetailTableViewCell class] forCellReuseIdentifier:@"MeDetailTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;//返回标题数组中元素的个数来确定分区的个数
    
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
        count = 2;
    }
    else if (section == 2)
    {
        count = 2;
    }
    else if (section == 3)
    {
        count = 3;
    }
    else
    {
        count = 1;
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
            [cell.iconImgv sd_setImageWithURL:[Helper imageIconUrl:_model.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
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
        NSArray *titleArr = @[@"个人资料",@"球友",@"足迹",@"交易中心",@"我的活动",@"推荐有礼",@"关于我们",@"产品评价",@"设置"];
//PersonHomeController   PersonHomeController
        NSArray* VcArr = @[@"PersonHomeController",@"ContactViewController",@"MyFootViewController",@"JGDPrivateAccountViewController",@"MyTradeViewController",@"MyRecomViewController",@"MySetAboutController",@"",@"MySetViewController"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < VcArr.count; i++) {
            if (i != 7) {
                ViewController* vc = [[NSClassFromString(VcArr[i]) alloc]init];
                vc.title = titleArr[i];
                [arr addObject:vc];
            }
            
        }
        
        if (indexPath.section == 0) {
            PersonHomeController* selfVc = [[PersonHomeController alloc]init];
            selfVc.sexType = [_model.sex integerValue];
            selfVc.strMoodId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
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
                    [self.navigationController pushViewController:arr[3] animated:YES];
                    break;
                }
                case 1:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[4] animated:YES];
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
                    [self.navigationController pushViewController:arr[5] animated:YES];
                    break;
                }
                    
                case 1:{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:arr[6] animated:YES];
                    
                    break;
                }
                    
                case 2:
                {
                    [Helper alertViewWithTitle:@"是否立即前往appStore进行评价" withBlockCancle:^{
                        
                    } withBlockSure:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/da-gao-er-fu-la-guo-nei-ling/id1056048082?l=en&mt=8"]];
                    } withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            [self.navigationController pushViewController:arr[7] animated:YES];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
 
}


@end
