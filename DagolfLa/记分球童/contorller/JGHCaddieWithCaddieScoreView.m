//
//  JGHCaddieWithCaddieScoreView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCaddieWithCaddieScoreView.h"
#import "JGLCaddieScoreTableViewCell.h"


@interface JGHCaddieWithCaddieScoreView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* _dataArray;
    NSInteger _page;
    //    NSString* _qCodeId;
    NSString* _qcodeUserName,* _qcodeUserMobile;//被扫码客户的用户名,手机号
    NSNumber* _qcodeUserKey;
    
    UIView *_footerView;
    UIButton *_footerFinishBtn;//点击完成的按钮和存放按钮的视图
    NSInteger _isHaveData;
}
@property (nonatomic ,strong) UILabel *tipLabel;

@property (nonatomic, strong)  NSTimer * timer;


@end

@implementation JGHCaddieWithCaddieScoreView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _dataArray = [[NSMutableArray alloc]init];
        _page = 0;
        _isHaveData = 1;
        
        //监听分组页面返回，刷新数据
//        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
//        [center addObserver:self selector:@selector(reloadCaddieScoreData) name:@"reloadCaddieScoreData" object:nil];
        
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
//        item.tintColor=[UIColor whiteColor];
//        self.navigationItem.leftBarButtonItem = item;
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 44, 44);
//        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
//        [btn setImage:[UIImage imageNamed:@"cabbArwed"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(pushRewardCtrl:) forControlEvents:UIControlEventTouchUpInside];
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//        self.navigationItem.rightBarButtonItem = rightItem;
        
        [self createTable];
        
        [self setData];
    }
    return self;
}

#pragma mark --通知调用－－刷新数据
- (void)reloadCaddieScoreData{
    [self headRereshing];
}

//-(void)backButtonClcik
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark -- 奖励
//- (void)pushRewardCtrl:(UIButton *)btn{
//    JGHCabbieRewardViewController *cabbieRewardCtrl = [[JGHCabbieRewardViewController alloc]init];
//    [self.navigationController pushViewController:cabbieRewardCtrl animated:YES];
//}


#pragma mark ----- 创建 tableView

- (void)createTable{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGLCaddieScoreTableViewCell class] forCellReuseIdentifier:@"JGLCaddieScoreTableViewCell"];
    //    [self.tableView registerClass:[JGDPlayPersonTableViewCell class] forCellReuseIdentifier:@"JGDPlayPersonTableViewCell"];
    self.tableView.rowHeight = 50 * ProportionAdapter;
    [self addSubview:self.tableView];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 200 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIView *topViewFir = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth , 120 * ProportionAdapter)];
    topViewFir.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 10 * ProportionAdapter, screenWidth/2, 200 * ProportionAdapter);
    [btn1 addTarget:self action:@selector(saomaClick:) forControlEvents:UIControlEventTouchUpInside];
    [topViewFir addSubview:btn1];
    
    UIView *topViewSec = [[UIView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 1 * ProportionAdapter, 10 * ProportionAdapter, 2 * ProportionAdapter, 100 * ProportionAdapter)];
    topViewSec.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(screenWidth / 2 - 1 * ProportionAdapter, 10 * ProportionAdapter, screenWidth/2, 100 * ProportionAdapter);
    [btn2 addTarget:self action:@selector(erweimaClick:) forControlEvents:UIControlEventTouchUpInside];
    [topViewFir addSubview:btn2];
    
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
    self.tipLabel.text = @"球童扫描客户二维码，可代替客户记分，记分完成后，成绩自动存入客户历史记分卡中。";
    self.tipLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
    [headerView addSubview:self.tipLabel];
    
    self.tableView.tableHeaderView = headerView;
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 500 * ProportionAdapter, screenWidth, 60 * screenWidth / 320)];
    _footerFinishBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * screenWidth / 320, 10 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 44 * screenWidth / 320)];
    _footerFinishBtn.clipsToBounds = YES;
    _footerFinishBtn.layer.cornerRadius = 6.f;
    [_footerView addSubview:_footerFinishBtn];
    [_footerFinishBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    _footerFinishBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [_footerFinishBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_footerView];
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
        }
    } completionBlock:^(id data) {
        if ([data objectForKey:@"packSuccess"]) {
            //清除数组数据
            [_dataArray removeAllObjects];
            
            if ([data objectForKey:@"list"]) {
                _footerView.hidden = NO;
                _footerFinishBtn.hidden = NO;
                self.tipLabel.hidden = NO;
                self.tableView.tableFooterView.hidden = NO;
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGLCaddieModel *model = [[JGLCaddieModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [_dataArray addObjectsFromArray:[data objectForKey:@"teamSignUpList"]];
                _page++;
                _isHaveData = 2;
                [self setData];
                
            }
            else{
                _footerView.hidden = YES;
                _footerFinishBtn.hidden = YES;
                self.tipLabel.hidden = YES;
                self.tableView.tableFooterView.hidden = YES;
                _isHaveData = 1;
                [self setData];
                
            }
            [_tableView reloadData];
        }else {
            
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    }];
}

-(void)setData{
    if (_isHaveData == 1) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 200 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
        imageV.image = [UIImage imageNamed:@"bg-shy"];
        imageV.tag = 1001;
        [_tableView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, screenWidth, 30 * ProportionAdapter)];
        label.text = @"您还没有替客户记录的记分哦";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        [_tableView addSubview:label];
        label.tag = 1002;
        
        UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 370 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter)];
        detailLB.text = @"球童扫描客户二维码，可代替客户记分，记分完成后，成绩自动存入客户历史记分卡中。";
        detailLB.tag = 1003;
        detailLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        detailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        detailLB.numberOfLines = 0;
        [_tableView addSubview:detailLB];
    }
    else{
        
        for (UIImageView* img in _tableView.subviews) {
            if (img.tag == 1001) {
                [img removeFromSuperview];
            }
        }
        for (UILabel* label in _tableView.subviews) {
            if (label.tag == 1002 || label.tag == 1003) {
                [label removeFromSuperview];
            }
        }
    }
}

#pragma mark --扫码或二维码点击事件
-(void)erweimaClick:(UIButton *)btn
{
    _blockCaddieErweimaClick();
//    JGDPlayerQRCodeViewController* barVc = [[JGDPlayerQRCodeViewController alloc]init];
//    [self.navigationController pushViewController:barVc animated:YES];
}
//扫码
-(void)saomaClick:(UIButton *)btn
{
    _blockCaddieSaomaClick();
    /*
    JGLAddClientViewController* addVc = [[JGLAddClientViewController alloc]init];
    //    addVc.blockData = ^(NSString* numQId){
    //        _qCodeId = numQId;
    //        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loopAct) userInfo:nil repeats:YES];
    //        [self.timer fire];
    //    };
    addVc.isCaddie = _isCaddie;
    [self.navigationController pushViewController:addVc animated:YES];
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ---查看更多
- (void)checkBtnClick:(UIButton *)btn{
//    JGDHistoryScoreViewController *hisVC = [[JGDHistoryScoreViewController alloc] init];
//    [self.navigationController pushViewController:hisVC animated:YES];
    _blockCaddieMoreScore();
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
    [cell showData:_dataArray[indexPath.section]];
    //    if ([[_dataArray[indexPath.section] scoreFinish] integerValue] == 0) {
    //        [cell.checkBtn addTarget:self action:@selector(continueClick:) forControlEvents:UIControlEventTouchUpInside];
    //        cell.checkBtn.tag = 1000 + indexPath.section;
    //    }
    ////    else if ([[_dataArray[indexPath.section] scoreFinish] integerValue] == 1)
    //    else
    //    {
    [cell.checkBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkBtn.tag = 1000 + indexPath.section;
    //    }
    
    return cell;
    
}

-(void)continueClick:(UIButton *)btn
{
    
}

-(void)finishClick:(UIButton *)btn
{
    JGLCaddieModel *model = [[JGLCaddieModel alloc]init];
    model = _dataArray[btn.tag - 1000];
    _blockCaddieContinueScore(model);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
