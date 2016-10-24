//
//  JGDCheckScoreViewController.m
//  DagolfLa
//
//  Created by 東 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCheckScoreViewController.h"
#import "JGDCheckScoreTableViewCell.h"
#import "JGDTeamSortViewController.h" // 球队排行

@interface JGDCheckScoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *ballLB;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGDCheckScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队竞赛";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"排名" style:(UIBarButtonItemStyleDone) target:self action:@selector(sortAct)];

    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDCheckScoreTableViewCell class] forCellReuseIdentifier:@"checkScore"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.view addSubview:self.tableView];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * ProportionAdapter)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    
    UIView *lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    lightView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [headView addSubview:lightView];
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 68 * ProportionAdapter, 68 * ProportionAdapter)];
    self.iconView.layer.cornerRadius = 6 * ProportionAdapter;
    self.iconView.clipsToBounds = YES;
    [headView addSubview:self.iconView];
    
    //清缓存
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/match/%@.jpg",self.matchKey];
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
    
    // 再给图片赋值
    [self.iconView sd_setImageWithURL:[Helper setMatchImageIconUrl:[self.matchKey integerValue] ]placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 27 * ProportionAdapter, 280 * ProportionAdapter, 20 * ProportionAdapter)];
    self.titleLB.text = self.matchName;
    self.titleLB.textColor = [UIColor colorWithHexString:@"#313131"];
    self.titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headView addSubview:self.titleLB];
    
    UIImageView *addessImageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 60 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
    addessImageV.image = [UIImage imageNamed:@"address"];
    [headView addSubview:addessImageV];
    
    // 球场名字
    self.ballLB = [[UILabel alloc] initWithFrame:CGRectMake(110 * ProportionAdapter, 60 * ProportionAdapter, 250 * ProportionAdapter, 20 * ProportionAdapter)];
    self.ballLB.text = self.ballName;
    self.ballLB.textColor = [UIColor colorWithHexString:@"#666666"];
    self.ballLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    [headView addSubview:self.ballLB];
    
    [self matchData];
    // Do any additional setup after loading the view.
}


- (void)matchData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:self.matchKey forKey:@"matchKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%@&userKey=%@dagolfla.com", self.matchKey, DEFAULF_USERID]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"match/getMatchCombatList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                self.dataArray = [[data objectForKey:@"list"] mutableCopy];
                [self.tableView reloadData];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

#pragma mark -- 排名

- (void)sortAct{
    
    JGDTeamSortViewController *sortVC = [[JGDTeamSortViewController alloc] init];
    sortVC.matchKey = self.matchKey;
    sortVC.matchName = self.matchName;
    sortVC.ballName = self.ballName;
    [self.navigationController pushViewController:sortVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35 * ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//    UILabel *styleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 10 * ProportionAdapter)];;
//    styleLB.text =@"比赛类型：哈哈哈哈哈哈哈哈哈";
//    styleLB.textAlignment = NSTextAlignmentRight;
//    styleLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
//    styleLB.textColor = [UIColor colorWithHexString:@"#32b14d"];
//    [view addSubview:styleLB];
    UIView *greenLine = [[UIView alloc] initWithFrame:CGRectMake(0, 8 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
    greenLine.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
    [view addSubview:greenLine];
    
    UILabel *numberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 25 * ProportionAdapter)];
    numberLB.textColor = [UIColor colorWithHexString:@"#313131"];
    numberLB.textAlignment = NSTextAlignmentCenter;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[self.dataArray[section] objectForKey:@"round"]];
    
    numberLB.text = [NSString stringWithFormat:@"第%@轮 %@",string, [self.dataArray[section] objectForKey:@"matchformatName"]];
    numberLB.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    numberLB.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:numberLB];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35 * ProportionAdapter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDCheckScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkScore"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.dataArray[indexPath.section] objectForKey:@"combatList"][indexPath.row];
    cell.leftLB.text = [dic objectForKey:@"teamName1"];
    cell.rightLB.text = [dic objectForKey:@"teamName2"];
    
    NSString *teamScore1 = [[dic objectForKey:@"teamScore1"] stringValue];
    NSString *teamScore2 = [[dic objectForKey:@"teamScore2"] stringValue];
    NSMutableAttributedString *scoreString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@", teamScore1, teamScore2]];
    [scoreString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#60c8d4"] range:NSMakeRange(0, [teamScore1 length])];
    [scoreString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange([teamScore1 length] + 1, 1)];
    [scoreString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#dc6b5d"] range:NSMakeRange([teamScore1 length] + 3, [teamScore2 length])];

    cell.scoreLB.attributedText = scoreString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83 * ProportionAdapter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArray[section] objectForKey:@"combatList"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
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
