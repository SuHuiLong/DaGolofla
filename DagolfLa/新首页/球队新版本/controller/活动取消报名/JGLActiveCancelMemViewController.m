//
//  JGLActiveCancelMemViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActiveCancelMemViewController.h"
#import "JGLActiveMemTableViewCell.h"
#import "JGLActivityMemberTableViewCell.h"
#import "UITool.h"

#import "JGTeamGroupViewController.h"

#import "JGHPlayersModel.h"
@interface JGLActiveCancelMemViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSInteger _page;
    
    NSMutableArray* _dataArray;
}
@end

@implementation JGLActiveCancelMemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"分组管理" style:UIBarButtonItemStylePlain target:self action:@selector(groupClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    [self uiConfig];
    
}

#pragma mark --分组管理点击事件

-(void)groupClick
{
    JGTeamGroupViewController* tgVc = [[JGTeamGroupViewController alloc]init];
    tgVc.teamActivityKey = [self.activityKey integerValue];
    [self.navigationController pushViewController:tgVc animated:YES];
}


#pragma mark --uitableview创建
-(void)uiConfig
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_tableView registerNib:[UINib nibWithNibName:@"JGLActiveCancelTableViewCell" bundle:nil] forCellReuseIdentifier:@"JGLActiveCancelTableViewCell"];
    [_tableView registerClass:[JGLActivityMemberTableViewCell class] forCellReuseIdentifier:@"JGLActivityMemberTableViewCell"];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.activityKey forKey:@"activityKey"];
    [dict setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:_teamKey activityKey:[_activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
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
            for (NSDictionary *dicList in [data objectForKey:@"teamSignUpList"])
            {
                JGHPlayersModel *model = [[JGHPlayersModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
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
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}



#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGLActivityMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLActivityMemberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showData:_dataArray[indexPath.row]];
    cell.iconImg.layer.cornerRadius = cell.iconImg.frame.size.height/2;
    cell.iconImg.layer.masksToBounds = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
