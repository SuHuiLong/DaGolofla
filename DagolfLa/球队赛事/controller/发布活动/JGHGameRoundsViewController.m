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
    
    self.dataArray = [NSMutableArray array];
    self.ballBaseArray = [NSMutableArray array];
    
    if (!self.roundArray) {
        self.roundArray = [NSMutableArray array];
    }
    
    if (self.ballBaseArray.count == 0) {
        //添加默认信息
        NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
        [baseDict setObject:@"" forKey:@"kickOffTime"];
        [baseDict setObject:@"" forKey:@"ballKey"];
        [baseDict setObject:@"" forKey:@"ballName"];
        [baseDict setObject:@"0" forKey:@"select"];//0-保存，1-删除
        [baseDict setObject:_rulesTimeKey forKey:@"matchTypeKey"];//赛事类型key
        [self.ballBaseArray addObject:baseDict];
    }
    
    [self createGameRoundsTableView];
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
        
        if (self.roundArray.count >= indexPath.section +1) {
            [eventRulesContentCell configJGHEventRulesContentCellContext:[self.roundArray[indexPath.section] objectForKey:@"name"]];
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
            if (dateString.length == 16) {
                [dict setObject:[NSString stringWithFormat:@"%@:00", dateString] forKey:@"kickOffTime"];
            }else{
                [dict setObject:dateString forKey:@"kickOffTime"];
            }
            
            [self.ballBaseArray replaceObjectAtIndex:indexPath.section withObject:dict];
            
            NSIndexPath *indPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self.gameRoundsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:datePicksCrel animated:YES];
    }
    
    if (indexPath.row == 1) {
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
    
    if ([[ballDict objectForKey:@"kickOffTime"]isEqualToString:@""]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择开球时间！" FromView:self.view];
        return;
    }
    
    if ([[ballDict objectForKey:@"ballName"]isEqualToString:@""]) {
        [[ShowHUD showHUD]showToastWithText:@"请选择球场！" FromView:self.view];
        return;
    }
    
    if (self.roundArray.count > btn.tag -100 +1) {
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
                [self.dataArray insertObject:[data objectForKey:@"timeKey"] atIndex:btn.tag -100];
                [ballDict setValue:@1 forKey:@"select"];
                [self.ballBaseArray replaceObjectAtIndex:btn.tag -100 withObject:ballDict];
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
                [_ballBaseArray removeObjectAtIndex:btn.tag -100];
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
//    self.roundArray = roundRulesArray;
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
