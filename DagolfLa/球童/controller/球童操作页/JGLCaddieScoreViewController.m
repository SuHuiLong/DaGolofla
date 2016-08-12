
//
//  JGDPlayPersonViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCaddieScoreViewController.h"
#import "JGLCaddieScoreTableViewCell.h"
//#import "JGDPlayPersoningTableViewCell.h"
//#import "JGDPlayPersonTableViewCell.h"

#import "JGDHistoryScoreViewController.h"
#import "JGDPlayerHisScoreCardViewController.h" // 活动记分

#import "JGLAddClientViewController.h"
#import "JGMyBarCodeViewController.h"

#import "JGLCaddieModel.h"
@interface JGLCaddieScoreViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *tipLabel;

@end

@implementation JGLCaddieScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球童记分";
    _dataArray = [[NSMutableArray alloc]init];
    _page = 0;
    [self createTable];
    //    [self setData];
    // Do any additional setup after loading the view.
}

- (void)setData{
    if (1) {
        self.tipLabel.hidden = YES;
        self.tableView.tableFooterView.hidden = YES;
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
    }
}

#pragma mark ----- 创建 tableView

- (void)createTable{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGLCaddieScoreTableViewCell class] forCellReuseIdentifier:@"JGLCaddieScoreTableViewCell"];
//    [self.tableView registerClass:[JGDPlayPersonTableViewCell class] forCellReuseIdentifier:@"JGDPlayPersonTableViewCell"];
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 50 * ProportionAdapter;
    [self.view addSubview:self.tableView];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 200 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIView *topViewFir = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth , 120 * ProportionAdapter)];
    topViewFir.backgroundColor = [UIColor whiteColor];
    UIView *topViewSec = [[UIView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 1 * ProportionAdapter, 10 * ProportionAdapter, 2 * ProportionAdapter, 100 * ProportionAdapter)];
    topViewSec.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIButton *erweimaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [erweimaBtn setImage:[UIImage imageNamed:@"erweima"] forState:(UIControlStateNormal)];
    erweimaBtn.frame = CGRectMake(screenWidth / 2 + 73 * ProportionAdapter, 25 * ProportionAdapter, 40 * ProportionAdapter, 40 * ProportionAdapter);
    [erweimaBtn addTarget:self action:@selector(erweimaClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *saomaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [saomaBtn setImage:[UIImage imageNamed:@"saoma"] forState:(UIControlStateNormal)];
    saomaBtn.frame = CGRectMake(71 * ProportionAdapter, 25 * ProportionAdapter, 40 * ProportionAdapter, 40 * ProportionAdapter);
    [saomaBtn addTarget:self action:@selector(saomaClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelerweima = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 2 + 2 * ProportionAdapter, 80 * ProportionAdapter, screenWidth / 2, 30)];
    labelerweima.text = @"我的二维码";
    labelerweima.textAlignment = NSTextAlignmentCenter;
    labelerweima.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    labelerweima.textColor = [UIColor colorWithHexString:@"#313131"];
    
    UILabel *labelSaomiao = [[UILabel alloc] initWithFrame:CGRectMake(0, 80 * ProportionAdapter, screenWidth / 2, 30)];
    labelSaomiao.text = @"添加记分客户";
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
    self.tipLabel.text = @"扫描球童二维码，可指定球童为您记分，记分完成后，成绩自动存入您的历史记分卡中。";
    self.tipLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
    [headerView addSubview:self.tipLabel];
    
    self.tableView.tableHeaderView = headerView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 500 * ProportionAdapter, screenWidth, 60 * screenWidth / 320)];
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * screenWidth / 320, 10 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 44 * screenWidth / 320)];
    footBtn.clipsToBounds = YES;
    footBtn.layer.cornerRadius = 6.f;
    [footView addSubview:footBtn];
    [footBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    footBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [footBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footView];
}

// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString* strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com",DEFAULF_USERID]];
    [dict setObject:strMd forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getCaddieRecord" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([data objectForKey:@"packSuccess"]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in [data objectForKey:@"list"]) {
                JGLCaddieModel *model = [[JGLCaddieModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [_dataArray addObjectsFromArray:[data objectForKey:@"teamSignUpList"]];
            _page++;
            [_tableView reloadData];
        }else {
            
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}






#pragma mark --扫码或二维码点击事件

-(void)erweimaClick:(UIButton *)btn
{
    JGMyBarCodeViewController* barVc = [[JGMyBarCodeViewController alloc]init];
    [self.navigationController pushViewController:barVc animated:YES];
}
-(void)saomaClick:(UIButton *)btn
{
    JGLAddClientViewController* addVc = [[JGLAddClientViewController alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDPlayerHisScoreCardViewController *DPHVC = [[JGDPlayerHisScoreCardViewController alloc] init];
    [self.navigationController pushViewController:DPHVC animated:YES];
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
    JGLCaddieScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGLCaddieScoreTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showData:_dataArray[indexPath.row]];
    if ([[_dataArray[indexPath.row] scoreFinish] integerValue] == 0) {
        [cell.checkBtn addTarget:self action:@selector(continueClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([[_dataArray[indexPath.row] scoreFinish] integerValue] == 1)
    {
        [cell.checkBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        
    }
    return cell;
    
}

-(void)continueClick
{
    
}

-(void)finishClick
{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
