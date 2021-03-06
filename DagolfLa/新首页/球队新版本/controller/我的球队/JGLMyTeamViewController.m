//
//  JGLMyTeamViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLMyTeamViewController.h"
#import "JGTeamChannelTableView.h"
#import "JGTeamChannelTableViewCell.h"
#import "JGDNewTeamDetailViewController.h"

#import "JGTeamDetailStylelTwoViewController.h"


#import "JGTeamDetail.h"


#import "JGLMyTeamModel.h"

#import "JGLMyTeamTableViewCell.h"
@interface JGLMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    JGTeamChannelTableView* _tableView;
    
    NSMutableArray* _dataArray;
    NSInteger _page;
}

//@property (nonatomic, strong) NSMutableArray *TeamArray;


@end

@implementation JGLMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    self.title = @"我的球队";
    [self uiConfig];
    
    
}

-(void) uiConfig
{
    _tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.rowHeight = 83 * screenWidth / 320;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGLMyTeamTableViewCell class] forCellReuseIdentifier:@"JGLMyTeamTableViewCell"];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
//            self.TeamArray = [data objectForKey:@"teamList"];
            for (NSDictionary *dataDic in [data objectForKey:@"teamList"]) {
                JGLMyTeamModel *model = [[JGLMyTeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
//            [self.TeamArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:@"获取列表信息失败" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGLMyTeamTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"JGLMyTeamTableViewCell"];
//        cell.nameLabel.text = _dataArray[indexPath.row%3];
    [cell showData:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    [dic setObject:@([[_dataArray[indexPath.row] teamKey] integerValue]) forKey:@"teamKey"];
    
    JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
    newTeamVC.timeKey = [_dataArray[indexPath.row] teamKey];
    [self.navigationController pushViewController:newTeamVC animated:YES];
//    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
//        [Helper alertViewNoHaveCancleWithTitle:@"获取球队信息失败" withBlock:^(UIAlertController *alertView) {
//            [self.navigationController presentViewController:alertView animated:YES completion:nil];
//        }];
//        
//    } completionBlock:^(id data) {
//        
//        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//            JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
//            if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
//                detailVC.detailDic = [data objectForKey:@"team"];
//                //                detailVC.detailModel.manager = 1;
//                detailVC.isManager = YES;
//                
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }else{
//                
//                detailVC.detailDic = [data objectForKey:@"team"];
//                //                detailVC.detailModel.manager = 0;
//                detailVC.isManager = NO;
//                
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }
//            
//        }else{
//            if ([data objectForKey:@"packResultMsg"]) {
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//            }
//        }
//        
//    }];
    
}
//
//- (NSMutableArray *)TeamArray{
//    if (!_TeamArray) {
//        _TeamArray = [[NSMutableArray alloc] init];
//    }
//    return _TeamArray;
//}

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
