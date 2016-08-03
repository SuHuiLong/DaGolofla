//
//  JGTeamActibityNameViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActibityNameViewController.h"
#import "JGTeamActivityWithAddressCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGHHeaderLabelCell.h"
#import "JGTeamApplyViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "SXPickPhoto.h"
#import "BallParkViewController.h"
#import "JGHCostListTableViewCell.h"
#import "JGTeamActivityViewController.h"
#import "JGHTeamMembersViewController.h"
#import "JGTeamDeatilWKwebViewController.h"
#import "JGTeamGroupViewController.h"

#import "UMSocial.h"
#import "ShareAlert.h"
#import "UMSocialData.h"
#import "ShareAlert.h"
#import "UMSocialConfig.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "CommuniteTableViewCell.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialControllerService.h"

#import "EnterViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGActivityNameBaseCell.h"
#import "JGHCancelApplyViewController.h"

#import "JGActivityMemNonMangerViewController.h"
#import "JGLActiveCancelMemViewController.h"
#import "JGLPaySignUpViewController.h"
#import "JGLActiveCancelMemViewController.h"
#import "JGLPresentAwardViewController.h"
//#import "JGLWinnersShareViewController.h"

static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHCostListTableViewCellIdentifier = @"JGHCostListTableViewCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static CGFloat ImageHeight  = 210.0;

@interface JGTeamActibityNameViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _isTeamMember;//是否是球队成员 1 － 不是
    NSString *_userName;//用户在球队的真实姓名
    
    id _isApply;//是否已经报名0未，1已
    
    NSString *_power;//权限
    
    UIButton *_viewResultsBtn;//查看成绩
}

@property (nonatomic, strong)UITableView *teamActibityNameTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源
@property (nonatomic, strong)NSMutableArray *subDataArray;//费用说明数据源
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UILabel *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, strong)NSDictionary *teamMemberDic;

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@end

@implementation JGTeamActibityNameViewController

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
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
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
        self.subDataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
            }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //监听分组页面返回，刷新数据
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadActivityData:) name:@"reloadActivityData" object:nil];
    
    self.imgProfile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TeamBGImage]];
    self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
    self.imgProfile.userInteractionEnabled = YES;
    self.teamActibityNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44)];
    UINib *tableViewNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:tableViewNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    UINib *addressNib = [UINib nibWithNibName:@"JGTeamActivityWithAddressCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:addressNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    UINib *deetailsNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle: [NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:deetailsNib forCellReuseIdentifier:JGTeamActivityDetailsCellIdentifier];
    UINib *costListNib = [UINib nibWithNibName:@"JGHCostListTableViewCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:costListNib forCellReuseIdentifier:JGHCostListTableViewCellIdentifier];
    UINib *costSubsidiesNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:costSubsidiesNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    self.teamActibityNameTableView.dataSource = self;
    self.teamActibityNameTableView.delegate = self;
    self.teamActibityNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.teamActibityNameTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.teamActibityNameTableView];
    [self.view addSubview:self.imgProfile];
    
    //顶部图
    self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.imgProfile addSubview:self.titleView];
    
    //渐变图
    UIImageView *gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
    [gradientImage setImage:[UIImage imageNamed:@"backChange"]];
    [self.titleView addSubview:gradientImage];

    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
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
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.imgProfile addSubview:self.addressBtn];

    //分享按钮
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-44, self.titleField.frame.origin.y, 44, 25)];
    [shareBtn setImage:[UIImage imageNamed:@"iconfont-fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(addShare) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:shareBtn];

    [self dataSet];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 下载数据 －－－
- (void)dataSet{
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    
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

            if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] < 0) {
                if ([_isApply integerValue] == 0) {
                    [self createApplyBtn];//报名按钮
                }else{
                    [self createCancelBtnAndApplyOrPay];//已报名
                }
            }else{
                self.teamActibityNameTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            }
            
            [_subDataArray removeAllObjects];
            if ([self.model.memberPrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球队队员资费", [self.model.memberPrice floatValue]]];
            }
            
            if ([self.model.guestPrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-普通嘉宾资费", [self.model.guestPrice floatValue]]];
            }
            
            if ([self.model.billNamePrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球场记名会员资费", [self.model.billNamePrice floatValue]]];
            }
            
            if ([self.model.billPrice floatValue] > 0) {
                [_subDataArray addObject:[NSString stringWithFormat:@"%.2f-球场无记名会员资费", [self.model.billPrice floatValue]]];
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
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}
#pragma mark - 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
    if ([_model.timeKey integerValue] == 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?key=%td", _model.teamActivityKey];
    }
    else
    {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[_model.timeKey integerValue]andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?key=%@", _model.timeKey];
    }
    
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@报名", _model.name];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
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
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"打高尔夫啦",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
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
#pragma mark -- 获取球场地址
- (void)replaceWithPicture:(UIButton *)Btn{
    //球场列表
    BallParkViewController *ballCtrl = [[BallParkViewController alloc]init];
    [ballCtrl setCallback:^(NSString *balltitle, NSInteger ballid) {
        NSLog(@"%@----%ld", balltitle, (long)ballid);
        self.model.ballKey = *(&(ballid));
        self.model.ballName = balltitle;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize size = [self.model.ballName boundingRectWithSize:CGSizeMake(screenWidth - 100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGRect address = self.addressBtn.frame;
        self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25);
        [self.addressBtn setTitle:self.model.ballName forState:UIControlStateNormal];
    }];
    
    [self.navigationController pushViewController:ballCtrl animated:YES];
}
#pragma mark -- 页面按钮事件
- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 520){
        //更换背景
        [self SelectPhotoImage:btn];
    }else if (btn.tag == 740){
        [self SelectPhotoImage:btn];
    }
}
#pragma mark --添加活动头像
-(void)SelectPhotoImage:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                }
                
                [self.teamActibityNameTableView reloadData];
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                
                //设置背景
                if (btn.tag == 520) {
                    self.imgProfile.image = _headerImage;
                }else if (btn.tag == 740){
                    [self.headPortraitBtn setImage:_headerImage forState:UIControlStateNormal];
                    self.headPortraitBtn.layer.masksToBounds = YES;
                    self.headPortraitBtn.layer.cornerRadius = 8.0;
                }
            }
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
}
#pragma mark -- 取消报名－－报名／支付
- (void)createCancelBtnAndApplyOrPay{
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
    [photoBtn setImage:[UIImage imageNamed:@"consulting"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(telPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];

    UIButton *cancelApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width, screenHeight-44, (screenWidth - 75 *ScreenWidth/375)/2, 44)];
    [cancelApplyBtn setTitle:@"取消报名" forState:UIControlStateNormal];
    cancelApplyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    [cancelApplyBtn addTarget:self action:@selector(cancelApplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] >= 0) {
        cancelApplyBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self.view addSubview:cancelApplyBtn];
    
    UIButton *applyOrPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width + cancelApplyBtn.frame.size.width, screenHeight-44, (screenWidth - 75 *ScreenWidth/375)/2, 44)];
    [applyOrPayBtn setTitle:@"报名／支付" forState:UIControlStateNormal];
    applyOrPayBtn.backgroundColor = [UIColor colorWithHexString:Cancel_Color];
    [applyOrPayBtn addTarget:self action:@selector(applyOrPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] >= 0) {
        applyOrPayBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self.view addSubview:applyOrPayBtn];
}
#pragma mark -- 报名／支付
- (void)applyOrPayBtnClick:(UIButton *)btn{
    JGLPaySignUpViewController *paySignUpCtrl = [[JGLPaySignUpViewController alloc]init];
    paySignUpCtrl.dictRealDetail = self.teamMemberDic;
    if (_model.teamActivityKey == 0) {
        //球队活动
        paySignUpCtrl.activityKey = [_model.timeKey integerValue];
    }else{
        //我的球队
        paySignUpCtrl.activityKey = _model.teamActivityKey;
    }
    
    paySignUpCtrl.model = _model;
    paySignUpCtrl.isApply = (BOOL)[_isApply floatValue];
    paySignUpCtrl.userName = _userName;
    [self.navigationController pushViewController:paySignUpCtrl animated:YES];
}
#pragma mark -- 取消报名
- (void)cancelApplyBtnClick:(UIButton *)btn{
    
    JGHCancelApplyViewController *cancelApplyCtrl = [[JGHCancelApplyViewController alloc]init];
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
- (void)createApplyBtn{
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight-44, (75*screenWidth/375)-1, 44)];
    [photoBtn setImage:[UIImage imageNamed:@"consulting"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(telPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(photoBtn.frame.origin.x, photoBtn.frame.size.width, 1, 44)];
    lines.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lines];
    self.applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width + 1, screenHeight-44, screenWidth - 75 *ScreenWidth/375, 44)];
    [self.applyBtn setTitle:@"报名参加" forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    [self.applyBtn addTarget:self action:@selector(applyAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:self.applyBtn];
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
            JGTeamApplyViewController *teamApplyCtrl = [[JGTeamApplyViewController alloc]initWithNibName:@"JGTeamApplyViewController" bundle:nil];
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
        NSLog(@"%td", _subDataArray.count + 1);
        return _subDataArray.count + 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;//详情页面
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
    }else if (section == 6){
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.teamActibityNameTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        cell.activityDetails.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == _subDataArray.count) {
            JGActivityNameBaseCell *costSubCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
            costSubCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_model.subsidyPrice) {
                NSLog(@"%.2f", [_model.subsidyPrice floatValue]);
                [costSubCell configCostSubInstructionPriceFloat:[_model.subsidyPrice floatValue]];
            }else{
                [costSubCell configCostSubInstructionPriceFloat:0.0];
            }
            
            return costSubCell;
        }else{
            JGHCostListTableViewCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListTableViewCellIdentifier];
            costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_subDataArray.count > 0) {
                [costListCell configCostData:_subDataArray[indexPath.row]];
            }
            
            return costListCell;
        }
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
        [addressCell configModel:self.model];
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
        [headerCell congiftitles:@"查看报名人"];
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
    
    NSInteger timeKey;
    JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
    if (_model.teamActivityKey == 0) {
        timeKey = [_model.timeKey integerValue];
        wkVC.activeTimeKey = [_model.timeKey integerValue];
    }else{
        timeKey = _model.teamActivityKey;
        wkVC.activeTimeKey = _model.teamActivityKey;;
    }
    wkVC.teamTimeKey = _model.teamKey;
    wkVC.isScore = YES;
    wkVC.activeName = _model.name;
    wkVC.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreRanking.html?teamKey=%td&userKey=%@&srcKey=%td&srcType=1", _model.teamKey,DEFAULF_USERID, timeKey];
    wkVC.teamName = @"活动成绩";
    [self.navigationController pushViewController:wkVC animated:YES];
}
#pragma mark -- 详情页面
- (void)pushDetailSCtrl:(UIButton *)btn{
    JGTeamDeatilWKwebViewController *WKCtrl = [[JGTeamDeatilWKwebViewController alloc]init];
    WKCtrl.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamActivityDetails.html?key=%@", _model.timeKey];
    WKCtrl.teamName = @"活动详情";
    [self.navigationController pushViewController:WKCtrl animated:YES];
}
#pragma mark -- 查看已报名人列表
- (void)getTeamActivitySignUpList:(UIButton *)btn{
    if (_isTeamMember == 1) {
        [[ShowHUD showHUD]showToastWithText:@"您不是该球队队员！" FromView:self.view];
        return;
    }
    
    NSInteger timeKey;
    if (_model.teamActivityKey == 0) {
        timeKey = [_model.timeKey integerValue];
    }else{
        timeKey = _model.teamActivityKey;
    }
    
    if ([_power containsString:@"1001"]) {
        JGLActiveCancelMemViewController *powerCtrl = [[JGLActiveCancelMemViewController alloc]init];
        powerCtrl.title = self.model.name;
        powerCtrl.activityKey = [NSNumber numberWithInteger:timeKey];
        [self.navigationController pushViewController:powerCtrl animated:YES];
    }else{
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
        [self.navigationController  pushViewController:nonMangerVC animated:YES];
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
