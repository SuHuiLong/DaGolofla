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
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self refreshConversationTableViewIfNeeded];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;


    self.conversationListTableView.backgroundColor=[UITool colorWithHexString:@"DBDBDB" alpha:1];
    self.conversationListTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    

    //聚合会话类型
//   [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_PRIVATE)]];

}

-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}

//无消息的时候的视图  背景图
- (void)showEmptyConversationView {
    
}
#pragma mark - 点击事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
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



@end
