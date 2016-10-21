//
//  JGHEventDetailsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEventDetailsViewController.h"
#import "JGHHeaderLabelCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGActivityNameBaseCell.h"
#import "JGHCostListTableViewCell.h"
#import "JGTeamActivityWithAddressCell.h"
#import "JGHEditorEventViewController.h"
#import "JGHPublishEventModel.h"
#import "JGHActivityBaseInfoCell.h"
#import "JGLTeamSignUpSuccViewController.h"
#import "JGLSignSuccFinishViewController.h"
#import "JGHGameRoundsRulesViewController.h"
#import "JGDCheckScoreViewController.h"
#import "JGHGameRoundsRulesViewController.h"

static CGFloat ImageHeight  = 210.0;
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGHCostListTableViewCellIdentifier = @"JGHCostListTableViewCell";
static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGHActivityBaseInfoCellIdentifier = @"JGHActivityBaseInfoCell";
static NSString *const JGHTotalPriceCellIdentifier = @"JGHTotalPriceCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";

@interface JGHEventDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;//标题数组
    
    NSArray *_baseInfoArray;
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
    
    NSInteger _hasHaveTeam;//是否拥有球队
    
    NSInteger _canSubsidy;//是否补贴-0不
    NSArray *_levelArray;
    
    NSInteger _isApply;//是否已经报名
}

@property (nonatomic, strong)UITableView *eventDetailsTableView;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, strong)JGHPublishEventModel *model;

@property (nonatomic, strong)NSMutableArray *costListArray;

@end

@implementation JGHEventDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGHPublishEventModel alloc]init];
        self.costListArray = [NSMutableArray array];
        self.titleView = [[UIView alloc]init];
        
        UIImage *image = [UIImage imageNamed:ActivityBGImage];
        self.model.bgImage = image;
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.eventDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -44)];
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        
        //渐变图
        _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
        [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
        [self.imgProfile addSubview:_gradientImage];
        
        [self.view addSubview:self.eventDetailsTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 10 *ProportionAdapter, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        
        [self.imgProfile addSubview:self.titleView];
        
        UINib *tableViewNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
        [self.eventDetailsTableView registerNib:tableViewNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
        
        UINib *costSubsidiesNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle:[NSBundle mainBundle]];
        [self.eventDetailsTableView registerNib:costSubsidiesNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
        
        UINib *costListNib = [UINib nibWithNibName:@"JGHCostListTableViewCell" bundle:[NSBundle mainBundle]];
        [self.eventDetailsTableView registerNib:costListNib forCellReuseIdentifier:JGHCostListTableViewCellIdentifier];
        
        UINib *addressNib = [UINib nibWithNibName:@"JGTeamActivityWithAddressCell" bundle: [NSBundle mainBundle]];
        [self.eventDetailsTableView registerNib:addressNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
        
        UINib *activityBaseInfoCellNib = [UINib nibWithNibName:@"JGHActivityBaseInfoCell" bundle: [NSBundle mainBundle]];
        [self.eventDetailsTableView registerNib:activityBaseInfoCellNib forCellReuseIdentifier:JGHActivityBaseInfoCellIdentifier];
        
        //JGTeamActivityDetailsCell
        UINib *teamActivityDetailsCellNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle: [NSBundle mainBundle]];
        [self.eventDetailsTableView registerNib:teamActivityDetailsCellNib forCellReuseIdentifier:JGTeamActivityDetailsCellIdentifier];
        
        self.eventDetailsTableView.dataSource = self;
        self.eventDetailsTableView.delegate = self;
        self.eventDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.eventDetailsTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.placeholder = @"请输入赛事名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15 *ProportionAdapter] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.tag = 345;
//    self.titleField.delegate = self;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    [self.titleView addSubview:self.titleField];
    
    _titleArray = @[@"", @"基本信息", @"参赛费用", @"球队比杆排位赛", @"查看报名及分组", @"查看成绩", @"对所有人公开", @"主办方", @"赛事联系人电话", @"赛事说明"];
    
    _baseInfoArray = @[@"开球时间", @"报名截止时间", @"举办场地"];
    
    _levelArray = @[@"对所有人公开", @"仅对参与球队公开", @"仅对参与及被邀请方公开"];
}
#pragma mark -- 设置图片及名称
- (void)setData{
    self.titleField.text = self.model.matchName;
    //我的球队活动
    [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"match" andTeamKey:_model.timeKey andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    
    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    self.imgProfile.layer.masksToBounds = YES;
}
#pragma mark -- 下载数据
- (void)getMatchInfo:(NSInteger)timeKey{
    //30342
    self.timeKey = timeKey;
//    self.timeKey = 30342;
    NSMutableDictionary *getDict = [NSMutableDictionary dictionary];
    [getDict setObject:@(_timeKey) forKey:@"matchKey"];
    [getDict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD5 = [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%td&userKey=%tddagolfla.com", _timeKey, [DEFAULF_USERID integerValue]]];
    [getDict setObject:strMD5 forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getMatchInfo" JsonKey:nil withData:getDict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self.model setValuesForKeysWithDictionary:[data objectForKey:@"match"]];
            _hasHaveTeam = [[data objectForKey:@"hasHaveTeam"]integerValue];
            self.costListArray = [data objectForKey:@"costList"];
            //是否补贴
            if ([data objectForKey:@"canSubsidy"]) {
                _canSubsidy = [[data objectForKey:@"canSubsidy"] integerValue];
            }else{
                _canSubsidy = 0;
            }
            
            [self setData];//设置名称 及 图片
            
            if ([data objectForKey:@"hasSignUp"]) {
                _isApply = [[data objectForKey:@"hasSignUp"] integerValue];
            }else{
                _isApply = 0;
            }
            
            if ([[Helper returnCurrentDateString] compare:_model.endDate] < 0) {
                if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] < 0) {
                    if (_isApply == 0) {
                        [self createApplyBtn:0];//报名按钮
                    }else{
                        [self createCancelBtnAndApplyOrPay:0];//已报名
                    }
                }else{
                    //判断活动是否结束 endDate
                    if ([[Helper returnCurrentDateString] compare:_model.endDate] < 0) {
                        if (_isApply == 0) {
                            self.eventDetailsTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                        }else{
                            [self createCancelBtnAndApplyOrPay:1];//已报名
                        }
                    }else{
                        self.eventDetailsTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                    }
                }
            }else{
                self.eventDetailsTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.eventDetailsTableView reloadData];
    }];
}
#pragma mark -- 取消报名－－报名／支付
- (void)createCancelBtnAndApplyOrPay:(NSInteger)applercatory{
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
    [photoBtn setImage:[UIImage imageNamed:@"consulting"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(telPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UIButton *cancelApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width, screenHeight-44, (screenWidth - 75 *ScreenWidth/375)/2, 44)];
    [cancelApplyBtn setTitle:@"取消报名" forState:UIControlStateNormal];
    cancelApplyBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    if (applercatory == 0) {
        cancelApplyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        [cancelApplyBtn addTarget:self action:@selector(cancelApplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cancelApplyBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    [self.view addSubview:cancelApplyBtn];
    
    UIButton *applyOrPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width + cancelApplyBtn.frame.size.width, screenHeight-44, (screenWidth - 75 *ScreenWidth/375)/2, 44)];
    [applyOrPayBtn setTitle:@"报名／支付" forState:UIControlStateNormal];
    applyOrPayBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    applyOrPayBtn.backgroundColor = [UIColor colorWithHexString:Cancel_Color];
    [applyOrPayBtn addTarget:self action:@selector(applyOrPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:applyOrPayBtn];
}
#pragma mark -- 创建报名按钮
- (void)createApplyBtn:(NSInteger)btnID{
    if ([_model.userKey integerValue] == [DEFAULF_USERID integerValue]) {
        UIButton *editorBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
        [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
        editorBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        editorBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        [editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:editorBtn];
        
        UIButton *invitationBtn = [[UIButton alloc]initWithFrame:CGRectMake(75*screenWidth/375, screenHeight-44, (75*screenWidth/375)-1, 44)];
        [invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
        invitationBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        invitationBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        [invitationBtn addTarget:self action:@selector(inviteTeamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:invitationBtn];
        
        self.applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*75*screenWidth/375, screenHeight-44, screenWidth -2* 75 *ScreenWidth/375, 44)];
        [self.applyBtn setTitle:@"球队报名" forState:UIControlStateNormal];
        self.applyBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        [self.applyBtn addTarget:self action:@selector(applyAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.applyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        
        [self.view addSubview:self.applyBtn];
    }else{
        UIButton *editorBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
        [editorBtn setTitle:@"邀请" forState:UIControlStateNormal];
        editorBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        editorBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        [editorBtn addTarget:self action:@selector(inviteTeamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:editorBtn];
        
        UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(editorBtn.frame.origin.x, editorBtn.frame.size.width, 1, 44)];
        lines.backgroundColor = [UIColor blackColor];
        [self.view addSubview:lines];
        self.applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(editorBtn.frame.size.width + 1, screenHeight-44, screenWidth - 75 *ScreenWidth/375, 44)];
        [self.applyBtn setTitle:@"球队报名" forState:UIControlStateNormal];
        self.applyBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
        [self.applyBtn addTarget:self action:@selector(applyAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.applyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        
        [self.view addSubview:self.applyBtn];
    }
}
#pragma mark -- 邀请
- (void)inviteTeamBtnClick:(UIButton *)btn{
    
}
#pragma mark -- 编辑
- (void)editorBtnClick:(UIButton *)btn{
    JGHEditorEventViewController *editorEventCtrl = [[JGHEditorEventViewController alloc]init];
    [editorEventCtrl configJGHPublishEventModelReloadTable:_model andCostlistArray:_costListArray];
    [self.navigationController pushViewController:editorEventCtrl animated:YES];
}
#pragma mark -- 报名
- (void)applyAttendBtnClick:(UIButton *)btn{
    JGLTeamSignUpSuccViewController *teamSignUpVC = [[JGLTeamSignUpSuccViewController alloc] init];
    teamSignUpVC.matchKey = [NSNumber numberWithInteger:self.timeKey];
    [self.navigationController pushViewController:teamSignUpVC animated:YES];
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }else if (section == 2) {
        //列表
        return _costListArray.count +1;
    }else if (section == 3){
        return 4;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;//详情页面
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 || indexPath.section == 1) {
        return 30 *ProportionAdapter;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3 || section == 4) {
        return 0;
    }
    return 10 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ImageHeight;
    }else if (section == 9){
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.eventDetailsTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        cell.activityDetails.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 44 *ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        JGHActivityBaseInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityBaseInfoCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [infoCell configMatchBaseInfo:_baseInfoArray[indexPath.row] andBaseValue:_model.beginDate andRow:indexPath.row];
        }else if (indexPath.row == 1){
            [infoCell configMatchBaseInfo:_baseInfoArray[indexPath.row] andBaseValue:_model.signUpEndTime andRow:indexPath.row];
        }else{
            [infoCell configMatchBaseInfo:_baseInfoArray[indexPath.row] andBaseValue:_model.ballName andRow:indexPath.row];
        }
        return infoCell;
    }else{
        if (indexPath.row == _costListArray.count) {
            JGActivityNameBaseCell *costSubCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
            costSubCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([_model.subsidyPrice integerValue] > 0 && _canSubsidy == 1) {
                NSLog(@"%.2f", [_model.subsidyPrice floatValue]);
                [costSubCell configCostSubInstructionPriceFloat:[_model.subsidyPrice floatValue]];
            }else{
                [costSubCell configCostSubInstructionPriceFloat:0.0];
            }
            
            return costSubCell;
        }else{
            JGHCostListTableViewCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListTableViewCellIdentifier];
            costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_costListArray.count > 0) {
                [costListCell configMatchCostData:_costListArray[indexPath.row]];
            }
            
            return costListCell;
        }
    }
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
    }else if (section == 9){
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
        return (UIView *)detailsCell;
    }else{
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        [detailsBtn addTarget:self action:@selector(pushSectionDetailSCtrl:) forControlEvents:UIControlEventTouchUpInside];
        detailsBtn.tag = 1000 +section;
        [headerCell addSubview:detailsBtn];
        
        if (section == 6) {
            [headerCell congiftitles:_levelArray[_model.openType]];
        }else if (section == 3){
            headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (_model.matchName == nil) {
                [headerCell congiftitles:_model.matchName];
            }else{
                [headerCell congiftitles:_titleArray[section]];
            }
        }else{
            [headerCell congiftitles:_titleArray[section]];
            if (section == 7) {
                [headerCell configInvoiceIfo:_model.userName];
            }else if (section == 8){
                [headerCell configInvoiceIfo:_model.userMobile];
            }else{
                headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        return (UIView *)headerCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 点击事件
- (void)pushSectionDetailSCtrl:(UIButton *)btn{
    NSLog(@"btn.tag == %td", btn.tag -1000);
    //查看规则
    if (btn.tag -1000 == 3) {
        JGHGameRoundsRulesViewController *roundCtrl = [[JGHGameRoundsRulesViewController alloc]init];
        [self.navigationController pushViewController:roundCtrl animated:YES];
    }
    
    if (btn.tag -1000 == 4) {
        
    }
    
    //查看成绩
    if (btn.tag -1000 == 5) {
        JGDCheckScoreViewController *checkCtrl = [[JGDCheckScoreViewController alloc]init];
        checkCtrl.matchKey = [NSNumber numberWithInteger:_model.timeKey];
        [self.navigationController pushViewController:checkCtrl animated:YES];
    }
}
#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
}
#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = self.eventDetailsTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight)*screenWidth)/ImageHeight;
    if (yOffset < 0) {
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        _gradientImage.frame = self.imgProfile.frame;
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 10 *ProportionAdapter, title.size.width, title.size.height);
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
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
