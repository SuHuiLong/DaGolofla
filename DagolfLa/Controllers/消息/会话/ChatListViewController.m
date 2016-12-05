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
    
    NSInteger _newFriendUnread;
    
    UILabel *_sysDetailLable;
    UILabel *_teamNotDetailLable;
    
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
        [self loadMessageData];
        
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
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"君高高尔夫" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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

}
#pragma mark -- 下载未读消息数量
- (void)loadMessageData{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"君高高尔夫" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"msg/geSumtUnread" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _teamUnread = [[data objectForKey:@"teamUnread"] integerValue];
            _systemUnread = [[data objectForKey:@"systemUnread"] integerValue];
            _newFriendUnread = [[data objectForKey:@"newFriendUnread"] integerValue];
            
            if ([data objectForKey:@"teamMsgNewest"]) {
                _teamNotDetailLable.text = [NSString stringWithFormat:@"%@", [[data objectForKey:@"teamMsgNewest"] objectForKey:@"title"]];
            }
            
            if ([data objectForKey:@"systemMsgNewest"]) {
                _sysDetailLable.text = [NSString stringWithFormat:@"%@", [[data objectForKey:@"systemMsgNewest"] objectForKey:@"title"]];
            }
            
            [[_viewHeader viewWithTag:1000] removeFromSuperview];
            [[_viewHeader viewWithTag:1001] removeFromSuperview];
            [[_viewHeader viewWithTag:1002] removeFromSuperview];
            [[_viewHeader viewWithTag:1003] removeFromSuperview];
            
            if (100 > _systemUnread && _systemUnread >0) {
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
            
            if (100 > _teamUnread && _teamUnread>0) {
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
            
            [self notifyUpdateUnreadMessageCount];
            
        }else{
            [self notifyUpdateUnreadMessageCount];
            
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.conversationListTableView.header endRefreshing];
    }];
}

//导航栏右按钮点击事件
-(void)teamFClick
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        ContactViewController* tVc = [[ContactViewController alloc]init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        tVc.addFriendSum = [NSNumber numberWithInteger:_newFriendUnread];
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
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 196*ProportionAdapter)];
    _viewHeader.backgroundColor = [UIColor whiteColor];
    
    UIView *heView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
    heView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [_viewHeader addSubview:heView];
    
    UIImageView *sysMessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 20 *ProportionAdapter, 50 *ProportionAdapter, 47 *ProportionAdapter)];
    sysMessImageView.image = [UIImage imageNamed:@"app-message"];
    [_viewHeader addSubview:sysMessImageView];
    
    UIImageView *sysPointed = [[UIImageView alloc]initWithFrame:CGRectMake( screenWidth -18*ProportionAdapter, 37*ProportionAdapter, 8*ProportionAdapter, 13 *ProportionAdapter)];
    [sysPointed setImage:[UIImage imageNamed:@")"]];
    [_viewHeader addSubview:sysPointed];
    
    UILabel *sysNotLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 23 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
    sysNotLable.text = @"系统通知";
    sysNotLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    [_viewHeader addSubview:sysNotLable];
    
    _sysDetailLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 47 *ProportionAdapter, screenWidth -100*ProportionAdapter, 20 *ProportionAdapter)];
    _sysDetailLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    _sysDetailLable.text = @"暂无系统消息";
    [_viewHeader addSubview:_sysDetailLable];
    
    UILabel *oneLine = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 77 *ProportionAdapter, screenWidth -10 *ProportionAdapter, 0.5)];
    oneLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:oneLine];
    
    UIButton *sysMessbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 77*ProportionAdapter)];
    [sysMessbtn addTarget:self action:@selector(sysMessbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHeader addSubview:sysMessbtn];
    
    //球队通知
    UIImageView *teamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 88 *ProportionAdapter, 50 *ProportionAdapter, 47*ProportionAdapter)];
    teamImageView.image = [UIImage imageNamed:@"team-message"];
    [_viewHeader addSubview:teamImageView];
    
    UIImageView *teamPointed = [[UIImageView alloc]initWithFrame:CGRectMake( screenWidth -18*ProportionAdapter, 105*ProportionAdapter, 8*ProportionAdapter, 13 *ProportionAdapter)];
    [teamPointed setImage:[UIImage imageNamed:@")"]];
    [_viewHeader addSubview:teamPointed];
    
    UILabel *teamNotLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 91 *ProportionAdapter, 100 *ProportionAdapter, 20 *ProportionAdapter)];
    teamNotLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    teamNotLable.text = @"球队通知";
    [_viewHeader addSubview:teamNotLable];
    
    _teamNotDetailLable = [[UILabel alloc]initWithFrame:CGRectMake(70 *ProportionAdapter, 115 *ProportionAdapter, screenWidth -100*ProportionAdapter, 20 *ProportionAdapter)];
    _teamNotDetailLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    _teamNotDetailLable.text = @"暂无球队消息";
    [_viewHeader addSubview:_teamNotDetailLable];
    
    UILabel *twoLine = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 148 *ProportionAdapter, screenWidth -10*ProportionAdapter, 0.5)];
    twoLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:twoLine];
    
    UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 159 *ProportionAdapter, 200 *ProportionAdapter, 28 *ProportionAdapter)];
    proLable.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    proLable.text = @"会话列表";
    [_viewHeader addSubview:proLable];
    
    UILabel *threeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 195 *ProportionAdapter, screenWidth, 1)];
    threeLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:threeLine];
    
    UIButton *teamNotbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 78 *ProportionAdapter, screenWidth, 67*ProportionAdapter)];
    [teamNotbtn addTarget:self action:@selector(teamNotbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHeader addSubview:teamNotbtn];
    
    self.conversationListTableView.tableHeaderView = _viewHeader;
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    _systemUnread = 0;
    [self updateBadgeValueForTabBarItem];
    
    JGHSystemNotViewController *sysCtrl = [[JGHSystemNotViewController alloc]init];
    sysCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sysCtrl animated:YES];
    
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 球队通知
- (void)teamNotbtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    _teamUnread = 0;
    [self updateBadgeValueForTabBarItem];
    
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
        
        if (count > 10) {
            self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }else{
            self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
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
}

@end
