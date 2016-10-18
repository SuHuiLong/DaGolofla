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
    
    [self.dataArray removeAllObjects];
    
    self.ballBaseArray = [NSMutableArray array];
    
    if (!self.roundArray) {
        self.roundArray = [NSMutableArray array];
    }

    [self createGameRoundsTableView];
    
//    [self loadJsonData];
    
    //1、获取所有赛制
    [self getAllRound];
    
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
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.ballBaseArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data allKeys].count == 2) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"" forKey:@"kickOffTime"];
                [dict setObject:@"" forKey:@"ballKey"];
                [dict setObject:@"0" forKey:@"select"];//0-保存，1-删除
                [dict setObject:_rulesTimeKey forKey:@"matchTypeKey"];//赛事类型key
                [self.ballBaseArray addObject:dict];
            }else{
                //数据
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.gameRoundsTableView reloadData];
    }];
}
- (void)loadJsonData{
    [[JsonHttp jsonHttp]httpRequest:@"http://res.dagolfla.com/download/json/matchFormart.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.dataArray removeAllObjects];
        [self.roundArray removeAllObjects];
        
        self.dataArray = [data objectForKey:_rulesTimeKey];
        
        for (int i=0; i<_ballBaseArray.count; i++) {
            [self.roundArray addObject:self.dataArray[0]];
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
    return _ballBaseArray.count +1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _ballBaseArray.count) {
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

    NSDictionary *contextDict = [self.ballBaseArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"kickOffTime"]];
    }else if (indexPath.row == 1){
        [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"ballName"]];
    }else{
        
        if (self.roundArray.count > 0) {
            [eventRulesContentCell configJGHEventRulesContentCellContext:[self.roundArray[indexPath.section] objectForKey:@"name"]];
        }else{
            if (self.dataArray.count > 0) {
                [eventRulesContentCell configJGHEventRulesContentCellContext:[self.dataArray[0] objectForKey:@"name"]];
            }
        }
    }
    
    return eventRulesContentCell;
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < _ballBaseArray.count) {
        JGHEventRulesHeaderCell *eventRulesHeaderCell = [tableView dequeueReusableCellWithIdentifier:JGHEventRulesHeaderCellIdentifier];
        eventRulesHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        eventRulesHeaderCell.delegate = self;
        eventRulesHeaderCell.saveAndDeleteBtn.tag = 100 + section;
        
        NSInteger saveOrDelete = 0;
        NSDictionary *ballDict = self.ballBaseArray[section];
        saveOrDelete = [[ballDict objectForKey:@"select"] integerValue];
        [eventRulesHeaderCell configJGHEventRulesHeaderCell:section +1 andSelect:saveOrDelete];
        
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
            NSMutableDictionary *dict = [self.ballBaseArray objectAtIndex:indexPath.section];
            [dict setObject:dateString forKey:@"kickOffTime"];
            [self.ballBaseArray replaceObjectAtIndex:indexPath.section withObject:dict];
            
            NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self.gameRoundsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:datePicksCrel animated:YES];
    }else if (indexPath.row == 1) {
        //球场列表
        BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
        [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
            NSLog(@"%@----%ld", balltitle, (long)ballid);
//            self.model.ballKey = [NSNumber numberWithInteger:ballid];
//            self.model.ballName = balltitle;
            NSMutableDictionary *dict = [self.ballBaseArray objectAtIndex:indexPath.section];
            [dict setObject:@(ballid) forKey:@"ballKey"];
            [dict setObject:balltitle forKey:@"ballName"];
            [self.ballBaseArray replaceObjectAtIndex:indexPath.section withObject:dict];
            
            NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self.gameRoundsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self.navigationController pushViewController:ballCtrl animated:YES];
    }
    
    if (indexPath.row == 2) {
        JGHGameRoundsRulesViewController *gameRulesListCtrl = [[JGHGameRoundsRulesViewController alloc]init];
//        NSDictionary *rulesDict = _rulesArray[0][0];
        gameRulesListCtrl.rulesTimeKey = _rulesTimeKey;
        gameRulesListCtrl.roundRulesArray = self.roundArray[indexPath.section];
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
    [baseDict setObject:@"0" forKey:@"select"];//0-保存，1-删除
    [baseDict setObject:_rulesTimeKey forKey:@"matchTypeKey"];//赛事类型key
    [self.ballBaseArray addObject:baseDict];
    
    [self.gameRoundsTableView reloadData];
}
#pragma mark -- 删除或者保存
- (void)didSelectSaveOrDeleteBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    //区分是保存还是删除
    NSInteger selectCatory;
    NSDictionary *ballDict = self.ballBaseArray[btn.tag -100];
    selectCatory = [[ballDict objectForKey:@"select"] integerValue];
    
//    @Param(value = "roundKey"    , require = true )Long roundKey,
//    @Param(value = "userKey"     , require = true )Long userKey,
//    @Param(value = "md5"         , require = true )String md5,
    
//    @Param(value = "matchRound" , require = true ) MatchRound  matchRound,   // 比赛轮次
//    @Param(value = "userKey"    , require = true )Long userKey,
//    @Param(value = "md5"        , require = true )String md5,
    if (selectCatory == 1) {
        //保存
        NSMutableDictionary *paterdict = [NSMutableDictionary dictionary];
        
    }else{
        //删除
        
    }
}
#pragma mark -- 赛制代理
- (void)didGameRoundsRulesViewSaveroundRulesArray:(NSMutableArray *)roundRulesArray{
    self.roundArray = roundRulesArray;
    if (_roundID > self.roundArray.count -1) {
        [self.roundArray addObject:roundRulesArray[0]];
    }else{
        for (int i=0; i<self.roundArray.count; i++) {
            [self.roundArray replaceObjectAtIndex:_roundID withObject:roundRulesArray[0]];
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
