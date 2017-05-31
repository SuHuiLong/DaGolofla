//
//  ActivityDetailViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailTableViewCell.h"
#import "ActivityDetailModel.h"
#import "JGTeamAcitivtyModel.h"
#import "ActivityDetailListTableViewCell.h"
#import "JGDNewTeamDetailViewController.h"
#import "ActivityExplainDetailViewController.h"
#import "JGLScoreLiveViewController.h"
#import "JGLScoreRankViewController.h"
#import "JGTeamDeatilWKwebViewController.h"
@interface ActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
//标题
@property (nonatomic,copy) UILabel *titleLabel;
//导航背景
@property (nonatomic,copy) UIView *navagationBackView;
//主视图
@property (nonatomic,copy) UITableView *mainTableView;
//顶部图片
@property (nonatomic,copy) UIImageView *headerImageView;
//渐变图
@property (nonatomic,copy) UIImageView *gradientImage;
//底部按钮
@property (nonatomic,strong) UIButton *bottomBtn;
//底部按钮状态 0：报名 1：取消报名 2：退出 3：再次报名 4:查看成绩
@property (nonatomic,assign) NSInteger bottomBtnTag;
//活动详情数据源
@property (nonatomic, strong)NSMutableArray *dataArray;
//成员列表数据源
@property (nonatomic, strong)NSMutableArray *playerDataArray;
//活动人数限制最多人数 0：为无限制人数
@property (nonatomic,assign) NSInteger maxGroup;
//分页请求
@property (nonatomic,assign) NSInteger off;
//是否报名
@property (nonatomic,copy) NSString *isApply;
//活动详细数据
@property (nonatomic,copy) JGTeamAcitivtyModel *detailModel;
//费用数组
@property (nonatomic,strong) NSArray *priceArray;
//填写资料弹窗背景
@property (nonatomic,copy) UIView *alapView;
//填写资料弹窗
@property (nonatomic,copy) UIView *alertView;
//填写资料的数据
@property (nonatomic, strong)NSMutableDictionary *importDict;
//报名用户的timekey
@property (nonatomic,copy) NSString *signupTimeKey;
//是否公布成绩0：未发布，1：已公布
@property (nonatomic,assign)NSInteger hasReleaseScore;
//是否球队成员
@property (nonatomic,assign) BOOL isTeamNumber;

@end

@implementation ActivityDetailViewController
-(NSMutableDictionary *)importDict{
    if (_importDict == nil) {
        _importDict = [NSMutableDictionary dictionary];
    }
    return _importDict;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRefresh];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}
#pragma mark - CreateView
-(void)createView{
    [self createMainView];
    [self createNavigationView];
}
//创建上导航
-(void)createNavigationView{
    //背景图
    _navagationBackView = [Factory createViewWithBackgroundColor:BarRGB_Color frame:CGRectMake(0, 0, screenWidth, 64)];
    _navagationBackView.alpha = 0;
    [self.view addSubview:_navagationBackView];
    
    //活动名称
    _titleLabel = [Factory createLabelWithFrame:CGRectMake(0, 20, screenWidth, 46) textColor:WhiteColor fontSize:kHorizontal(18) Title:@"2"];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_titleLabel];
    //返回按钮
    UIButton *backBtn = [Factory createButtonWithFrame:CGRectMake(0, 20, 44, 44) image:[UIImage imageNamed:@"backL"] target:self selector:@selector(backBtnClick) Title:nil];
    [self.view addSubview:backBtn];
    //分享按钮
    UIButton *shareBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - 54, 20, 54, 44) image:[UIImage imageNamed:@"ic_portshare"] target:self selector:@selector(shareBtnClick) Title:nil];
    [self.view addSubview:shareBtn];
    
    //电话按钮
    UIButton *photoBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - 90, shareBtn.y, 44, 44) image:[UIImage imageNamed:@"consult"] target:self selector:@selector(telPhotoClick:) Title:nil];
    [self.view addSubview:photoBtn];
    
}
//创建主视图
-(void)createMainView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    [mainTableView registerClass:[ActivityDetailTableViewCell class] forCellReuseIdentifier:@"ActivityDetailTableViewCellID"];
    [mainTableView registerClass:[ActivityDetailListTableViewCell class] forCellReuseIdentifier:@"ActivityDetailListTableViewCellID"];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [mainTableView setExtraCellLineHidden];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}
//底部按钮创建
-(void)createBottomBtn:(NSString *)title{
    //标题
    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc] initWithString:title];
    [showStr addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0,title.length)];
    [showStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(18)] range:NSMakeRange(0,title.length)];
    //按钮背景
    UIView *bottomBackView = [UIView new];
    if (!_bottomBtn) {
        //底部按钮
        UIView *btnBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, screenHeight - kHvertical(66), screenWidth, kHvertical(66))];
        [self.view addSubview:btnBackView];
        self.bottomBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(10), kWvertical(10), screenWidth-kWvertical(20), kHvertical(46)) titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:RGB(243,152,0) target:self selector:@selector(bootmCLick) Title:nil];
        self.bottomBtn.layer.masksToBounds = true;
        self.bottomBtn.layer.cornerRadius = kWvertical(6);
        [btnBackView addSubview:_bottomBtn];
        bottomBackView = btnBackView;
        _mainTableView.height = screenHeight-kHvertical(66);
    }else{
        bottomBackView = _bottomBtn.superview;
    }
    //默认按钮不隐藏
    bottomBackView.hidden = false;
    [_bottomBtn setBackgroundColor:RGB(243,152,0)];
    if (title.length==0) {
        [bottomBackView removeAllSubviews];
        [bottomBackView removeFromSuperview];
        bottomBackView.hidden = true;
        _bottomBtn = nil;
        _mainTableView.height = screenHeight;
        return;
    }
    if (_bottomBtnTag<6) {
        //默认报名按钮为屏幕宽
        if (_bottomBtnTag<4){
            [showStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 195, 142) range:NSMakeRange(4,title.length-4)];
            [showStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(15)] range:NSMakeRange(4,title.length-4)];
        }else if (_bottomBtnTag <6){
            if(_bottomBtnTag==5){
                [_bottomBtn setBackgroundColor:RGB(160,160,160)];
            }
        }
    }

    [_bottomBtn setAttributedTitle:showStr forState:UIControlStateNormal];
}

//创建填写资料界面
-(void)createFillView{
    
    [MobClick event:@"findactivity_apply_click"];

    //浅色背景
    _alapView = [Factory createViewWithBackgroundColor:RGBA(0, 0, 0, 0.7) frame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView)];
    _alapView.userInteractionEnabled = true;
    [_alapView addGestureRecognizer:tap];
    [self.view addSubview:_alapView];
    
    //填写界面
    UIView *whiteBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, screenHeight - kHvertical(451), screenWidth, kHvertical(451))];
    [self.view addSubview:whiteBackView];
    
    //标题
    UILabel *titleLable = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(52)) textColor:RGB(98,98,98) fontSize:kHorizontal(17) Title:@"填写报名资料"];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [whiteBackView addSubview:titleLable];
    //关闭按钮
    UIButton *closeBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(37), kHvertical(14), kWvertical(23), kWvertical(23)) image:[UIImage imageNamed:@"date_close"] target:self selector:@selector(closeAlertView) Title:nil];
    [whiteBackView addSubview:closeBtn];
    //内容
    NSArray *titleArray = @[@"姓名",@"性别",@"差点",@"手机号"];
    NSArray *placeHoldArray = @[@"请输入姓名",@"",@"必填",@"必填"];
    NSArray *textFieldText = @[@"",[UserDefaults objectForKey:@"sex"],[UserDefaults objectForKey:@"almost"],[UserDefaults objectForKey:@"mobile"]];
    NSArray *keyArray = @[@"",@"sex",@"almost",@"mobile"];
    NSArray *sexArry = @[@"男",@"女"];
    //设置默认数据
    

    for (int i = 0; i < titleArray.count; i++) {
        NSString *textFieldVelue = [NSString stringWithFormat:@"%@",textFieldText[i]];
        
        UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(20), kHvertical(50)*(i+1), kWvertical(110), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(18) Title:titleArray[i]];
        [whiteBackView addSubview:titleLabel];
        if (i!=1) {
            UITextField *textField = [Factory createViewWithFrame:CGRectMake(kWvertical(115), kHvertical(50)*(i+1), screenWidth-kWvertical(125), kHvertical(50)) placeholder:placeHoldArray[i] textColor:RGB(49, 49, 49) borderStyle:UITextBorderStyleNone Text:textFieldVelue];
            [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
            textField.tag = 100 + i;
            if (i>1) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            textField.delegate = self;
            [whiteBackView addSubview:textField];;
        }else{
            //性别按钮
            for (int j = 0; j < 2; j++) {
                UILabel *sexLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(115)+ kWvertical(112)*j, kHvertical(50)*(i+1), kWvertical(25), kHvertical(50)) textColor:RGB(49,49,49) fontSize:kHorizontal(18) Title:sexArry[j]];
                
                UIButton *sexBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(125) + kWvertical(112)*j, kHvertical(50)*(i+1), kWvertical(57), kHvertical(50)) titleFont:kHorizontal(18) textColor:RGB(49,49,49) backgroundColor:ClearColor target:self selector:@selector(sexBtnSelect:) Title:@" "];
                UIImage *selectImage = [UIImage imageNamed:@"icn_allianceAgreementSelect"];
                UIImage *unSelectImage = [UIImage imageNamed:@"gou_w"];
                [sexBtn setImage:unSelectImage forState:UIControlStateNormal];
                [sexBtn setImage:selectImage forState:UIControlStateSelected];
                sexBtn.tag = 104 + j;
                NSInteger sex = [textFieldText[i] integerValue];
                if (sex==0&&j==1) {
                    sexBtn.selected = true;
                }
//                [sexBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -selectImage.size.width+kWvertical(10), 0, selectImage.size.width+kWvertical(5))];
//                [sexBtn setImageEdgeInsets:UIEdgeInsetsMake(0, sexBtn.width-selectImage.size.width, 0,0)];
                [whiteBackView addSubview:sexLabel];
                [whiteBackView addSubview:sexBtn];
            }
        }
        //下划线
        UIView *line = [Factory createViewWithBackgroundColor:RGB(217,217,217) frame:CGRectMake(kWvertical(10), kHvertical(49)*(i+2), screenWidth - kWvertical(10), 1)];
        if (i==0) {
            UIView *topLine = [Factory createViewWithBackgroundColor:RGB(217,217,217) frame:CGRectMake(0, kHvertical(49), screenWidth , 1)];
            [whiteBackView addSubview:topLine];
        }else if (i==titleArray.count-1){
            line.x=0;
            line.width = screenWidth;
        }
        [whiteBackView addSubview:line];
        if (i>0) {
            [self.importDict setValue:textFieldVelue forKey:keyArray[i]];
        }
    }
    
    //球员类型：球队成员&&嘉宾
    NSArray *typeArray = @[@"  我是球队成员",@"  我是嘉宾"];
    for (int i = 0; i<2; i++) {
        UIButton *playerTypeBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(9) + (screenWidth -kWvertical(178))*i, kHvertical(290), kWvertical(160), kHvertical(35)) titleFont:kHorizontal(18) textColor:RGB(49,49,49) backgroundColor:ClearColor target:self selector:@selector(playerTypeBtnSelect:) Title:typeArray[i]];
        UIImage *selectImage = [UIImage imageNamed:@"activity_btn_select"];
        UIImage *unSelectImage = [UIImage imageNamed:@"activity_btn_unselect"];
        [playerTypeBtn setImage:unSelectImage forState:UIControlStateNormal];
        [playerTypeBtn setImage:selectImage forState:UIControlStateSelected];
        playerTypeBtn.tag = 106 + i;
        [whiteBackView addSubview:playerTypeBtn];
    }
    
    //提交
    UIButton *sendBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(112), kHvertical(388), kWvertical(151), kHvertical(33)) titleFont:kHorizontal(20) textColor:WhiteColor backgroundColor:RGB(210, 210, 210) target:self selector:@selector(sendBtnClick) Title:@"提交"];
    sendBtn.tag = 108;
    sendBtn.layer.cornerRadius = kWvertical(16);
    sendBtn.enabled = false;
    [whiteBackView addSubview:sendBtn];
    
    _alertView = whiteBackView;

}

#pragma mark - MJRefresh
-(void)createRefresh{
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
}
//加载
-(void)footerRefresh{
    _off ++ ;
    [self initPlayerData];
}

#pragma mark - InitData
-(void)initData{
    [self initMainData];
    [self initPlayerData];
}
//获取主视图数据
-(void)initMainData{
    if (![self.view.subviews containsObject:(UIView *)[ShowHUD showHUD]]) {
        [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    }
    NSDictionary *dict = @{
                           @"activityKey":_activityKey,
                           @"userKey":DEFAULF_USERID
                           };
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        BOOL packSuccess = [data objectForKey:@"packSuccess"];
        if (packSuccess) {
            [self formActivityData:data];
            _titleLabel.text = _detailModel.name;
            [self.mainTableView reloadData];
        }
    }];
}
//获取联系人列表
- (void)initPlayerData{
    NSString *md5 = [JGReturnMD5Str getTeamActivitySignUpListWithTeamKey:0 activityKey:[self.activityKey integerValue] userKey:[DEFAULF_USERID integerValue]];
    NSDictionary *dict = @{
                           @"activityKey":self.activityKey,
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":@0,
                           @"offset":@(_off),
                           @"md5":md5,
                           };
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.mainTableView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [self.mainTableView.mj_footer endRefreshing];
        BOOL packSucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSucess) {
            if (_off==0) {
                self.playerDataArray = [NSMutableArray array];
            }
            NSArray *listArray = [data objectForKey:@"teamSignUpList"];
            for (NSDictionary *listDict in listArray) {
                ActivityDetailModel *model = [ActivityDetailModel modelWithDictionary:listDict];
                [self.playerDataArray addObject:model];
            }
            [self.mainTableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}


//格式化活动数据
-(void)formActivityData:(id)data{
    self.dataArray = [NSMutableArray array];
    //是否是球队成员
    _isTeamNumber = [data objectForKey:@"teamMember"];
    //是否公布成绩0：未发布，1：已公布
    _hasReleaseScore = [[data objectForKey:@"hasReleaseScore"] integerValue];
    //是否报名
    _isApply = [data objectForKey:@"hasSignUp"];
    //活动数据
    NSDictionary *activity = [data objectForKey:@"activity"];
    _detailModel = [JGTeamAcitivtyModel modelWithDictionary:activity];
    //开始时间
    ActivityDetailModel *beginModel = [[ActivityDetailModel alloc] init];
    beginModel.iconStr = @"icn_time";
    NSString *begainTime = [Helper stringFromDateString:_detailModel.beginDate withFormater:@"yyyy年MM月dd日HH时mm分"];
    beginModel.desc = [NSString stringWithFormat:@"开球时间：%@",begainTime];
    [self.dataArray addObject:beginModel];
    //截止时间
    ActivityDetailModel *singupEndModel = [[ActivityDetailModel alloc] init];
    singupEndModel.iconStr = @"icn_registration";
    NSString *endTime = [Helper stringFromDateString:_detailModel.signUpEndTime withFormater:@"yyyy年MM月dd日"];
    singupEndModel.desc = [NSString stringWithFormat:@"报名截止：%@",endTime];
    [self.dataArray addObject:singupEndModel];
    //活动地址
    ActivityDetailModel *addressModel = [[ActivityDetailModel alloc] init];
    addressModel.iconStr = @"icn_address";
    addressModel.desc = [NSString stringWithFormat:@"活动地址：%@",_detailModel.ballAddress];
    [self.dataArray addObject:addressModel];
    //参赛费用
    NSArray *costList = [data objectForKey:@"costList"];
    _priceArray = [NSArray arrayWithArray:costList];
    
    ActivityDetailModel *costModel = [[ActivityDetailModel alloc] init];
    if (costList.count == 0) {
        costModel.isEmpty = true;
    }else{        
        costModel.iconStr = @"icn_preferential";
        costModel.desc = @"参赛费用";
    }
    [self.dataArray addObject:costModel];
    
    for (NSDictionary *dict in costList) {
        ActivityDetailModel *costDetailModel = [[ActivityDetailModel alloc] init];
        costDetailModel.price = [NSString stringWithFormat:@"%@",[dict objectForKey:@"money"]];
        costDetailModel.desc = [NSString stringWithFormat:@"%@ %@元/人",[dict objectForKey:@"costName"],costDetailModel.price];
        [self.dataArray addObject:costDetailModel];
    }
    //活动说明
    ActivityDetailModel *nodeModel = [[ActivityDetailModel alloc] init];
    if (_detailModel.info.length>0) {
        nodeModel.iconStr = @"icn_event_details";
        nodeModel.desc = @"活动说明";
    }else{
        nodeModel.isEmpty = true;
    }
    [self.dataArray addObject:nodeModel];
    
    //活动开始之后按钮变化
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDateStr = [inputFormatter stringFromDate:nowDate];
    //当前时间与报名截止时间
    NSComparisonResult signUpEndResult = [nowDateStr compare:_detailModel.signUpEndTime];
    //当前时间与开始时间
    NSComparisonResult beginResult = [nowDateStr compare:_detailModel.beginDate];
    //当前时间与结束时间
    NSComparisonResult endresult = [nowDateStr compare:_detailModel.endDate];
    //底部按钮变化
    NSDictionary *signup = [data objectForKey:@"signup"];
    //按钮标题
    NSString *titleStr = [NSString string];
    if (signup) {
        _signupTimeKey = [signup objectForKey:@"timeKey"];
        NSString *stateButtonString = [signup objectForKey:@"stateButtonString"];
        if ([stateButtonString isEqualToString:@"报名中"]) {
            titleStr = @"取消报名（审核中）";
            _bottomBtnTag = 1;
        }else if ([stateButtonString isEqualToString:@"已通过"]){
            titleStr = @"退出活动（审核通过）";
            _bottomBtnTag = 2;
        }else if ([stateButtonString isEqualToString:@"已拒绝"]){
            titleStr = @"再次报名（审核未通过）";
            _bottomBtnTag = 3;
        }
        if (beginResult == NSOrderedDescending) {
            if (endresult == NSOrderedAscending) {
                //报名截止到开球时间
                _bottomBtnTag = 4;
                titleStr = @"查看成绩";
            }else if (endresult == NSOrderedDescending){
                //开球到结束时间
                _bottomBtnTag = 5;
                titleStr = [NSString string];
            }
        }
    }else{
        if (signUpEndResult == NSOrderedDescending) {
            titleStr = [NSString string];
            _bottomBtnTag = 6;
        }else{
            titleStr = @"报名参加";
            _bottomBtnTag = 0;
        }
    }
    [self createBottomBtn:titleStr];
    //允许报名最大人数
    _maxGroup = _detailModel.maxCount;
}
//判断数据是否全部填充,全部填充之后按钮可点
-(void)boolAlldataInput{
    NSInteger inputNum = self.importDict.allValues.count;
    UIButton *sendBtn =[self.view viewWithTag:108];
    [sendBtn setBackgroundColor:RGB(210, 210, 210)];
    sendBtn.selected = false;
    sendBtn.enabled = false;
    for (NSString *velue in self.importDict.allValues) {
        if (velue.length==0) {
            inputNum--;
        }
    }
    
    if (inputNum == 5) {
        sendBtn.selected = true;
        sendBtn.enabled = true;
        [sendBtn setBackgroundColor:RGB(243,152,0)];
    }
}
//提交报名数据
-(void)sendPlayerData{
    [MobClick event:@"findactivity_applysend_click"];
    
    //报名类型 0：球员 1：嘉宾
    NSString *isTeamMenber = [self.importDict objectForKey:@"type"];
    //设备id
    NSString * uuid= [FCUUID getUUID];
    //分组id
    NSString *teamKey = [NSString stringWithFormat:@"%ld",_detailModel.teamKey];
    //请求数据源
    NSDictionary *dict = [NSDictionary dictionary];
    //报名用户信息
    NSDictionary *info = @{
                           @"teamKey":teamKey,
                           @"activityKey":_activityKey,
                           @"userName":DEFAULF_UserName,
                           @"userKey":DEFAULF_USERID,
                           @"timeKey":@0,
                           };
    //被报名用户信息
    NSMutableDictionary *teamSignUpListInfo = [NSMutableDictionary dictionaryWithDictionary:
                                        @{
                                         @"sex":[_importDict objectForKey:@"sex"],
                                         @"almost":[_importDict objectForKey:@"almost"],
                                         @"mobile":[_importDict objectForKey:@"mobile"],
                                         @"name":[_importDict objectForKey:@"name"],
                                         @"isOnlinePay":@0,
                                         @"userKey":DEFAULF_USERID,
                                         @"userType":@"0",
                                         }];
    //请求的链接
    NSString *urlStr = [NSString string];
    if ([isTeamMenber isEqualToString:@"1"]) {
        dict = @{
                 @"userKey":DEFAULF_USERID,
                 @"activityKey":_activityKey,
                 @"signup":teamSignUpListInfo,
                 };
        urlStr = @"team/doTeamActivitySignupRequestJoinTeam";
    }else{
        [teamSignUpListInfo setValue:@1 forKey:@"userType"];
        dict = @{
                 @"teamSignUpList":@[teamSignUpListInfo],
                 @"srcType":@1,
                 @"info":info,
                 @"deviceID":uuid
                 };
        urlStr = @"team/doTeamActivitySignUp";
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"报名中..." FromView:self.view];
    [[JsonHttp jsonHttp] httpRequestWithMD5:urlStr JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        NSString *packResultMsg = [data objectForKey:@"packResultMsg"];
        BOOL packSucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSucess) {
            _off = 0;
            [self initMainData];
            [self initPlayerData];
        }
        if (!packResultMsg) {
            packResultMsg = @"报名成功";
        }
        [[ShowHUD showHUD] showLinesToastWithText:packResultMsg FromView:self.view];

            [self.importDict removeAllObjects];
            [_alertView removeAllSubviews];
            [_alertView removeFromSuperview];
            [_alapView removeFromSuperview];
    }];

}
//取消报名
-(void)abolish{
    [[ShowHUD showHUD]showAnimationWithText:@"取消中..." FromView:self.view];
    NSDictionary *dict = @{
                           @"signupKeyList":@[_signupTimeKey],
                           @"activityKey":_activityKey
                           };
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doUnSignUpTeamActivity" JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [LQProgressHud showMessage:@"取消报名成功！"];
            [self initMainData];
            [self initPlayerData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}
//退出活动
-(void)exitActivity{
    [[ShowHUD showHUD]showAnimationWithText:@"退出中..." FromView:self.view];

    NSDictionary *dict = @{
                           @"signupKeyList":@[_signupTimeKey],
                           @"activityKey":_activityKey
                           };
    
    [[JsonHttp jsonHttp]httpRequest:@"team/doUnSignUpTeamActivity" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [LQProgressHud showMessage:@"成功退出！"];
            [self initPlayerData];
            [self initMainData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showLinesToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

#pragma mark - Action
//返回
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:true];
}
//分享
-(void)shareBtnClick{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    
    [self.view addSubview:alert];
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}
// 拨打电话
- (void)telPhotoClick:(UIButton *)btn{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", _detailModel.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//点击头像进入球队
-(void)headerImageClick{
    JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
    newTeamVC.timeKey = [NSNumber numberWithInteger:_detailModel.teamKey];
    [self.navigationController pushViewController:newTeamVC animated:YES];
}
//查看分组
-(void)viewGroup{
    JGTeamDeatilWKwebViewController *WKCtrl = [[JGTeamDeatilWKwebViewController alloc]init];
    NSString *str = [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%@&userKey=%@dagolfla.com",_detailModel.teamKey, self.activityKey, DEFAULF_USERID]];
    
    WKCtrl.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/group.html?teamKey=%td&activityKey=%@&userKey=%@&md5=%@", _detailModel.teamKey, self.activityKey, DEFAULF_USERID, str];
    NSString *playerCountStr = [NSString stringWithFormat:@"%ld",(long)self.playerDataArray.count];
    WKCtrl.teamName = [NSString stringWithFormat:@"活动总人数(%@人)", playerCountStr];
    WKCtrl.isShareBtn = 1;
    WKCtrl.activeTimeKey = [self.activityKey integerValue];
    WKCtrl.activeName = _titleLabel.text;
    WKCtrl.teamKey = _detailModel.teamKey;
    [self.navigationController pushViewController:WKCtrl animated:YES];
    
}


//底部按钮点击
-(void)bootmCLick{
    switch (_bottomBtnTag) {
        case 0:{
            if (_isTeamNumber) {
                NSString *sex = [NSString stringWithFormat:@"%@",[UserDefaults objectForKey:@"sex"]];
                NSString *almost = [NSString stringWithFormat:@"%@",[UserDefaults objectForKey:@"almost"]];
                if (almost.length==0) {
                    almost = @"-10000";
                }
                NSString *mobile = [UserDefaults objectForKey:Mobile];
                NSString *name = [UserDefaults objectForKey:UserName];
                //填写报名资料
                _importDict = [NSMutableDictionary dictionary];
                [_importDict setValue:sex forKey:@"sex"];
                [_importDict setValue:almost forKey:@"almost"];
                [_importDict setValue:mobile forKey:@"mobile"];
                [_importDict setValue:name forKey:@"name"];
                
                [self sendPlayerData];
            }else{
                [self createFillView];
            }
        }break;
        case 1:
            //取消报名
            [self abolish];
            break;
        case 2:{
            __weak typeof(self) weakself = self;
            //退出活动
            UIAlertController *quitAlertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认退出活动" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancellAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself exitActivity];
            }];
            [quitAlertView addAction:cancellAction];
            [quitAlertView addAction:sureAction];
            [self presentViewController:quitAlertView animated:YES completion:nil];
        }break;
        case 3:
            //再次报名
            [self createFillView];
            break;
        case 4:
            //查看成绩
            [self viewProgress];
            break;
        case 5:
            //活动结束
            return;
            break;
        default:
            break;
    }
}
//查看成绩
-(void)viewProgress{
    if (_hasReleaseScore == 0) {
        //记分直播
        [MobClick event:@"team_activity_grade_click"];
        JGLScoreLiveViewController *scoreLiveCtrl = [[JGLScoreLiveViewController alloc]init];
        scoreLiveCtrl.activity = [NSNumber numberWithString:_activityKey];
        [self.navigationController pushViewController:scoreLiveCtrl animated:YES];
    }else{
        JGLScoreRankViewController *rankCtrl = [[JGLScoreRankViewController alloc]init];
        rankCtrl.activity = [NSNumber numberWithString:_activityKey];
        rankCtrl.teamKey = [NSNumber numberWithInteger:_detailModel.teamKey];
        [self.navigationController pushViewController:rankCtrl animated:YES];
    }
}

//关闭报名资料界面
-(void)closeAlertView{
    [MobClick event:@"findactivity_applycancel_click"];
    [self.importDict removeAllObjects];
    [_alertView removeAllSubviews];
    [_alertView removeFromSuperview];
    [_alapView removeFromSuperview];
}
//性别选择
-(void)sexBtnSelect:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    btn.selected = true;
    NSInteger otherBtnTag = 104;
    if (btn.tag==104) {
        otherBtnTag = 105;
    }
    UIButton *otherBtn =[self.view viewWithTag:otherBtnTag];
    otherBtn.selected = false;
    
    NSString *velue = [NSString stringWithFormat:@"%ld",otherBtnTag-104];
    [self.importDict setValue:velue forKey:@"sex"];
    [self boolAlldataInput];
}
//选择球员类型
-(void)playerTypeBtnSelect:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    btn.selected = true;
    NSInteger otherBtnTag = 106;
    if (btn.tag==106) {
        otherBtnTag = 107;
    }
    UIButton *otherBtn =[self.view viewWithTag:otherBtnTag];
    otherBtn.selected = false;
    
    NSString *velue = [NSString stringWithFormat:@"%ld",otherBtnTag-106];
    [self.importDict setValue:velue forKey:@"type"];
    [self boolAlldataInput];
}
//提交
-(void)sendBtnClick{
    [self sendPlayerData];
}




#pragma mark - UITableviewDelegate&&Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return 0;
    }
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return _priceArray.count+1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return self.playerDataArray.count + 1;
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailModel *model = [self formtData:indexPath];
    if (model.isEmpty) {
        return 0;
    }
    if (indexPath.section == 3) {
        return kHvertical(50);
    }
    if (indexPath.section==1&&indexPath.row>0) {
        return kHvertical(36);
    }
    return kHvertical(45);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return kHvertical(197);
    }
    ActivityDetailModel *model = [self formtData:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (model.isEmpty) {
        return 0.1;
    }
    return kHvertical(10);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //数据模型
    ActivityDetailModel *model = [self formtData:indexPath];
    if (indexPath.section==3&&indexPath.row>0) {
        //球员列表cell
        ActivityDetailListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailListTableViewCellID"];
        [listCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        model = self.playerDataArray[indexPath.row-1];
        [listCell configModel:model];
        return listCell;
    }
    //详情cell
    ActivityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailTableViewCellID"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell configModel:model];
    [cell.viewGroup addTarget:self action:@selector(viewGroup) forControlEvents:UIControlEventTouchUpInside];
    cell.hidden = false;
    if (model.isEmpty) {
        cell.hidden = true;
    }
    return cell;
}
//格式化cell的数据
-(ActivityDetailModel *)formtData:(NSIndexPath *)indexPath{
    
    ActivityDetailModel *model = [[ActivityDetailModel alloc] init];
    switch (indexPath.section) {
        case 0:
            model = self.dataArray[indexPath.row];
            break;
        case 1:
            model = self.dataArray[indexPath.row+3];
            break;
        case 2:
            model = self.dataArray[indexPath.row+_priceArray.count+4];
            break;
        case 3:{
            if (indexPath.row==0) {
                NSString *playerCountStr = [NSString stringWithFormat:@"%ld",(long)self.playerDataArray.count];
                NSString *descStr = [NSString stringWithFormat:@"( %@人 )",playerCountStr];
                if (_maxGroup>0) {
                    descStr = [NSString stringWithFormat:@"（ %@/%ld人 ）",playerCountStr,(long)_maxGroup];
                }
                model.activityPlayer = descStr;
                model.iconStr = @"icn_event_group";
                model.desc = [NSString stringWithFormat:@"活动成员列表%@",descStr];
            }else{
                model = self.playerDataArray[indexPath.row-1];
            }
        }break;
        default:
            break;
    }
    return model;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, screenWidth, kHvertical(10))];
    if (section==0) {
        headerView.frame = CGRectMake(0, 0, screenWidth, kHvertical(197));
        //头部照片
        _headerImageView = [Factory createImageViewWithFrame:CGRectMake(0, 0, screenWidth, kHvertical(187)) Image:nil];
        [headerView addSubview:_headerImageView];
        [_headerImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_detailModel.timeKey integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        //渐变图
        _gradientImage = [Factory createImageViewWithFrame:CGRectMake(0, 0, screenWidth, _headerImageView.height) Image:[UIImage imageNamed:@"backChange"]];
        [headerView addSubview:_gradientImage];
        //球队图片
        UIImageView *teamImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(111), kHvertical(62), kHvertical(62)) Image:nil];
        teamImageView.layer.masksToBounds = true;
        teamImageView.layer.cornerRadius = kHvertical(5);
        [headerView addSubview:teamImageView];
        [teamImageView sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_detailModel.teamKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageClick)];
        teamImageView.userInteractionEnabled = true;
        headerView.userInteractionEnabled = true;
        [teamImageView addGestureRecognizer:tap];
        //球队名
        NSString *teamNameStr = self.detailModel.ballName;
        UILabel *teamName = [Factory createLabelWithFrame:CGRectMake(teamImageView.x_width + kWvertical(5), kHvertical(150), screenWidth - teamImageView.x_width - kWvertical(30), kHvertical(22)) textColor:WhiteColor fontSize:kHvertical(14) Title:teamNameStr];
        [headerView addSubview:teamName];
    }
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (_detailModel.info.length == 0) {
            return;
        }
        ActivityExplainDetailViewController *vc = [[ActivityExplainDetailViewController alloc] init];
        vc.title = self.titleLabel.text;
        vc.contentStr = _detailModel.info;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITextFeildDelegate
-(void)textFieldChange:(UITextField *)textField{
    NSString *textFieldStr = textField.text;
    NSString *key = [NSString string];
    switch (textField.tag) {
        case 100:
            key = @"name";
            break;
        case 102:
            key = @"almost";
            break;
        case 103:
            key = @"mobile";
            break;
            
        default:
            break;
    }
    [self.importDict setValue:textFieldStr forKey:key];
    [self boolAlldataInput];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat yOffset = self.mainTableView.contentOffset.y;
    CGFloat factor = screenWidth + ABS(yOffset);
    if (yOffset < 0&&self.dataArray.count>0) {
        CGRect f = CGRectMake(-(factor-screenWidth)/2, -ABS(yOffset), factor, kHvertical(187)+ABS(yOffset));
        self.headerImageView.frame = f;
        self.gradientImage.frame = f;
    }
    
    _navagationBackView.alpha = yOffset/64;

}

#pragma mark - 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
    if ([_detailModel.timeKey integerValue] == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_detailModel.teamActivityKey andIsSetWidth:YES andIsBackGround:YES]];
        NSString *md5String = [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%td&userKey=%@dagolfla.com", _detailModel.teamKey, _detailModel.teamActivityKey, DEFAULF_USERID]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?teamKey=%td&activityKey=%td&userKey=%@&share=1&md5=%@", _detailModel.teamKey, _detailModel.teamActivityKey, DEFAULF_USERID, md5String];
    }else{
        NSString *md5String = [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%@&userKey=%@dagolfla.com", _detailModel.teamKey, _detailModel.timeKey, DEFAULF_USERID]];
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_detailModel.timeKey integerValue]andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?teamKey=%td&activityKey=%@&userKey=%@&share=1&md5=%@", _detailModel.teamKey, _detailModel.timeKey, DEFAULF_USERID, md5String];
    }
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@报名", _detailModel.name];
    
    NSString *shaderString = @"";
    //默认
    shaderString = [NSString stringWithFormat:@"活动场地：%@，活动时间：%@", _detailModel.ballName,_detailModel.beginDate];
    
    if (_priceArray.count >0) {
        //存在费用设置
        for (NSDictionary *priceDict in _priceArray) {
            shaderString = [shaderString stringByAppendingString:[NSString stringWithFormat:@"，%@：%@元", [priceDict objectForKey:@"costName"], [priceDict objectForKey:@"money"]]];
        }
        
        if ([_detailModel.subsidyPrice integerValue] > 0) {
            //存在补贴
            shaderString = [shaderString stringByAppendingString:[NSString stringWithFormat:@"，平台补贴：%@元", _detailModel.subsidyPrice]];
        }
    }
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shaderString image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shaderString image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
