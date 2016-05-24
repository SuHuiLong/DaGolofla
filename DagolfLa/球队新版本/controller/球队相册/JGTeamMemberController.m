//
//  JGTeamMemberController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamMemberController.h"
#import "JGMenberTableViewCell.h"

#import "JGMemManageController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "JGLTeamMemberModel.h"
@interface JGTeamMemberController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tableView;
    NSInteger _page;
    NSMutableArray* _dataArray;
}
@end

@implementation JGTeamMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc]init];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(manageClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    [self uiConfig];
    
}


-(void)manageClick
{
    JGMemManageController* menVc = [[JGMemManageController alloc]init];
    [self.navigationController pushViewController:menVc animated:YES];
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JGMenberTableViewCell class] forCellReuseIdentifier:@"JGMenberTableViewCell"];
    
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@188 forKey:@"teamKey"];
    [dict setObject:@244 forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamMemberList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dataDic in [data objectForKey:@"teamMemberList"]) {
                JGLTeamMemberModel *model = [[JGLTeamMemberModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:@"失败" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGMenberTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGMenberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showData:_dataArray[indexPath.row]];
    return cell;
}



@end
