//
//  JGHGameRoundsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameRoundsViewController.h"
#import "JGHEventRulesHeaderCell.h"
#import "JGHEventRulesContentCell.h"
#import "JGHAddEventRoundsBtnCell.h"
#import "JGHGameRoundsRulesViewController.h"
#import "BallParkViewController.h"

static NSString *const JGHEventRulesHeaderCellIdentifier = @"JGHEventRulesHeaderCell";
static NSString *const JGHEventRulesContentCellIdentifier = @"JGHEventRulesContentCell";
static NSString *const JGHAddEventRoundsBtnCellIdentifier = @"JGHAddEventRoundsBtnCell";

@interface JGHGameRoundsViewController ()<UITableViewDelegate, UITableViewDataSource, JGHAddEventRoundsBtnCellDelegate, JGHEventRulesHeaderCellDelegate, JGHGameRoundsRulesViewControllerDelegate>
{
    NSInteger _roundCount;//轮次数
    
    NSArray *_titltArray;
    
    NSInteger _roundID;//轮次ID
    
    NSInteger _isCreateRound;//是否可以添加轮次
    
    NSMutableArray *_showArray;//是否显示0-保存， 1- 删除
}

@property (nonatomic, strong)UITableView *gameRoundsTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHGameRoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置比赛轮次";
    _titltArray = @[@"开球时间", @"比赛场地", @"赛制/规则"];
    
    self.dataArray = [NSMutableArray array];
//    self.ballBaseArray = [NSMutableArray array];
    _showArray = [NSMutableArray array];
    
    if (!self.roundArray) {
        self.roundArray = [NSMutableArray array];
    }
    
//    if (self.ballBaseArray.count == 0) {
//        //添加默认信息
//        NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
//        [baseDict setObject:_beginDate forKey:@"kickOffTime"];
//        [baseDict setObject:@(_ballKey) forKey:@"ballKey"];
//        [baseDict setObject:_ballName forKey:@"ballName"];
//        [baseDict setObject:@"0" forKey:@"select"];//0-保存，1-删除
//        [baseDict setObject:_rulesTimeKey forKey:@"matchTypeKey"];//赛事类型key
//        [self.ballBaseArray addObject:baseDict];
//    }
    
    [self createGameRoundsTableView];
    
    [self getAllRound];
}
#pragma mark -- 下载轮次列表
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
                for (int i=0; i<self.dataArray.count; i++) {
                    NSDictionary *dict = self.dataArray[i];
                    NSString *ruleJson = [dict objectForKey:@"ruleJson"];
                    [self.roundArray addObject:[Helper dictionaryWithJsonString:ruleJson]];
                    if (i == 0) {
                        [_showArray addObject:@0];
                    }else{
                        [_showArray addObject:@1];
                    }
                }
                for (NSDictionary *dict in self.dataArray) {
                    NSString *ruleJson = [dict objectForKey:@"ruleJson"];
                    [self.roundArray addObject:[Helper dictionaryWithJsonString:ruleJson]];
                    [_showArray addObject:@1];
                }
            }else{
                if (self.dataArray.count == 0) {
                    [self loadRulesData];//下载默认轮次
                    //添加默认信息
                    NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
                    [baseDict setObject:_beginDate forKey:@"kickOffTime"];
                    [baseDict setObject:@(_ballKey) forKey:@"ballKey"];
                    [baseDict setObject:_ballName forKey:@"ballName"];
                    [baseDict setObject:_rulesTimeKey forKey:@"matchTypeKey"];//赛事类型key
                    [self.dataArray addObject:baseDict];
                    [_showArray addObject:@0];
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
#pragma mark -- 下载默认轮次
- (void)loadRulesData{
    [[JsonHttp jsonHttp]httpRequest:@"http://res.dagolfla.com/download/json/matchFormart.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        NSArray *array = [NSArray array];
        array = [data objectForKey:_rulesTimeKey];
        
        if (self.roundArray.count == 0) {
            [self.roundArray addObject:array[0]];
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

    if (_dataArray.count > 0) {
        NSDictionary *contextDict = [self.dataArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"kickOffTime"]];
        }else if (indexPath.row == 1){
            [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"ballName"]];
        }else{
            
            if (self.roundArray.count >= indexPath.section +1) {
                [eventRulesContentCell configJGHEventRulesContentCellContext:[self.roundArray[indexPath.section] objectForKey:@"name"]];
            }
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
        
        NSInteger saveOrDelete = 0;
        saveOrDelete = [_showArray[section] integerValue];
        [eventRulesHeaderCell configJGHEventRulesHeaderCell:section +1 andSelect:saveOrDelete];
        
        return eventRulesHeaderCell;
    }else{
        JGHAddEventRoundsBtnCell *addEventRoundsBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHAddEventRoundsBtnCellIdentifier];
        addEventRoundsBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addEventRoundsBtnCell.delegate = self;
        if (_isCreateRound == 0) {
            addEventRoundsBtnCell.ruleaddBtn.userInteractionEnabled = NO;
            [addEventRoundsBtnCell.ruleaddBtn setTitleColor:[UIColor colorWithHexString:BG_color] forState:UIControlStateNormal];
        }else{
            addEventRoundsBtnCell.ruleaddBtn.userInteractionEnabled = YES;
        }
        
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
            NSMutableDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
            if (dateString.length == 16) {
                [dict setObject:[NSString stringWithFormat:@"%@:00", dateString] forKey:@"kickOffTime"];
            }else{
                [dict setObject:dateString forKey:@"kickOffTime"];
            }
            
            NSMutableArray *array = [NSMutableArray array];
            array = [NSMutableArray arrayWithArray:_dataArray];
            [array replaceObjectAtIndex:indexPath.section withObject:dict];
            self.dataArray = array;
            [_showArray replaceObjectAtIndex:indexPath.section withObject:@0];
            [self.gameRoundsTableView reloadData];
        };
        [self.navigationController pushViewController:datePicksCrel animated:YES];
    }
    
    if (indexPath.row == 1) {
        //球场列表
        BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
        [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
            NSLog(@"%@----%ld", balltitle, (long)ballid);
            NSMutableDictionary *dict = [self.dataArray objectAtIndex:indexPath.section];
            [dict setObject:@(ballid) forKey:@"ballKey"];
            [dict setObject:balltitle forKey:@"ballName"];
            NSMutableArray *array = [NSMutableArray array];
            array = [NSMutableArray arrayWithArray:_dataArray];
            [array replaceObjectAtIndex:indexPath.section withObject:dict];
            self.dataArray = array;
            [_showArray replaceObjectAtIndex:indexPath.section withObject:@0];
            [self.gameRoundsTableView reloadData];
        }];
        
        [self.navigationController pushViewController:ballCtrl animated:YES];
    }
    
    if (indexPath.row == 2) {
        JGHGameRoundsRulesViewController *gameRulesListCtrl = [[JGHGameRoundsRulesViewController alloc]init];
//        NSDictionary *rulesDict = _rulesArray[0][0];
        gameRulesListCtrl.rulesTimeKey = _rulesTimeKey;
        if (self.roundArray.count >= indexPath.section+1) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:self.roundArray[indexPath.section]];
            gameRulesListCtrl.roundRulesArray = array;
        }
        
        gameRulesListCtrl.delegate = self;
        _roundID = indexPath.section;
        [self.navigationController pushViewController:gameRulesListCtrl animated:YES];
    }
}
#pragma mark -- 添加轮次
- (void)didSelectAddEventRoundsBtn:(UIButton *)btn{
    //添加默认信息
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
    [baseDict setObject:@"" forKey:@"kickOffTime"];
    [baseDict setObject:@"" forKey:@"ballKey"];
    [baseDict setObject:@"" forKey:@"ballName"];
    [baseDict setObject:@"1" forKey:@"select"];//0-保存，1-删除
    [baseDict setObject:_rulesTimeKey forKey:@"matchTypeKey"];//赛事类型key
    [self.dataArray addObject:baseDict];
    [_showArray addObject:@1];
    [self.gameRoundsTableView reloadData];
}
#pragma mark -- 删除或者保存
- (void)didSelectSaveOrDeleteBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    
    //区分是保存还是删除
    NSInteger selectCatory;
    NSDictionary *ballDict = self.dataArray[btn.tag -100];
    if (btn.tag -100 == 0) {
        selectCatory = 0;
    }else{
        selectCatory = [_showArray[btn.tag -100] integerValue];
    }
    
    //删除未保存的轮次 -－－
    if (selectCatory == 1) {
        if (![ballDict objectForKey:@"timeKey"]) {
            if (self.roundArray.count >= btn.tag -100 +1) {
                [self.roundArray removeObjectAtIndex:btn.tag -100];
            }
            
            [self.dataArray removeObjectAtIndex:btn.tag -100];
            [self.gameRoundsTableView reloadData];
            return;
        }
    }
    
    if ([[ballDict objectForKey:@"kickOffTime"]isEqualToString:@""]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择开球时间！" FromView:self.view];
        return;
    }
    
    if ([[ballDict objectForKey:@"ballName"]isEqualToString:@""]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择球场！" FromView:self.view];
        return;
    }
    
    if (self.roundArray.count < btn.tag -100 +1) {
        [[ShowHUD showHUD]showToastWithText:@"请选择赛制规则！" FromView:self.view];
        return;
    }
    
    btn.enabled = NO;
    NSLog(@"btn.tag ==%td", btn.tag);
    NSDictionary *roundDict = [self.roundArray objectAtIndex:btn.tag - 100];
    
    if (selectCatory == 0) {
        //保存
        NSMutableDictionary *paterdict = [NSMutableDictionary dictionary];
        NSMutableDictionary *matchRoundDict = [NSMutableDictionary dictionary];
        matchRoundDict = [ballDict mutableCopy];
        [matchRoundDict setObject:@0 forKey:@"timeKey"];
        [matchRoundDict setObject:[roundDict objectForKey:@"timeKey"] forKey:@"matchformatKey"];
        [matchRoundDict setObject:[roundDict objectForKey:@"name"] forKey:@"matchformatName"];
        [matchRoundDict setObject:@(_timeKey) forKey:@"matchKey"];
        [matchRoundDict setObject:roundDict forKey:@"ruleJson"];
        
        [paterdict setObject:DEFAULF_USERID forKey:@"userKey"];
        [paterdict setObject:matchRoundDict forKey:@"matchRound"];
        [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"match/addRound" JsonKey:nil withData:paterdict failedBlock:^(id errType) {
            btn.enabled = YES;
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                if (btn.tag != 100) {
                    NSMutableArray *array = [NSMutableArray array];
                    array = [_showArray mutableCopy];
                    [array replaceObjectAtIndex:btn.tag -100 withObject:@1];
                    _showArray = array;
                }
                [[ShowHUD showHUD]showToastWithText:@"保存成功！" FromView:self.view];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
            btn.enabled = YES;
            [self.gameRoundsTableView reloadData];
        }];
    }else{
        //删除
        NSMutableDictionary *postdict = [NSMutableDictionary dictionary];
        [postdict setObject:self.dataArray[btn.tag -100] forKey:@"roundKey"];
        [postdict setObject:DEFAULF_USERID forKey:@"userKey"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"match/deleteRound" JsonKey:nil withData:postdict failedBlock:^(id errType) {
            btn.enabled = YES;
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [self.dataArray removeObjectAtIndex:btn.tag -100];
                [self.roundArray removeObjectAtIndex:btn.tag -100];
                [[ShowHUD showHUD]showToastWithText:@"删除成功！" FromView:self.view];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
            btn.enabled = YES;
            [self.gameRoundsTableView reloadData];
        }];
    }
}
#pragma mark -- 赛制代理
- (void)didGameRoundsRulesViewSaveroundRulesArray:(NSMutableArray *)roundRulesArray{
    [_showArray replaceObjectAtIndex:_roundID withObject:@0];
    
    if (self.roundArray.count == 0) {
        [self.roundArray addObject:roundRulesArray[0]];
    }else{
        if (_roundID <= self.roundArray.count -1) {
            for (int i=0; i<self.roundArray.count; i++) {
                [self.roundArray replaceObjectAtIndex:_roundID withObject:roundRulesArray[0]];
            }
        }else{
            [self.roundArray addObject:roundRulesArray[0]];
        }
    }
    
    [self.gameRoundsTableView reloadData];
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
