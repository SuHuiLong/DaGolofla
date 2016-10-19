//
//  JGHEventDetailsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEventDetailsViewController.h"
#import "SXPickPhoto.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHHeaderLabelCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGActivityNameBaseCell.h"
#import "JGHCostListTableViewCell.h"
#import "JGTeamActivityWithAddressCell.h"
#import "JGHEditorEventViewController.h"

static CGFloat ImageHeight  = 210.0;
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGHCostListTableViewCellIdentifier = @"JGHCostListTableViewCell";
static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";

@interface JGHEventDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;//标题数组
    NSInteger _photos;//跳转相册问题
    
    NSMutableDictionary* dictData;
    
    UIImageView *_gradientImage;
}

@property (nonatomic, strong)UITableView *eventDetailsTableView;

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类

@property (nonatomic, strong)UIImage *headerImage;

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UITextField *titleField;//球队名称输入框

@property (nonatomic, strong)UIButton *applyBtn;

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
        
        self.model = [[JGTeamAcitivtyModel alloc]init];
        
        self.pickPhoto = [[SXPickPhoto alloc]init];
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
//    if (self.costListArray == nil) {
//        self.costListArray = [NSMutableArray array];
//    }
    
    _photos = 1;
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //点击更换背景
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-64, 0, 54, 44);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    //输入框
    self.titleField = [[UITextField alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.placeholder = @"请输入赛事名称";
    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.tag = 345;
//    self.titleField.delegate = self;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:15];
    [self.titleView addSubview:self.titleField];
    
    _titleArray = @[@[], @[@"开球时间", @"活动结束时间", @"报名截止时间", @"举办场地"], @[@"玩法设置"], @[@"主办方", @"联系人电话"]];
    
    [self createApplyBtn:0];
    
    [self getMatchInfo];
}
#pragma mark -- 下载数据
- (void)getMatchInfo{
    NSMutableDictionary *getDict = [NSMutableDictionary dictionary];
    [getDict setObject:@(_timeKey) forKey:@"matchKey"];
    [getDict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD5 = [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%td&userKey=%tddagolfla.com", _timeKey, [DEFAULF_USERID integerValue]]];
    [getDict setObject:strMD5 forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"match/getMatchInfo" JsonKey:nil withData:getDict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
}
#pragma mark -- 创建报名按钮
- (void)createApplyBtn:(NSInteger)btnID{
//    self.headPortraitBtn.layer.masksToBounds = YES;
//    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    UIButton *editorBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editorBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    editorBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    [editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editorBtn];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(editorBtn.frame.origin.x, editorBtn.frame.size.width, 1, 44)];
    lines.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lines];
    self.applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(editorBtn.frame.size.width + 1, screenHeight-44, screenWidth - 75 *ScreenWidth/375, 44)];
    [self.applyBtn setTitle:@"报名参加" forState:UIControlStateNormal];
    self.applyBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [self.applyBtn addTarget:self action:@selector(applyAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.applyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    
    [self.view addSubview:self.applyBtn];
}
#pragma mark -- 编辑
- (void)editorBtnClick:(UIButton *)btn{
    JGHEditorEventViewController *editorEventCtrl = [[JGHEditorEventViewController alloc]init];
    [self.navigationController pushViewController:editorEventCtrl animated:YES];
}
#pragma mark -- 报名
- (void)applyAttendBtnClick:(UIButton *)btn{
    
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        //列表
        return 3;
    }else if (section == 3){
        return 4;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;//详情页面
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3 || section == 4) {
        return 0;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ImageHeight;
    }else if (section == 1){
        return 110;
    }else if (section == 9){
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.eventDetailsTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        cell.activityDetails.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        JGActivityNameBaseCell *costSubCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
        costSubCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if ([_model.subsidyPrice integerValue] > 0 && _canSubsidy == 1) {
//            NSLog(@"%.2f", [_model.subsidyPrice floatValue]);
//            [costSubCell configCostSubInstructionPriceFloat:[_model.subsidyPrice floatValue]];
//        }else{
//            [costSubCell configCostSubInstructionPriceFloat:0.0];
//        }
        
        return costSubCell;
    }else if (indexPath.section == 3){
        JGHCostListTableViewCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListTableViewCellIdentifier];
        costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (_costListArray.count > 0) {
//            [costListCell configCostData:_costListArray[indexPath.row]];
//        }
        
        return costListCell;
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
        JGTeamActivityWithAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityWithAddressCellIdentifier];
//        [addressCell configModel:self.model];
        return (UIView *)addressCell;
    }else if (section == 2){
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        return (UIView *)headerCell;
    }else if (section == 3){
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *applyListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        [applyListBtn addTarget:self action:@selector(getTeamActivitySignUpList:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell addSubview:applyListBtn];
        headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [headerCell congiftitles:@"活动成员及分组"];
        [headerCell congifCount:self.model.sumCount andSum:self.model.maxCount];
        return (UIView *)headerCell;
    }else if (section == 4) {
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *applyListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        [applyListBtn addTarget:self action:@selector(getTeamActivityResults:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell addSubview:applyListBtn];
        headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [headerCell congiftitles:@"查看成绩"];
        return (UIView *)headerCell;
    }else if (section == 5) {
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *applyListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        [applyListBtn addTarget:self action:@selector(getTeamActivityAward:) forControlEvents:UIControlEventTouchUpInside];
        headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [headerCell addSubview:applyListBtn];
        [headerCell congiftitles:@"查看奖项"];
        return (UIView *)headerCell;
    }else if (section == 6) {
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        UIButton *applyListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
        [applyListBtn addTarget:self action:@selector(getTeamActivityGuestCode:) forControlEvents:UIControlEventTouchUpInside];
        headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [headerCell addSubview:applyListBtn];
        [headerCell congiftitles:@"嘉宾参赛码"];
        return (UIView *)headerCell;
    }else{
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, detailsCell.frame.size.height)];
        [detailsBtn addTarget:self action:@selector(pushDetailSCtrl:) forControlEvents:UIControlEventTouchUpInside];
        [detailsCell addSubview:detailsBtn];
        detailsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
        return (UIView *)detailsCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
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
//        CGRect t = self.titleView.frame;
//        t.origin.y = yOffset;
//        self.titleView.frame = t;
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
