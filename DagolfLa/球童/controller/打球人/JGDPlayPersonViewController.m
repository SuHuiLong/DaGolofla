
//
//  JGDPlayPersonViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPlayPersonViewController.h"
#import "JGDPlayPersoningTableViewCell.h"
#import "JGDPlayPersonTableViewCell.h"

#import "JGDHistoryScoreViewController.h"
#import "JGDPlayerHisScoreCardViewController.h" // 活动记分
#import "JGDNotActScoreViewController.h" // 非活动记分

#import "JGDPlayerQRCodeViewController.h" // 我的二维码
#import "JGDResultViewController.h" // 扫描结果

#import "JGDPlayerModel.h"

#import "JGHCabbieCertViewController.h"
#import "JGDPlayerScanViewController.h"

@interface JGDPlayPersonViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *footView;

@end

@implementation JGDPlayPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球童记分";

    [self setData];

    [self createTable];
    // Do any additional setup after loading the view.
}

- (void)setData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getUserCaddieRecordHome" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGDPlayerModel *model =[[JGDPlayerModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }else{
                self.tipLabel.hidden = YES;
                self.tableView.tableFooterView.hidden = YES;
                self.footView.hidden = YES;
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 200 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
                imageV.image = [UIImage imageNamed:@"bg-shy"];
                [self.view addSubview:imageV];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, screenWidth, 30 * ProportionAdapter)];
                label.text = @"您还没有球童记分记录哦";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
                label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
                [self.view addSubview:label];
                
                UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 370 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter)];
                detailLB.text = @"扫描球童二维码，可指定球童为您记分，记分完成后，成绩自动存入您的历史记分卡中。";
                detailLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
                detailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
                detailLB.numberOfLines = 0;
                [self.view addSubview:detailLB];
                
                UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"我是球童" style:UIBarButtonItemStyleDone target:self action:@selector(ballBoy)];
                rightBtn.tintColor = [UIColor whiteColor];
                self.navigationItem.rightBarButtonItem = rightBtn;
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];

}


#pragma mark --- 我是球童  － 球童认证

- (void)ballBoy{
    JGHCabbieCertViewController *cabVC = [[JGHCabbieCertViewController alloc] init];
    [self.navigationController pushViewController:cabVC animated:YES];
}

#pragma mark ----- 创建 tableView

- (void)createTable{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDPlayPersoningTableViewCell class] forCellReuseIdentifier:@"JGDPlayPersoningTableViewCell"];
    [self.tableView registerClass:[JGDPlayPersonTableViewCell class] forCellReuseIdentifier:@"JGDPlayPersonTableViewCell"];
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 50 * ProportionAdapter;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 200 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIView *topViewFir = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth , 120 * ProportionAdapter)];
    topViewFir.backgroundColor = [UIColor whiteColor];
    UIView *topViewSec = [[UIView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 1 * ProportionAdapter, 10 * ProportionAdapter, 2 * ProportionAdapter, 100 * ProportionAdapter)];
    topViewSec.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIButton *erweimaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [erweimaBtn setImage:[UIImage imageNamed:@"erweima"] forState:(UIControlStateNormal)];
    erweimaBtn.frame = CGRectMake(screenWidth / 2 + 73 * ProportionAdapter, 25 * ProportionAdapter, 40 * ProportionAdapter, 40 * ProportionAdapter);
    [erweimaBtn addTarget:self action:@selector(qrCodeAct) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *saomaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [saomaBtn setImage:[UIImage imageNamed:@"saoma"] forState:(UIControlStateNormal)];
    saomaBtn.frame = CGRectMake(71 * ProportionAdapter, 25 * ProportionAdapter, 40 * ProportionAdapter, 40 * ProportionAdapter);
    [saomaBtn addTarget:self action:@selector(scanAct) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *labelerweima = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 2 + 2 * ProportionAdapter, 80 * ProportionAdapter, screenWidth / 2, 30)];
    labelerweima.text = @"我的二维码";
    labelerweima.textAlignment = NSTextAlignmentCenter;
    labelerweima.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    labelerweima.textColor = [UIColor colorWithHexString:@"#313131"];
    
    UILabel *labelSaomiao = [[UILabel alloc] initWithFrame:CGRectMake(0, 80 * ProportionAdapter, screenWidth / 2, 30)];
    labelSaomiao.text = @"指定记分球童";
    labelSaomiao.textAlignment = NSTextAlignmentCenter;
    labelSaomiao.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    labelSaomiao.textColor = [UIColor colorWithHexString:@"#313131"];
    
    [topViewFir addSubview:topViewSec];
    
    [topViewFir addSubview:labelerweima];
    [topViewFir addSubview:labelSaomiao];
    
    [topViewFir addSubview:saomaBtn];
    [topViewFir addSubview:erweimaBtn];
    
    [headerView addSubview:topViewFir];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 140 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 37 * ProportionAdapter)];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.text = @"扫描球童的二维码，客户可指定球童为其记分，记分完成后，成绩自动存入您的历史记分卡中。";
    self.tipLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
    [headerView addSubview:self.tipLabel];
    
    self.tableView.tableHeaderView = headerView;
    
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 500 * ProportionAdapter, screenWidth, 60 * screenWidth / 320)];
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * screenWidth / 320, 10 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 44 * screenWidth / 320)];
    footBtn.clipsToBounds = YES;
    footBtn.layer.cornerRadius = 6.f;
    [self.footView addSubview:footBtn];
    [footBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    footBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [footBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDPlayerModel *model = self.dataArray[indexPath.section];
    if ([model.scoreFinish integerValue] == 1) {

        JGDHistoryScoreViewController *hisVC = [[JGDHistoryScoreViewController alloc] init];
        [self.navigationController pushViewController:hisVC animated:YES];
        
    }else{
//        JGDPlayPersoningTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        [cell.checkBtn addTarget:self action:@selector(checkAct:) forControlEvents:(UIControlEventTouchUpInside)];
//        cell.tag = indexPath.section;
    }
}

- (void)checkAct:(UIButton *)btn{
    JGDPlayerModel *model = self.dataArray[btn.tag];
    if ([model.srcType integerValue] == 1) {
        JGDPlayerHisScoreCardViewController *DPHVC = [[JGDPlayerHisScoreCardViewController alloc] init];
        DPHVC.timeKey = model.timeKey;
        [self.navigationController pushViewController:DPHVC animated:YES];
    }else{
        JGDNotActScoreViewController *noActVC = [[JGDNotActScoreViewController alloc] init];
        noActVC.timeKey = model.timeKey;
        [self.navigationController pushViewController:noActVC animated:YES];
    }
}

#pragma mark ------- 我的二维码

- (void)qrCodeAct{
    JGDPlayerQRCodeViewController *codeVC = [[JGDPlayerQRCodeViewController alloc] init];
    [self.navigationController pushViewController:codeVC animated:YES];
}

- (void)scanAct{
    JGDPlayerScanViewController *scanVC = [[JGDPlayerScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
//    JGDResultViewController *resultVC = [[JGDResultViewController alloc] init];
//    [self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark ---查看更多

- (void)checkBtnClick:(UIButton *)btn{
    JGDHistoryScoreViewController *hisVC = [[JGDHistoryScoreViewController alloc] init];
    [self.navigationController pushViewController:hisVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5 * ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    JGDPlayerModel *model = self.dataArray[indexPath.section];
    
    if ([model.scoreFinish integerValue] == 1) {
        JGDPlayPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDPlayPersonTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"球童 %@ 已完成记分并推送到您的 历史记分卡", model.scoreUserName]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(str.length - 5, 5)];
        cell.textLB.attributedText = str;
        return cell;
    }else{
        JGDPlayPersoningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGDPlayPersoningTableViewCell"];
        cell.titleLabel.text = [NSString stringWithFormat:@"球童 %@ 正在为您记分", model.scoreUserName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.checkBtn addTarget:self action:@selector(checkAct:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.tag = indexPath.section;
        return cell;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
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
