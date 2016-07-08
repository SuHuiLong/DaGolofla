//
//  JGActivityMemNonMangerViewController.m
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.5429
//

#import "JGDActivityListViewController.h"
#import "JGDactivityListTableViewCell.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "JGDActivityList.h"
#import "JGHAwardModel.h"

@interface JGDActivityListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableString *_signupKeyInfo;//key,拼接
    NSMutableString *_signupNameInfo;//name,拼接
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger sumCount;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation JGDActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _signupKeyInfo =[NSMutableString stringWithString:@""];
    _signupNameInfo =[NSMutableString stringWithString:@""];
    
    if ([[_checkdict allKeys]containsObject:@"signupKeyInfo"]) {
        _signupKeyInfo = [NSMutableString stringWithFormat:@"%@", [_checkdict objectForKey:@"signupKeyInfo"]];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[JGDactivityListTableViewCell class] forCellReuseIdentifier:@"listCell"];
    
    _page = 0;
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *barItm = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(check)];
    barItm.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barItm;
    
    // Do any additional setup after loading the view.
}

- (void)check{

/*
 self.block(key, name, mobie);

 * 保存选择获奖人
 * @Title: doSavePrizeUser
 * @param teamKey
 * @param activityKey
 * @param userKey
 * @param prizeKey
 * @param signupKeyList
 * @param response
 * @throws Throwable
 * @author lyh

    @HttpService(RequestURL="/doSavePrizeUser" , method="post")
    public void doSavePrizeUser(
                                @Param(value="teamKey", require=true)                                    Long        teamKey,
                                @Param(value="activityKey", require=true)                                Long        activityKey,
                                @Param(value="userKey"     , require = true)                             Long        userKey,
                                @Param(value="prizeKey",     require=true)                               Long        prizeKey,
                                @Param(value="signupKeyList", require=true, genricType=Long.class)       List<Long>  signupKeyList,
                                TcpResponse response) throws Throwable {

 */
    
    
    
    if (self.delegate) {
        [self.delegate saveBtnDict:_checkdict andAwardId:_awardId];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    
    [dict setObject:[NSNumber numberWithInteger:self.activityKey] forKey:@"activityKey"];
    [dict setObject:[NSNumber numberWithInteger:_page]forKey:@"offset"];
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
                //清除数组数据  signUpInfoKey
                [self.dataArray removeAllObjects];
            }
            if ([data objectForKey:@"teamSignUpList"]) {
                for (NSDictionary *dic in [data objectForKey:@"teamSignUpList"]) {
                    JGDActivityList *model = [[JGDActivityList alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
       
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
    
    JGDactivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    if (_signupKeyInfo.length > 0) {
        JGDActivityList *model = [[JGDActivityList alloc]init];
        model = self.dataArray[indexPath.row];
        if ([_signupKeyInfo containsString:[NSString stringWithFormat:@"%@", model.timeKey]]) {
            model.isSelect = YES;
        }
        
        cell.listModel = model;
    }else{
        cell.listModel = self.dataArray[indexPath.row];
    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JGDactivityListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JGDActivityList *model = self.dataArray[indexPath.row];

    if (model.isSelect) {
        cell.selectImage.image = [UIImage imageNamed:@"kuang"];
        model.isSelect = NO;
        if ([_signupKeyInfo containsString:[NSString stringWithFormat:@"%@", model.timeKey]]) {
            _signupKeyInfo = [NSMutableString stringWithString:[_signupKeyInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", model.timeKey] withString:@""]];
            
            _signupNameInfo = [NSMutableString stringWithString:[_signupNameInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", model.name] withString:@""]];
        }
        
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"kuang_xz"];
        model.isSelect = YES;
        _signupKeyInfo = [NSMutableString stringWithString:[_signupKeyInfo stringByAppendingString:[NSString stringWithFormat:@"%@,", model.timeKey]]];
        
        _signupNameInfo = [NSMutableString stringWithString:[_signupNameInfo stringByAppendingString:[NSString stringWithFormat:@"%@/", model.name]]];
    }
    
    [_checkdict setObject:_signupKeyInfo forKey:@"signupKeyInfo"];
    
    if (cell.listModel.isSelect == NO) {
        [self.selectedArray addObject:model];
    }
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
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

