//
//  JGHEventRoundsRulesViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEventRoundsRulesViewController.h"
#import "JGHEventRulesHeaderCell.h"
#import "JGHEventRulesContentCell.h"
#import "JGHAddEventRoundsBtnCell.h"
#import "JGHGameRoundsRulesViewController.h"
#import "BallParkViewController.h"

static NSString *const JGHEventRulesHeaderCellIdentifier = @"JGHEventRulesHeaderCell";
static NSString *const JGHEventRulesContentCellIdentifier = @"JGHEventRulesContentCell";
static NSString *const JGHAddEventRoundsBtnCellIdentifier = @"JGHAddEventRoundsBtnCell";

@interface JGHEventRoundsRulesViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titltArray;
}

@property (nonatomic, strong)UITableView *gameRoundsRulesTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHEventRoundsRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置比赛轮次";
    _titltArray = @[@"赛制", @"小组赛胜负规则", @"球队排名规则"];
    //
    self.dataArray = [NSMutableArray array];
    
    [self createGameRoundsTableView];
    
    [self getAllRound];
}
- (void)getAllRound{
    //getMatchRoundList
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_matchKey) forKey:@"matchKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    //[JGReturnMD5Str]
    NSString *strMD5 = [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%td&userKey=%tddagolfla.com", _matchKey, [DEFAULF_USERID integerValue]]];
    [dict setObject:strMD5 forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getMatchRoundList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [self.dataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                self.dataArray = [data objectForKey:@"list"];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.gameRoundsRulesTableView reloadData];
    }];
}
- (void)createGameRoundsTableView{
    self.gameRoundsRulesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    UINib *eventRulesNib = [UINib nibWithNibName:@"JGHEventRulesHeaderCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsRulesTableView registerNib:eventRulesNib forCellReuseIdentifier:JGHEventRulesHeaderCellIdentifier];
    
    UINib *eventRulesContentNib = [UINib nibWithNibName:@"JGHEventRulesContentCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsRulesTableView registerNib:eventRulesContentNib forCellReuseIdentifier:JGHEventRulesContentCellIdentifier];
    
    UINib *addEventRoundsNib = [UINib nibWithNibName:@"JGHAddEventRoundsBtnCell" bundle: [NSBundle mainBundle]];
    [self.gameRoundsRulesTableView registerNib:addEventRoundsNib forCellReuseIdentifier:JGHAddEventRoundsBtnCellIdentifier];
    
    self.gameRoundsRulesTableView.dataSource = self;
    self.gameRoundsRulesTableView.delegate = self;
    self.gameRoundsRulesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameRoundsRulesTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    [self.view addSubview:self.gameRoundsRulesTableView];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count +1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGHEventRulesContentCell *eventRulesContentCell = [tableView dequeueReusableCellWithIdentifier:JGHEventRulesContentCellIdentifier];
    eventRulesContentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < _titltArray.count) {
        [eventRulesContentCell configJGHEventRulesContentCellTitle:_titltArray[indexPath.row]];
    }else{
        [eventRulesContentCell configJGHEventRulesContentCellTitle:@""];
    }
    
    /*
    NSDictionary *contextDict = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"matchformatName"]];
    }else if (indexPath.row == 1){
        [eventRulesContentCell configJGHEventRulesContentCellContext:[contextDict objectForKey:@"ballName"]];
    }else{
        
//        if (self.roundArray.count >= indexPath.section +1) {
//            [eventRulesContentCell configJGHEventRulesContentCellContext:[self.roundArray[indexPath.section] objectForKey:@"name"]];
//        }
        //        else{
        //            if (self.dataArray.count > 0) {
        //                [eventRulesContentCell configJGHEventRulesContentCellContext:[self.dataArray[0] objectForKey:@"name"]];
        //            }
        //        }
    }
    */
    return eventRulesContentCell;
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGHEventRulesHeaderCell *eventRulesHeaderCell = [tableView dequeueReusableCellWithIdentifier:JGHEventRulesHeaderCellIdentifier];
    eventRulesHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    eventRulesHeaderCell.saveAndDeleteBtn.hidden = YES;
    eventRulesHeaderCell.saveAndDeleteBtn.userInteractionEnabled = NO;
    [eventRulesHeaderCell configJGHEventRulesHeaderCell:section +1 andSelect:0];
    
    return eventRulesHeaderCell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
