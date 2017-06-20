//
//  JGActivityMemNonMangerViewController.m
//  DagolfLa
//
//  Created by 東 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGActivityMemNonMangerViewController.h"
//#import "JGActivityMemNonmangerTableViewCell.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "ActivityDetailModel.h"
#import "ActivityDetailListTableViewCell.h"
#import "SortManager.h"

@interface JGActivityMemNonMangerViewController ()<UITableViewDelegate, UITableViewDataSource>
//主视图
@property (nonatomic, strong) UITableView *tableView;
//已报名人数
@property (nonatomic, assign) NSInteger sumCount;
//总用户的数据源
@property (nonatomic, strong) NSMutableArray *listArray;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JGActivityMemNonMangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}
#pragma mark - CreateView
-(void)createView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[ActivityDetailListTableViewCell class] forCellReuseIdentifier:@"ActivityDetailListTableViewCellID"];
    self.tableView.sectionIndexColor = RGB(50,177,77);

    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.mj_header beginRefreshing];
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
    
    WKCtrl.detailString = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/share/team/group.html?teamKey=%td&activityKey=%@&userKey=%@&md5=%@", self.teamKey, self.activityKey, DEFAULF_USERID, str];
    WKCtrl.teamName = [NSString stringWithFormat:@"活动总人数(%td人)", self.sumCount];
    WKCtrl.isShareBtn = 1;
    WKCtrl.activeTimeKey = [self.activityKey integerValue];
    WKCtrl.activeName = _activityName;
    WKCtrl.teamKey = self.teamKey;
    [self.navigationController pushViewController:WKCtrl animated:YES];
}

// 刷新
- (void)headRereshing{
    [self initPlayerData];
}
#pragma mark - 下载数据

//获取联系人列表
- (void)initPlayerData{
    NSString *md5 = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:[self.activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    NSDictionary *dict = @{
                           @"activityKey":self.activityKey,
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":@0,
                           @"md5":md5,
                           };
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        BOOL packSucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSucess) {
            self.listArray = [NSMutableArray array];
            NSArray *listArray = [data objectForKey:@"teamSignUpList"];
            for (NSDictionary *listDict in listArray) {
                ActivityDetailModel *model = [ActivityDetailModel modelWithDictionary:listDict];
                [self.listArray addObject:model];
            }
            _sumCount = [[data objectForKey:@"sumCount"] integerValue];

            self.indexArray = [SortManager IndexWithArray:self.listArray Key:@"name"];
            self.dataArray = [SortManager sortObjectArray:self.listArray Key:@"name"];

            [_tableView reloadData];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *indexSectionArray = self.dataArray[section];
    return [indexSectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(26);
}

//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailListTableViewCellID"];
    [listCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ActivityDetailModel *model = self.dataArray[indexPath.section][indexPath.row];
    [listCell configModel:model];
    return listCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [Factory createViewWithBackgroundColor:RGB(245,245,245) frame:CGRectMake(0, 0, screenWidth, kHvertical(26))];
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(26), 0, screenWidth-kWvertical(26), kHvertical(26)) textColor:RGB(49,49,49) fontSize:kHvertical(15) Title:_indexArray[section]];
    [headerView addSubview:titleLabel];
    return headerView;
}



- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
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
