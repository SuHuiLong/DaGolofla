//
//  ChatListViewController.m
//  DagolfLa
//
//  Created by bhxx on 16/2/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ChatListViewController.h"
#import "UITool.h"

#import "ChatDetailViewController.h"
#import "ContactViewController.h"

#import "NewsDetailController.h"
#import "Helper.h"
#import "UITabBar+badge.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#import <RongIMKit/RCIM.h>
#import "JGHSystemNotViewController.h"
#import "JGHTeamNotViewController.h"

#import "RCDTabBarBtn.h"

@interface ChatListViewController ()<UITextFieldDelegate, RCIMUserInfoDataSource>
{
    UITextField* _textField;
    
    UIView* _viewHeader;
    
    UIButton* _btnInvite;
    
    NSInteger _teamUnread;
    NSInteger _systemUnread;
}

@end

@implementation ChatListViewController

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.isShowNetworkIndicatorView = NO;
    //    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
//    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        if ([[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray] == 0) {
             [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self refreshConversationTableViewIfNeeded];
//        [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
//        [self.tabBarController.tabBar showBadgeOnItemIndex:4];
        
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:self];
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
    [self notifyUpdateUnreadMessageCount];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >7.0) {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qytxl"] style:UIBarButtonItemStylePlain target:self action:@selector(teamFClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    self.conversationListTableView.backgroundColor=[UIColor whiteColor];
    self.conversationListTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
    [self createTableHeaderView];
    
//    self.title = @"消息";
    
    

    //聚合会话类型
//   [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_PRIVATE)]];

    [self loadMessageData];
    

}
#pragma mark -- 下载未读消息数量
- (void)loadMessageData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"msg/geSumtUnread" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _teamUnread = [[data objectForKey:@"teamUnread"] integerValue];
            _systemUnread = [[data objectForKey:@"systemUnread"] integerValue];
            
            [[_viewHeader viewWithTag:1000] removeFromSuperview];
            [[_viewHeader viewWithTag:1001] removeFromSuperview];
            [[_viewHeader viewWithTag:1002] removeFromSuperview];
            [[_viewHeader viewWithTag:1003] removeFromSuperview];
            
            if (100 > _systemUnread > 0) {
                RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(50 *ProportionAdapter, 10 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
                btn.layer.cornerRadius = 9;//圆形
                btn.unreadCount = [NSString stringWithFormat:@"%td", _systemUnread];
                btn.tag = 1000;
                [_viewHeader addSubview:btn];
            }
            
            if (_systemUnread > 100) {
                RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(50 *ProportionAdapter, 10 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
                btn.layer.cornerRadius = 9;//圆形
                [btn setImage:[UIImage imageNamed:@"icn_mesg_99+"] forState:UIControlStateNormal];
                btn.tag = 1001;
                [_viewHeader addSubview:btn];
            }
            
            if (100 > _teamUnread > 0) {
                RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(50 *ProportionAdapter, 78 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
                btn.layer.cornerRadius = 9;//圆形
                btn.unreadCount = [NSString stringWithFormat:@"%td", _teamUnread];
                btn.tag = 1002;
                [_viewHeader addSubview:btn];
            }
            
            if (_teamUnread > 100) {
                RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(50 *ProportionAdapter, 78 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
                btn.layer.cornerRadius = 9;//圆形
                [btn setImage:[UIImage imageNamed:@"icn_mesg_99+"] forState:UIControlStateNormal];
                btn.tag = 1003;
                [_viewHeader addSubview:btn];
            }
            
            [self updateBadgeValueForTabBarItem];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

//导航栏右按钮点击事件
-(void)teamFClick
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        ContactViewController* tVc = [[ContactViewController alloc]init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        [self.navigationController pushViewController:tVc animated:YES];
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
#pragma mark --头视图
-(void)createTableHeaderView
{
    
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 186*ProportionAdapter)];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    
    UIImageView *sysMessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10 *ProportionAdapter, 50 *ProportionAdapter, 47 *ProportionAdapter)];
    sysMessImageView.image = [UIImage imageNamed:@"app-message"];
    [_viewHeader addSubview:sysMessImageView];
    
    UILabel *sysNotLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 10 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
    sysNotLable.text = @"系统通知";
    sysNotLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    [_viewHeader addSubview:sysNotLable];
    
    UILabel *sysDetailLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 40 *ProportionAdapter, screenWidth -100*ProportionAdapter, 20 *ProportionAdapter)];
    sysDetailLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    sysDetailLable.text = @"系统消息第几纷纷大幅";
    [_viewHeader addSubview:sysDetailLable];
    
    UILabel *oneLine = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 67 *ProportionAdapter, screenWidth -10 *ProportionAdapter, 1)];
    oneLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:oneLine];
    
    UIButton *sysMessbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 67*ProportionAdapter)];
    [sysMessbtn addTarget:self action:@selector(sysMessbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHeader addSubview:sysMessbtn];
    
    //球队通知
    UIImageView *teamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 78 *ProportionAdapter, 50 *ProportionAdapter, 47*ProportionAdapter)];
    teamImageView.image = [UIImage imageNamed:@"team-message"];
    [_viewHeader addSubview:teamImageView];
    
    UILabel *teamNotLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 78 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
    teamNotLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    teamNotLable.text = @"球队通知";
    [_viewHeader addSubview:teamNotLable];
    
    UILabel *teamNotDetailLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 108 *ProportionAdapter, screenWidth -100*ProportionAdapter, 20 *ProportionAdapter)];
    teamNotDetailLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    teamNotDetailLable.text = @"球队通知详情";
    [_viewHeader addSubview:teamNotDetailLable];
    
    UILabel *twoLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 138 *ProportionAdapter, screenWidth -10*ProportionAdapter, 1)];
    twoLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:twoLine];
    
    UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 149 *ProportionAdapter, 200 *ProportionAdapter, 28 *ProportionAdapter)];
    proLable.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    proLable.text = @"好友列表";
    [_viewHeader addSubview:proLable];
    
    UILabel *threeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 185 *ProportionAdapter, screenWidth, 1)];
    threeLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:threeLine];
    
    UIButton *teamNotbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 68 *ProportionAdapter, screenWidth, 67*ProportionAdapter)];
    [teamNotbtn addTarget:self action:@selector(teamNotbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHeader addSubview:teamNotbtn];
    
    self.conversationListTableView.tableHeaderView = _viewHeader;
    
    self.conversationListTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//    self.conversationListTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark -- headRereshing
- (void)headRereshing{
    [self loadMessageData];
}
#pragma mark -- 系统通知
- (void)sysMessbtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    JGHSystemNotViewController *sysCtrl = [[JGHSystemNotViewController alloc]init];
    sysCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sysCtrl animated:YES];
    
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 球队通知
- (void)teamNotbtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    JGHTeamNotViewController *teamCtrl = [[JGHTeamNotViewController alloc]init];
    teamCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teamCtrl animated:YES];
    
    btn.userInteractionEnabled = YES;
}

-(void)messageCLick
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
    {
        NewsDetailController* myVc = [[NewsDetailController alloc]init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        [self.navigationController pushViewController:myVc animated:YES];
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





//无消息的时候的视图  背景图
- (void)showEmptyConversationView {
    
}


#pragma mark - 点击事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
    //设置聊天类型
    vc.conversationType = ConversationType_PRIVATE;
    //设置对方的id
    vc.targetId = model.targetId;
    //设置对方的名字
//    vc.userName = model.conversationTitle;
    //设置聊天标题
    vc.title = model.conversationTitle;
    //设置不现实自己的名称  NO表示不现实
    vc.displayUserNameInCell = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 消息数据
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {

    return [super willReloadTableData:dataSource];
}

#pragma mark - 删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super rcConversationListTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super rcConversationListTableView:tableView cellForRowAtIndexPath:indexPath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)notifyUpdateUnreadMessageCount
{
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem
{
    
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        if ((count + (int)_teamUnread +(int)_systemUnread) > 0) {
            //      __weakSelf.tabBarItem.badgeValue =
            //          [[NSString alloc] initWithFormat:@"%d", count];
//            int badgeValue = count+_teamUnread+_systemUnread;
            [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:count+ (int)_teamUnread + (int)_systemUnread];
            
        } else {
            //      __weakSelf.tabBarItem.badgeValue = nil;
            [__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
        
    });
    
////    __weak typeof(self) __weakSelf = self;
////    dispatch_async(dispatch_get_main_queue(), ^{
//        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
//        if (count>0) {
////            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
//            self.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
//            [self.tabBarController.tabBar showBadgeOnItemIndex:2];
//        }
////        else
////        {
////            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
////        }
//    
////    });
}

@end
