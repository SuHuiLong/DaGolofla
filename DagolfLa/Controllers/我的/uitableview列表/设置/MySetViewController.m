//
//  MySetViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/25.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MySetViewController.h"

#import "MySetBindViewController.h"
#import "MySetPasswordController.h"

#import "MySetHelpController.h"
#import "MySetUpDateViewController.h"
#import "MySetReceiveController.h"
#import "MySetApplyController.h"

#import "EnterViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#define kUpDateData_URL @"user/updateUserInfo.do"

#import "SDImageCache.h"

#import "ScreenViewController.h"
#import "InformViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "UITabBar+badge.h"

@interface MySetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    //cell的标题
    NSArray* _titleArray;
    //最下方按钮
    UIButton* _btnExit;
    //
    BOOL _isClick;
    
    BOOL _isOrder;
    
    NSMutableString* _str;
    NSMutableDictionary* _dict;
    
    UILabel* _labCache;
}

@end

@implementation MySetViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _titleArray = [[NSArray alloc]init];
//    _titleArray = @[@[@"关于我们",@"帮助反馈",@"清空缓存"],@[@"是否接受他人约球"]];
    _titleArray = @[@"通知设置",@"屏蔽管理",@"帮助反馈",@"清空缓存"];
    
    
    _dict = [[NSMutableDictionary alloc]init];
    [self uiConfig];
    
    
//    [self createImage];
    
    [self createBtnView];
    
    // 获取通知设置
    [self setinformMessege];

}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*4*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    
    _labCache = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-130*ScreenWidth/375, 44*3*ScreenWidth/375, 100*ScreenWidth/375, 44*ScreenWidth/375)];
    [_tableView addSubview:_labCache];
    NSInteger cacha=[[SDImageCache sharedImageCache] getSize];
    float ca=cacha/1000.0/1000.0;
    if (ca==0) {
        _labCache.text=[NSString stringWithFormat:@"%.2fk",ca];
    }else{
        _labCache.text=[NSString stringWithFormat:@"%.2fM",ca];
    }
    _labCache.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _labCache.textAlignment = NSTextAlignmentRight;
    
}

/**
 *  是否接受约球显示的图片
 */
-(void)createImage
{
    UISwitch* switV = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth-70*ScreenWidth/375, 245*ScreenWidth/375-44*ScreenWidth/375*2-11*ScreenWidth/375, 0, 0)];
    [_tableView addSubview:switV];
    [switV addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchIsChanged:(UISwitch *)swith
{
    if ([swith isOn]){
//        ////NSLog(@"The switch is on.");
    } else {
//        ////NSLog(@"The switch is off.");
    }
    ////NSLog(@"%d",[swith isOn]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _str = [[NSMutableString alloc]init];
    if (defaults) {
        
        _str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"userId"]];
        //        [_dict setValue:str forKey:@"uId"];
        //         ////NSLog(@"%@",str);
        [_dict setObject:_str forKey:@"userId"];
    }
    NSNumber* num = [NSNumber numberWithBool:[swith isOn]];
    
    [_dict setValue:num forKey:@"isPlayBall"];
    [[PostDataRequest sharedInstance] postDataRequest:kUpDateData_URL parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    } failed:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        
    }];
    
}

/**
 *  退出登录按钮
 */
-(void)createBtnView
{
    _btnExit = [[UIButton alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 44*4*ScreenWidth/375+1*10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_btnExit];
    [_btnExit setTitle:@"退出登录" forState:UIControlStateNormal];
    [_btnExit setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _btnExit.backgroundColor = [UIColor whiteColor];
    [_btnExit addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _btnExit.layer.cornerRadius = 10*ScreenWidth/375;
    _btnExit.layer.masksToBounds = YES;
}
-(void)exitBtnClick
{

    [Helper alertViewWithTitle:@"是否退出账号?" withBlockCancle:^{
        
        
    } withBlockSure:^{
        //网页端同步退出
        [[PostDataRequest sharedInstance] getDataRequest:[NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLogOut"] success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"%@",[dict objectForKey:@"MessageString"]);
        } failed:^(NSError *error) {
            
        }];
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        //
        [[RCIMClient sharedRCIMClient]logout];
        //清空记分的数据和登录的数据
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        
        [user removeObjectForKey:@"userId"];
        [user removeObjectForKey:@"isFirstEnter"];
        [user removeObjectForKey:@"userName"];

        [user removeObjectForKey:@"scoreObjectTitle"];
        [user removeObjectForKey:@"scoreballName"];
        [user removeObjectForKey:@"scoreSite0"];
        [user removeObjectForKey:@"scoreSite1"];
        [user removeObjectForKey:@"scoreType"];
        [user removeObjectForKey:@"scoreTTaiwan"];
        [user removeObjectForKey:@"scoreObjectId"];
        [user removeObjectForKey:@"scoreballId"];
        [user removeObjectForKey:@"openId"];
        [user removeObjectForKey:@"uid"];
        [user removeObjectForKey:@"isWeChat"];
        [user removeObjectForKey:@"rongTk"];
        [user synchronize];

        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        EnterViewController *vc = [[EnterViewController alloc] init];
        vc.popViewNumber = 101;
        [self.navigationController pushViewController:vc animated:YES];
        
    } withBlock:^(UIAlertController *alertView) {
        
        [self.navigationController presentViewController:alertView animated:YES completion:nil];
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
//    if (section != 0) {
//        height = 10*ScreenWidth/375;
//    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//返回标题数组中元素的个数来确定分区的个数
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger number = 0;
//    if (section == 0)
//    {
//        number  = 3;
//    }
//    else
//    {
//        number  = 1;
//    }
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section != 1) {
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];

    if (indexPath.row == 0) {
        InformViewController* inforVc = [[InformViewController alloc]init];
        [self.navigationController pushViewController:inforVc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        ScreenViewController *screenVC = [[ScreenViewController alloc] init];
        [self.navigationController pushViewController:screenVC animated:YES];
    }
    else if (indexPath.row == 2)
    {
        MySetHelpController* mySetVc = [[MySetHelpController alloc]init];
        [self.navigationController pushViewController:mySetVc animated:YES];
    }
    else {
        [[SDImageCache sharedImageCache] clearDisk];
        NSInteger cacha=[[SDImageCache sharedImageCache] getSize];
        float ca=cacha/1000.0/1000.0;
        if (ca==0) {
            _labCache.text=[NSString stringWithFormat:@"%.2fk",ca];
        }else{
            _labCache.text=[NSString stringWithFormat:@"%.2fM",ca];
        }
    }


}


#pragma mark ------- 用户设置通知消息

- (void)setinformMessege{
    
    [[PostDataRequest sharedInstance] postDataRequest:@"user/querybyUserSys.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSDictionary *modelDic = [dict objectForKey:@"rows"];
            
            [[NSUserDefaults standardUserDefaults] setObject:modelDic forKey:@"informMessege"];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取通知设置信息失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failed:^(NSError *error) {
        
        
    }];
    
}


@end
