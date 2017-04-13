//
//  VipCardGoodDetailViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardGoodDetailViewController.h"
#import "VipCardGoodDetailViewModel.h"
#import "VipCardConfirmOrderViewController.h"
@interface VipCardGoodDetailViewController ()<UIScrollViewDelegate>
/**
 背景界面
 */
@property(nonatomic, strong)UIScrollView *mainBackView;
/**
 数据源
 */
@property(nonatomic, strong)VipCardGoodDetailViewModel *dataModel;

/**
 球场图片
 */
@property(nonatomic, strong)UIImageView *parkImageView;

/**
 渐变图
 */
@property(nonatomic, strong)UIImageView *gradientImageView;

/**
 图片高
 */
@property(nonatomic, assign)CGFloat ImageHeight;

@end

@implementation VipCardGoodDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = true;
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}
#pragma mark - CreateView
-(void)createView{
    _ImageHeight = kHvertical(210);
    [self createMainView];
    [self createNavigationView];
    [self createBottomButton];
}
/**
 创建上导航
 */
-(void)createNavigationView{
//    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //返回按钮
    UIButton *backBtn = [Factory createButtonWithFrame:CGRectMake(0, 21, 44, 44) image:[UIImage imageNamed:@"backL"] target:self selector:@selector(backBtnClick) Title:nil];
    [self.view addSubview:backBtn];
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(screenWidth - kWvertical(54), 20, kWvertical(54), kWvertical(44));
    [shareBtn setTintColor:[UIColor whiteColor]];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];

}
/**
 创建主界面
 */
-(void)createMainView{
    //背景图
    self.mainBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.mainBackView.backgroundColor = RGB(238,238,238);
    self.mainBackView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mainBackView setContentSize:CGSizeMake(screenWidth, screenHeight+1)];
    [self.view addSubview:self.mainBackView];
}
/**
 头部
 */
-(void)createHeader{
    //球场图片
    NSURL *picUrl = [NSURL URLWithString:self.dataModel.picURL];
    self.parkImageView = [Factory createImageViewWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(210)) Image:nil];
    [self.parkImageView sd_setImageWithURL:picUrl placeholderImage:nil];
    [self.mainBackView addSubview:self.parkImageView];
    //渐变图
    self.gradientImageView = [[UIImageView alloc]initWithFrame:self.parkImageView.frame];
    [self.gradientImageView setImage:[UIImage imageNamed:@"backChange"]];
    [self.mainBackView addSubview:self.gradientImageView];

    //君高联盟
    UIButton *allianceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kHvertical(185),kWvertical(100),  kWvertical(20))];
    [allianceBtn addTarget:self action:@selector(allianceBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [allianceBtn setImage:[UIImage imageNamed:@"booking_details"] forState:(UIControlStateNormal)];
    [allianceBtn setTitle:@"君高联盟" forState:(UIControlStateNormal)];
    allianceBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    allianceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
    [self.mainBackView addSubview:allianceBtn];

    //标题背景
    UIView *titleBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0,  kHvertical(221), screenWidth, kHvertical(81))];
    [self.mainBackView addSubview:titleBackView];
    //标题
    NSString *nameStr = self.dataModel.name;
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(21), screenWidth-kWvertical(20), kHvertical(16)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:nil];
    titleLabel.text = nameStr;
    [titleBackView addSubview:titleLabel];
    //价格
    UILabel *priceLabel = [Factory createLabelWithFrame:CGRectMake(titleLabel.x, kHvertical(49), kWvertical(80), kHvertical(17)) textColor:RGB(252,90,1) fontSize:kHorizontal(22) Title:nil];
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.dataModel.price]];
    [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(14)] range:NSMakeRange(0, 1)];
    priceLabel.attributedText = priceStr;
    [titleBackView addSubview:priceLabel];

}
/**
 创建详情
 */
-(void)createDetailView{
    //详情背景图
    UIView *detailBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(311), screenWidth, kHvertical(145))];
    [self.mainBackView addSubview:detailBackView];
    //会籍类型
    UILabel *title = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, screenWidth - kWvertical(10), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"会籍类型"];
    UILabel *titleDetail = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth-kWvertical(10), kHorizontal(50)) textColor:RGB(252,90,1) fontSize:kHorizontal(15) Title:@"君高会籍"];
    [titleDetail setTextAlignment:NSTextAlignmentRight];
    [detailBackView addSubview:title];
    [detailBackView addSubview:titleDetail];
    //分割线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(0, kHvertical(50), screenWidth, 1)];
    [detailBackView addSubview:line];
    //会员权益
    UILabel *equityTitle = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), line.y_height + kHvertical(16), kWvertical(120), kHvertical(14)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:@"君高会籍权益"];
    [detailBackView addSubview:equityTitle];
    //服务年限
    UILabel *equityYears = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), line.y_height + kHvertical(41), screenWidth - kWvertical(20), kHvertical(13)) textColor:RGB(98,98,98) fontSize:kHorizontal(14) Title:nil];
    NSInteger years = self.dataModel.expiry;
    NSInteger schemeCount = self.dataModel.schemeMaxCount;
    NSMutableAttributedString *equitYearsStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"服务年限： 服务年限：%ld年 / %ld次联盟价击球权益",years,schemeCount]];
    [equitYearsStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(15)] range:NSMakeRange(0, 6)];
    [equitYearsStr addAttribute:NSForegroundColorAttributeName value:RGB(160, 160, 160) range:NSMakeRange(0, 6)];
    equityYears.attributedText = equitYearsStr;
    [detailBackView addSubview:equityYears];
    //权益详情
    UILabel *equityDetail = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), equityYears.y_height + kHvertical(12), equityYears.width, equityYears.height) textColor:RGB(98,98,98) fontSize:kHorizontal(15) Title:nil];
    NSString *equitDetailString = @"暂无";
    if (self.dataModel.enjoyService) {
        equitDetailString = self.dataModel.enjoyService;
    }
    NSMutableAttributedString *equityDetailStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"特殊权限： %@",equitDetailString]];
    [equityDetailStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(15)] range:NSMakeRange(0, 6)];
    [equityDetailStr addAttribute:NSForegroundColorAttributeName value:RGB(160, 160, 160) range:NSMakeRange(0, 6)];
    equityDetail.attributedText = equityDetailStr;
    [detailBackView addSubview:equityDetail];
}
/**
 底部两个按钮
 */
-(void)createBottomButton{
    //咨询
    UIButton *consultBtn = [Factory createButtonWithFrame:CGRectMake(0, screenHeight - kHvertical(45), kWvertical(89), kHvertical(45)) titleFont:19 textColor:WhiteColor backgroundColor:RGB(243,152,0) target:self selector:@selector(consultBtnClick) Title:nil];
    UIImageView *consultImgeView = [Factory createImageViewWithFrame:CGRectMake(kHvertical(12), kWvertical(14), kWvertical(22), kHvertical(22)) Image:[UIImage imageNamed:@"icn_serve_phone"]];
    UILabel *consultLabel = [Factory createLabelWithFrame:CGRectMake(consultImgeView.x_width + kWvertical(6), kHvertical(14), kWvertical(44), kHvertical(18)) textColor:WhiteColor fontSize:kHorizontal(19) Title:@"咨询"];
    [consultBtn addSubview:consultImgeView];
    [consultBtn addSubview:consultLabel];
    [self.view addSubview:consultBtn];
    //立即购买
    UIButton *buyNow = [Factory createButtonWithFrame:CGRectMake(consultBtn.x_width, consultBtn.y, screenWidth-consultBtn.width, consultBtn.height) titleFont:19 textColor:WhiteColor backgroundColor:RGB(252,90,1) target:self selector:@selector(buyNowClick) Title:@"立即购买"];
    [self.view addSubview:buyNow];
}
#pragma mark - InitData
/**
 获取当前界面的数据
 */
-(void)initViewData{
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"cardTypeKey=%@&userKey=%@dagolfla.com",_cardTypeKey,DEFAULF_USERID]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"cardTypeKey":_cardTypeKey,
                           @"md5":md5Value,
                           };
    [[JsonHttp jsonHttp] httpRequest:@"league/getSystemCardInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL Success = [[data objectForKey:@"packSuccess"] boolValue];
        if (Success) {
            self.dataModel = [VipCardGoodDetailViewModel modelWithDictionary:[data objectForKey:@"cardType"]];
            self.dataModel.cardId = _cardTypeKey;
            self.dataModel.cardNum = 1;
            [self createHeader];
            [self createDetailView];
        }
    }];

}

#pragma mark - Action

/**
 返回点击
 */
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 分享按钮点击
 */
-(void)shareBtnClick{
    
}
/**
 君高联盟
 */
-(void)allianceBtnClick{

}
/**
 咨询
 */
-(void)consultBtnClick{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}
/**
 立即购买
 */
-(void)buyNowClick{
    VipCardConfirmOrderViewController *vc = [[VipCardConfirmOrderViewController alloc] init];
    vc.dataModel = self.dataModel;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.mainBackView.contentOffset.y;
    CGFloat factor = ((ABS(yOffset)+_ImageHeight)*screenWidth)/_ImageHeight;
    if (yOffset < 0) {
        CGRect f = CGRectMake(-(factor-screenWidth)/2, -ABS(yOffset), factor, _ImageHeight+ABS(yOffset));
        self.parkImageView.frame = f;
        self.gradientImageView.frame = self.parkImageView.frame;
    }
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
