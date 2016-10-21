//
//  JGDTeamSortViewController.m
//  DagolfLa
//
//  Created by 東 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDTeamSortViewController.h"
#import "JGDSortTableViewCell.h"

@interface JGDTeamSortViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *ballLB;


@end

@implementation JGDTeamSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队排行";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JGDSortTableViewCell class] forCellReuseIdentifier:@"checkScore"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 140 * ProportionAdapter)];
    headView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headView;
    
    UIView *lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    lightView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [headView addSubview:lightView];
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, 68 * ProportionAdapter, 68 * ProportionAdapter)];
    self.iconView.backgroundColor = [UIColor orangeColor];
    [headView addSubview:self.iconView];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 27 * ProportionAdapter, 280 * ProportionAdapter, 20 * ProportionAdapter)];
    self.titleLB.text = @"第一高尔夫球队活动";
    self.titleLB.textColor = [UIColor colorWithHexString:@"#313131"];
    self.titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [headView addSubview:self.titleLB];
    
    UIImageView *addessImageV = [[UIImageView alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, 62 * ProportionAdapter, 10 * ProportionAdapter, 15 * ProportionAdapter)];
    addessImageV.image = [UIImage imageNamed:@"address"];
    [headView addSubview:addessImageV];
    
    // 球场名字
    self.ballLB = [[UILabel alloc] initWithFrame:CGRectMake(110 * ProportionAdapter, 60 * ProportionAdapter, 250 * ProportionAdapter, 20 * ProportionAdapter)];
    self.ballLB.text = @"上海汤臣高尔夫球场（整修中）";
    self.ballLB.textColor = [UIColor colorWithHexString:@"#666666"];
    self.ballLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    [headView addSubview:self.ballLB];
    
    UIView *lightV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
    lightV2.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [headView addSubview:lightV2];
    
    UIView *greenVie = [[UIView alloc] initWithFrame:CGRectMake(0, 128 * ProportionAdapter, screenWidth, 2 * ProportionAdapter)];
    greenVie.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
    [headView addSubview:greenVie];
    
    UILabel *matchLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 100 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 20 * ProportionAdapter)];
    matchLB.text = @"队际比杆积分赛";
    matchLB.textColor = [UIColor colorWithHexString:@"#32b14d"];
    matchLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    [headView addSubview:matchLB];

    [self downLoadData];
    
    // Do any additional setup after loading the view.

}



- (void)downLoadData{
 
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.matchKey forKey:@"matchKey"];
    NSString *md5String = [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%@dagplfla.com", self.matchKey]];
    [dic setObject:md5String forKey:@"md5"];
    [[JsonHttp jsonHttp] httpRequest:@"match/getMatchTeamRankingList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
    }];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30 * ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *styleLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 3 * ProportionAdapter, 100 * ProportionAdapter, 15 * ProportionAdapter)];
    styleLB.text =@"排名";
//    styleLB.textAlignment = NSTextAlignmentCenter;
    styleLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    styleLB.textColor = [UIColor lightGrayColor];
    [view addSubview:styleLB];
    
    UILabel *styleLB2 = [[UILabel alloc] initWithFrame:CGRectMake(100 * ProportionAdapter, 3 * ProportionAdapter, 100 * ProportionAdapter, 15 * ProportionAdapter)];
    styleLB2.text =@"参赛球队";
    styleLB2.textAlignment = NSTextAlignmentCenter;
    styleLB2.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    styleLB2.textColor = [UIColor lightGrayColor];
    [view addSubview:styleLB2];
    
    
    
    UILabel *styleLB3 = [[UILabel alloc] initWithFrame:CGRectMake(230 * ProportionAdapter, 3 * ProportionAdapter, 50 * ProportionAdapter, 15 * ProportionAdapter)];
    styleLB3.text =@"杆数";
    styleLB3.textAlignment = NSTextAlignmentCenter;
    styleLB3.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    styleLB3.textColor = [UIColor lightGrayColor];
    [view addSubview:styleLB3];
    
    
    UILabel *styleLB4 = [[UILabel alloc] initWithFrame:CGRectMake(290 * ProportionAdapter, 3 * ProportionAdapter, 50 * ProportionAdapter, 15 * ProportionAdapter)];
    styleLB4.text =@"得分";
    styleLB4.textAlignment = NSTextAlignmentCenter;
    styleLB4.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    styleLB4.textColor = [UIColor lightGrayColor];
    [view addSubview:styleLB4];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30 * ProportionAdapter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkScore"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.numberLB.text = [NSString stringWithFormat:@"%td", indexPath.row];
    if (indexPath.row < 3) {
        cell.numberLB.backgroundColor = [UIColor colorWithHexString:@"#4393d6"];
        cell.numberLB.textColor = [UIColor whiteColor];
    }

    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * ProportionAdapter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
