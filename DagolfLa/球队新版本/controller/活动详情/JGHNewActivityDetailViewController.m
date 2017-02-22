//
//  JGHNewActivityDetailViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityDetailViewController.h"
#import "JGHNewTeamApplyViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "BallParkViewController.h"
#import "JGHCostListTableViewCell.h"
#import "JGTeamActivityViewController.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "JGTeamGroupViewController.h"

#import "JGActivityMemNonMangerViewController.h"
#import "JGLActiveCancelMemViewController.h"
#import "JGLPaySignUpViewController.h"
#import "JGLActiveCancelMemViewController.h"
#import "JGLPresentAwardViewController.h"
#import "JGLScoreLiveViewController.h"
#import "JGLScoreRankViewController.h"
#import "JGLActivityMemberSetViewController.h"
#import "JGHNewActivityCell.h"
#import "JGHActivityAllCell.h"
#import "JGHActivityInfoCell.h"
#import "JGHNewCancelApplyViewController.h"

static NSString *const JGHCostListTableViewCellIdentifier = @"JGHCostListTableViewCell";
static NSString *const JGHNewActivityCellIdentifier = @"JGHNewActivityCell";
static NSString *const JGHActivityAllCellIdentifier = @"JGHActivityAllCell";
static NSString *const JGHActivityInfoCellIdentifier = @"JGHActivityInfoCell";


static CGFloat ImageHeight  = 210.0;

@interface JGHNewActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource, JGLActivityMemberSetViewControllerDelegate, JGHActivityAllCellDelegate>
{
    NSInteger _isTeamMember;//是否是球队成员 1 － 不是
    NSString *_userName;//用户在球队的真实姓名
    
    id _isApply;//是否已经报名0未，1已
    
    NSString *_power;//权限
    
    UIButton *_viewResultsBtn;//查看成绩
    
    NSInteger _hasReleaseScore;//是否公布成绩0，1-已公布
    
    NSInteger _canSubsidy;//是否补贴-0不
    
    NSString* _strShare;
    
    UIImageView *_gradientImage;//渐变图
    
    NSArray *_titleArray;
    NSArray *_imageArray;
}

@property (nonatomic, strong)UITableView *teamActibityNameTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源
//@property (nonatomic, strong)NSMutableArray *subDataArray;//费用说明数据源
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UILabel *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, strong)NSDictionary *teamMemberDic;

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (nonatomic, strong)NSMutableArray *costListArray;//报名资费列表

@end

@implementation JGHNewActivityDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setData{
    self.titleField.text = self.model.name;
    self.addressBtn.hidden = NO;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15*ProportionAdapter]};
    CGSize size = [self.model.ballName boundingRectWithSize:CGSizeMake(screenWidth - 100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect address = self.addressBtn.frame;
    self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25);
    [self.addressBtn setTitle:self.model.ballName forState:UIControlStateNormal];
    
    if (_model.teamActivityKey == 0) {
        //我的球队活动
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_model.teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    }else{
        //球队活动
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:_model.teamKey andIsSetWidth:YES andIsBackGround:NO] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    }
    
    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    self.imgProfile.layer.masksToBounds = YES;
}

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        //        self.subDataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        self.costListArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleArray = @[@"参赛费用", @"活动成员及分组", @"查看成绩", @"查看奖项", @"活动说明"];
    _imageArray = @[@"icn_preferential", @"icn_event_group1", @"icn_event_score", @"icn_awards", @"icn_event_details"];
    
    //监听分组页面返回，刷新数据
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadActivityData:) name:@"reloadActivityData" object:nil];
    
    self.imgProfile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TeamBGImage]];
    self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
    self.imgProfile.userInteractionEnabled = YES;
    self.teamActibityNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44)];

    UINib *costListNib = [UINib nibWithNibName:@"JGHCostListTableViewCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:costListNib forCellReuseIdentifier:JGHCostListTableViewCellIdentifier];
    
    [self.teamActibityNameTableView registerClass:[JGHNewActivityCell class] forCellReuseIdentifier:JGHNewActivityCellIdentifier];
    
    [self.teamActibityNameTableView registerClass:[JGHActivityAllCell class] forCellReuseIdentifier:JGHActivityAllCellIdentifier];
    
    UINib *activityInfoCellNib = [UINib nibWithNibName:JGHActivityInfoCellIdentifier bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:activityInfoCellNib forCellReuseIdentifier:JGHActivityInfoCellIdentifier];
    
    self.teamActibityNameTableView.dataSource = self;
    self.teamActibityNameTableView.delegate = self;
    self.teamActibityNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.teamActibityNameTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.teamActibityNameTableView];
    [self.view addSubview:self.imgProfile];
    
    //渐变图
    _gradientImage = [[UIImageView alloc]initWithFrame:self.imgProfile.frame];
    [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
    [self.imgProfile addSubview:_gradientImage];
    
    //顶部图
    self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.imgProfile addSubview:self.titleView];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    
    //活动名称输入框
    self.titleField = [[UILabel alloc]initWithFrame:CGRectMake(64, 17, screenWidth - 128, 30)];
    self.titleField.text = _model.name;
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:16 * screenWidth / 320];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 135, 65, 65)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:TeamLogoImage] forState:UIControlStateNormal];
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.tag = 740;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    //地址
    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(85, 180, 70, 25)];
    self.addressBtn.tag = 333;
    [self.addressBtn setTitle:@"地址" forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.imgProfile addSubview:self.addressBtn];
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(screenWidth-44, self.titleField.frame.origin.y, 44, 25);
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    
    [shareBtn addTarget:self action:@selector(addShare) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTintColor:[UIColor whiteColor]];
    [self.titleView addSubview:shareBtn];
    
    [self dataSet];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 下载数据 －－－
- (void)dataSet{
    if (![self.view.subviews containsObject:(UIView *)[ShowHUD showHUD]]) {
        [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(_teamKey) forKey:@"activityKey"];
    
    [dict setValue:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"error");
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        _isApply = [data objectForKey:@"hasSignUp"];//是否报名
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            _hasReleaseScore = [[data objectForKey:@"hasReleaseScore"] integerValue];
            //是否补贴
            _canSubsidy = [[data objectForKey:@"canSubsidy"] integerValue];
            //费用列表
            if (self.costListArray != nil) {
                self.costListArray = [NSMutableArray arrayWithArray:self.costListArray];
                [self.costListArray removeAllObjects];
            }
            
            self.costListArray = [data objectForKey:@"costList"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            if ([data objectForKey:@"teamMember"]) {
                dict = [data objectForKey:@"teamMember"];
                self.teamMemberDic = dict;
                _userName = [dict objectForKey:@"userName"];//获取用户在球队的真实姓名
                if ([dict objectForKey:@"power"]) {
                    _power = [dict objectForKey:@"power"];
                }
            }else{
                _isTeamMember = 1;//非球队成员
                [self.applyBtn setBackgroundColor:[UIColor lightGrayColor]];
            }
            
            [self.model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
            
            [self setData];//设置名称 及 图片
            if ([[Helper returnCurrentDateString] compare:_model.endDate] < 0) {
                if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] < 0) {
                    if ([_isApply integerValue] == 0) {
                        [self createApplyBtn:0];//报名按钮
                    }else{
                        [self createCancelBtnAndApplyOrPay:0];//已报名
                    }
                }else{
                    //判断活动是否结束 endDate
                    if ([[Helper returnCurrentDateString] compare:_model.endDate] < 0) {
                        if ([_isApply integerValue] == 0) {
                            self.teamActibityNameTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                        }else{
                            [self createCancelBtnAndApplyOrPay:1];//已报名
                        }
                    }else{
                        self.teamActibityNameTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                    }
                }
            }else{
                self.teamActibityNameTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
            }
            
            [self.teamActibityNameTableView reloadData];
        }else{
            
        }
    }];
}
#pragma mark -分享
- (void)addShare{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        
        [self.titleView addSubview:alert];
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index];
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [alert show];
        }];
    }else {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}
#pragma mark -- 跳转分组页面
- (void)pushGroupCtrl:(UIButton *)btn{
    JGTeamGroupViewController *teamCtrl = [[JGTeamGroupViewController alloc]init];
    
    if (_model.teamActivityKey == 0) {
        teamCtrl.teamActivityKey = [_model.timeKey integerValue];
    }else{
        teamCtrl.teamActivityKey = _model.teamActivityKey;
    }
    
    [self.navigationController pushViewController:teamCtrl animated:YES];
}
#pragma mark -- 返回
- (void)initItemsBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 退出活动
- (void)createCancelBtnAndApplyOrPay:(NSInteger)applercatory{
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
    [photoBtn setImage:[UIImage imageNamed:@"consulting"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(telPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UIButton *cancelApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width, screenHeight-44, screenWidth - 75 *ScreenWidth/375, 44)];
    [cancelApplyBtn setTitle:@"退出活动" forState:UIControlStateNormal];
    cancelApplyBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    if (applercatory == 0) {
        cancelApplyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        [cancelApplyBtn addTarget:self action:@selector(cancelApplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cancelApplyBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self.view addSubview:cancelApplyBtn];
}
#pragma mark -- 退出活动
- (void)cancelApplyBtnClick:(UIButton *)btn{
    
    JGHNewCancelApplyViewController *cancelApplyCtrl = [[JGHNewCancelApplyViewController alloc]init];
    if (_model.teamActivityKey == 0) {
        //球队活动
        cancelApplyCtrl.activityKey = [_model.timeKey integerValue];
    }else{
        //我的球队
        cancelApplyCtrl.activityKey = _model.teamActivityKey;
    }
    
    cancelApplyCtrl.model = _model;
    [self.navigationController pushViewController:cancelApplyCtrl animated:YES];
}
#pragma mark -- 创建报名按钮
- (void)createApplyBtn:(NSInteger)btnID{
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
    
    [photoBtn addTarget:self action:@selector(telPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(photoBtn.frame.origin.x, photoBtn.frame.size.width, 1, 44)];
    lines.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lines];
    self.applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width + 1, screenHeight-44, screenWidth - 75 *ScreenWidth/375, 44)];
    [self.applyBtn setTitle:@"报名参加" forState:UIControlStateNormal];
    self.applyBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [self.applyBtn addTarget:self action:@selector(applyAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.applyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    [photoBtn setImage:[UIImage imageNamed:@"consulting"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.applyBtn];
}
#pragma mark -- 过期－报名
- (void)applyNoAttendBtnClick:(UIButton *)btn{
    [[ShowHUD showHUD]showToastWithText:@"该活动已截止报名！" FromView:self.view];
    return;
}
#pragma mark -- 报名参加
- (void)applyAttendBtnClick:(UIButton *)btn{
    //判断活动是否结束报名
    if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] >= 0) {
        [[ShowHUD showHUD]showToastWithText:@"该活动已截止报名！" FromView:self.view];
    }else{
        //判断是不改球队成员
        if (_isTeamMember == 1) {
            [[ShowHUD showHUD]showToastWithText:@"您不是该球队队员！" FromView:self.view];
        }else{
            JGHNewTeamApplyViewController *teamApplyCtrl = [[JGHNewTeamApplyViewController alloc] init];
            teamApplyCtrl.modelss = self.model;
            teamApplyCtrl.userName = _userName;
            teamApplyCtrl.isApply = (BOOL)[_isApply floatValue];
            teamApplyCtrl.teamMember = self.teamMemberDic;
            [self.navigationController pushViewController:teamApplyCtrl animated:YES];
        }
    }
}
#pragma mark -- 拨打电话
- (void)telPhotoClick:(UIButton *)btn{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", _model.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        //参赛费用列表
        NSLog(@"%td", _costListArray.count + 1);
        return _costListArray.count;
    }else if (section == 6){
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;//详情页面
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 30*ProportionAdapter;
    }else if (indexPath.section == 6){
        static JGHActivityInfoCell *cell;
        if (!cell) {
            cell = [self.teamActibityNameTableView dequeueReusableCellWithIdentifier:JGHActivityInfoCellIdentifier];
        }
        
        cell.infoLable.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3 || section == 4 || section == 6) {
        return 0;
    }
    return 10*ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ImageHeight;
    }else if (section == 1){
        return 132 *ProportionAdapter;
    }
    return 44*ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        JGHCostListTableViewCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListTableViewCellIdentifier];
        costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_costListArray.count > 0) {
            [costListCell configCostData:_costListArray[indexPath.row]];
        }
        
        return costListCell;
    }else if (indexPath.section == 6){
        JGHActivityInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityInfoCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        infoCell.infoLable.text = _model.info;
        return infoCell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *windowReuseIdentifier = @"SectionOneCell";
    if (section == 0) {
        UITableViewCell *launchImageActivityCell = nil;
        launchImageActivityCell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!launchImageActivityCell) {
            
            launchImageActivityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
        }
        
        launchImageActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return (UIView *)launchImageActivityCell;
    }else if (section == 1) {
        JGHNewActivityCell *addressCell = [tableView dequeueReusableCellWithIdentifier:JGHNewActivityCellIdentifier];
        [addressCell configJGTeamAcitivtyModel:_model];
        return (UIView *)addressCell;
    }else{
        JGHActivityAllCell *activityCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityAllCellIdentifier];
        activityCell.clickBtn.tag = 100 +section;
        activityCell.delegate = self;
        if (section == 2 || section == 6) {
            activityCell.accessoryType = UITableViewCellAccessoryNone;
            if (section == 6) {
                activityCell.line.hidden = YES;
            }
        }else{
            activityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (section == 3) {
            NSString *group = [NSString stringWithFormat:@"活动成员及分组(%td/%td)", self.model.sumCount, self.model.maxCount];
            
            [activityCell configImageName:_imageArray[section -2] withName:group];
        }else{
            [activityCell configImageName:_imageArray[section -2] withName:_titleArray[section -2]];
        }
        
        return (UIView *)activityCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 查看奖项
- (void)getTeamActivityAward:(UIButton *)btn{
    if (_isTeamMember == 1) {
        [[ShowHUD showHUD]showToastWithText:@"您不是该球队队员！" FromView:self.view];
        return;
    }
    
    JGLPresentAwardViewController *prizeCtrl = [[JGLPresentAwardViewController alloc]init];
    prizeCtrl.activityKey = _teamKey;
    prizeCtrl.teamKey = _model.teamKey;
    if ([_power containsString:@"1001"]) {
        prizeCtrl.isManager = 1;
    }else{
        prizeCtrl.isManager = 0;
    }
    
    prizeCtrl.model = _model;
    [self.navigationController pushViewController:prizeCtrl animated:YES];
}
#pragma mark -- 查看成绩
- (void)getTeamActivityResults:(UIButton *)btn{
    if (_isTeamMember == 1) {
        [[ShowHUD showHUD]showToastWithText:@"您不是该球队队员！" FromView:self.view];
        return;
    }
    
    if (_hasReleaseScore == 0) {
        //记分直播
        JGLScoreLiveViewController *scoreLiveCtrl = [[JGLScoreLiveViewController alloc]init];
        scoreLiveCtrl.activity = [NSNumber numberWithInteger:_teamKey];
        //        scoreLiveCtrl.model = _model;
        //        scoreLiveCtrl.teamKey = [NSNumber numberWithInteger:_teamKey];
        [self.navigationController pushViewController:scoreLiveCtrl animated:YES];
    }else{
        JGLScoreRankViewController *rankCtrl = [[JGLScoreRankViewController alloc]init];
        rankCtrl.activity = [NSNumber numberWithInteger:_teamKey];
        rankCtrl.teamKey = [NSNumber numberWithInteger:_model.teamKey];
        [self.navigationController pushViewController:rankCtrl animated:YES];
    }
}
#pragma mark -- 详情页面
- (void)pushDetailSCtrl:(UIButton *)btn{
    JGTeamDeatilWKwebViewController *WKCtrl = [[JGTeamDeatilWKwebViewController alloc]init];
    WKCtrl.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamActivityDetails.html?key=%@", _model.timeKey];
    WKCtrl.teamName = @"活动详情";
    [self.navigationController pushViewController:WKCtrl animated:YES];
}
#pragma mark -- 活动成员及分组
- (void)getTeamActivitySignUpList:(UIButton *)btn{
    if (_isTeamMember == 1) {
        [[ShowHUD showHUD]showToastWithText:@"您不是该球队队员！" FromView:self.view];
        return;
    }
    
    NSString *power = nil;
    
    if ([self.teamMemberDic objectForKey:@"power"]) {
        power = [self.teamMemberDic objectForKey:@"power"];
    }
    
    if (power != nil) {
        if ([power containsString:@"1001"]) {
            JGLActivityMemberSetViewController *activityMemberCtrl = [[JGLActivityMemberSetViewController alloc]init];
            activityMemberCtrl.delegate = self;
            
            if (_model.teamActivityKey != 0) {
                activityMemberCtrl.activityKey = [NSNumber numberWithInteger:_model.teamActivityKey];
            }else{
                activityMemberCtrl.activityKey = [NSNumber numberWithInteger:[_model.timeKey integerValue]];
            }
            
            activityMemberCtrl.teamKey = [NSNumber numberWithInteger:_model.teamKey];
            [self.navigationController pushViewController:activityMemberCtrl animated:YES];
        }else{
            [self pushJGActivityMemNonMangerViewController];
        }
    }else{
        [self pushJGActivityMemNonMangerViewController];
    }
    
}
- (void)pushJGActivityMemNonMangerViewController{
    NSInteger timeKey;
    JGActivityMemNonMangerViewController *nonMangerVC = [[JGActivityMemNonMangerViewController alloc] init];
    
    if (_model.teamActivityKey == 0) {
        timeKey = [_model.timeKey integerValue];
    }else{
        timeKey = _model.teamActivityKey;
    }
    nonMangerVC.teamKey = _model.teamKey;
    nonMangerVC.activityKey = [NSNumber numberWithInteger:timeKey];
    nonMangerVC.title = self.model.name;
    nonMangerVC.activityName = self.model.name;
    [self.navigationController  pushViewController:nonMangerVC animated:YES];
}
- (void)newdidselectActivityClick:(UIButton *)btn{
    NSLog(@"newdidselectActivityClick == %td", btn.tag);
    if (btn.tag == 103) {
//        [self pushGroupCtrl:btn];
        [self getTeamActivitySignUpList:btn];
    }
    
    if (btn.tag == 104) {
        [self getTeamActivityResults:btn];
    }
    
    if (btn.tag == 105) {
        [self getTeamActivityAward:btn];
    }
}
#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _teamActibityNameTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight)*screenWidth)/ImageHeight;
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        
        _gradientImage.frame = self.imgProfile.frame;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 0, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset;
        self.titleView.frame = t;
        
        if (yOffset == 0.0) {
            self.headPortraitBtn.hidden = NO;
            self.addressBtn.hidden = NO;
        }
    }
}

#pragma mark --分组页面返回后，刷新数据
- (void)reloadData:(LoadData)block{
    [self dataSet];
}

#pragma mark -- 刷新数据
- (void)reloadActivityData:(id)not{
    
    [self dataSet];
}
#pragma mark -- 添加意向成员返回刷新数据
- (void)reloadActivityMemberData{
    [self dataSet];
}
#pragma mark - 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
    if ([_model.timeKey integerValue] == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES]];
        NSString *md5String = [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%td&userKey=%@dagolfla.com", _model.teamKey, _model.teamActivityKey, DEFAULF_USERID]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?teamKey=%td&activityKey=%td&userKey=%@&share=1&md5=%@", _model.teamKey, _model.teamActivityKey, DEFAULF_USERID, md5String];
    }
    else
    {
        NSString *md5String = [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%@&userKey=%@dagolfla.com", _model.teamKey, _model.timeKey, DEFAULF_USERID]];
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue]andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?teamKey=%td&activityKey=%@&userKey=%@&share=1&md5=%@", _model.teamKey, _model.timeKey, DEFAULF_USERID, md5String];
    }
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@报名", _model.name];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        
        NSString* str = [NSString stringWithFormat:@"活动地址:%@。%@",_model.ballName,_strShare];
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"球队会员：%.2f元，平台补贴：%.2f元，活动地点：%@，活动时间：%@", [_model.memberPrice floatValue],[_model.subsidyPrice floatValue],_model.ballName,_model.beginDate]  image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"球队会员：%.2f元，平台补贴：%.2f元，活动地点：%@，活动时间：%@", [_model.memberPrice floatValue],[_model.subsidyPrice floatValue],_model.ballName,_model.beginDate] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
