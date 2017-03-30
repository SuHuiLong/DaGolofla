//
//  
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCaddieChooseStyleViewController.h"
#import "UITool.h"
#import "JGLChoosesScoreTableViewCell.h"
#import "JGLChooseScoreModel.h"
#import "JGLCaddieSelfScoreViewController.h"//普通记分
#import "JGLCaddieActiveScoreViewController.h"//活动记分
@interface JGLCaddieChooseStyleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    UIView *_viewHeader;
    NSInteger _page;
    NSMutableArray* _dataArray;
}
@end

@implementation JGLCaddieChooseStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //球童记分前，选择活动积分或者普通积分的那个列表
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
    self.title = @"选择记分对象";
    [self uiConfig];
    [self createHeader];
    
    [self createBtn];
}

-(void)createBtn
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 54*ScreenWidth/375 - 64, ScreenWidth, 54*ScreenWidth/375)];
    [self.view addSubview:view];
    view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"普通记分" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [view addSubview:btn];
    [btn addTarget:self action:@selector(selfScoreClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selfScoreClick
{
    JGLCaddieSelfScoreViewController* selfVc = [[JGLCaddieSelfScoreViewController alloc]init];
    selfVc.userNamePlayer = _userNamePlayer;
    selfVc.userKeyPlayer = _userKeyPlayer;
    [self.navigationController pushViewController:selfVc animated:YES];
}
-(void)createHeader
{
    _viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * screenWidth / 375)];
    _viewHeader.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    _tableView.tableHeaderView = _viewHeader;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, screenWidth - 20*screenWidth/375, 60*screenWidth/375)];
    label.text = @"检测到您近三天有如下高球活动正在进行，如您此次记分的对象为下列活动之一，点击活动名即可对点选的活动进行记分。";
    [_viewHeader addSubview:label];
    label.font = [UIFont systemFontOfSize:14*screenWidth/375];
    label.textColor = [UITool colorWithHexString:@"b8b8b8" alpha:1];
    label.numberOfLines = 0;
}

-(void)uiConfig
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLChoosesScoreTableViewCell class] forCellReuseIdentifier:@"JGLChoosesScoreTableViewCell"];
    
    _tableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    //    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:_userKeyPlayer forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", _userKeyPlayer]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getUserLatelyActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }
        //        else {
        //            [_tableView.mj_footer endRefreshing];
        //        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            //            self.TeamArray = [data objectForKey:@"teamList"];
            for (NSDictionary *dataDic in [data objectForKey:@"activityList"]) {
                JGLChooseScoreModel *model = [[JGLChooseScoreModel alloc] init];
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
        }
        //        else {
        //            [_tableView.mj_footer endRefreshing];
        //        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

//- (void)footRereshing
//{
//    [self downLoadData:_page isReshing:NO];
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //活动数据列表，当球童添加的那个打球人最近2天有活动，则展示到这个列表中
    JGLChoosesScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLChoosesScoreTableViewCell" forIndexPath:indexPath];
    [cell showData:_dataArray[indexPath.section]];
    if (![Helper isBlankString:[_dataArray[indexPath.section] beginDate]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *destDate= [dateFormatter dateFromString:[_dataArray[indexPath.section] beginDate]];
        NSString* str = [NSString stringWithFormat:@"%@",destDate];
        
        NSArray* array = [str componentsSeparatedByString:@" "];
        NSArray* array1 = [array[0] componentsSeparatedByString:@"-"];
        
        NSString* strTime = [NSString stringWithFormat:@"%@月%@日",array1[1],array1[2]];
        cell.labelTime.text = strTime;
        
    }
    else{
        cell.labelTime.text = @"暂无时间";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10* screenWidth / 375;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 93 * screenWidth / 375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGLCaddieActiveScoreViewController* actVc = [[JGLCaddieActiveScoreViewController alloc]init];
    actVc.model = _dataArray[indexPath.section];
    actVc.userNamePlayer = _userNamePlayer;
    actVc.userKeyPlayer = _userKeyPlayer;
    [self.navigationController pushViewController:actVc animated:YES];
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
