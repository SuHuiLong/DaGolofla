//
//  JGActivityMemNonMangerViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGActivityMemNonMangerViewController.h"
#import "JGActivityMemNonmangerTableViewCell.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface JGActivityMemNonMangerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger sumCount;

@end

@implementation JGActivityMemNonMangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[JGActivityMemNonmangerTableViewCell class] forCellReuseIdentifier:@"memCell"];
    
    _page = 0;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *barItm = [[UIBarButtonItem alloc] initWithTitle:@"查看分组" style:(UIBarButtonItemStylePlain) target:self action:@selector(check)];
    [barItm setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:UIControlStateNormal];

    barItm.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barItm;
    
    // Do any additional setup after loading the view.
}

- (void)check{
    JGTeamDeatilWKwebViewController *WKCtrl = [[JGTeamDeatilWKwebViewController alloc]init];
    NSString *str = [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%@&userKey=%@dagolfla.com",self.teamKey, self.activityKey, DEFAULF_USERID]];
    
    WKCtrl.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/group.html?teamKey=%td&activityKey=%@&userKey=%@&md5=%@", self.teamKey, self.activityKey, DEFAULF_USERID, str];
    WKCtrl.teamName = @"报名人列表";
    WKCtrl.isShareBtn = 1;
    WKCtrl.activeTimeKey = [self.activityKey integerValue];
    WKCtrl.activeName = _activityName;
    WKCtrl.teamKey = self.teamKey;
    [self.navigationController pushViewController:WKCtrl animated:YES];
}

// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:self.activityKey forKey:@"activityKey"];
    [dict setObject:[NSNumber numberWithInteger:_page]forKey:@"offset"];
    [dict setObject:@0 forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:[self.activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    [dict setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([data objectForKey:@"packSuccess"]) {
            if (page == 0)
            {
                //清除数组数据
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:[data objectForKey:@"teamSignUpList"]];
            self.sumCount = [[data objectForKey:@"sumCount"] integerValue];
            _page++;
            [_tableView reloadData];
        }else {

        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGActivityMemNonmangerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memCell"];
    cell.nameLB.text = [self.dataArray[indexPath.row] objectForKey:@"name"];

    if ([self.dataArray[indexPath.row] objectForKey:@"mobile"]) {
        cell.phoneLB.text = [self.dataArray[indexPath.row] objectForKey:@"mobile"];
    }else{
        cell.phoneLB.text = @"";
    }
    
//    cell.signLB.textColor = [UIColor colorWithHexString:@"#7fc1ff"];
//    if ([[self.dataArray[indexPath.row] objectForKey:@"signUpInfoKey"] integerValue] == -1) {
//        cell.signLB.text = @"意向成员";
//    }else{
//        cell.signLB.text = @"线上报名";
//    }
    
    [cell.headIconV sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[[self.dataArray[indexPath.row] objectForKey:@"userKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat: @"活动成员列表（%td人）", self.sumCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0 * screenWidth / 375;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * screenWidth / 375;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

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
