//
//  JGDCourtDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCourtDetailViewController.h"
#import "JGDCostumTableViewCell.h"
#import "JGDCourtSecDetailViewController.h"

#import "JGDCommitOrderViewController.h"
#import "LGLCalenderViewController.h" // 日历
#import "JGDWKCourtDetailViewController.h"

static CGFloat ImageHeight  = 210.0;

@interface JGDCourtDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *courtDetail;

@property (nonatomic, strong)UIView *titleView;//顶部导航
@property (nonatomic, strong) UIImageView *imgProfile;

@property (nonatomic, strong) UIImageView *gradientImage;

@property (nonatomic, strong) UIButton *detailBtn; // 详情

@property (nonatomic, strong) UILabel *serviceDetail;

@property (nonatomic, strong) NSMutableDictionary *detailDic;

@property (nonatomic, strong) UILabel *detailLB;

@property (nonatomic, copy) NSString *selectDate;           //  选择的时间

@property (nonatomic, copy) NSString *unitPrice;          //  总价
@property (nonatomic, copy) NSString *payMoney;           //  线上
@property (nonatomic, copy) NSString *unitPaymentMoney;   //  线下

@property (nonatomic, copy) NSString *deductionMoney; // 立减价格

@property (nonatomic, copy) NSString *depositMoney; // 押金

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *time;

@end

@implementation JGDCourtDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (!self.detailDic) {
        [self downData];
    }
    
    NSString *headUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/bookball/%@.jpg", self.timeKey];
    [[SDImageCache sharedImageCache] removeImageForKey:headUrl fromDisk:YES];
    
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/bookball/%@.jpg", self.timeKey]] placeholderImage:[UIImage imageNamed:TeamBGImage]];
    
    
}

// 隐藏 navigationBar http://www.tuicool.com/articles/BJFNNz
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    
}

- (instancetype)init{
    
    if (self == [super init]) {
        
        self.titleView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:@"teamBGImage"];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        
        //渐变图
        _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
        [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
        [self.imgProfile addSubview:_gradientImage];
        
        self.courtDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStylePlain)];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
        self.courtDetail.tableHeaderView = headView;
        
        self.courtDetail.dataSource = self;
        self.courtDetail.delegate = self;
        self.courtDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.courtDetail.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        [self.view addSubview:self.courtDetail];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        [self.imgProfile addSubview:self.titleView];
        
    }
    
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    
    //咨询
    UIButton *consultBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    consultBtn.frame = CGRectMake(screenWidth - 70 * screenWidth / 320, 22 * ProportionAdapter, 22 * screenWidth / 320, 22 * screenWidth / 320);
    consultBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [consultBtn setTintColor:[UIColor whiteColor]];
    [consultBtn setImage:[UIImage imageNamed:@"consult"] forState:(UIControlStateNormal)];
    consultBtn.titleLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
    consultBtn.tag = 520;
    [consultBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:consultBtn];
    
    // share
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(screenWidth - 35 * screenWidth / 320, 20 * ProportionAdapter, 23 * screenWidth / 320, 23 * screenWidth / 320);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [shareBtn setTintColor:[UIColor whiteColor]];
    [shareBtn setImage:[UIImage imageNamed:@"ic_portshare"] forState:(UIControlStateNormal)];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
    shareBtn.tag = 530;
    [shareBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:shareBtn];
    
    
    // 球队详情
    //    UILabel *courtLB = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 270, 44 * ProportionAdapter)];;
    //    courtLB.text = @"AAAAAAAAAAAAA";
    //    courtLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    //    courtLB.textColor = [UIColor whiteColor];
    //    courtLB.textAlignment = NSTextAlignmentCenter;
    //    [self.titleView addSubview:courtLB];
    
    
    
    self.detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(300 * ProportionAdapter, self.imgProfile.frame.size.height - 30 * ProportionAdapter, 70 * ProportionAdapter, 20 * ProportionAdapter)];
    self.detailBtn.tag = 522;
    [self.detailBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.detailBtn setImage:[UIImage imageNamed:@"booking_details"] forState:(UIControlStateNormal)];
    [self.detailBtn setTitle:@"详情" forState:(UIControlStateNormal)];
    self.detailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
    
    //    [self.detailBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgProfile addSubview:self.detailBtn];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.courtDetail.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];;
    
}


- (void)downData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:self.timeKey forKey:@"ballKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%@dagolfla.com", self.timeKey]] forKey:@"md5"];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp] httpRequest:@"bookball/getBallInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"ball"]) {
                
                self.detailDic = [[data objectForKey:@"ball"] mutableCopy];
                
                NSString *time = [self.detailDic objectForKey:@"unitPriceDate"];
                
                self.payMoney = [NSString stringWithFormat:@"%td", [[self.detailDic objectForKey:@"payMoney"] integerValue] + [[self.detailDic objectForKey:@"unitPaymentMoney"] integerValue]];
                self.unitPaymentMoney = [[self.detailDic objectForKey:@"unitPaymentMoney"] stringValue];
                self.selectDate = time;
                
                if ([self.detailDic objectForKey:@"deductionMoney"] && [[self.detailDic objectForKey:@"deductionMoney"] integerValue] != 0) {
                    self.deductionMoney = [[self.detailDic objectForKey:@"deductionMoney"] stringValue];
                    self.unitPrice = [NSString stringWithFormat:@"%td", [[self.detailDic objectForKey:@"unitPrice"] integerValue] + [[self.detailDic objectForKey:@"deductionMoney"] integerValue]];

                }else{
                    self.unitPrice = [[self.detailDic objectForKey:@"unitPrice"] stringValue];

                }
                _date = [NSString stringWithFormat:@"%@", [Helper stringFromDateString:time withFormater:@"yyyy年MM月dd日"]];
                _week = [NSString stringWithFormat:@"%@", [Helper stringFromDateString:time withFormater:@"EEE"]];;
                _time = [NSString stringWithFormat:@"%@", [Helper stringFromDateString:time withFormater:@"HH:mm"]];
                
                if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
                    self.payMoney = [self.detailDic objectForKey:@"depositMoney"];
                }
                
                [self.courtDetail reloadData];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

#pragma mark -分享

- (void)addShare{
    
}



#pragma mark - 详情

- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 520){
        //咨询4008605308
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        //        [self addShare];
    }else if (btn.tag == 526){
        
    }else if (btn.tag == 522) {
        JGDWKCourtDetailViewController *detailVC = [[JGDWKCourtDetailViewController alloc] init];
        detailVC.ballKey = self.timeKey;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (btn.tag == 530) {
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index];
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [alert show];
        }];    }
}


#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = self.courtDetail.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight)*screenWidth)/ImageHeight;
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        
        _gradientImage.frame = self.imgProfile.frame;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0, title.size.width, title.size.height);
        
        self.detailBtn.hidden = YES;
        //        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset;
        self.titleView.frame = t;
        
        if (yOffset == 0.0) {
            self.detailBtn.hidden = NO;
            //            self.addressBtn.hidden = NO;
        }
    }
}

#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.detailDic objectForKey:@"instapaper"] integerValue] == 2) {
        if (section == 0) {
            return 0;
        }else{
            return 2;
        }
        
    }else{
        return 2;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return indexPath.row == 0 ? 80 * ProportionAdapter : 60 * ProportionAdapter;
        
    }else {
        
        CGFloat height = [Helper textHeightFromTextString:self.serviceDetail.text width:screenWidth - 20 * ProportionAdapter fontSize:15 * ProportionAdapter];
        return indexPath.row == 0 ? 100 * ProportionAdapter : 50 * ProportionAdapter + height;
        
    }
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15  * screenWidth / 320] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20  * screenWidth / 320 , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            self.detailLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter)];
            self.detailLB.layer.borderWidth = 0.5 * ProportionAdapter;
            self.detailLB.layer.borderColor = [[UIColor colorWithHexString:@"#32b14b"] CGColor];
            self.detailLB.layer.cornerRadius = 6;
            self.detailLB.clipsToBounds = YES;
            self.detailLB.userInteractionEnabled = YES;
            [cell.contentView addSubview:self.detailLB];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calendarTap)];
            [self.detailLB addGestureRecognizer:tap];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(22 * ProportionAdapter, 10 * ProportionAdapter, 25 * ProportionAdapter, 20 * ProportionAdapter)];
            imageV.image = [UIImage imageNamed:@"booking_DATE"];
            [self.detailLB addSubview:imageV];
            
            UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(65 * ProportionAdapter,  12 * ProportionAdapter, 0.5 * ProportionAdapter, 15 * ProportionAdapter)];
            lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [self.detailLB addSubview:lineLB];
            
            UILabel *dateLB = [[UILabel alloc] init];
            [self lableReDraw:dateLB rect:CGRectMake(82 * ProportionAdapter, 0, 160 * ProportionAdapter , 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#32b14b"] labelFont:(20 * ProportionAdapter) text:_date textAlignment:NSTextAlignmentCenter];
            [self.detailLB addSubview:dateLB];
            
            UILabel *weekLB = [[UILabel alloc] init];
            [self lableReDraw:weekLB rect:CGRectMake(242 * ProportionAdapter, 0, 40 , 40 * ProportionAdapter) labelColor:[UIColor blackColor] labelFont:(17 * ProportionAdapter) text:_week textAlignment:NSTextAlignmentCenter];
            [self.detailLB addSubview:weekLB];
            
            UILabel *timeLB = [[UILabel alloc] init];
            [self lableReDraw:timeLB rect:CGRectMake(287 * ProportionAdapter, 0, 60 * ProportionAdapter , 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#32b14b"] labelFont:(20 * ProportionAdapter) text:_time textAlignment:NSTextAlignmentCenter];
            [self.detailLB addSubview:timeLB];
            
            UILabel *underLine = [[UILabel alloc] init];
            [self lableReDraw:underLine rect:CGRectMake(0, 79.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#EEEEEE"] labelFont:0 text:@"" textAlignment:NSTextAlignmentCenter];
            underLine.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [cell.contentView addSubview:underLine];
            
            
            
        }else{
            UILabel *begainLB = [[UILabel alloc] init];
            
            NSString *begainDate = [NSString stringWithFormat:@"将为您提供%@-%@（１小时内的开球时间）", [Helper dateFromDate:self.selectDate timeInterval:-30 * 60], [Helper dateFromDate:self.selectDate timeInterval:30 * 60]];
            
            
            [self lableReDraw:begainLB rect:CGRectMake(0, 0, screenWidth, 60 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#636363"] labelFont:16 * ProportionAdapter text:begainDate textAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:begainLB];
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            UILabel *courtName = [[UILabel alloc] init];
            [self lableReDraw:courtName rect:CGRectMake(10 * ProportionAdapter, 25 * ProportionAdapter, 200 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:[self.detailDic objectForKey:@"bookName"] textAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:courtName];
            
            UILabel *serviceName = [[UILabel alloc] init];
            [self lableReDraw:serviceName rect:CGRectMake(10 * ProportionAdapter, 55 * ProportionAdapter, 200 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(13 * ProportionAdapter) text:[self.detailDic objectForKey:@"servicePj"] textAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:serviceName];
            
            UILabel *underLine = [[UILabel alloc] init];
            [self lableReDraw:underLine rect:CGRectMake(0, 99.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#EEEEEE"] labelFont:0 text:@"" textAlignment:NSTextAlignmentCenter];
            underLine.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [cell.contentView addSubview:underLine];
            
            
            UILabel *priceLB = [[UILabel alloc] init];
            
            UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 85 * ProportionAdapter, 22 * ProportionAdapter, 75 * ProportionAdapter, 55 * ProportionAdapter)];
    // 0: 未上架  1: 已上架   2:封场
            if ([[self.detailDic objectForKey:@"instapaper"] integerValue] == 2) {
                [payBtn setBackgroundImage:[UIImage imageNamed:@"booking_pay"] forState:(UIControlStateNormal)];
                [payBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
                [self lableReDraw:priceLB rect:CGRectMake(screenWidth - 155 * ProportionAdapter , 35 * ProportionAdapter, 60 * ProportionAdapter, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:17 text:@"已封场" textAlignment:(NSTextAlignmentRight)];
                payBtn.enabled = NO;
                [cell.contentView addSubview:priceLB];
            }else if ([[self.detailDic objectForKey:@"instapaper"] integerValue] == 1) {
                
                [payBtn setBackgroundImage:[UIImage imageNamed:@"booking_paycolor"] forState:(UIControlStateNormal)];
                [payBtn setTitleColor:[UIColor colorWithHexString:@"#fc5a01"] forState:(UIControlStateNormal)];

                if (self.deductionMoney) {
        // 立减优惠
                // 优惠前价格
                    UILabel *greyLB = [self lablerect:CGRectMake(screenWidth - 155 * ProportionAdapter , 30 * ProportionAdapter, 60 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:13 text:[NSString stringWithFormat:@"¥ %@",self.unitPrice] textAlignment:(NSTextAlignmentRight)];
                    [cell.contentView addSubview:greyLB];
                    
                    CGFloat width = [Helper textWidthFromTextString:[NSString stringWithFormat:@"¥ %@",self.unitPrice] height:screenWidth - 20 * ProportionAdapter fontSize:13];
                    
                    UILabel *lineLB = [self lablerect:CGRectMake(screenWidth - 95 * ProportionAdapter - width - 2.5 * ProportionAdapter , 40 * ProportionAdapter, width + 5 * ProportionAdapter, 1 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
                    lineLB.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
                    [cell.contentView addSubview:lineLB];
                    
                // 优惠后价格
//                    NSInteger orangePrice = [self.unitPrice integerValue] - [self.deductionMoney integerValue];

                    UILabel *orangeLB = [self lablerect:CGRectMake(screenWidth - 155 * ProportionAdapter , 50 * ProportionAdapter, 60 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:17 text:[NSString stringWithFormat:@"¥%@", self.payMoney] textAlignment:(NSTextAlignmentRight)];
                    [cell.contentView addSubview:orangeLB];

                }else{
                    
            // 无立减优惠
                    [self lableReDraw:priceLB rect:CGRectMake(screenWidth - 155 * ProportionAdapter , 35 * ProportionAdapter, 60 * ProportionAdapter, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:17 text:[NSString stringWithFormat:@"¥ %@", self.unitPrice] textAlignment:(NSTextAlignmentRight)];
                    
                    NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", self.unitPrice]];
                    [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 * ProportionAdapter] range:NSMakeRange(0, 1)];
                    priceLB.attributedText = mutaStr;
                    [cell.contentView addSubview:priceLB];
                }
                
                
            }else{
                [payBtn setBackgroundImage:[UIImage imageNamed:@"booking_pay"] forState:(UIControlStateNormal)];
                [payBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
                
            }
            // payType  支付类型设置 0: 全额预付  1: 部分预付  2: 球场现付
            if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
                [payBtn setTitle:@"球场现付" forState:(UIControlStateNormal)];
                
            }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 1) {
                [payBtn setTitle:@"部分预付" forState:(UIControlStateNormal)];
                
            }else{
                [payBtn setTitle:@"全额预付" forState:(UIControlStateNormal)];
                
            }
            
            [payBtn addTarget:self action:@selector(payAct) forControlEvents:(UIControlEventTouchUpInside)];
            payBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            [payBtn setTitleEdgeInsets:UIEdgeInsetsMake(27 * ProportionAdapter, 0, 0, 0)];
            [cell addSubview:payBtn];
            
            
            
        }else{
            
            UILabel *discLB = [[UILabel alloc] init];
            [self lableReDraw:discLB rect:CGRectMake(10 * ProportionAdapter, 12 * ProportionAdapter, 300 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"预订说明" textAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:discLB];
            
            
            CGFloat height = [Helper textHeightFromTextString:[self.detailDic objectForKey:@"serviceDetails"] width:screenWidth - 20 * ProportionAdapter fontSize:15 * ProportionAdapter];
            
            self.serviceDetail = [[UILabel alloc] init];
            [self lableReDraw:self.serviceDetail rect:CGRectMake(10 * ProportionAdapter, 40 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, height) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:[self.detailDic objectForKey:@"serviceDetails"] textAlignment:NSTextAlignmentLeft];
            self.serviceDetail.numberOfLines = 0;
            [cell.contentView addSubview:self.serviceDetail];
        }
        
        
    }
    
    return cell;
    
}


#pragma mark --- 时间选择
//  money 单价（减免后的）     sence 现场价格  deductionMoney 减免
- (void)calendarTap{
    LGLCalenderViewController *caleVC = [[LGLCalenderViewController alloc] init];
    caleVC.ballKey = self.timeKey;
    caleVC.blockTimeWithPrice = ^(NSString *selectTime, NSString *pay, NSString *scenePay, NSString *deductionMoney){
        _date = [NSString stringWithFormat:@"%@", [Helper stringFromDateString:selectTime withFormater:@"yyyy年MM月dd日"]];
        _week = [NSString stringWithFormat:@"%@", [Helper stringFromDateString:selectTime withFormater:@"EEE"]];;
        _time = [NSString stringWithFormat:@"%@", [Helper stringFromDateString:selectTime withFormater:@"HH:mm"]];
        
        if ([[self.detailDic objectForKey:@"payType"] integerValue] != 2) {
            self.payMoney = pay;
        }
        self.unitPaymentMoney = scenePay;
        if ([deductionMoney isEqualToString:@""]) {
            self.deductionMoney = nil;
            self.unitPrice = pay;
        }else{
            self.deductionMoney = deductionMoney;
            self.unitPrice = [NSString stringWithFormat:@"%td", [pay integerValue] + [deductionMoney integerValue]];
        }
        self.selectDate = selectTime;
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [self.courtDetail reloadRowsAtIndexPaths:@[indexPath0, indexPath1, indexPath2] withRowAnimation:NO];
    };
    [self.navigationController pushViewController:caleVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma  mark -- 付款

- (void)payAct{
    JGDCommitOrderViewController *commitVC = [[JGDCommitOrderViewController alloc] init];
    commitVC.selectDate = self.selectDate;
    
//    if (self.deductionMoney) {
//        commitVC.selectMoney = [NSString stringWithFormat:@"%td", [self.payMoney integerValue] - [self.deductionMoney integerValue]];
//    }else{
//        commitVC.selectMoney = self.payMoney;
//    }
    
    if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
//         球场现付
            commitVC.selectMoney = self.payMoney;
        
    }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 1) {
//         部分预付
        if ([self.unitPaymentMoney isEqualToString:@""]) {
            commitVC.selectMoney = self.payMoney;
        }else{
            commitVC.selectMoney = [NSString stringWithFormat:@"%td", [self.payMoney integerValue] - [self.unitPaymentMoney integerValue]];
        }

    }else{
//         全额预付
        if ([self.unitPaymentMoney isEqualToString:@""]) {
            commitVC.selectMoney = self.payMoney;
        }else{
            commitVC.selectMoney = [NSString stringWithFormat:@"%td", [self.payMoney integerValue] - [self.unitPaymentMoney integerValue]];
        }

    }
    
    
    commitVC.selectSceneMoney = self.unitPaymentMoney;
    commitVC.detailDic = self.detailDic;
    commitVC.timeKey = self.timeKey;
    [self.navigationController pushViewController:commitVC animated:YES];
}



#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData;
    
    fiData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/bookball/%@.jpg", self.timeKey]]];
    NSObject* obj;
    if (fiData != nil && fiData.length > 0) {
        obj = fiData;
    }
    else
    {
        obj = [UIImage imageNamed:@"iconlogo"];
    }
    
    NSString *md5Str = [Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%@dagolfla.com", self.timeKey]];
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/bookBallPark.html?ballKey=%@&md5=%@", self.timeKey, md5Str];
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@",[self.detailDic objectForKey:@"ballName"]];
    NSString *timeString =[[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"unitPriceDate"]] substringWithRange:NSMakeRange(0, 10)];
    NSString *detailString = [NSString stringWithFormat:@"%@ | %@洞\n%@  ¥%@" ,[self.detailDic objectForKey:@"type"], [self.detailDic objectForKey:@"holesSum"],timeString, self.unitPrice];
    ;
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:detailString  image:obj location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:detailString image:obj location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        //        self.launchActivityTableView.frame = CGRectMake(0, 64, ScreenWidth, screenHeight - 64 - 49);
        
    }
    
}


//  封装cell方法
- (UILabel *)lableReDraw:(UILabel *)lable rect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    lable.textAlignment = alignment;
    lable.frame = rect;
    lable.textColor = color;
    lable.font = [UIFont systemFontOfSize:font];
    lable.text = text;
    return lable;
}

//  封装cell方法 2 。。。
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    if ([text length] > 1) {
        NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:text];
        [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
        label.attributedText = mutaStr;
    }else{
        label.text = text;
    }
    return label;
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
