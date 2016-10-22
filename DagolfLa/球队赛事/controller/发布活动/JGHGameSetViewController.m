//
//  JGHGameSetViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameSetViewController.h"
#import "JGHGameSetCell.h"
#import "JGHGameSetBaseCell.h"
#import "JGHGameSetBaseCellCell.h"
#import "JGHGameBaseSetViewController.h"

static NSString *const JGHGameSetCellIdentifier = @"JGHGameSetCell";
static NSString *const JGHGameSetBaseCellIdentifier = @"JGHGameSetBaseCell";
static NSString *const JGHGameSetBaseCellCellIdentifier = @"JGHGameSetBaseCellCell";

@interface JGHGameSetViewController ()<UITableViewDelegate, UITableViewDataSource, JGHGameSetCellDelegate, JGHGameSetBaseCellCellDelegate, JGHGameBaseSetViewControllerDelegate>

@property (nonatomic, strong)UITableView *gameSetTableView;

@property (nonatomic, strong)NSMutableDictionary *dictData;

@property (nonatomic, strong)NSMutableArray *titleArray;

@property (nonatomic, strong)NSMutableArray *showArray;


@end

@implementation JGHGameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"玩法设置";
    self.dictData = [NSMutableDictionary dictionary];
    self.titleArray = [NSMutableArray array];
    self.showArray = [NSMutableArray array];
    if (self.rulesArray.count == 0) {
        self.rulesArray = [NSMutableArray array];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RightNavItemFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self createGameSetTableView];
    
    [self loadJosnData];
}
#pragma mark -- 确定
- (void)saveBtnClick:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate saveRulesArray:self.rulesArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -- 下载数据
- (void)loadJosnData{
    [[JsonHttp jsonHttp]httpRequest:@"http://res.dagolfla.com/download/json/rule_all.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        self.dictData = data;
        if ([self.dictData objectForKey:@"-1"]) {
            self.titleArray = [[self.dictData objectForKey:@"-1"] mutableCopy];
            for (int i=0; i<self.titleArray.count; i++) {
                if (self.rulesArray.count > 0) {
                    if ([[self.titleArray[i] objectForKey:@"timeKey"] isEqualToString:[self.rulesArray[0] objectForKey:@"timeKey"]]) {
                        [self.showArray addObject:@1];
                    }else{
                        [self.showArray addObject:@0];
                    }
                }else{
                    [self.showArray addObject:@0];
                }
            }
        }
        
        [self.gameSetTableView reloadData];
    }];
}

- (void)createGameSetTableView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 45 *ProportionAdapter)];
    UILabel *catoryLable = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 20 *ProportionAdapter, screenWidth - 20 *ProportionAdapter, 21 *ProportionAdapter)];
    catoryLable.text = @"选择你的比赛类型";
    catoryLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    [headerView addSubview:catoryLable];
    
    self.gameSetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    self.gameSetTableView.tableHeaderView = headerView;
    
    UINib *gameSetCellNib = [UINib nibWithNibName:@"JGHGameSetCell" bundle: [NSBundle mainBundle]];
    [self.gameSetTableView registerNib:gameSetCellNib forCellReuseIdentifier:JGHGameSetCellIdentifier];
    
    UINib *gameSetBaseCellNib = [UINib nibWithNibName:@"JGHGameSetBaseCell" bundle: [NSBundle mainBundle]];
    [self.gameSetTableView registerNib:gameSetBaseCellNib forCellReuseIdentifier:JGHGameSetBaseCellIdentifier];
    
    UINib *gameSetBaseCellCellNib = [UINib nibWithNibName:@"JGHGameSetBaseCellCell" bundle: [NSBundle mainBundle]];
    [self.gameSetTableView registerNib:gameSetBaseCellCellNib forCellReuseIdentifier:JGHGameSetBaseCellCellIdentifier];

    self.gameSetTableView.dataSource = self;
    self.gameSetTableView.delegate = self;
    self.gameSetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameSetTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    [self.view addSubview:self.gameSetTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger showID = [[self.showArray objectAtIndex:section] integerValue];
    if (showID == 0) {
        return 0;
    }else{
        NSString *timeKey = nil;
        NSDictionary *dict = [_titleArray objectAtIndex:section];
        timeKey = [dict objectForKey:@"timeKey"];
        NSArray *secondaryDirectoryArray = [NSArray array];
        secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
        return secondaryDirectoryArray.count;
    }
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
    JGHGameSetBaseCellCell *gameSetBaseCellCell = [tableView dequeueReusableCellWithIdentifier:JGHGameSetBaseCellCellIdentifier];
    gameSetBaseCellCell.delegate = self;
    gameSetBaseCellCell.rulesSetBtn.tag = 1000 +indexPath.section;

    if (indexPath.row == 0) {
        gameSetBaseCellCell.rulesSetBtn.hidden = NO;
    }else{
        gameSetBaseCellCell.rulesSetBtn.hidden = YES;
    }
    
    NSString *timeKey = nil;
    timeKey = [[_titleArray objectAtIndex:indexPath.section] objectForKey:@"timeKey"];
    NSArray *subRulesArray = [NSArray array];
    subRulesArray = [self.dictData objectForKey:timeKey];
    
    NSDictionary *rulesTitleDict = subRulesArray[indexPath.row];
    NSArray *rulesList = [self.dictData objectForKey:[rulesTitleDict objectForKey:@"timeKey"]];
    NSDictionary *baseDict = [rulesList objectAtIndex:0];
    
    NSArray *secondaryDirectoryArray = [NSArray array];
    secondaryDirectoryArray = [self.dictData objectForKey:timeKey];
    
    [gameSetBaseCellCell configJGHGameSetBaseCellCell:secondaryDirectoryArray[indexPath.row]];
    
    if (self.rulesArray.count == 0) {
        [gameSetBaseCellCell configJGHGameSetBaseCellCellContext:baseDict];
    }else{
        for (int i=0; i<_showArray.count; i++) {
            NSInteger show = [_showArray[i] integerValue];
            if (show == 1) {
                [gameSetBaseCellCell configJGHGameSetBaseCellCellContext:self.rulesArray[indexPath.row +1]];
            }
        }
    }
    
    return gameSetBaseCellCell;
}

//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGHGameSetCell *gameSetCell = [tableView dequeueReusableCellWithIdentifier:JGHGameSetCellIdentifier];
    gameSetCell.delegate = self;
    gameSetCell.gameSetCellBtn.tag = 100 +section;
    
    NSArray *titleArray = [NSArray array];
    titleArray = [self.dictData objectForKey:@"-1"];
    NSDictionary *titleDict = [titleArray objectAtIndex:section];
    NSString *titleString = [titleDict objectForKey:@"name"];
    NSInteger showID = [[self.showArray objectAtIndex:section] integerValue];
    [gameSetCell configJGHGameSetCellTitleString:titleString andSelect:showID];
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
    return 44 *ProportionAdapter;
}
#pragma mark -- 点击组头
- (void)didSelectJGHGameSetCellBtn:(UIButton *)btn{
    NSInteger showID = [[self.showArray objectAtIndex:btn.tag -100] integerValue];
    for (int i=0; i < _showArray.count; i++) {
        if (btn.tag -100 == i) {
            if (showID == 0) {
                [self.showArray replaceObjectAtIndex:btn.tag -100 withObject:@1];
            }else{
                [self.showArray replaceObjectAtIndex:btn.tag -100 withObject:@0];
            }
        }else{
            [_showArray replaceObjectAtIndex:i withObject:@0];
        }
    }
    
    //填充默认规则
    if (self.rulesArray.count != 0) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict = [self.rulesArray objectAtIndex:0];
        [self.rulesArray removeAllObjects];
//        [self.rulesArray addObject:dict];
    }
    
    [self.rulesArray addObject:[_titleArray objectAtIndex:btn.tag -100]];
    NSString *timeKey = nil;
    timeKey = [[_titleArray objectAtIndex:btn.tag -100] objectForKey:@"timeKey"];
    NSArray *subRulesArray = [NSArray array];
    subRulesArray = [self.dictData objectForKey:timeKey];
    
    for (int i=0; i<subRulesArray.count; i++) {
        NSDictionary *rulesTitleDict = subRulesArray[i];
        NSArray *rulesList = [self.dictData objectForKey:[rulesTitleDict objectForKey:@"timeKey"]];
        NSDictionary *baseDict = [rulesList objectAtIndex:0];
        [self.rulesArray addObject:baseDict];
    }
    
    [self.gameSetTableView reloadData];
}
#pragma mark -- 设置规则
- (void)didSelectGameSetBtn:(UIButton *)setBtn{
    
    JGHGameBaseSetViewController *gameBaseCtrl = [[JGHGameBaseSetViewController alloc]init];
    gameBaseCtrl.delegate = self;
    gameBaseCtrl.dictData = self.dictData;
    gameBaseCtrl.rulesId = setBtn.tag -1000;
    gameBaseCtrl.rulesArray = _rulesArray;
    [self.navigationController pushViewController:gameBaseCtrl animated:YES];
}
#pragma mark -- 返回赛制规则
- (void)selectRulesArray:(NSMutableArray *)rulesArray{
    self.rulesArray = [rulesArray mutableCopy];
    [self.gameSetTableView reloadData];
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
