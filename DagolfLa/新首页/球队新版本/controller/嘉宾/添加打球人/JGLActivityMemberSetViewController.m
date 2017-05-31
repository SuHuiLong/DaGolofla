//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActivityMemberSetViewController.h"
#import "PYTableViewIndexManager.h"
#import "JGLGuestAddPlayerViewController.h"

#import "MyattenModel.h"

#import "JGLAddActiivePlayModel.h"
#import "JGLGuestActiveMemberTableViewCell.h"
#import "JGTeamGroupViewController.h"
#import "JGHAddIntentionPalyerViewController.h"
#import "GuestRegistrationAuditViewController.h"

#import "SortManager.h"
#import "ActivityDetailListTableViewCell.h"
#import "segementBtnView.h"



@interface JGLActivityMemberSetViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dataAccountDict;
    
    NSInteger _signUpInfoKey;//0-意向成员，1-报名成员
}
//索引数据源
@property (strong, nonatomic)NSMutableArray *keyArray;
//列表数据源
@property (strong, nonatomic)NSMutableArray *listArray;

@end

@implementation JGLActivityMemberSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动成员";
    _signUpInfoKey = 0;
    
    _keyArray        = [[NSMutableArray alloc]init];
    _listArray       = [[NSMutableArray alloc]init];
    _dataArray       = [[NSMutableArray alloc]init];
    _dataAccountDict = [[NSMutableDictionary alloc]init];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"设置分组" style:UIBarButtonItemStylePlain target:self action:@selector(activityGroupManager)];
    item.tintColor=[UIColor whiteColor];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15*ProportionAdapter],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
    [self uiConfig];
    [self createBtn];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [_tableView.mj_header beginRefreshing];
}
#pragma mark -- 返回
- (void)backButtonClcik:(UIButton *)btn{
    if (self.delegate) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate reloadActivityMemberData];
    }
}
#pragma mark -- 分组管理
- (void)activityGroupManager{
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.teamActivityKey = [_activityKey integerValue];
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
//底部按钮
-(void)createBtn
{
    segementBtnView *btnView = [[segementBtnView alloc] initWithFrame:CGRectMake(0, screenHeight - kHvertical(65)-64, screenWidth, kHvertical(65)) leftTile:@"批量添加打球人" rightTile:@"嘉宾报名审核"];
    [btnView.leftBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    [btnView.rightBtn addTarget:self action:@selector(auditView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnView];
}
//批量添加
-(void)finishClick{
    
    JGHAddIntentionPalyerViewController *addTeamPlaysCtrl = [[JGHAddIntentionPalyerViewController alloc]init];
    addTeamPlaysCtrl.activityKey = [_activityKey integerValue];
    
    addTeamPlaysCtrl.teamKey = [_teamKey integerValue];
    addTeamPlaysCtrl.allListArray = _dataArray;
    addTeamPlaysCtrl.blockRefresh = ^(){
        [_tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:addTeamPlaysCtrl animated:YES];
}
//报名审核
-(void)auditView{
    [MobClick event:@"teamclan_check_click"];

    GuestRegistrationAuditViewController *vc = [[GuestRegistrationAuditViewController alloc] init];
    vc.teamKey = [_teamKey integerValue];;
    vc.activityKey = [_activityKey integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-kHvertical(65)-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ActivityDetailListTableViewCell class] forCellReuseIdentifier:@"ActivityDetailListTableViewCellID"];
    _tableView.tag = 1001;
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.mj_header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{

    NSString *md5 = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:[self.activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    NSDictionary *dict = @{
                           @"activityKey":self.activityKey,
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":@0,
                           @"md5":md5,
                           };

    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        //清除数组数据  signUpInfoKey
        NSLog(@"%@",data);
        [_dataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            NSArray *listArray = [data objectForKey:@"teamSignUpList"];
            for (NSDictionary *listDict in listArray) {
                ActivityDetailModel *model = [ActivityDetailModel modelWithDictionary:listDict];
                [_dataArray addObject:model];
            }
            self.keyArray = [SortManager IndexWithArray:_dataArray Key:@"name"];
            self.listArray = [SortManager sortObjectArray:_dataArray Key:@"name"];
            [_tableView reloadData];
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing{
    
    [self downLoadData:0 isReshing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHvertical(50);
}
//每个分区内的row个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray[section] count] ;
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keyArray[section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailListTableViewCellID"];
    [listCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ActivityDetailModel *model = _listArray[indexPath.section][indexPath.row];
    [listCell playerManagerConfigModel:model];
    return listCell;
}

// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    _tableView.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];;
    NSInteger number = [_listArray count];
    return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
    
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if (![_listArray[index] count]) {
        return 0;
    }else{
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        return index;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.section == %td", indexPath.section);
    NSLog(@"indexPath.row == %td", indexPath.row);
    NSString *type = nil;
    type = @"取消报名";
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:type handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self cancelAndDeleateApplyIndex:indexPath.section andRow:indexPath.row];
    }];
    
    return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
}
#pragma mark -- 取消报名－－取消意向
- (void)cancelAndDeleateApplyIndex:(NSInteger)index andRow:(NSInteger)row{
    
    ActivityDetailModel *mod = self.listArray[index][row];

    NSString *alertString = [NSString stringWithFormat:@"是否要帮%@取消报名",mod.name];
    
    [Helper alertViewWithTitle:alertString withBlockCancle:^{
        NSLog(@"取消");
    } withBlockSure:^{
        ActivityDetailModel *model = self.listArray[index][row];

        //doUnSignUpTeamActivity
        [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        NSMutableArray *signupKeyArray = [NSMutableArray array];
        [signupKeyArray addObject:model.timeKey];
        //signupKeyList
        [postDict setObject:signupKeyArray forKey:@"signupKeyList"];
        //activityKey
        [postDict setObject:[NSString stringWithFormat:@"%@", _activityKey] forKey:@"activityKey"];
        
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doUnSignUpTeamActivity" JsonKey:nil withData:postDict failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [LQProgressHud showMessage:@"取消报名成功！"];
                [self headRereshing];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                }
            }
        }];
        //        }
    } withBlock:^(UIAlertController *alertView) {
        [self presentViewController:alertView animated:YES completion:nil];
    }];
}

@end
