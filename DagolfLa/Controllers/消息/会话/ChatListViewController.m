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



#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ChatListViewController ()<UITextFieldDelegate, RCIMUserInfoDataSource>
{
    UITextField* _textField;
    
    UIView* _viewHeader;
    
    UIButton* _btnInvite;
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
             [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
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
    
    self.conversationListTableView.backgroundColor=[UITool colorWithHexString:@"DBDBDB" alpha:1];
    self.conversationListTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
    [self createHeaderView];
    
//    self.title = @"消息";
    
    

    //聚合会话类型
//   [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_PRIVATE)]];

    
    

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





#pragma mark --创建表头
-(void)createHeaderView
{
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100*ScreenWidth/375)];
    _viewHeader.backgroundColor = [UIColor redColor];
    self.conversationListTableView.tableHeaderView = _viewHeader;
    
    
//    [self createSeachBar];
    
    [self createInvite];
    
}


//自定义searchbar
#pragma mark --自定义searchbar
-(void)createSeachBar{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37*ScreenWidth/375)];
    view.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f];
    [_viewHeader addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13*ScreenWidth/375, 5*ScreenWidth/375, ScreenWidth-80*ScreenWidth/375, 27*ScreenWidth/375)];
    imageView.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    imageView.layer.cornerRadius=13*ScreenWidth/375;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 4*ScreenWidth/375, 16*ScreenWidth/375, 16*ScreenWidth/375);
    [imageView addSubview:imageView2];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 27*ScreenWidth/375)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    _textField.placeholder=@"请输入约球名称进行搜索";
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [imageView addSubview:_textField];
    _textField.delegate = self;
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 3*ScreenWidth/375, 60*ScreenWidth/375, 30*ScreenWidth/375);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachcityClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
//搜索点击事件
-(void)seachcityClick{
    [_textField resignFirstResponder];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
//        [_tableView.header endRefreshing];
//        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//        [_tableView.header beginRefreshing];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

#pragma mark --邀请视图
-(void)createInvite
{
    _btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnInvite.frame = CGRectMake(0, 0, ScreenWidth, 70*ScreenWidth/375);
    _btnInvite.backgroundColor = [UIColor whiteColor];
    [_viewHeader addSubview:_btnInvite];
    [_btnInvite addTarget:self action:@selector(messageCLick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(12*ScreenWidth/375, 15*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@"xpy"];
    [_btnInvite addSubview:imgv];
    
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(65*ScreenWidth/375, 25*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
    labelTitle.text = @"邀请消息";
    [_btnInvite addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 28*ScreenWidth/375, 10*ScreenWidth/375, 14*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [_btnInvite addSubview:imgvJian];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 70*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [_viewHeader addSubview:viewLine];
    
    
    UILabel* labelRK = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    labelRK.text = @"会话列表";
    [viewLine addSubview:labelRK];
    labelRK.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    
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
//    __weak typeof(self) __weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
        if (count>0) {
//            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
//            self.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
            [self.tabBarController.tabBar showBadgeOnItemIndex:3];
        }else
        {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
//    });
}

@end
