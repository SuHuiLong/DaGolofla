//
//  JGHActivityScoreManagerViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityScoreManagerViewController.h"
#import "JGHActivityMembersViewController.h"
#import "JGHSetAlmostPromptViewController.h"
#import "JGHMatchTranscriptTableViewCell.h"
#import "JGHPlayersScoreTableViewCell.h"
#import "JGHCenterBtnTableViewCell.h"
#import "JGHPublishedPeopleView.h"

static NSString *const JGHMatchTranscriptTableViewCellIdentifier = @"JGHMatchTranscriptTableViewCell";
static NSString *const JGHPlayersScoreTableViewCellIdentifier = @"JGHPlayersScoreTableViewCell";
static NSString *const JGHCenterBtnTableViewCellIdentifier = @"JGHCenterBtnTableViewCell";

@interface JGHActivityScoreManagerViewController ()<UITableViewDelegate, UITableViewDataSource, JGHMatchTranscriptTableViewCellDelegate, JGHCenterBtnTableViewCellDelegate>

@property (nonatomic, strong)UITableView *scoreManageTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHActivityScoreManagerViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"美兰湖球赛";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createTable];    
}

- (void)createTable{
    self.scoreManageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    
    UINib *matchTranscriptNib = [UINib nibWithNibName:@"JGHMatchTranscriptTableViewCell" bundle: [NSBundle mainBundle]];
    [self.scoreManageTableView registerNib:matchTranscriptNib forCellReuseIdentifier:JGHMatchTranscriptTableViewCellIdentifier];
    
    UINib *playersScoreNib = [UINib nibWithNibName:@"JGHPlayersScoreTableViewCell" bundle: [NSBundle mainBundle]];
    [self.scoreManageTableView registerNib:playersScoreNib forCellReuseIdentifier:JGHPlayersScoreTableViewCellIdentifier];
    
    UINib *centerBtnNib = [UINib nibWithNibName:@"JGHCenterBtnTableViewCell" bundle: [NSBundle mainBundle]];
    [self.scoreManageTableView registerNib:centerBtnNib forCellReuseIdentifier:JGHCenterBtnTableViewCellIdentifier];
    
    self.scoreManageTableView.delegate = self;
    self.scoreManageTableView.dataSource = self;
    
    self.scoreManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scoreManageTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.scoreManageTableView];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80 *ProportionAdapter;
    }else{
        return 40 *ProportionAdapter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHMatchTranscriptTableViewCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHMatchTranscriptTableViewCellIdentifier];
        tranCell.delegate = self;
        return tranCell;
    }else if (indexPath.section == 3){
        JGHCenterBtnTableViewCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHCenterBtnTableViewCellIdentifier];
        centerBtnCell.delegate = self;
        return centerBtnCell;
    }else{
        JGHPlayersScoreTableViewCell *playersScoreCell = [tableView dequeueReusableCellWithIdentifier:JGHPlayersScoreTableViewCellIdentifier];
        return playersScoreCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 2*ProportionAdapter;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 2*ProportionAdapter)];
        view.backgroundColor = [UIColor colorWithHexString:@"#3AB152"];
        return view;
    }else{
        return nil;
    }
}
#pragma mark -- 添加记录
- (void)addScoreRecord{
    JGHActivityMembersViewController *friendCtrl = [[JGHActivityMembersViewController alloc]init];
    [self.navigationController pushViewController:friendCtrl animated:YES];
}
#pragma mark -- 设置差点
- (void)selectSetAlmostBtn{
    NSLog(@"设置差点");
    JGHSetAlmostPromptViewController *setAlmostCtrl = [[JGHSetAlmostPromptViewController alloc]initWithNibName:@"JGHSetAlmostPromptViewController" bundle:nil];
    [self.navigationController pushViewController:setAlmostCtrl animated:YES];
}
#pragma mark -- 保存
- (void)saveBtnClick{
    NSLog(@"保存");
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
