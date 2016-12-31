//
//  JGHCaddieScoreListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCaddieWithPalyerScoreView.h"
#import "JGDPlayPersoningTableViewCell.h"
#import "JGDPlayPersonTableViewCell.h"
#import "JGDPlayerModel.h"
#import "JGDPlayerQRCodeViewController.h"

@interface JGHCaddieWithPalyerScoreView ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, assign) NSInteger throw;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImageView *shadeView;

@end

@implementation JGHCaddieWithPalyerScoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self setData];
        [self createTable];
    }
    return self;
}

#pragma mark -- 扫码返回－我的二维码返回
- (void)blackQRcodeName:(NSString *)name andThrow:(NSInteger)sourethrow{
    self.name = name;
    self.throw = sourethrow;
    
    if (self.throw == 10) {
        self.throw = 0;
        
        if (self.shadeView) {
            [self addSubview:self.shadeView];
        }else{
            self.shadeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100 * ProportionAdapter, screenWidth, screenHeight - 150 * ProportionAdapter)];
            self.shadeView.image = [UIImage imageNamed:@"bg_somiaohou_03"];
            self.shadeView.userInteractionEnabled = YES;
            [self addSubview:self.shadeView];
            UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
            [self.shadeView addGestureRecognizer:tapGest];
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 80 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
            iconImage.image = [UIImage imageNamed:@"happy_saomiaohou"];
            [self.shadeView addSubview:iconImage];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
            NSMutableAttributedString *lbStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"指定球童 %@ 成功！", self.name]];
            label.textColor = [UIColor colorWithHexString:@"#eeeeee"];
            [lbStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b14d"] range:NSMakeRange(5, lbStr.length - 8)];
            label.attributedText = lbStr;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20 * ProportionAdapter];
            [self.shadeView addSubview:label];
            
            UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 250 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter)];
            detailLB.text = [NSString stringWithFormat:@"球童%@正在为您做记分准备， 稍后下滑屏幕可同步查看记分。", self.name];
            detailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            detailLB.textColor = [UIColor colorWithHexString:@"#eeeeee"];
            detailLB.numberOfLines = 0;
            [self.shadeView addSubview:detailLB];
            
            UILabel *knownLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 360 * ProportionAdapter, ScreenWidth, 30 * ProportionAdapter)];
            knownLB.text = @"朕知道～～";
            knownLB.textAlignment = NSTextAlignmentCenter;
            knownLB.font = [UIFont systemFontOfSize:22 * ProportionAdapter];
            knownLB.textColor = [UIColor colorWithHexString:@"#f39800"];
            [self.shadeView addSubview:knownLB];
        }
        
    }
}

- (void)removeView{
    [self.shadeView removeFromSuperview];
}

- (void)setData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp] httpRequest:@"score/getUserCaddieRecordHome" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"list"]) {
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGDPlayerModel *model =[[JGDPlayerModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                self.tipLabel.hidden = NO;
                self.footView.hidden = NO;
                self.tableView.tableFooterView = nil;
                _blockHideCaddieBtn();
                
                [self.tableView reloadData];
            }else{
                self.tipLabel.hidden = YES;
                self.footView.hidden = YES;
                
                UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 * ProportionAdapter, screenWidth, 500 * ProportionAdapter)];
                
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 0 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
                imageV.image = [UIImage imageNamed:@"bg-shy"];
                [footView addSubview:imageV];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 130 * ProportionAdapter, screenWidth, 30 * ProportionAdapter)];
                label.text = @"您还没有球童记分记录哦";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
                label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
                [footView addSubview:label];
                
                UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 170 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 50 * ProportionAdapter)];
                detailLB.text = @"扫描球童二维码，可指定球童为您记分，记分完成后，成绩自动存入您的历史记分卡中。";
                detailLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
                detailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
                detailLB.numberOfLines = 0;
                [footView addSubview:detailLB];
                
                self.tableView.tableFooterView = footView;
                
                _blockShowCaddieBtn();//存在记录  显示我市球童
//                UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"我是球童" style:UIBarButtonItemStyleDone target:self action:@selector(ballBoy)];
//                [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
//                rightBtn.tintColor = [UIColor whiteColor];
//                self.navigationItem.rightBarButtonItem = rightBtn;
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self];
            }
        }
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
    
}

#pragma mark ----- 创建 tableView
- (void)createTable{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JGDPlayPersoningTableViewCell class] forCellReuseIdentifier:@"JGDPlayPersoningTableViewCell"];
    [self.tableView registerClass:[JGDPlayPersonTableViewCell class] forCellReuseIdentifier:@"JGDPlayPersonTableViewCell"];
    //    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 50 * ProportionAdapter;
    [self addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 200 * ProportionAdapter)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    UIView *topViewFir = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth , 120 * ProportionAdapter)];
    topViewFir.backgroundColor = [UIColor whiteColor];
    UIView *topViewSec = [[UIView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 1 * ProportionAdapter, 10 * ProportionAdapter, 2 * ProportionAdapter, 100 * ProportionAdapter)];
    topViewSec.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 10 * ProportionAdapter, screenWidth/2, 200 * ProportionAdapter);
    [btn1 addTarget:self action:@selector(scanAct) forControlEvents:UIControlEventTouchUpInside];
    [topViewFir addSubview:btn1];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(screenWidth / 2 - 1 * ProportionAdapter, 10 * ProportionAdapter, screenWidth/2, 100 * ProportionAdapter);
    [btn2 addTarget:self action:@selector(qrCodeAct) forControlEvents:UIControlEventTouchUpInside];
    [topViewFir addSubview:btn2];
    
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
    [self addSubview:self.footView];
    
    
    self.tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [self.tableView.header beginRefreshing];
    
}
#pragma mark 开始进入刷新状态

- (void)headRereshing
{
    [self setData ];
}

- (void)footRereshing
{
    [self setData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDPlayerModel *model = self.dataArray[indexPath.section];
    if ([model.scoreFinish integerValue] == 1) {
        
//        JGDHistoryScoreViewController *hisVC = [[JGDHistoryScoreViewController alloc] init];
//        [self.navigationController pushViewController:hisVC animated:YES];
        _blockHistoryScore();
    }else{
        JGDPlayPersoningTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.checkBtn addTarget:self action:@selector(checkAct:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.tag = indexPath.section;
    }
}

- (void)checkAct:(UIButton *)btn{
    JGDPlayerModel *model = self.dataArray[btn.tag];
    if ([model.srcType integerValue] == 1) {
        _blockPlayerHisScoreCard(model.timeKey);
//        JGDPlayerHisScoreCardViewController *DPHVC = [[JGDPlayerHisScoreCardViewController alloc] init];
//        DPHVC.timeKey = model.timeKey;
//        DPHVC.ballkid = 10;
//        [self.navigationController pushViewController:DPHVC animated:YES];
    }else{
        _blockNotActScore(model.timeKey);
//        JGDNotActScoreViewController *noActVC = [[JGDNotActScoreViewController alloc] init];
//        noActVC.timeKey = model.timeKey;
//        noActVC.ballkid = 10;
//        [self.navigationController pushViewController:noActVC animated:YES];
    }
}

#pragma mark ------- 我的二维码页面
- (void)qrCodeAct{
    _blockSelectMyCode();
}
#pragma mark -- 扫描页面
- (void)scanAct{
    _blockSelectSweepCode();
}
#pragma mark ---查看更多
- (void)checkBtnClick:(UIButton *)btn{
    _blockSelectMoreScore();
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
