//
//  JGHEditorGameRoundsRulesViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEditorGameRoundsRulesViewController.h"
#import "JGHGameBaseHeaderCell.h"
#import "JGHGameBaseHeaderSubCell.h"
#import "JGHRulesForDetailsView.h"

static NSString *const JGHGameBaseHeaderCellIdentifier = @"JGHGameBaseHeaderCell";
static NSString *const JGHGameBaseHeaderSubCellIdentifier = @"JGHGameBaseHeaderSubCell";

@interface JGHEditorGameRoundsRulesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *gameRoundsRulesTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)NSMutableDictionary *ruleDict;

@end

@implementation JGHEditorGameRoundsRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.navigationItem.title = @"设置赛制";
    
    self.dataArray = [NSMutableArray array];
    
    self.ruleDict = [NSMutableDictionary dictionary];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [self createGameRoundsRulesTableView];
    
    [self loadRulesData];
}

#pragma mark -- 保存
- (void)backButtonClcik{
    if (self.delegate) {
        [self.delegate didSelectRulesDict:self.ruleDict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)loadRulesData{
    [[JsonHttp jsonHttp]httpRequest:@"http://res.dagolfla.com/download/json/matchFormart.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.dataArray removeAllObjects];
        
        self.dataArray = [data objectForKey:_matchTypeKey];
        
        
        
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

    JGHGameBaseHeaderSubCell *gameSetBaseCellCell = [tableView dequeueReusableCellWithIdentifier:JGHGameBaseHeaderSubCellIdentifier];
    //
    NSInteger _select = 0;
    NSDictionary *rulesDict = self.dataArray[indexPath.row];
    NSString *matchformatKey1 = [rulesDict objectForKey:@"timeKey"];
    if ([matchformatKey1 isEqualToString:_matchformatKey]) {
        _select = 1;
    }
    
    [gameSetBaseCellCell configJGHGameBaseHeaderSubCell:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"] andSelect:_select andTopvalue:@""];
    return gameSetBaseCellCell;
}

//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGHGameBaseHeaderCell *gameSetCell = [tableView dequeueReusableCellWithIdentifier:JGHGameBaseHeaderCellIdentifier];
//    gameSetCell.delegate = self;
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
    self.ruleDict = self.dataArray[indexPath.row];
    _matchformatKey = [self.ruleDict objectForKey:@"timeKey"];
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
