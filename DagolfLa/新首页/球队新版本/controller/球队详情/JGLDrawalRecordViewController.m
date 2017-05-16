//
//  JGLDrawalRecordViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLDrawalRecordViewController.h"
#import "JGLDrawalRewardTableViewCell.h"
#import "JGLDrawalRecordModel.h"

@interface JGLDrawalRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@end

@implementation JGLDrawalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现记录";
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    [self uiConfig];
    
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, screenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLDrawalRewardTableViewCell class] forCellReuseIdentifier:@"JGLDrawalRewardTableViewCell"];
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    [dict setObject:[NSNumber numberWithInteger:_teamKey] forKey:@"teamKey"];
    [dict setObject:[JGReturnMD5Str getTeamWithDrawListWithTeamKey:_teamKey userKey:[DEFAULF_USERID integerValue]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamWithDrawList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"list"])
            {
                JGLDrawalRecordModel *model = [[JGLDrawalRecordModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*ScreenWidth/320;
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*ScreenWidth/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGLDrawalRewardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLDrawalRewardTableViewCell" forIndexPath:indexPath];

    [cell showData:_dataArray[indexPath.section]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
