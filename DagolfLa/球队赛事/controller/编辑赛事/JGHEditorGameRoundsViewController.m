//
//  JGHEditorGameRoundsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEditorGameRoundsViewController.h"
#import "JGHEventRulesHeaderCell.h"
#import "JGHEventRulesContentCell.h"
#import "JGHAddEventRoundsBtnCell.h"
#import "JGHEditorGameRoundsRulesViewController.h"
#import "BallParkViewController.h"

static NSString *const JGHEventRulesHeaderCellIdentifier = @"JGHEventRulesHeaderCell";
static NSString *const JGHEventRulesContentCellIdentifier = @"JGHEventRulesContentCell";
static NSString *const JGHAddEventRoundsBtnCellIdentifier = @"JGHAddEventRoundsBtnCell";

@interface JGHEditorGameRoundsViewController ()<UITableViewDelegate, UITableViewDataSource, JGHAddEventRoundsBtnCellDelegate, JGHEventRulesHeaderCellDelegate, JGHEditorGameRoundsRulesViewControllerDelegate>
{
    NSInteger _roundCount;//轮次数
    
    NSArray *_titltArray;
    
    NSInteger _roundID;//轮次ID
    
    NSMutableArray *_showArray;//显示保存或者删除
    
    NSInteger _isCreateRound;//是否可以添加轮次
    
    NSMutableArray *_roundKey;//轮次key,第一轮次没有Key
}

@property (nonatomic, strong)UITableView *gameRoundsTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;//列表数据

@property (nonatomic, strong)NSMutableArray *roundArray;

@end

@implementation JGHEditorGameRoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置比赛轮次";
    _titltArray = @[@"开球时间", @"比赛场地", @"赛制/规则"];
    self.dataArray = [NSMutableArray array];
    self.roundArray = [NSMutableArray array];
    _showArray = [NSMutableArray array];
    _roundKey = [NSMutableArray array];
    _isCreateRound = 0;
    //1、获取所有赛制
    [self getAllRound];
    
    [self createGameRoundsTableView];
}
- (void)getAllRound{
    //getMatchRoundList
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_timeKey) forKey:@"matchKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    //[JGReturnMD5Str]
    NSString *strMD5 = [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%td&userKey=%tddagolfla.com", _timeKey, [DEFAULF_USERID integerValue]]];
    [dict setObject:strMD5 forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getMatchRoundList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.dataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _isCreateRound = [[data objectForKey:@"isCreateRound"] integerValue];
            if ([data objectForKey:@"list"]) {
                self.dataArray = [data objectForKey:@"list"];
                
                for (NSDictionary *dict in self.dataArray) {
                    NSString *ruleJson = [dict objectForKey:@"ruleJson"];
                    [self.roundArray addObject:[Helper dictionaryWithJsonString:ruleJson]];
                    [_showArray addObject:@1];
                }
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.gameRoundsTableView reloadData];
    }];
}
- (void)createGameRoundsTableView{
    self.gameRoundsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    UINib *eventRulesNib = [UINib nibWithNibName:@"JGHEventRulesHeaderCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsTableView registerNib:eventRulesNib forCellReuseIdentifier:JGHEventRulesHeaderCellIdentifier];
    
    UINib *eventRulesContentNib = [UINib nibWithNibName:@"JGHEventRulesContentCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsTableView registerNib:eventRulesContentNib forCellReuseIdentifier:JGHEventRulesContentCellIdentifier];
    
    UINib *addEventRoundsNib = [UINib nibWithNibName:@"JGHAddEventRoundsBtnCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsTableView registerNib:addEventRoundsNib forCellReuseIdentifier:JGHAddEventRoundsBtnCellIdentifier];
    
    self.gameRoundsTableView.dataSource = self;
    self.gameRoundsTableView.delegate = self;
    self.gameRoundsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameRoundsTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    [self.view addSubview:self.gameRoundsTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count +1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _dataArray.count) {
        //        return [_rulesArray[section] count] -1 +2;
        return 3;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGHEventRulesContentCell *eventRulesContentCell = [tableView dequeueReusableCellWithIdentifier:JGHEventRulesContentCellIdentifier];
    eventRulesContentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < _titltArray.count) {
        [eventRulesContentCell configJGHEventRulesContentCellTitle:_titltArray[indexPath.row]];
    }else{
        [eventRulesContentCell configJGHEventRulesContentCellTitle:@""];
    }
    
    if (self.dataArray.count >= indexPath.section) {
        NSDictionary *contextDict = [self.dataArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"kickOffTime"]];
        }else if (indexPath.row == 1){
            [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"ballName"]];
        }else{
            [eventRulesContentCell configJGHEventRulesContentCellContext:[self.dataArray[indexPath.section] objectForKey:@"matchformatName"]];
        }
    }
    
    return eventRulesContentCell;
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < _dataArray.count) {
        JGHEventRulesHeaderCell *eventRulesHeaderCell = [tableView dequeueReusableCellWithIdentifier:JGHEventRulesHeaderCellIdentifier];
        eventRulesHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        eventRulesHeaderCell.delegate = self;
        eventRulesHeaderCell.saveAndDeleteBtn.tag = 100 + section;
        
        [eventRulesHeaderCell configJGHEventRulesHeaderCell:section +1 andSelect:[_showArray[section] integerValue]];
        
        return eventRulesHeaderCell;
    }else{
        JGHAddEventRoundsBtnCell *addEventRoundsBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHAddEventRoundsBtnCellIdentifier];
        addEventRoundsBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addEventRoundsBtnCell.delegate = self;
        return addEventRoundsBtnCell;
    }
}

//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30 *ProportionAdapter;
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //时间选择
        JGHDatePicksViewController *datePicksCrel = [[JGHDatePicksViewController alloc]init];
        datePicksCrel.returnDateString = ^(NSString *dateString){
            NSLog(@"%@", dateString);
            NSMutableDictionary *repDict = [[self.dataArray objectAtIndex:_roundID] mutableCopy];
            if (dateString.length == 16) {
                [repDict setObject:[NSString stringWithFormat:@"%@:00", dateString] forKey:@"kickOffTime"];
            }else{
                [repDict setObject:dateString forKey:@"kickOffTime"];
            }
            [self.dataArray replaceObjectAtIndex:_roundID withObject:repDict];
            [_showArray replaceObjectAtIndex:_roundID withObject:@0];
            [self.gameRoundsTableView reloadData];
        };
        [self.navigationController pushViewController:datePicksCrel animated:YES];
    }else if (indexPath.row == 1) {
        //球场列表
        BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
        [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
            NSLog(@"%@----%ld", balltitle, (long)ballid);
            NSMutableDictionary *repDict = [[self.dataArray objectAtIndex:_roundID] mutableCopy];
            [repDict setObject:@(ballid) forKey:@"ballKey"];
            [repDict setObject:balltitle forKey:@"ballName"];
            [self.dataArray replaceObjectAtIndex:_roundID withObject:repDict];
            [_showArray replaceObjectAtIndex:_roundID withObject:@0];
            [self.gameRoundsTableView reloadData];
        }];
        
        [self.navigationController pushViewController:ballCtrl animated:YES];
    }
    
    if (indexPath.row == 2) {
        JGHEditorGameRoundsRulesViewController *gameRulesListCtrl = [[JGHEditorGameRoundsRulesViewController alloc]init];
        NSMutableDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
        gameRulesListCtrl.matchformatKey = [dict objectForKey:@"matchformatKey"];
        gameRulesListCtrl.matchTypeKey = [dict objectForKey:@"matchTypeKey"];
        
//        if (self.roundArray.count >= indexPath.section+1) {
//            gameRulesListCtrl.roundRulesArray = self.roundArray[indexPath.section];
//        }
        
        gameRulesListCtrl.delegate = self;
        _roundID = indexPath.section;
        [self.navigationController pushViewController:gameRulesListCtrl animated:YES];
    }
}
#pragma mark -- 添加轮次
- (void)didSelectAddEventRoundsBtn:(UIButton *)btn{
    if (_isCreateRound == 0) {
        [[ShowHUD showHUD]showToastWithText:@"不允许添加轮次！" FromView:self.view];
        return;
    }else{
        //添加默认信息
        NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
        baseDict = [[self.dataArray lastObject] mutableCopy];
        [baseDict setObject:@"" forKey:@"kickOffTime"];
        [baseDict setObject:@"" forKey:@"ballKey"];
        [baseDict setObject:@"" forKey:@"ballName"];
        [baseDict setObject:@"" forKey:@"ruleJson"];
        [baseDict setObject:@"" forKey:@"matchformatName"];
        [baseDict setObject:@"" forKey:@"ruleType"];
        [baseDict setObject:@"" forKey:@"matchTypeKey"];//赛事类型key
        [baseDict setObject:@"" forKey:@"timeKey"];
        
        NSMutableArray *array = [NSMutableArray array];
        array = [self.dataArray mutableCopy];
        [array addObject:baseDict];
        self.dataArray = array;
        
        [_showArray addObject:@0];
        
        [self.gameRoundsTableView reloadData];
    }
}
#pragma mark -- 删除或者保存
- (void)didSelectSaveOrDeleteBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    
    //区分是保存还是删除
    NSInteger selectCatory;
    selectCatory = [_showArray[btn.tag -100] integerValue];
    //第一个不能删除
    if (selectCatory == 1 && btn.tag == 100) {
        [[ShowHUD showHUD]showToastWithText:@"该轮次不允许删除!" FromView:self.view];
        return;
    }
    
    NSDictionary *ruleDict = [NSDictionary dictionary];
    ruleDict = self.dataArray[btn.tag -100];
    if ([[ruleDict objectForKey:@"ballName"]isEqualToString:@""]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择球场！" FromView:self.view];
        return;
    }
    
    if ([[ruleDict objectForKey:@"kickOffTime"]isEqualToString:@""]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择开球时间！" FromView:self.view];
        return;
    }
    
    if (self.roundArray.count > btn.tag -100 +1) {
        [[ShowHUD showHUD]showToastWithText:@"请选择赛制规则！" FromView:self.view];
        return;
    }
        
    btn.enabled = NO;
    
    if (selectCatory == 0) {
        //保存
        NSMutableDictionary *paterdict = [NSMutableDictionary dictionary];
        NSMutableDictionary *matchRoundDict = [NSMutableDictionary dictionary];
        matchRoundDict = [ruleDict mutableCopy];
        [matchRoundDict setObject:@0 forKey:@"timeKey"];
        [matchRoundDict setObject:[ruleDict objectForKey:@"timeKey"] forKey:@"matchformatKey"];
        [matchRoundDict setObject:[ruleDict objectForKey:@"name"] forKey:@"matchformatName"];
        [matchRoundDict setObject:@(_timeKey) forKey:@"matchKey"];
        [matchRoundDict setObject:ruleDict forKey:@"ruleJson"];
        
        [paterdict setObject:DEFAULF_USERID forKey:@"userKey"];
        [paterdict setObject:matchRoundDict forKey:@"matchRound"];
        [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"match/addRound" JsonKey:nil withData:paterdict failedBlock:^(id errType) {
            btn.enabled = YES;
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                NSMutableArray *alldataArray = [NSMutableArray array];
                alldataArray = self.dataArray;
                for (int i=0; i< self.dataArray.count; i++) {
                    if (i == btn.tag -100) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict = [alldataArray[i] mutableCopy];
                        [dict setObject:[data objectForKey:@"timeKey"] forKey:@"roundKey"];
                        [alldataArray replaceObjectAtIndex:btn.tag -100 withObject:dict];
                    }
                }
                
                self.dataArray = alldataArray;
                
                [[ShowHUD showHUD]showToastWithText:@"保存成功！" FromView:self.view];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
            btn.enabled = YES;
        }];
    }else{
        //删除
        NSMutableDictionary *postdict = [NSMutableDictionary dictionary];
        
        [postdict setObject:DEFAULF_USERID forKey:@"userKey"];
        NSDictionary *rounKeyDict = self.dataArray[btn.tag -100];
        [postdict setObject:[rounKeyDict objectForKey:@"roundKey"] forKey:@"roundKey"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"match/deleteRound" JsonKey:nil withData:postdict failedBlock:^(id errType) {
            btn.enabled = YES;
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            
            [self.dataArray removeObjectAtIndex:btn.tag -100];
            [_showArray removeObjectAtIndex:btn.tag -100];
            btn.enabled = YES;
        }];
    }
}
#pragma mark -- 赛制代理
//- (void)didGameRoundsRulesViewSaveroundRulesArray:(NSMutableArray *)roundRulesArray{
////    self.roundArray = roundRulesArray;
//    if (_roundID <= self.roundArray.count -1) {
//        for (int i=0; i<self.roundArray.count; i++) {
//            NSMutableDictionary *oldRuleDict = [NSMutableDictionary dictionary];
//            oldRuleDict = self.roundArray[i];
//            [oldRuleDict setValuesForKeysWithDictionary:roundRulesArray[0]];
//            [self.roundArray replaceObjectAtIndex:_roundID withObject:oldRuleDict];
//        }
//    }else{
//        NSMutableDictionary *oldRuleDict = [NSMutableDictionary dictionary];
//        oldRuleDict = self.roundArray[0];
//        [oldRuleDict setValuesForKeysWithDictionary:roundRulesArray[0]];
//        [self.roundArray replaceObjectAtIndex:_roundID withObject:oldRuleDict];
//    }
//    
//    [self.gameRoundsTableView reloadData];
//}
#pragma mark -- 编辑赛制
- (void)didSelectRulesDict:(NSDictionary *)rulesDict{
    NSString *newMatchformatKey = [rulesDict objectForKey:@"timeKey"];
    NSString *matchformatKey = [self.dataArray[_roundID] objectForKey:@"matchformatKey"];
    if (![newMatchformatKey isEqualToString:matchformatKey]) {
        NSMutableDictionary *repDict = [[self.dataArray objectAtIndex:_roundID] mutableCopy];
        [repDict setObject:[rulesDict objectForKey:@"timeKey"] forKey:@"matchformatKey"];
        [repDict setObject:[rulesDict objectForKey:@"name"] forKey:@"matchformatName"];
        NSMutableArray *array = [self.dataArray mutableCopy];
        
        [array replaceObjectAtIndex:_roundID withObject:repDict];
        self.dataArray = array;
        
        [_showArray replaceObjectAtIndex:_roundID withObject:@0];
        [self.gameRoundsTableView reloadData];
    }
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
