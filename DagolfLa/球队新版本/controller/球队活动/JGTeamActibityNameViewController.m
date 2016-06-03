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

static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHCostListTableViewCellIdentifier = @"JGHCostListTableViewCell";
static CGFloat ImageHeight  = 210.0;

@interface JGTeamActibityNameViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    //    CGFloat _tableViewHeight;
//    NSMutableDictionary *_dictPhoto;
}
@property (nonatomic, strong)UITableView *teamActibityNameTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UILabel *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址
@end

@implementation JGTeamActibityNameViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self setData];
    if (_teamActivityKey != 0){
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_teamActivityKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"tu2"]];
        
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_teamActivityKey andIsSetWidth:YES andIsBackGround:YES] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"logo"]];
    }else if (_myActivityKey != 0){
        [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_myActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:@"tu2"]];
        
        [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:_myActivityKey andIsSetWidth:YES andIsBackGround:NO] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}


- (void)setData{
    self.titleField.text = self.model.name;
    [self.addressBtn setTitle:self.model.ballName forState:(UIControlStateNormal)];
}

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.activityDict = [NSMutableDictionary dictionary];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
            }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:TB_BG_Color];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    _dictPhoto = [NSMutableDictionary dictionary];
    UIImage *bgImage = nil;
    UIImage *headerImage = nil;
    if (![_model isKindOfClass:[NSNull class]]) {
        bgImage = _model.bgImage;
        headerImage = _model.headerImage;
    }
    
    self.imgProfile = [[UIImageView alloc] initWithImage:bgImage];
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
    self.teamActibityNameTableView.dataSource = self;
    self.teamActibityNameTableView.delegate = self;
    self.teamActibityNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.teamActibityNameTableView.backgroundColor = [UIColor colorWithHexString:TB_BG_Color];
    [self.view addSubview:self.teamActibityNameTableView];
    [self.view addSubview:self.imgProfile];
    self.titleView.frame = CGRectMake(0, 10, screenWidth, 44);
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.imgProfile addSubview:self.titleView];

    
    if (self.isAdmin == 1) {// 发布页面
        [self createSaveAndLaunchBtn];
    }else{
        [self createApplyBtn];//报名页面
    }
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    
    //分享按钮
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-44, 0, 44, 44)];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(addShare) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:shareBtn];
    //有管理权限的用户在活动详情页面显示－－活动分组
#warning ,,,,,,,TeamMember
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    NSString *str = [userDef objectForKey:userID];
//    if ([str rangeOfString:@"1001"].location != NSNotFound){
//        UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        replaceBtn.frame = CGRectMake(screenWidth-94, 3, 54, 44);
//        replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
//        [replaceBtn setTitle:@"活动分组" forState:UIControlStateNormal];
//        replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [replaceBtn addTarget:self action:@selector(pushGroupCtrl:) forControlEvents:UIControlEventTouchUpInside];
//        replaceBtn.tag = 520;
//        [self.titleView addSubview:replaceBtn];
//    }
    
    //输入框
    self.titleField = [[UILabel alloc]initWithFrame:CGRectMake(64, 7, screenWidth - 128, 30)];
    self.titleField.text = self.model.name;
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.font = [UIFont systemFontOfSize:16 * screenWidth / 320];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 135, 65, 65)];
    [self.headPortraitBtn setImage:headerImage forState:UIControlStateNormal];
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.tag = 740;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    //地址
    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(85, 180, 70, 25)];
    self.addressBtn.tag = 333;
    [self.addressBtn setTitle:_model.ballName forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize size = [self.model.ballName boundingRectWithSize:CGSizeMake(screenWidth - 100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect address = self.addressBtn.frame;
    self.addressBtn.frame = CGRectMake(address.origin.x, address.origin.y, size.width, 25);
    
    [self.imgProfile addSubview:self.addressBtn];
    
//    if (self.isTeamChannal == 1) {
        [self dataSet];
//    }
    
}
#pragma mark -- 下载数据 －－－ 成功
- (void)dataSet{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.teamActivityKey) forKey:@"activityKey"];
    [dict setValue:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"error");
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict = [data objectForKey:@"activity"];
            if ([data objectForKey:@"power"]) {
                if ([data objectForKey:@"power"]) {
                    NSString *str = [data objectForKey:@"power"];
                    if ([str containsString:@"1001"]) {
                        [self createGroupBtn];
                    }
                }
            }
            
            [self.model setValuesForKeysWithDictionary:dict];
            [self.teamActibityNameTableView reloadData];
        }else{
            
        }
    }];
}

//有管理权限的用户在活动详情页面显示－－活动分组
- (void)createGroupBtn{
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    NSString *str = [userDef objectForKey:userID];
//    if ([str rangeOfString:@"1001"].location != NSNotFound){
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replaceBtn.frame = CGRectMake(screenWidth-94, 3, 54, 44);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTitle:@"活动分组" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [replaceBtn addTarget:self action:@selector(pushGroupCtrl:) forControlEvents:UIControlEventTouchUpInside];
    replaceBtn.tag = 520;
    [self.titleView addSubview:replaceBtn];
//    }
}

#pragma mark -分享
- (void)addShare{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        //        self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexRow];
        
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
    if (_teamActivityKey != 0) {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_teamActivityKey andIsSetWidth:YES andIsBackGround:NO]];
    }
    else
    {
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_myActivityKey andIsSetWidth:YES andIsBackGround:NO]];
    }
    

    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamac.html?key=%td", _teamActivityKey];
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@报名", _model.name];
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"球队会员：%td元，平台补贴：%td元，活动地点：%@，活动时间：%@", _model.memberPrice,_model.subsidyPrice,_model.ballName,_model.beginDate]  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"球队会员：%td元，平台补贴：%td元，活动地点：%@，活动时间：%@", _model.memberPrice,_model.subsidyPrice,_model.ballName,_model.beginDate] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
//        self.launchActivityTableView.frame = CGRectMake(0, 64, ScreenWidth, screenHeight - 64 - 49);
        
    }
    
}
#pragma mark -- 跳转分组页面
- (void)pushGroupCtrl:(UIButton *)btn{
    JGTeamGroupViewController *teamGroupCtrl = [[JGTeamGroupViewController alloc]init];
    teamGroupCtrl.teamActivityKey = _teamActivityKey;
    [self.navigationController pushViewController:teamGroupCtrl animated:YES];
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
    //    _photos = 10;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        _photos = 1;
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
                //                _photos = 1;
            }
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相册
        [_pickPhoto SHowLocalPhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                // @{@"nType":@"1", @"tag":@"dagolfla", @"data":@"test"};
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
#pragma mark -- 创建保存 ＋ 发布 按钮
- (void)createSaveAndLaunchBtn{
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight -44 - 40, screenWidth, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    saveBtn.layer.cornerRadius = 8.0;
    saveBtn.tag = 800;//保存
    [saveBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    UIButton *launchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight -40, screenWidth, 40)];
    [launchBtn setTitle:@"发布" forState:UIControlStateNormal];
    launchBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    launchBtn.layer.cornerRadius = 8.0;
    launchBtn.tag = 801;//发布
    [launchBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:launchBtn];
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
    UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoBtn.frame.size.width + 1, screenHeight-44, screenWidth - 75 *ScreenWidth/375, 44)];
    [applyBtn setTitle:@"报名参加" forState:UIControlStateNormal];
    applyBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
    //    applyBtn.layer.cornerRadius = 8.0;
    [applyBtn addTarget:self action:@selector(applyAttendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
}
#pragma mark -- 报名参加
- (void)applyAttendBtnClick:(UIButton *)btn{
    JGTeamApplyViewController *teamApplyCtrl = [[JGTeamApplyViewController alloc]initWithNibName:@"JGTeamApplyViewController" bundle:nil];
    teamApplyCtrl.modelss = self.model;
    teamApplyCtrl.isTeamChannal = self.isTeamChannal;
    [self.navigationController pushViewController:teamApplyCtrl animated:YES];
}
#pragma mark -- 拨打电话
- (void)telPhotoClick:(UIButton *)btn{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", _model.userMobile];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark -- 发布活动 ＋ 保存活动
- (void)applyBtnClick:(UIButton *)btn{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%td", self.teamKey] forKey:@"teamKey"];//球队key
    [dict setObject:@0 forKey:@"timeKey"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];//用户key
    [dict setObject:self.model.name forKey:@"name"];//活动名字
    [dict setObject:self.model.signUpEndTime forKey:@"signUpEndTime"];//活动报名截止时间
    [dict setObject:self.model.beginDate forKey:@"beginDate"];//活动开始时间
    [dict setObject:self.model.endDate forKey:@"endDate"];//活动结束时间
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.ballKey] forKey:@"ballKey"];//球场id
    [dict setObject:self.model.ballName forKey:@"ballName"];//球场名称
    //    [dict setObject:@"" forKey:@"ballGeohash"];//球场坐标
    [dict setObject:self.model.info forKey:@"info"];//活动简介
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.model.memberPrice] forKey:@"memberPrice"];//会员价
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.guestPrice] forKey:@"guestPrice"];//嘉宾价
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.model.maxCount] forKey:@"maxCount"];//最大人员数
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)_model.isClose] forKey:@"isClose"];//活动是否结束 0 : 开始 , 1 : 已结束
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    [dict setObject:currentTime forKey:@"createTime"];//活动创建时间
    [dict setObject:self.model.userName forKey:@"userName"];//联系人
    [dict setObject:self.model.userMobile forKey:@"userMobile"];//联系人
    
    if (btn.tag == 800) {
        //保存活动
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        [userdef setObject:dict forKey:@"TeamActivityData"];
        [userdef synchronize];
    }else if (btn.tag == 801){
        //发布活动
        [[JsonHttp jsonHttp]httpRequest:@"team/createTeamActivity" JsonKey:@"teamActivity" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"%@", errType);
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 0) {
                [Helper alertViewWithTitle:@"活动发布失败！" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
                
                return ;
            }
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            [imageArray addObject:UIImageJPEGRepresentation(self.model.bgImage, 0.7)];
            
            NSNumber* strTimeKey = [data objectForKey:@"timeKey"];
            // 上传图片
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:strTimeKey forKey:@"data"];
            [dict setObject:TYPE_TEAM_BACKGROUND forKey:@"nType"];
            [dict setObject:PHOTO_DAGOLFLA forKey:@"tag"];
            
            [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:imageArray failedBlock:^(id errType) {
                NSLog(@"errType===%@", errType);
            } completionBlock:^(id data) {
                [dict setObject:[NSString stringWithFormat:@"%@_background" ,strTimeKey] forKey:@"data"];
                [dict setObject:TYPE_TEAM_BACKGROUND forKey:@"nType"];
                [imageArray removeAllObjects];
                [imageArray addObject:UIImageJPEGRepresentation(self.model.headerImage, 0.7)];
                [[JsonHttp jsonHttp] httpRequestImageOrVedio:@"1" withData:dict andDataArray:imageArray failedBlock:^(id errType) {
                    NSLog(@"errType===%@", errType);
                } completionBlock:^(id data) {
                    NSLog(@"data == %@", data);
                    if ([[data objectForKey:@"code"] integerValue] == 1) {
                        //获取主线层
                        if ([NSThread isMainThread]) {
                            NSLog(@"Yay!");
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            NSLog(@"Humph, switching to main");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            });
                        }
                    }
                }];
            }];
        }];
    }
}
#pragma mark -- 活动发布成功后
- (void)launchActivity{
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[JGTeamActivityViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        //参赛费用列表
        return 2;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isAdmin == 1) {
        return 4;//创建页面－－预览
    }else{
        return 5;//详情页面
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ImageHeight;
    }else if (section == 1){
        return 110;
    }else if (section == 4){
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.teamActibityNameTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        cell.activityDetails.text = self.model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }else if (section == 3){
        if (_isAdmin == 1) {
            static JGTeamActivityDetailsCell *cell;
            if (!cell) {
                cell = [self.teamActibityNameTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
            }
            
            cell.activityDetails.text = self.model.info;
            
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        }else{
            return 44;
        }
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
    //    model = self.dataArray[0];
    if (indexPath.section == 2) {
        JGHCostListTableViewCell *costListCell = [tableView dequeueReusableCellWithIdentifier:JGHCostListTableViewCellIdentifier];
        costListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            costListCell.titles.text = @"活动报名费";
            costListCell.price.text = [NSString stringWithFormat:@"%td", self.model.memberPrice];
        }else{
            costListCell.titles.text = @"平台补贴费用";
            costListCell.price.text = [NSString stringWithFormat:@"%td", self.model.subsidyPrice];
        }
        
        //    [addressCell configModel:model];
        return costListCell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
    //    model = self.dataArray[0];
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
        if (_isAdmin != 1) {
            JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
            UIButton *applyListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerCell.frame.size.height)];
            [applyListBtn addTarget:self action:@selector(getTeamActivitySignUpList:) forControlEvents:UIControlEventTouchUpInside];
            [headerCell addSubview:applyListBtn];
            [headerCell congiftitles:@"查看报名人"];
            [headerCell congifCount:self.model.sumCount andSum:self.model.maxCount];
            return (UIView *)headerCell;
        }else{
            JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
            UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, detailsCell.frame.size.height)];
            [detailsBtn addTarget:self action:@selector(pushDetailSCtrl:) forControlEvents:UIControlEventTouchUpInside];
            [detailsCell addSubview:detailsBtn];
            [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
            return (UIView *)detailsCell;
        }
    }else{
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, detailsCell.frame.size.height)];
        [detailsBtn addTarget:self action:@selector(pushDetailSCtrl:) forControlEvents:UIControlEventTouchUpInside];
        [detailsCell addSubview:detailsBtn];
        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:self.model.info];
        return (UIView *)detailsCell;
    }
}
#pragma mark -- 详情页面
- (void)pushDetailSCtrl:(UIButton *)btn{
    JGTeamDeatilWKwebViewController *WKCtrl = [[JGTeamDeatilWKwebViewController alloc]init];
    WKCtrl.teamName = self.model.name;
    WKCtrl.detailString = self.model.details;
    [self.navigationController pushViewController:WKCtrl animated:YES];
}
#pragma mark -- 查看已报名人列表
- (void)getTeamActivitySignUpList:(UIButton *)btn{
    JGHTeamMembersViewController *teamMemberCtrl = [[JGHTeamMembersViewController alloc]init];
    if (_teamActivityKey != 0) {
        teamMemberCtrl.activityKey = self.teamActivityKey; //活动key
    }else{
        teamMemberCtrl.activityKey = self.myActivityKey; //活动key
    }
    
    teamMemberCtrl.isload = 1;
    [self.navigationController pushViewController:teamMemberCtrl animated:YES];
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
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 10, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 10;
        self.titleView.frame = t;
        
        if (yOffset == 0.0) {
            self.headPortraitBtn.hidden = NO;
            self.addressBtn.hidden = NO;
        }
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
