//
//  JGDNewTeamDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/11/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//


#import "JGDNewTeamDetailViewController.h"
#import "JGTeamInfoViewController.h" //跳转info
#import "JGLSelfSetViewController.h" //个人设置
#import "JGTeamActivityViewController.h" //活动
#import "JGImageAndLabelAndLabelTableViewCell.h"
#import "JGTeamDeatilWKwebViewController.h"// 球队详情
#import "JGApplyMaterialViewController.h"
#import "JGSelfSetViewController.h"

#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "DateTimeViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDisplayInfoTableViewCell.h"

#import "ShareAlert.h"
#import "UMSocial.h"
#import "ShareAlert.h"
#import "UMSocialData.h"
#import "ShareAlert.h"
#import "UMSocialConfig.h"

#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialControllerService.h"

#import "JGTeamManageViewController.h"

#import "JGTeamMemberController.h"
//球队照片
#import "JGTeamPhotoViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"


#import "JGTeamHisScoreViewController.h"


static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGDNewTeamDetailViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDownloadDelegate>
{
    //、、、、、、、
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
    
    
    UIImageView *_gradientImage;
}

@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSDictionary *dataDict;
@property (nonatomic, strong)NSMutableDictionary *memBerDic;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UILabel *titleLB;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, copy)NSString *power;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, strong) UIImageView *jbImageV;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIView *footBackView;

@property (nonatomic, strong) NSNumber *memberState;

@property (nonatomic, strong) UIImageView *imgProfile;



@property (nonatomic, strong) NSMutableDictionary *detailDic;

@property (nonatomic, strong)UIView *backView;


@end

@implementation JGDNewTeamDetailViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    

    self.navigationController.navigationBarHidden = YES;
    NSString *head = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@.jpg@200w_200h_2o", self.timeKey];
    NSString *bgUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/team/%@_background.jpg", self.timeKey];
    
    [[SDImageCache sharedImageCache] removeImageForKey:head fromDisk:YES withCompletion:nil];
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
    

    [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[self.timeKey integerValue] andIsSetWidth:YES andIsBackGround:NO] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[self.timeKey integerValue] andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:TeamBGImage]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:self.timeKey forKey:@"teamKey"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];

    } completionBlock:^(id data) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            self.dataDict = [NSDictionary dictionaryWithDictionary:[data objectForKey:@"team"]];
            self.titleLB.text = [[data objectForKey:@"team"] objectForKey:@"name"];

            if ([data objectForKey:@"teamMember"]) {
                
                [self createPreviewBtn];
                self.launchActivityTableView.tableFooterView = self.footBackView;
                
                
                self.state = [[[data objectForKey:@"team"] objectForKey:@"state"] integerValue];
                self.power = [[data objectForKey:@"teamMember"] objectForKey:@"power"];
                [[NSUserDefaults standardUserDefaults] setObject:self.power forKey:@"power"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                self.memBerDic = [data objectForKey:@"teamMember"];
                
                self.memberState = [self.memBerDic objectForKey:@"state"];
                
                if (self.state == 1) {
                    
                    if ([[self.memBerDic objectForKey:@"state"] integerValue] == 0) {
                        
                        [self.previewBtn setTitle:@"正在等待管理员审核" forState:UIControlStateNormal];
                        self.previewBtn.userInteractionEnabled = NO;
                        self.previewBtn.backgroundColor = [UIColor lightGrayColor];
                        
                    }else if ([[self.dataDict objectForKey:@"state"] integerValue] == 2){
                        
                        [self.previewBtn setTitle:@"审核未通过" forState:UIControlStateNormal];
                        self.previewBtn.userInteractionEnabled = NO;
                        self.previewBtn.backgroundColor = [UIColor lightGrayColor];
                        
                    }else{
                        
                        [self.previewBtn setTitle:@"微信招集队友" forState:UIControlStateNormal];
                        self.previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
                    }
                    
                }else if (self.state == 0) {
                    
                    [self.previewBtn setTitle:@"正在等待审核" forState:UIControlStateNormal];
                    self.previewBtn.userInteractionEnabled = NO;
                    self.previewBtn.backgroundColor = [UIColor lightGrayColor];
                    
                }else if (self.state == 2) {
                    
                    [self.previewBtn setTitle:@"审核未通过" forState:UIControlStateNormal];
                    self.previewBtn.backgroundColor = [UIColor lightGrayColor];
                }
                
            }else{
                // 非球队成员
                [self createApplyViewBtn];
                self.launchActivityTableView.tableFooterView = self.backView;
            }
            
            
            [self.launchActivityTableView reloadData];
            
            
        }else{
            
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;

}

- (instancetype)init{
    
    if (self == [super init]) {
        
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:@"bg"];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imgProfile.layer.masksToBounds = YES;
        
        //渐变图
        _gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ImageHeight)];
        [_gradientImage setImage:[UIImage imageNamed:@"backChange"]];
        [self.imgProfile addSubview:_gradientImage];
        
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:(UITableViewStylePlain)];
        [self.launchActivityTableView registerClass:[JGImageAndLabelAndLabelTableViewCell class] forCellReuseIdentifier:@"lMGbVSlb"];
        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        
        [self.launchActivityTableView registerClass:[JGLableAndLableTableViewCell class] forCellReuseIdentifier:@"lbVSlb"];
        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        [self.launchActivityTableView registerClass:[JGImageAndLabelAndLabelTableViewCell class] forCellReuseIdentifier:@"iamgeVCell"];
        
        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        [self.view addSubview:self.launchActivityTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 0, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        [self.imgProfile addSubview:self.titleView];
        
    }
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];

    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
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
    
    //分享
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    replaceBtn.frame = CGRectMake(screenWidth - 54 * screenWidth / 320, 10, 54 * screenWidth / 320, 44 * screenWidth / 320);
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [replaceBtn setTintColor:[UIColor whiteColor]];
    [replaceBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    replaceBtn.titleLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
    replaceBtn.tag = 520;
    [replaceBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:replaceBtn];
    
    // 球队详情
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(screenWidth- 90 * screenWidth / 320, 0, 54 * screenWidth / 320, 44 * screenWidth / 320);
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
    detailBtn.tag = 526;
    [detailBtn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //球队名字
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(64 * screenWidth / 320, 17, screenWidth - 128, 30 * screenWidth / 320)];
    self.titleLB.textColor = [UIColor whiteColor];
    self.titleLB.font = [UIFont systemFontOfSize:18 * screenWidth / 320];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 * screenWidth / 320, 150, 50, 50)];
    [self.headPortraitBtn setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
    self.headPortraitBtn.userInteractionEnabled = NO;
    //    [self.headPortraitBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
//    self.headPortraitBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleLB];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];;
    
}

#pragma mark -分享

- (void)addShare{
    
    if ([[self.dataDict objectForKey:@"state"] integerValue] == 0) {
        return;
    }
    
    if ([[self.dataDict objectForKey:@"state"] integerValue] == 2) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
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
#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData;
    NSLog(@"%@",[Helper setImageIconUrl:@"team" andTeamKey:[self.timeKey integerValue] andIsSetWidth:YES andIsBackGround:NO]);
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"team" andTeamKey:[self.timeKey integerValue] andIsSetWidth:YES andIsBackGround:NO]];
    NSObject* obj;
    if (fiData != nil && fiData.length > 0) {
        obj = fiData;
    }
    else
    {
        obj = [UIImage imageNamed:@"iconlogo"];
    }
    
    //http://192.168.1.104:8888/imgcache.dagolfla.com/share/team/team.html?key=181
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/team.html?key=%@",self.timeKey];
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"欢迎加入%@",[self.dataDict objectForKey:@"name"]];
    if (index == 0){
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"球队简介:%@",[self.dataDict objectForKey:@"info"]]  image:obj location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"球队简介:%@",[self.dataDict objectForKey:@"info"]] image:obj location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
        self.launchActivityTableView.frame = CGRectMake(0, 64, ScreenWidth, screenHeight - 64 - 49);
        
    }
    
}


- (void)initItemsBtnClick:(UIButton *)btn{
    if (btn.tag == 521) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag == 520){
        //分享
        [self addShare];
    }else if (btn.tag == 526){
        // 球队详情
        JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
        wkVC.detailString = [self.dataDict objectForKey:@"details"];
        wkVC.teamName = [self.dataDict objectForKey:@"name"];
        [self.navigationController pushViewController:wkVC animated:YES];
    }
}


#pragma mark -- 邀请好友BUTTON

- (void)createPreviewBtn{
    
    self.footBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60 * screenWidth / 320)];
    self.previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 * screenWidth / 320, 10 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 44 * screenWidth / 320)];
    
    self.previewBtn.clipsToBounds = YES;
    self.previewBtn.layer.cornerRadius = 6.f;
    [self.footBackView addSubview:self.previewBtn];
    
    [self.previewBtn setTitle:@"微信招集队友" forState:UIControlStateNormal];
    self.previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [self.previewBtn addTarget:self action:@selector(previewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -- 微信分享召集好友
- (void)previewBtnClick{
    
    ShareAlert* alert = [[ShareAlert alloc]initMyAlertWithWeChat:YES];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
    
}


#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
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
#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.memBerDic) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 4;
        }else if (section == 2){
            return 3;
        }else{
            return 1;
        }
    }else{
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }else if (section == 2){
            return 5;
        }else{
            return 1;
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.dataDict) {
        return 0;
    }else{
        
        if (self.memBerDic) {
            return 5;
        }else{
            return 4;
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.memBerDic) {
        
        if (indexPath.section == 0) {
            
            return ImageHeight - 10 * screenWidth / 320;
        
        }else if (indexPath.section == 1){
            
            return [self calculationLabelHeight:[self.dataDict objectForKey:@"notice"]] + 40 * screenWidth / 320;
            
        }else if (indexPath.section == 4){
        
            if (![self.power containsString:@"1005"]) {
            
                return 0;
            }else{
                
                return 40 * screenWidth / 320;
            }
            
        }else{
            
            return 40 * screenWidth / 320;
        }

    }else{
        // 非球队成员
        if (indexPath.section == 0) {
        
            return ImageHeight -10;
        }else if (indexPath.section == 3){

            return 40 * screenWidth / 320;
        }else{
            
            return 40 * screenWidth / 320;
        }

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
    
    
    if (self.memBerDic) {
        
        NSString *windowReuseIdentifier = @"SectionOneCell";
        if (indexPath.section == 0) {
            UITableViewCell *launchImageActivityCell = nil;
            launchImageActivityCell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
            if (!launchImageActivityCell) {
                
                launchImageActivityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            }
            
            launchImageActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return launchImageActivityCell;
        }else if (indexPath.section == 1){
            JGDisplayInfoTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"Display"];
            contactCell.promptLB.text = @"球队公告";
            contactCell.promptLB.textColor = [UIColor blackColor];
            contactCell.promptLB.frame = CGRectMake(10 * screenWidth / 320, 0, 100 * screenWidth / 320, 30 * screenWidth / 320);
            contactCell.contentLB.lineBreakMode = NSLineBreakByWordWrapping;
            contactCell.contentLB.textColor = [UIColor lightGrayColor];
            contactCell.contentLB.text = [self.dataDict objectForKey:@"notice"];
            contactCell.contentLB.frame = CGRectMake(10, 35  * screenWidth / 320, screenWidth - 20  * screenWidth / 320, [self calculationLabelHeight:[self.dataDict objectForKey:@"notice"]]);
            return contactCell;
        }else if (indexPath.section == 2){
            
            JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lMGbVSlb" forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0:
                    launchActivityCell.imageV.image = [UIImage imageNamed:@"hd-2"];
                    launchActivityCell.promptLB.text = @"球队活动";
                    break;
                case 1:
                    launchActivityCell.imageV.image = [UIImage imageNamed:@"qdcy"];
                    launchActivityCell.promptLB.text = @"球队成员";
                    //                launchActivityCell.contentLB.text = self.detailModel.cityName;
                    break;
                case 2:
                    
                    launchActivityCell.promptLB.text = @"球队相册";
                    launchActivityCell.imageV.image = [UIImage imageNamed:@"xcgl"];
                    //                launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%td人", self.detailModel.userSum];
                    
                    break;
                case 3:
                    launchActivityCell.promptLB.text = @"球队简介";
                    launchActivityCell.imageV.image = [UIImage imageNamed:@"qdjj"];
                    //                launchActivityCell.contentLB.text = self.detailModel.establishTime;
                    break;
                case 4:
                    launchActivityCell.promptLB.text = @"球队历史记分卡";
                    launchActivityCell.imageV.image = [UIImage imageNamed:@"qiuduilist"];
                    //                launchActivityCell.contentLB.text = self.detailModel.establishTime;
                    break;
                default:
                    break;
            }
            
            launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return launchActivityCell;
            
        }else if (indexPath.section == 3){
            JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lMGbVSlb" forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            launchActivityCell.imageV.image = [UIImage imageNamed:@"selfSZ"];
            launchActivityCell.promptLB.text = @"个人设置";
            
            launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return launchActivityCell;
            
        }else{
            
            JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lMGbVSlb" forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            launchActivityCell.promptLB.text = @"球队管理";
            launchActivityCell.imageV.image = [UIImage imageNamed:@"qdgl"];
            launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            if (![self.power containsString:@"1005"]) {
                launchActivityCell.promptLB.text = @"";
                launchActivityCell.imageV.image = nil;
            }
            return launchActivityCell;
        }
    }else{
        
        // 非球队成员
        NSString *windowReuseIdentifier = @"SectionOneCell";
        if (indexPath.section == 0) {
            UITableViewCell *launchImageActivityCell = nil;
            launchImageActivityCell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
            if (!launchImageActivityCell) {
                
                launchImageActivityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            }
            
            launchImageActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return launchImageActivityCell;
        }else if (indexPath.section == 3){
            
            JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"iamgeVCell" forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            launchActivityCell.promptLB.text = @"球队简介";
            launchActivityCell.imageV.image = [UIImage imageNamed:@"qdjj"];
            launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return launchActivityCell;
            
        }else if (indexPath.section == 1){
            
            JGLableAndLableTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0:
                    launchActivityCell.promptLB.text = @"球队队长";
                    launchActivityCell.contentLB.text = [self.dataDict objectForKey:@"captainName"];
                    break;
                case 1:
                    launchActivityCell.promptLB.text = @"所属地区";
                    launchActivityCell.contentLB.text = [self.dataDict objectForKey:@"crtyName"];
                    break;
                case 2:
                    launchActivityCell.promptLB.text = @"成立时间";
                    launchActivityCell.contentLB.text = [Helper returnDateformatString:[self.dataDict objectForKey:@"establishTime"]];
                    break;
                case 3:
                    launchActivityCell.promptLB.text = @"球队规模";
                    launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%@人", [self.dataDict objectForKey:@"userSum"]];
                    break;
                default:
                    break;
            }
            
            
            return launchActivityCell;
        }else{
            JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"iamgeVCell" forIndexPath:indexPath];
            launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                launchActivityCell.promptLB.text = @"球队活动";
                launchActivityCell.imageV.image = [UIImage imageNamed:@"hd-2"];
            }else if (indexPath.row == 1){
                launchActivityCell.promptLB.text = @"球队相册";
                launchActivityCell.imageV.image = [UIImage imageNamed:@"xcgl"];
            }else{
                launchActivityCell.promptLB.text = @"球队历史记分卡";
                launchActivityCell.imageV.image = [UIImage imageNamed:@"qiuduilist"];
            }
            launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return launchActivityCell;
        }
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.memBerDic) {
    // 非球队成员
        if (indexPath.section == 1) {
            
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [MobClick event:@"team_main_activity_click"];

                JGTeamActivityViewController *activity = [[JGTeamActivityViewController alloc] init];
                activity.isMEActivity = 1;
                activity.timeKey = [[self.dataDict objectForKey:@"timeKey"] integerValue];
                [self.navigationController pushViewController:activity animated:YES];
                
            }else if (indexPath.row == 1){
                [MobClick event:@"team_main_album_click"];

                JGTeamPhotoViewController *photo = [[JGTeamPhotoViewController alloc] init];
                photo.manageInter = 1;
                photo.teamKey = [self.dataDict objectForKey:@"timeKey"];
                photo.titleStr = [self.dataDict objectForKey:@"name"];
                [self.navigationController pushViewController:photo animated:YES];
            }else
            {
                JGTeamHisScoreViewController *histroyVC = [[JGTeamHisScoreViewController alloc] init];
                histroyVC.teamKey = [self.dataDict objectForKey:@"timeKey"];
                histroyVC.isTeamMem = NO;
                [self.navigationController pushViewController:histroyVC animated:YES];
            }
            
            
        }else if (indexPath.section == 3){
            JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
            wkVC.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamDetails.html?key=%@", [self.dataDict objectForKey:@"timeKey"]];;
            wkVC.teamName = [self.dataDict objectForKey:@"name"];
            [self.navigationController pushViewController:wkVC animated:YES];
        }
        
        [self.launchActivityTableView reloadData];
    }else{
        
        // 球队成员
        
        if ([self.memberState integerValue] == 0) {
            return;
        }
        
        if ([[self.dataDict objectForKey:@"state"] integerValue] == 0) {
            return;
        }
        
        if ([[self.dataDict objectForKey:@"state"] integerValue] == 2) {
            return;
        }
        
        if (indexPath.section == 1) {
        }
        else if (indexPath.section == 2){
            
            switch (indexPath.row) {
                case 0:
                {
                    //获取球队活动列表
                    JGTeamActivityViewController *activiyVC = [[JGTeamActivityViewController alloc] init];
                    activiyVC.power = self.power;
                    activiyVC.state = self.state;
                    activiyVC.timeKey = [self.timeKey integerValue];
                    activiyVC.isMEActivity = 1;
                    if ([_dataDict objectForKey:@"name"]) {
                        activiyVC.teamName = [_dataDict objectForKey:@"name"];
                    }
                    
                    [self.navigationController pushViewController:activiyVC animated:YES];
                    
                }
                    break;
                case 1:
                {
                    JGTeamMemberController* tmVc = [[JGTeamMemberController alloc]init];
                    tmVc.teamMembers = 1;
                    tmVc.teamKey = [_dataDict objectForKey:@"timeKey"];
                    tmVc.power = self.power;
                    [self.navigationController pushViewController:tmVc animated:YES];
                }                 break;
                case 2:
                {
                    JGTeamPhotoViewController* phoVc = [[JGTeamPhotoViewController alloc]init];
                    phoVc.teamKey = self.timeKey;
                    phoVc.powerPho = self.power;
                    phoVc.dictMember = _memBerDic;
                    phoVc.manageInter = 1;
                    phoVc.titleStr = [self.dataDict objectForKey:@"name"];
                    [self.navigationController pushViewController:phoVc animated:YES];
                }
                    break;
                case 3:
                {
                    JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
                    
                    wkVC.detailString = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamDetails.html?key=%@", self.timeKey];;
                    wkVC.teamName = [self.dataDict objectForKey:@"name"];
                    [self.navigationController pushViewController:wkVC animated:YES];
                }
                    break;
                case 4:
                {
                    
                    JGTeamHisScoreViewController *histroyVC = [[JGTeamHisScoreViewController alloc] init];
                    histroyVC.teamKey = self.timeKey;
                    histroyVC.isTeamMem = YES;
                    [self.navigationController pushViewController:histroyVC animated:YES];
                    
                }
                    break;
                default:
                    break;
            }
            
        }
        else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                
                JGSelfSetViewController *meter = [[JGSelfSetViewController alloc] init];
                meter.isSelfSet = YES;
                meter.detailDic = [self.dataDict mutableCopy];
                meter.memeDic = self.memBerDic;
                [self.navigationController pushViewController:meter animated:YES];
            }
        }
        else
        {
            /**
             球队管理点击跳转
             */
            [MobClick event:@"team_main_manage_click"];

            JGTeamManageViewController* tmVc = [[JGTeamManageViewController alloc]init];
            tmVc.teamKey = [self.timeKey integerValue];
            tmVc.detailDic = [self.dataDict mutableCopy];
            tmVc.power = self.power;
            tmVc.memberDic = _memBerDic;
            [self.navigationController pushViewController:tmVc animated:YES];
        }
        
        [self.launchActivityTableView reloadData];
    }
}


#pragma mark -- 预览
- (void)createApplyViewBtn{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, screenHeight - 0, screenWidth - 20 * screenWidth / 320, 60 * screenWidth / 320)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth - 20 * screenWidth / 320,40 * screenWidth / 320)];
    
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(71 * screenWidth / 320, 0 * screenWidth / 320, screenWidth - 90 * screenWidth / 320, 40 * screenWidth / 320)];
    [previewBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:previewBtn];
    
    UIButton *askBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    askBtn.frame = CGRectMake(0, 0 * screenWidth / 320, 70 * screenWidth / 320, 40 * screenWidth / 320);
    //    [askBtn setTitle:@"咨询" forState:UIControlStateNormal];
    askBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [askBtn setImage:[UIImage imageNamed:@"consulting"] forState:(UIControlStateNormal)];
    // {top, left, bottom, right};
    [askBtn addTarget:self action:@selector(askBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:askBtn];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 6.f;
    [self.backView addSubview:view];
}

#pragma mark -- 申请加入
- (void)previewBtnClick:(UIButton *)btn{
    
    JGApplyMaterialViewController *applyVC = [[JGApplyMaterialViewController alloc] init];
    applyVC.teamKey = [[self.dataDict objectForKey:@"timeKey"] integerValue];
    [self.navigationController pushViewController:applyVC animated:YES];
    
}

#pragma mark -- 咨询
- (void)askBtnClick:(UIButton *)btn{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", [self.dataDict objectForKey:@"answerMobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}



- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL{
    NSLog(@"%@", destinationURL);
    NSLog(@"%@", connection);
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


