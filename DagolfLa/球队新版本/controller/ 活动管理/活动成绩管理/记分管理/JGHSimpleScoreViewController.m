//
//  JGHSimpleScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSimpleScoreViewController.h"
#import "JGHSimpleScorePepoleBaseCell.h"
#import "JGHSimpleAndResultsCell.h"
#import "JGHOperationSimlpeCell.h"
#import "JGHSetBallBaseCell.h"
#import "JGHOperationScoreCell.h"
#import "JGHScoreCalculateCell.h"

static NSString *const JGHSimpleScorePepoleBaseCellIdentifier = @"JGHSimpleScorePepoleBaseCell";
static NSString *const JGHSimpleAndResultsCellIdentifier = @"JGHSimpleAndResultsCell";
static NSString *const JGHOperationSimlpeCellIdentifier = @"JGHOperationSimlpeCell";
static NSString *const JGHSetBallBaseCellIdentifier = @"JGHSetBallBaseCell";
static NSString *const JGHOperationScoreCellIdentifier = @"JGHOperationScoreCell";
//static NSString *const JGHScoreCalculateCellIdentifier = @"JGHScoreCalculateCell";

@interface JGHSimpleScoreViewController ()<UITableViewDelegate, UITableViewDataSource, JGHSimpleAndResultsCellDelegate, JGHSetBallBaseCellDelegate, JGHOperationSimlpeCellDelegate, JGHScoreCalculateCellDelegate>
{
    NSInteger _selectId;//0-简单记分；1-十八洞开始记分；2-记分；3-记分列表页
}

@property (nonatomic, strong)UITableView *simpleScoreTableView;

@end

@implementation JGHSimpleScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加记分";
    _selectId = 0;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createTable];
}

- (void)createTable{
    self.simpleScoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    
    UINib *simpleScorePepoleNib = [UINib nibWithNibName:@"JGHSimpleScorePepoleBaseCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:simpleScorePepoleNib forCellReuseIdentifier:JGHSimpleScorePepoleBaseCellIdentifier];
    
    UINib *simpleAndResultsNib = [UINib nibWithNibName:@"JGHSimpleAndResultsCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:simpleAndResultsNib forCellReuseIdentifier:JGHSimpleAndResultsCellIdentifier];
    
    UINib *operationSimlpeNib = [UINib nibWithNibName:@"JGHOperationSimlpeCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:operationSimlpeNib forCellReuseIdentifier:JGHOperationSimlpeCellIdentifier];
    
    UINib *setBallBaseCellNib = [UINib nibWithNibName:@"JGHSetBallBaseCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:setBallBaseCellNib forCellReuseIdentifier:JGHSetBallBaseCellIdentifier];
    
    UINib *operationScoreCellNib = [UINib nibWithNibName:@"JGHOperationScoreCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:operationScoreCellNib forCellReuseIdentifier:JGHOperationScoreCellIdentifier];
    
    [self.simpleScoreTableView registerClass:[JGHScoreCalculateCell class] forCellReuseIdentifier:@"JGHScoreCalculateCell"];
    
    self.simpleScoreTableView.delegate = self;
    self.simpleScoreTableView.dataSource = self;
    
    self.simpleScoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.simpleScoreTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.simpleScoreTableView];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60 *ProportionAdapter;
    }else if (indexPath.section == 1) {
        return 50 *ProportionAdapter;
    }else{
        if (_selectId == 0) {
            return 310 *ProportionAdapter;
        }else if (_selectId == 1){
            return 280 *ProportionAdapter;
        }else{
            return screenWidth;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHSimpleScorePepoleBaseCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHSimpleScorePepoleBaseCellIdentifier];
        return tranCell;
    }else if (indexPath.section == 1) {
        JGHSimpleAndResultsCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHSimpleAndResultsCellIdentifier];
        centerBtnCell.delegate = self;
        [centerBtnCell configUIBtn:_selectId];
        return centerBtnCell;
    }else {
        if (_selectId == 0) {
            JGHOperationSimlpeCell *operationSimlpeCell = [tableView dequeueReusableCellWithIdentifier:JGHOperationSimlpeCellIdentifier];
            operationSimlpeCell.delegate = self;
            return operationSimlpeCell;
        }else if (_selectId == 1){
            JGHSetBallBaseCell *setBallBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHSetBallBaseCellIdentifier];
            setBallBaseCell.delegate = self;
            return setBallBaseCell;
        }else{
            JGHScoreCalculateCell *scoreCalculateCell = [tableView dequeueReusableCellWithIdentifier:@"JGHScoreCalculateCell" forIndexPath:indexPath];
            scoreCalculateCell.delegate = self;
            scoreCalculateCell.backgroundColor = [UIColor redColor];
            scoreCalculateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return scoreCalculateCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}
#pragma mark -- 简单记分 ＋
- (void)addRodBtn{
    NSLog(@"简单记分 ＋");
}
#pragma mark -- 简单记分 －
- (void)redRodBtn{
    NSLog(@"简单记分 －");
}
#pragma mark -- 第一九洞
- (void)oneAndNineBtn{
    NSLog(@"第一九洞");
}
#pragma mark -- 第二九洞
- (void)twoAndNineBtn{
    NSLog(@"第二九洞");
}
#pragma mark -- 开始录入
- (void)startScoreBtn{
    NSLog(@"开始录入");
    _selectId = 2;
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 简单记分
- (void)selectSimpleScoreBtnClick:(UIButton *)btn{
    NSLog(@"简单记分");
    _selectId = 0;
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 十八洞记分
- (void)selectHoleScoreBtnClick:(UIButton *)btn{
    NSLog(@"十八洞记分");
    _selectId = 1;
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 十八洞记分 ＋
- (void)selectAddOperationBtn{
    NSLog(@"十八洞记分 ＋");
}
#pragma mark -- 十八洞记分 －
- (void)selectRedOperationBtn{
    NSLog(@"十八洞记分 －");
}
#pragma mark -- 十八洞记分 list
- (void)selectScoreListBtn{
    NSLog(@"十八洞记分 list");
    _selectId = 3;
    
}
#pragma mark -- 完成
- (void)saveBtnClick{
    NSLog(@"完成");
    [self.simpleScoreTableView reloadData];
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
