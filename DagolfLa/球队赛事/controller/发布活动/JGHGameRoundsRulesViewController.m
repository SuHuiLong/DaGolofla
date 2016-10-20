//
//  JGHGameRoundsRulesViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameRoundsRulesViewController.h"
#import "JGHGameBaseHeaderCell.h"
#import "JGHGameBaseHeaderSubCell.h"
#import "JGHRulesForDetailsView.h"

static NSString *const JGHGameBaseHeaderCellIdentifier = @"JGHGameBaseHeaderCell";
static NSString *const JGHGameBaseHeaderSubCellIdentifier = @"JGHGameBaseHeaderSubCell";

@interface JGHGameRoundsRulesViewController ()<UITableViewDelegate, UITableViewDataSource, JGHGameBaseHeaderCellDelegate>

@property (nonatomic, strong)UITableView *gameRoundsRulesTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHGameRoundsRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置赛制";
    
    self.dataArray = [NSMutableArray array];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    if (self.roundRulesArray == nil) {
        self.roundRulesArray = [NSMutableArray array];
    }
    
    [self createGameRoundsRulesTableView];
    
    [self loadRulesData];
}
#pragma mark -- 保存
- (void)backButtonClcik{
    if (self.delegate) {
        [self.delegate didGameRoundsRulesViewSaveroundRulesArray:self.roundRulesArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)loadRulesData{
    [[JsonHttp jsonHttp]httpRequest:@"http://res.dagolfla.com/download/json/matchFormart.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.dataArray removeAllObjects];
        
        self.dataArray = [data objectForKey:_rulesTimeKey];
        
        if (self.roundRulesArray.count == 0) {
            [self.roundRulesArray addObject:self.dataArray[0]];
        }
        
        [self.gameRoundsRulesTableView reloadData];
    }];
}

- (void)createGameRoundsRulesTableView{
    self.gameRoundsRulesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    UINib *gameBaseHeaderCellNib = [UINib nibWithNibName:@"JGHGameBaseHeaderCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsRulesTableView registerNib:gameBaseHeaderCellNib forCellReuseIdentifier:JGHGameBaseHeaderCellIdentifier];
    
    UINib *gameSetBaseCellNib = [UINib nibWithNibName:@"JGHGameBaseHeaderSubCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsRulesTableView registerNib:gameSetBaseCellNib forCellReuseIdentifier:JGHGameBaseHeaderSubCellIdentifier];
    
    self.gameRoundsRulesTableView.dataSource = self;
    self.gameRoundsRulesTableView.delegate = self;
    self.gameRoundsRulesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameRoundsRulesTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    [self.view addSubview:self.gameRoundsRulesTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 *ProportionAdapter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *timeKey = nil;
//    NSDictionary *dict = [[self.dictData objectForKey:@"-1"]objectAtIndex:_rulesId];
//    timeKey = [dict objectForKey:@"timeKey"];
//    NSArray *secondaryDirectoryArray = [NSArray array];
//    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
//    NSDictionary *rulesTitleDict = secondaryDirectoryArray[indexPath.section];
//    NSArray *rulesList = [self.dictData objectForKey:[rulesTitleDict objectForKey:@"timeKey"]];
//    NSDictionary *baseDict = [rulesList objectAtIndex:indexPath.row];
    JGHGameBaseHeaderSubCell *gameSetBaseCellCell = [tableView dequeueReusableCellWithIdentifier:JGHGameBaseHeaderSubCellIdentifier];
//
    NSInteger _select = 0;
    NSDictionary *rulesDict = self.dataArray[indexPath.row];
    if ([rulesDict objectForKey:@"timeKey"] == [self.roundRulesArray[0] objectForKey:@"timeKey"]) {
        _select = 1;
    }
    
    [gameSetBaseCellCell configJGHGameBaseHeaderSubCell:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"] andSelect:_select];
    return gameSetBaseCellCell;
}

//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGHGameBaseHeaderCell *gameSetCell = [tableView dequeueReusableCellWithIdentifier:JGHGameBaseHeaderCellIdentifier];
    gameSetCell.delegate = self;
    [gameSetCell configJGHGameBaseHeaderCell:@"赛制"];
    return gameSetCell;
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 *ProportionAdapter;
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 *ProportionAdapter;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.roundRulesArray removeAllObjects];
    
    [self.roundRulesArray addObject:self.dataArray[indexPath.row]];
    [self.gameRoundsRulesTableView reloadData];
}
#pragma mark -- 赛制详情
- (void)didSelectHelpBtn:(UIButton *)btn{
    
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
