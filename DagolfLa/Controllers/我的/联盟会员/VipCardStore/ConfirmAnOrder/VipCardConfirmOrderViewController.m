//
//  VipCardConfirmOrderViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardConfirmOrderViewController.h"
#import "VipCardConfirmOrderModel.h"
#import "VipCardOrderDetailViewController.h"
#import "JGDVipInfoFillViewController.h"
#import "VipCardAgreementViewController.h"
#import "VipCardSellPhoneViewController.h"
#import "JGDConfirmPayViewController.h"  // 支付界面
#import "UseMallViewController.h"
@interface VipCardConfirmOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 主视图
 */
@property (nonatomic, strong)UITableView *mainTableView;

/**
 当前界面输入的数据
 */
@property (nonatomic, strong)VipCardConfirmOrderModel *inputModel;

@end

@implementation VipCardConfirmOrderViewController

-(VipCardConfirmOrderModel *)inputModel{
    if (!_inputModel) {
        _inputModel = [[VipCardConfirmOrderModel alloc] init];
    }
    return _inputModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigation];
    [self createTableView];
}
/**
 创建导航栏
 */
-(void)createNavigation{
    self.title = @"确认订单";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}
/**
 主视图
 */
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    mainTableView.backgroundColor = RGB(238,238,238);
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView setExtraCellLineHidden];
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
}

/**
 无会员信息
 
 @return 会员信息为空的界面
 */
-(UIView *)userInformationNpneView{
    //输出的界面
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(61))];
    //标题
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, kWvertical(200), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"会员信息"];
    [backView addSubview:titleLabel];
    
    UILabel *inputAlertLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth-kWvertical(25), kHvertical(51)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:@"请输入会员信息"];
    [inputAlertLabel setTextAlignment:NSTextAlignmentRight];
    [backView addSubview:inputAlertLabel];
    UIImageView *arrowImageView = [Factory createImageViewWithFrame:CGRectMake(inputAlertLabel.x_width + kWvertical(5), kHvertical(20), kWvertical(8), kHvertical(13)) Image:[UIImage imageNamed:@"darkArrow"]];
    [backView addSubview:arrowImageView];
    //浅灰
    UIView *bottomView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, backView.y_height-kWvertical(10), screenWidth, kHvertical(10))];
    [backView addSubview:bottomView];
    
    return backView;
}

/**
 会员信息
 
 @return 会员信息界面
 */
-(UIView *)userInformationView{
    //输出的界面
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(160))];
    //标题
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, kWvertical(200), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"会员信息"];
    [backView addSubview:titleLabel];
    //分割线
    UIView *line = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, kHvertical(50), screenWidth, 1)];
    [backView addSubview:line];
    //头像背景
    UIView *userImageBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(10), kHvertical(71), kHvertical(61), kHvertical(61))];
    userImageBackView.layer.borderColor = RGB(229,229,229).CGColor;
    userImageBackView.layer.borderWidth = 1;
    [backView addSubview:userImageBackView];
    //用户头像
    NSURL *userImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@@200w_200h_2o",self.inputModel.picHeadURL]];
    UIImageView *headImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(11), kHvertical(72), kHvertical(59), kHvertical(59)) Image:nil];
    [headImageView sd_setImageWithURL:userImageUrl placeholderImage:[UIImage imageNamed:@"moren"]];
    headImageView.backgroundColor = RandomColor;
    [backView addSubview:headImageView];
    //用户名
    UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(headImageView.x_width + kWvertical(11), kHvertical(70), 0, kHvertical(22)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:self.inputModel.userName];
    [nameLabel sizeToFitSelf];
    [backView addSubview:nameLabel];
    //用户性别
    NSInteger sex = self.inputModel.sex;
    NSString *sexImageName = @"xb_n";
    if (sex == 1) {
        sexImageName = @"xb_nn";
    }
    UIImageView *sexImageView = [Factory createImageViewWithFrame:CGRectMake(nameLabel.x_width+kWvertical(11), kHvertical(74), 13,13) Image:[UIImage imageNamed:sexImageName]];
    [backView addSubview:sexImageView];
    //用户身份信息
    NSString *documentsStr = self.inputModel.certNumber;
    UIImageView *documentsIcon = [Factory createImageViewWithFrame:CGRectMake(nameLabel.x, kHvertical(98), kWvertical(17), kHvertical(12)) Image:[UIImage imageNamed:@"icn_allianceDocuments"]];
    [backView addSubview:documentsIcon];
    UILabel *documentsLable = [Factory createLabelWithFrame:CGRectMake(documentsIcon.x_width + kWvertical(5), kHvertical(99), screenWidth-documentsIcon.x_width-kWvertical(15), kHvertical(10)) textColor:RGB(160,160,160) fontSize:kHorizontal(14) Title:documentsStr];
    [backView addSubview:documentsLable];
    //用户手机号
    NSString *phoneStr = self.inputModel.mobile;
    UIImageView *phoneIcon = [Factory createImageViewWithFrame:CGRectMake(documentsIcon.x, kHvertical(120), kHvertical(13), kHvertical(13)) Image:[UIImage imageNamed:@"icn_alliancePhone"]];
    [backView addSubview:phoneIcon];
    UILabel *phoneLabel = [Factory createLabelWithFrame:CGRectMake(documentsLable.x, kHvertical(120), documentsLable.width, documentsLable.height) textColor:RGB(160, 160, 160) fontSize:kHorizontal(14) Title:phoneStr];
    [backView addSubview:phoneLabel];
    //编辑信息
    UILabel *editLabel = [Factory createLabelWithFrame:CGRectMake(screenWidth - kWvertical(80), kHvertical(74), kWvertical(55), kHvertical(13)) textColor:RGB(178,178,178) fontSize:kHorizontal(13) Title:@"编辑信息"];
    [editLabel setTextAlignment:NSTextAlignmentRight];
    [backView addSubview:editLabel];
    UIImageView *arrowImageView = [Factory createImageViewWithFrame:CGRectMake(editLabel.x_width + kWvertical(5), kHvertical(74), kWvertical(8), kHvertical(13)) Image:[UIImage imageNamed:@"darkArrow"]];
    [backView addSubview:arrowImageView];
    //浅灰
    UIView *bottomView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, backView.y_height-kWvertical(20), screenWidth, kHvertical(20))];
    [backView addSubview:bottomView];
    //锯齿
    UIImageView *jagView = [Factory createImageViewWithFrame:CGRectMake(0, backView.y_height-kHvertical(20), screenWidth, kHvertical(10)) Image:[UIImage imageNamed:@"icn_allianceJag"]];
    [backView addSubview:jagView];
    return backView;
}
/**
 会员卡信息
 
 @return 会员卡详情界面
 */
-(UIView *)cardInformationView{
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(211))];
    //卡片背景
    UIView *cardBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(10), kHvertical(22), kWvertical(92), kHvertical(58))];
    cardBackView.layer.masksToBounds = true;
    cardBackView.layer.cornerRadius = kWvertical(4);
    cardBackView.layer.borderColor = RGB(229,229,229).CGColor;
    cardBackView.layer.borderWidth = 1;
    [backView addSubview:cardBackView];
    //卡片图片
    NSURL *cardUrl = [NSURL URLWithString:self.dataModel.bigPicURL];
    UIImageView *cardImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(12), kHvertical(24), kWvertical(88), kHvertical(54)) Image:nil];
    [cardImageView sd_setImageWithURL:cardUrl placeholderImage:[UIImage imageNamed:@"moren"]];
    cardImageView.layer.masksToBounds = true;
    cardImageView.layer.cornerRadius = kWvertical(4);
    [backView addSubview:cardImageView];
    //卡片名
    NSString *cardName = self.dataModel.name;
    UILabel *cardNameLabel = [Factory createLabelWithFrame:CGRectMake(cardImageView.x_width + kWvertical(11), kHvertical(25), kWvertical(150), kHvertical(26)) textColor:RGB(49, 49, 49) fontSize:kHorizontal(15) Title:cardName];
    [cardNameLabel sizeToFitSelf];
    [backView addSubview:cardNameLabel];
    //单张价格
    NSString *singlePrice = [NSString stringWithFormat:@"￥%@",self.dataModel.price];
    UILabel *singlePriceLabel = [Factory createLabelWithFrame:CGRectMake(cardNameLabel.x, kHvertical(59), kWvertical(80), kHorizontal(12)) textColor:RGB(252,90,1) fontSize:kHorizontal(12) Title:nil];
    NSMutableAttributedString *singlePriceStr = [[NSMutableAttributedString alloc] initWithString:singlePrice];
    [singlePriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(15)] range:NSMakeRange(1, singlePrice.length-1)];
    singlePriceLabel.attributedText = singlePriceStr;
    
    [backView addSubview:singlePriceLabel];
    //左按钮
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(105), kHvertical(54), kWvertical(23), kHvertical(23)) NormalImage:@"icn_cardNumMinusNormal" SelectedImage:@"icn_cardNumMinusSelect" target:self selector:@selector(leftBtnClick:)];
    if (self.dataModel.cardNum>1) {
        leftBtn.selected = YES;
    }
    [backView addSubview:leftBtn];
    //卡片数1
    NSString *cardNumStr = [NSString stringWithFormat:@"%ld",self.dataModel.cardNum];
    UILabel *cardNumLabel1 = [Factory createLabelWithFrame:CGRectMake(leftBtn.x_width, leftBtn.y, kWvertical(50), kHvertical(23)) textColor:RGB(49,49,49) fontSize:kHorizontal(20) Title:cardNumStr];
    [cardNumLabel1 setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:cardNumLabel1];
    //右按钮
    UIButton *rightBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kHvertical(33), kHvertical(54), kWvertical(23), kHvertical(23)) NormalImage:@"icn_cardNumAddNormal" SelectedImage:@"icn_cardNumAddSelect" target:self selector:@selector(rightBtnClick:)];
    if (self.dataModel.cardNum<100) {
        rightBtn.selected = YES;
    }
    [backView addSubview:rightBtn];
    //分割线1
    UIView *line1 = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(kWvertical(10), kHvertical(100), screenWidth, 1)];
    [backView addSubview:line1];
    //套餐权益
    
    NSString *enjoyService = [NSString stringWithFormat:@"套餐权益：%@",self.dataModel.enjoyService];
    
    CGSize TitleSize= [enjoyService boundingRectWithSize:CGSizeMake(screenWidth - kWvertical(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:kHorizontal(13)]} context:nil].size;
    backView.height = kHvertical(179)+TitleSize.height;
    UILabel *enjoyLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(110), screenWidth - kWvertical(20), TitleSize.height) textColor:RGB(160,160,160) fontSize:kHorizontal(13) Title:enjoyService];
    enjoyLabel.numberOfLines = 0;
    [backView addSubview:enjoyLabel];
    //分割线2
    UIView *line2 = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, enjoyLabel.y_height + kHvertical(9), screenWidth, 1)];
    [backView addSubview:line2];
    //卡片数
    NSString *totalCardStr = [NSString stringWithFormat:@"共 %ld 件商品",self.dataModel.cardNum];
    UILabel *cardNumLabel2 = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), line2.y, screenWidth - kWvertical(20), kHvertical(51)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:totalCardStr];
    [backView addSubview:cardNumLabel2];
    //总价
    UILabel *totalPriceLabel = [Factory createLabelWithFrame:CGRectMake(0, line2.y, screenWidth-kWvertical(10), kHvertical(51)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:nil];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计： ¥%ld",[self.dataModel.price integerValue]*self.dataModel.cardNum]];
    [attributed addAttribute:NSForegroundColorAttributeName value:RGB(252,90,1) range:NSMakeRange(3, attributed.length-3)];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(14)] range:NSMakeRange(4, 1)];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(18)] range:NSMakeRange(5, attributed.length-5)];
    totalPriceLabel.attributedText = attributed;
    [totalPriceLabel setTextAlignment:NSTextAlignmentRight];
    [backView addSubview:totalPriceLabel];
    //浅灰
    UIView *bottomView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, totalPriceLabel.y_height, screenWidth, kHvertical(10))];
    [backView addSubview:bottomView];
    return backView;
}
/**
 销售手机号与提交按钮
 
 @return 底部的界面
 */
-(UIView *)phoneAndsendView{
    //是否勾选
    BOOL isSelect = self.inputModel.isSelect;
    
    UIView *backView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, 0, screenWidth, kHvertical(260))];
    backView.userInteractionEnabled = true;
    //白色背景
    UIView *whiteView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(51))];
    [backView addSubview:whiteView];
    //销售人员手机
    UILabel *sellPhoneLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, kWvertical(130), kHvertical(51)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"销售人员手机号"];
    [whiteView addSubview:sellPhoneLabel];
    //销售人员手机号
    UILabel *sellPhoneTextLabel = [Factory createLabelWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2-kWvertical(25), kHvertical(51)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:@"请输入销售人员手机号"];
    if (self.inputModel.sellPhoneStr.length>0) {
        sellPhoneTextLabel.text = self.inputModel.sellPhoneStr;
    }
    [sellPhoneTextLabel setTextAlignment:NSTextAlignmentRight];
    UITapGestureRecognizer *sellPhoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addSellPhone:)];
    sellPhoneTextLabel.userInteractionEnabled = true;
    [sellPhoneTextLabel addGestureRecognizer:sellPhoneTap];
    [whiteView addSubview:sellPhoneTextLabel];
    UIImageView *arrowImageView = [Factory createImageViewWithFrame:CGRectMake(sellPhoneTextLabel.x_width + kWvertical(5), kHvertical(20), kWvertical(8), kHvertical(13)) Image:[UIImage imageNamed:@"darkArrow"]];
    [whiteView addSubview:arrowImageView];
    //君高协议
    UIButton *circleBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(10), kHvertical(61), kHvertical(16), kHvertical(16)) NormalImage:@"icn_allianceAgreementSelect" SelectedImage:@"icn_allianceAgreementUnselect" target:self selector:@selector(circleBtnClick:)];
    circleBtn.selected = isSelect;
    [backView addSubview:circleBtn];
    //描述文件
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(circleBtn.x_width + kWvertical(5), kHvertical(61), 0, kHvertical(13)) textColor:RGB(160,160,160) fontSize:kHorizontal(13) Title:@"勾选表示已查阅并认同"];
    [descLabel sizeToFit];
    [backView addSubview:descLabel];
    //服务协议
    UILabel *titleTestLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, 0, 0) fontSize:kHorizontal(13) Title:@"《君高高尔夫会籍入会协议书》"];
    [titleTestLabel sizeToFit];
    UIButton *agreementBtn = [Factory createButtonWithFrame:CGRectMake(descLabel.x_width, descLabel.y+kHvertical(1), titleTestLabel.width, kHorizontal(13)) titleFont:kHorizontal(13) textColor:RGB(0,134,73) backgroundColor:ClearColor target:self selector:@selector(agreementBtnClick:) Title:titleTestLabel.text];
    [backView addSubview:agreementBtn];
    //提交订单按钮
    UIButton *sendBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(8), descLabel.y_height + kHvertical(85), screenWidth - kWvertical(16), kHvertical(46)) titleFont:kHorizontal(19) textColor:RGB(255,255,255) backgroundColor:RGB(252,90,1) target:self selector:@selector(sendBtnClick:) Title:@"提交订单"];
    if (isSelect||!_inputModel.userKey) {
        sendBtn.backgroundColor = LightGrayColor;
    }
    sendBtn.layer.cornerRadius = kHvertical(5);
    [backView addSubview:sendBtn];
    return backView;
}

#pragma mark - InitData
//每次进入界面都会调用
-(void)initViewWillApperData{
    [self initInformationData];
}

/**
 获取该用户的系统联盟会员信息
 */
-(void)initInformationData{
    
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com",DEFAULF_USERID]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"md5":md5Value,
                           };
    [[JsonHttp jsonHttp] httpRequest:@"league/getSystemLeagueUInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        BOOL Success = [[data objectForKey:@"packSuccess"] boolValue];
        if (Success) {
            NSDictionary *luserDict = [data objectForKey:@"luInfo"];
            VipCardConfirmOrderModel *model = [VipCardConfirmOrderModel modelWithDictionary:luserDict];
            NSString *phoneStr = [NSString string];
            if (self.inputModel.sellPhoneStr) {
                phoneStr = [NSString stringWithFormat:@"%@",self.inputModel.sellPhoneStr];
            }
            self.inputModel = model;
            self.inputModel.sellPhoneStr = phoneStr;
            [self.mainTableView reloadData];
        }
    }];
}
/**
 提交信息
 */
-(void)createOrder:(UIButton *)btn{
    btn.userInteractionEnabled = false;
    [[ShowHUD  showHUD] showAnimationWithText:@"提交中..." FromView:self.view];
    NSString *cardId = self.dataModel.cardId;
    NSString *cardNumStr = [NSString stringWithFormat:@"%ld",self.dataModel.cardNum];
    NSString *sellMobileStr = [[NSString alloc] init];
    if (_inputModel.sellPhoneStr) {
        sellMobileStr = _inputModel.sellPhoneStr;
    }
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"cardTypeKey":cardId,
                           @"luinfoKey":_inputModel.timeKey,
                           @"number":cardNumStr,
                           @"sellMobile":sellMobileStr
                           };
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"league/doCreateSystemsCardOrder" JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        btn.userInteractionEnabled = true;
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        btn.userInteractionEnabled = true;
        BOOL parkSucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (parkSucess) {
            JGDConfirmPayViewController *confirVC = [[JGDConfirmPayViewController alloc] init];
            confirVC.orderKey = [data objectForKey:@"orderKey"];
            confirVC.fromWitchVC = 1;
            confirVC.payMoney = [[data objectForKey:@"money"] floatValue];
            [self.navigationController pushViewController:confirVC animated:YES];

        }
    }];
}

#pragma mark - Action
/**
 卡片数减1
 */
-(void)leftBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        return;
    }
    NSInteger cardNum = self.dataModel.cardNum;
    cardNum -- ;
    self.dataModel.cardNum = cardNum;
    [self.mainTableView reloadData];
    
}
/**
 卡片数加1
 */
-(void)rightBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        return;
    }
    NSInteger cardNum = self.dataModel.cardNum;
    cardNum ++ ;
    self.dataModel.cardNum = cardNum;
    [self.mainTableView reloadData];
}

/**
 同意条款按钮
 
 @param btn 点击切换选择与未选中
 */
-(void)circleBtnClick:(UIButton *)btn{
    self.inputModel.isSelect = true;
    if (btn.selected) {
        btn.selected = false;
        self.inputModel.isSelect = false;
    }
    [self.mainTableView reloadData];
}
/**
 条款按钮
 
 @param btn 点击可以查看详情
 */
-(void)agreementBtnClick:(UIButton *)btn{
    UseMallViewController *vc = [[UseMallViewController alloc]init];
    vc.linkUrl = @"http://res.dagolfla.com/h5/league/sysLeagueAgreement.html";
    vc.isNewColor = true;
    [self.navigationController pushViewController:vc animated:YES];    
}
/**
 编辑信息
 */
-(void)editUserInformaion{
    JGDVipInfoFillViewController *infoVipVC = [[JGDVipInfoFillViewController alloc] init];
    infoVipVC.inputModel = self.inputModel;
    [self.navigationController pushViewController:infoVipVC animated:YES];
}
/**
 修改销售人员手机号
 
 @param tap 手势
 */
-(void)addSellPhone:(UITapGestureRecognizer *)tap{
    __weak typeof(self) weakself = self;
    VipCardSellPhoneViewController *vc = [[VipCardSellPhoneViewController alloc] init];
    vc.defaultText = self.inputModel.sellPhoneStr;
    [vc setAddPhoneBlock:^(NSString *phoneStr) {
        weakself.inputModel.sellPhoneStr = phoneStr;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 提交订单
 
 @param btn 红色可以提交，灰色无反应
 */
-(void)sendBtnClick:(UIButton *)btn{
    if ([btn.backgroundColor isEqual:LightGrayColor]) {
        return;
    }
    [self createOrder:btn];
}

#pragma mark - UITableViewDelegate&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_inputModel.userKey) {
            return kHvertical(160);
        }
        return kHvertical(61);
    }
    if(section == 1){
        NSString *enjoyService = [NSString stringWithFormat:@"套餐权益：%@",self.dataModel.enjoyService];
        
        CGSize TitleSize= [enjoyService boundingRectWithSize:CGSizeMake(screenWidth - kWvertical(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:kHorizontal(13)]} context:nil].size;
        return kHvertical(179)+TitleSize.height;
    }
    return kHvertical(260);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    if (section == 0) {
        headerView = [self userInformationNpneView];
        if (_inputModel.userKey) {
            headerView = [self userInformationView];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self editUserInformaion];
        }];
        headerView.userInteractionEnabled = true;
        [headerView addGestureRecognizer:tap];
    } else if(section == 1){
        headerView = [self cardInformationView];
    }else{
        headerView = [self phoneAndsendView];
    }
    
    return headerView;
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
