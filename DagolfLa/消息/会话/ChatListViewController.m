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
#import "UITabBar+badge.h"

#import <RongIMKit/RCIM.h>
#import "JGHSystemNotViewController.h"
#import "JGHTeamNotViewController.h"

#import "RCDTabBarBtn.h"

@interface ChatListViewController ()<UITextFieldDelegate, RCIMUserInfoDataSource>
{
    UITextField* _textField;
    
    UIView* _viewHeader;
    
    UIButton* _btnInvite;
    
    int _newFriendUnreadCount;
    
    UILabel *_sysDetailLable;
    UILabel *_teamNotDetailLable;
    
    UIButton *_costumBtn;
}

@property (nonatomic, retain)RCDTabBarBtn *systemRCDbtn;

@property (nonatomic, retain)RCDTabBarBtn *teamRCDbtn;

@property (nonatomic, retain)RCDTabBarBtn *newfirendRCDbtn;

@end

@implementation ChatListViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self reloadRongTKChet];
}
//更新融云数据
- (void)reloadRongTKChet{
    self.isShowNetworkIndicatorView = NO;
    [[RCIM sharedRCIM] clearUserInfoCache];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        [self loadMessageData];
        if ([[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray] == 0) {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
        [self refreshConversationTableViewIfNeeded];
    }else{
        [self refreshConversationTableViewIfNeeded];
    }
    [[UIApplication sharedApplication]setStatusBarHidden:false];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
};
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
        vc.reloadCtrlData = ^(){
            [self.conversationListTableView.mj_header beginRefreshing];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"loadMessageData" object:nil];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    _costumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44 * ProportionAdapter, 44 * ProportionAdapter)];
    [_costumBtn setImage:[UIImage imageNamed:@"qytxl"] forState:(UIControlStateNormal)];
    [_costumBtn addTarget:self action:@selector(teamFClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithCustomView:_costumBtn];
    
    self.navigationItem.rightBarButtonItem = itm;
    
    self.conversationListTableView.backgroundColor=[UIColor whiteColor];
    self.conversationListTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.conversationListTableView setExtraCellLineHidden];
    //设置要显示的会话类型
    [self setShowConversationListWhileLogOut:NO];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
    [self createTableHeaderView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rongTKChat) name:@"RongTKChat" object:nil];
}

- (void)rongTKChat{

    [self reloadRongTKChet];
}
#pragma mark -- 下载未读消息数量
- (void)loadMessageData{
    
    if (!DEFAULF_USERID){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"君高高尔夫" message:@"是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [self.conversationListTableView.mj_header endRefreshing];
        return;
    }
    [self notifyUpdateUnreadMessageCount];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"msg/geSumtUnread" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"teamMsgNewest"]) {
                _teamNotDetailLable.text = [NSString stringWithFormat:@"%@", [[data objectForKey:@"teamMsgNewest"] objectForKey:@"title"]];
            }
            if ([data objectForKey:@"systemMsgNewest"]) {
                _sysDetailLable.text = [NSString stringWithFormat:@"%@", [[data objectForKey:@"systemMsgNewest"] objectForKey:@"title"]];
            }
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
    [MobClick event:@"msg_ball_friends_address_book_click"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        ContactViewController* tVc = [[ContactViewController alloc]init];
        tVc.hidesBottomBarWhenPushed = YES;
        tVc.addFriendSum = [NSNumber numberWithInt:_newFriendUnreadCount];
        [self.navigationController pushViewController:tVc animated:YES];
    }else{
        [self loginOut];
    }
}

#pragma mark --头视图
-(void)createTableHeaderView
{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 203*ProportionAdapter)];
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
    _sysDetailLable.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
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
    _teamNotDetailLable.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    [_viewHeader addSubview:_teamNotDetailLable];
    
    UILabel *twoLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 148 *ProportionAdapter, screenWidth, 1)];
    twoLine.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    [_viewHeader addSubview:twoLine];
    
    UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 160 *ProportionAdapter, 200 *ProportionAdapter, 28 *ProportionAdapter)];
    proLable.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    proLable.text = @"会话列表";
    proLable.textColor = [UIColor colorWithHexString:@"#313131"];
    [_viewHeader addSubview:proLable];
    
    UILabel *threeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 199 *ProportionAdapter, screenWidth, 1)];
    threeLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    [_viewHeader addSubview:threeLine];
    
    UIButton *teamNotbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 78 *ProportionAdapter, screenWidth, 67*ProportionAdapter)];
    [teamNotbtn addTarget:self action:@selector(teamNotbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHeader addSubview:teamNotbtn];
    
    self.conversationListTableView.tableHeaderView = _viewHeader;
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.conversationListTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [self.conversationListTableView.mj_header beginRefreshing];
    //    self.conversationListTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark -- headRereshing
- (void)headRereshing{
    [self loadMessageData];
}
#pragma mark -- 系统通知
- (void)sysMessbtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    [MobClick event:@"msg_system_click"];

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"君高高尔夫" message:@"是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [self.conversationListTableView.mj_header endRefreshing];
        btn.userInteractionEnabled = YES;
        return;
    }
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:SYSTEM_ID];
    [_systemRCDbtn removeFromSuperview];
    _systemRCDbtn = nil;
    [self updateBadgeValueForTabBarItem];
    
    JGHSystemNotViewController *sysCtrl = [[JGHSystemNotViewController alloc]init];
    sysCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sysCtrl animated:YES];
    
    btn.userInteractionEnabled = YES;
}
#pragma mark -- 球队通知
- (void)teamNotbtn:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    [MobClick event:@"msg_team_click"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"君高高尔夫" message:@"是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [self.conversationListTableView.mj_header endRefreshing];
        btn.userInteractionEnabled = YES;
        
        return;
    }
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:TEAM_ID];
    [_teamRCDbtn removeFromSuperview];
    _teamRCDbtn = nil;
    
    [self updateBadgeValueForTabBarItem];
    
    JGHTeamNotViewController *teamCtrl = [[JGHTeamNotViewController alloc]init];
    teamCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teamCtrl animated:YES];
    
    btn.userInteractionEnabled = YES;
}

-(void)messageCLick{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
    {
        NewsDetailController* myVc = [[NewsDetailController alloc]init];
        myVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myVc animated:YES];
    }else{
        [self loginOut];
        
    }
    
}
#pragma mark -- 登录
- (void)loginOut{
    [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        
    } withBlockSure:^{
        JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
        vc.reloadCtrlData = ^(){
            [self.conversationListTableView.mj_header beginRefreshing];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"loadMessageData" object:nil];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
}

//无消息的时候的视图  背景图
- (void)showEmptyConversationView {
    
}


#pragma mark - 点击事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
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
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        return nil;
    }else{
        return [super rcConversationListTableView:tableView cellForRowAtIndexPath:indexPath];
    }
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

        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        //会话消息
        int countChat = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        //球队消息
        int teamUnreadCount = [[RCIMClient sharedRCIMClient]
                               getUnreadCount:ConversationType_SYSTEM targetId:TEAM_ID];
        //系统消息
        int systemUnreadCount = [[RCIMClient sharedRCIMClient]
                                 getUnreadCount:ConversationType_SYSTEM targetId:SYSTEM_ID];
        
        //新球友消息
        _newFriendUnreadCount = [[RCIMClient sharedRCIMClient]
                                    getUnreadCount:ConversationType_SYSTEM targetId:NEW_FRIEND_ID];
        
        int iconCount = countChat +teamUnreadCount +systemUnreadCount +_newFriendUnreadCount;
        /*
       RCConversation *sysConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_SYSTEM targetId:SYSTEM_ID];
        _sysDetailLable.text = [(RCTextMessage *)sysConversation.lastestMessage content];
        
        RCConversation *teamConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_SYSTEM targetId:TEAM_ID];
        _teamNotDetailLable.text = [(RCTextMessage *) teamConversation.lastestMessage content];
        */
        //新球友
        if (100 > _newFriendUnreadCount && _newFriendUnreadCount >0) {
            self.newfirendRCDbtn.frame = CGRectMake(24 *ProportionAdapter, 5 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter);
            _newfirendRCDbtn.unreadCount = [NSString stringWithFormat:@"%d", _newFriendUnreadCount];
            [_costumBtn addSubview:_newfirendRCDbtn];
        }else if (_newFriendUnreadCount <= 0){
            [_newfirendRCDbtn removeFromSuperview];
            _newfirendRCDbtn = nil;
        }else{
            self.newfirendRCDbtn.frame = CGRectMake(24 *ProportionAdapter, 5 *ProportionAdapter, 30 *ProportionAdapter, 20 *ProportionAdapter);
            [_newfirendRCDbtn setImage:[UIImage imageNamed:@"icn_mesg_99+"] forState:UIControlStateNormal];
            [_costumBtn addSubview:_newfirendRCDbtn];
        }
        //系统
        if (100 > systemUnreadCount && systemUnreadCount >0) {
            self.systemRCDbtn.frame = CGRectMake(50 *ProportionAdapter, 10 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter);
            _systemRCDbtn.unreadCount = [NSString stringWithFormat:@"%d", systemUnreadCount];
        }else if (systemUnreadCount <= 0){
            [_systemRCDbtn removeFromSuperview];
            _systemRCDbtn = nil;
        }else{
            self.systemRCDbtn.frame = CGRectMake(50 *ProportionAdapter, 10 *ProportionAdapter, 30 *ProportionAdapter, 20 *ProportionAdapter);
            [_systemRCDbtn setImage:[UIImage imageNamed:@"icn_mesg_99+"] forState:UIControlStateNormal];
        }
        //球队
        if (100 > teamUnreadCount && teamUnreadCount>0) {
            self.teamRCDbtn.frame = CGRectMake(50 *ProportionAdapter, 78 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter);
            _teamRCDbtn.unreadCount = [NSString stringWithFormat:@"%d", teamUnreadCount];
        }else if (teamUnreadCount <= 0){
            [_teamRCDbtn removeFromSuperview];
            _teamRCDbtn = nil;
        }else{
            self.teamRCDbtn.frame = CGRectMake(50 *ProportionAdapter, 78 *ProportionAdapter, 30 *ProportionAdapter, 20 *ProportionAdapter);
            [_teamRCDbtn setImage:[UIImage imageNamed:@"icn_mesg_99+"] forState:UIControlStateNormal];
        }
        
        
        
        //本地存红点数
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        [userdef setObject:@(iconCount) forKey:IconCount];
        [userdef synchronize];
        
        if (iconCount > 0) {
            
            [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3 badgeValue:iconCount];
        } else {
            [__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
        [self.conversationListTableView.mj_header endRefreshing];
    });
}

- (RCDTabBarBtn *)systemRCDbtn{
    if (_systemRCDbtn == nil) {
        _systemRCDbtn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(50 *ProportionAdapter, 10 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
        _systemRCDbtn.layer.cornerRadius = 9;//圆形
        _systemRCDbtn.tag = 1000;
        [_viewHeader addSubview:_systemRCDbtn];
    }
    return _systemRCDbtn;
}

- (RCDTabBarBtn *)teamRCDbtn{
    if (_teamRCDbtn == nil) {
        _teamRCDbtn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(50 *ProportionAdapter, 78 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
        _teamRCDbtn.layer.cornerRadius = 9;//圆形
        _teamRCDbtn.tag = 1001;
        [_viewHeader addSubview:_teamRCDbtn];
    }
    return _teamRCDbtn;
}

- (RCDTabBarBtn *)newfirendRCDbtn{
    if (_newfirendRCDbtn == nil) {
        _newfirendRCDbtn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(24 *ProportionAdapter, 5 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
        _newfirendRCDbtn.layer.cornerRadius = 9;//圆形
        _newfirendRCDbtn.tag = 1002;
        
    }
    return _newfirendRCDbtn;
}
@end
