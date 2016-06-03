//
//  JGTeamMemberORManagerViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//


#import "JGTeamMemberORManagerViewController.h"
#import "JGTeamInfoViewController.h" //跳转info
#import "JGLSelfSetViewController.h" //个人设置
#import "JGTeamActivityViewController.h" //活动
#import "JGImageAndLabelAndLabelTableViewCell.h"
#import "JGTeamDeatilWKwebViewController.h"// 球队详情
#import "JGApplyMaterialViewController.h"
#import "JGSelfSetViewController.h"

#import "JGHLaunchActivityViewController.h"
#import "JGTableViewCell.h"
#import "JGHConcentTextViewController.h"
#import "JGHTeamActivityImageCell.h"
#import "DateTimeViewController.h"
#import "TeamAreaViewController.h"
#import "JGTeamActibityNameViewController.h"
#import "SXPickPhoto.h"
#import "JGHTeamContactTableViewCell.h"
#import "JGCostSetViewController.h"
#import "JGLableAndLableTableViewCell.h"
#import "JGDisplayInfoTableViewCell.h"
#import "TeamInviteViewController.h"

#import "ShareAlert.h"
#import "EnterViewController.h"
#import "UMSocial.h"
#import "ShareAlert.h"
#import "UMSocialData.h"
#import "ShareAlert.h"
#import "UMSocialConfig.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialControllerService.h"

#import "JGTeamManageViewController.h"

#import "JGTeamMemberController.h"
#import "TeamMessageController.h"//发送信息

static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGHTeamContactCellIdentifier = @"JGHTeamContactTableViewCell";
static CGFloat ImageHeight  = 210.0;


@interface JGTeamMemberORManagerViewController ()<UITableViewDelegate, UITableViewDataSource, JGHTeamActivityImageCellDelegate, JGHConcentTextViewControllerDelegate, NSURLConnectionDownloadDelegate, JGCostSetViewControllerDelegate>
{
    //、、、、、、、
    NSArray *_titleArray;//标题数组
    
    NSString *_contcat;//联系人
    
    
    //好友列表请求的数据
    NSMutableArray* _arrayIndex;
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayData1;
    
    NSMutableArray* _messageArray;
    NSMutableArray* _telArray;

}
@property (nonatomic,strong)SXPickPhoto * pickPhoto;//相册类
@property (nonatomic, strong)UITableView *launchActivityTableView;

@property (nonatomic, strong)NSMutableDictionary *dataDict;
@property (nonatomic, strong)NSMutableDictionary *memBerDic;

@property (nonatomic, strong)UIImage *headerImage;

@property (nonnull, strong)UIButton *headPortraitBtn;//头像

@property (nonatomic, strong)UILabel *titleField;//球队名称输入框

@property (nonatomic, strong)UIView *titleView;//顶部导航

@property (nonatomic, strong)UIButton *addressBtn;//添加地址

@property (nonatomic, copy)NSString *power;

@end

@implementation JGTeamMemberORManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.titleField.text = [self.detailDic objectForKey:@"name"];
    
    [self.headPortraitBtn sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"logo"]];
    self.headPortraitBtn.layer.masksToBounds = YES;
    self.headPortraitBtn.layer.cornerRadius = 8.0;
    
    [self.imgProfile sd_setImageWithURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:@"selfBackPic.jpg"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"teamKey"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
     
        
    } completionBlock:^(id data) {
           self.power = [[data objectForKey:@"teamMember"] objectForKey:@"power"];
        [[NSUserDefaults standardUserDefaults] setObject:self.power forKey:@"power"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        self.memBerDic = [data objectForKey:@"teamMember"];
        
    }];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    NSLog(@"%@",_detailDic);
}

- (instancetype)init{
    if (self == [super init]) {
        self.dataDict = [NSMutableDictionary dictionary];
        self.pickPhoto = [[SXPickPhoto alloc]init];
        self.titleView = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:@"bg"];
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
        self.imgProfile.frame = CGRectMake(0, 0, screenWidth, ImageHeight);
        self.imgProfile.userInteractionEnabled = YES;
        
        self.launchActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44) style:(UITableViewStylePlain)];
        [self.launchActivityTableView registerClass:[JGImageAndLabelAndLabelTableViewCell class] forCellReuseIdentifier:@"lbVSlb"];
        [self.launchActivityTableView registerClass:[JGDisplayInfoTableViewCell class] forCellReuseIdentifier:@"Display"];
        
        self.launchActivityTableView.dataSource = self;
        self.launchActivityTableView.delegate = self;
        self.launchActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.launchActivityTableView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
        [self.view addSubview:self.launchActivityTableView];
        [self.view addSubview:self.imgProfile];
        self.titleView.frame = CGRectMake(0, 20, screenWidth, 44);
        self.titleView.backgroundColor = [UIColor clearColor];
        [self.imgProfile addSubview:self.titleView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EAEAEB"];
    
    //好友
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    btn.tag = 521;
    [btn setImage:[UIImage imageNamed:@"backL"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:btn];
    //分享
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    replaceBtn.frame = CGRectMake(screenWidth - 54 * screenWidth / 320, 0, 54 * screenWidth / 320, 44 * screenWidth / 320);
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
    [self.titleView addSubview:detailBtn];
    //输入框
    self.titleField = [[UILabel alloc]initWithFrame:CGRectMake(64 * screenWidth / 320, 7 * screenWidth / 320, screenWidth - 128, 30 * screenWidth / 320)];
    self.titleField.textColor = [UIColor whiteColor];
    self.titleField.font = [UIFont systemFontOfSize:18 * screenWidth / 320];
    //    [self.titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    [self.titleField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.titleField.textAlignment = NSTextAlignmentCenter;
//    self.titleField.font = [UIFont systemFontOfSize:15];
    //头像
    self.headPortraitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20 * screenWidth / 320, 150, 50, 50)];
//    [self.headPortraitBtn.imageView sd_setImageWithURL:[Helper setImageIconUrl:[self.detailDic objectForKey:@"teamKey"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    [self.headPortraitBtn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [self.headPortraitBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    self.headPortraitBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgProfile addSubview:self.headPortraitBtn];
    [self.titleView addSubview:self.titleField];
    
    //地址
    //    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, 170, screenWidth-70, 30)];
    //    self.addressBtn.tag = 333;
    //    [self.addressBtn setTitle:@"请添加地址" forState:UIControlStateNormal];
    //    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    //    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [self.addressBtn addTarget:self action:@selector(replaceWithPicture:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.imgProfile addSubview:self.addressBtn];
    
//    _titleArray = @[@[], @[@"活动日期", @"开球时间", @"报名截止时间"], @[@"费用说明", @"人员限制", @"活动说明"], @[@"联系电话"]];
    
    [self createPreviewBtn];
}

#pragma mark -分享

- (void)addShare{
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
//        self.ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexRow];
        
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
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
};

-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData;
    
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO]];
    
    //http://192.168.1.104:8888/imgcache.dagolfla.com/share/team/team.html?key=181
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/team.html?key=%@",[self.detailDic objectForKey:@"timeKey"]];
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"欢迎加入%@",[self.detailDic objectForKey:@"name"]];
    if (index == 0){
//        [Helper setImageIconUrl:@"team" andTeamKey:[[self.detailDic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO]
        
        
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"球队简介:%@",[self.detailDic objectForKey:@"info"]]  image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
//                [self shareS:indexRow];
            }
        }];

    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"球队简介:%@",[self.detailDic objectForKey:@"info"]] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
        self.launchActivityTableView.frame = CGRectMake(0, 64, ScreenWidth, screenHeight - 64 - 49);
        
    }
    
}



- (void)replaceWithPicture:(UIButton *)Btn{
    if (Btn.tag == 333) {
        //球场列表
        
    }
//    [self didSelectPhotoImage:Btn];
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
        wkVC.detailString = [self.detailDic objectForKey:@"details"];
        wkVC.teamName = [self.detailDic objectForKey:@"name"];
        [self.navigationController pushViewController:wkVC animated:YES];
    }
}
#pragma mark -- 邀请好友BUTTON
- (void)createPreviewBtn{
    UIButton *previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight -44, screenWidth, 44)];
    [previewBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
    previewBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    [previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewBtn];
}
#pragma mark -- 邀请好友
- (void)previewBtnClick:(UIButton *)btn{
    TeamInviteViewController *inviteVc = [[TeamInviteViewController alloc] init];
    
    
    inviteVc.block = ^(NSMutableArray* arrayIndex, NSMutableArray* arrayData, NSMutableArray *addressArray){
        
        
        //接收数据
        [_arrayIndex removeAllObjects];
        [_arrayData1 removeAllObjects];//第一个列表的数据
        [_arrayData removeAllObjects];//第二个列表的数据
        
        [_messageArray removeAllObjects];//第三个列表
        [_telArray removeAllObjects];//第四个列表
        
        _arrayIndex=arrayIndex;
        _arrayData1=arrayData;
        
        for (int i = 0; i < [addressArray[0] count]; i++) {
            [_telArray addObject:addressArray[0][i]];
        }
        
        [_arrayData addObjectsFromArray:arrayData[0]];
        [_arrayData addObjectsFromArray:arrayData[1]];
        
        //存储短信数组
        [_messageArray addObjectsFromArray:arrayData[2]];
        NSMutableArray* arrayIdLis = [[NSMutableArray alloc]init];
        
        
        
    };
    
    
    [self.navigationController pushViewController:inviteVc animated:YES];

}


#pragma mark -- 改变图片位置 放大缩小
- (void)updateImg {
    CGFloat yOffset = _launchActivityTableView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGFloat factor = ((ABS(yOffset)+ImageHeight)*screenWidth)/ImageHeight;
    if (yOffset < 0) {
        
        CGRect f = CGRectMake(-(factor-screenWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        
        CGRect title = self.titleView.frame;
        self.titleView.frame = CGRectMake((factor-screenWidth)/2, 20, title.size.width, title.size.height);
        
        self.headPortraitBtn.hidden = YES;
        
        self.addressBtn.hidden = YES;
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        self.imgProfile.frame = f;
        
        CGRect t = self.titleView.frame;
        t.origin.y = yOffset + 20;
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
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ImageHeight - 10 * screenWidth / 320;
    }else if (indexPath.section == 1){
        return [self calculationLabelHeight:[self.detailDic objectForKey:@"notice"]] + 40 * screenWidth / 320;
        
    }else if (indexPath.section == 4){
        if (self.isManager == NO) {
            return 0;
        }else{
            return 40 * screenWidth / 320;
        }
    }else{
        return 40 * screenWidth / 320;
    }
}

- (CGFloat)calculationLabelHeight: (NSString *)LbText{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    CGRect bounds = [LbText boundingRectWithSize:(CGSizeMake(screenWidth - 20  * screenWidth / 320 , 10000)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        contactCell.promptLB.text = @"球队动态";
        contactCell.promptLB.textColor = [UIColor lightGrayColor];
        contactCell.promptLB.frame = CGRectMake(10 * screenWidth / 320, 0, 100 * screenWidth / 320, 30 * screenWidth / 320);
        contactCell.contentLB.lineBreakMode = NSLineBreakByWordWrapping;
        contactCell.contentLB.text = [self.detailDic objectForKey:@"notice"];
        contactCell.contentLB.frame = CGRectMake(10, 35  * screenWidth / 320, screenWidth - 20  * screenWidth / 320, [self calculationLabelHeight:[self.detailDic objectForKey:@"notice"]]);
        return contactCell;
    }else if (indexPath.section == 2){
        
        JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                launchActivityCell.imageV.image = [UIImage imageNamed:@"hd-2"];
                launchActivityCell.promptLB.text = @"赛事活动";
                break;
            case 1:
                launchActivityCell.imageV.image = [UIImage imageNamed:@"qdcy"];
                launchActivityCell.promptLB.text = @"球队成员";
//                launchActivityCell.contentLB.text = self.detailModel.cityName;
                break;
//            case 2:
//                launchActivityCell.promptLB.text = @"球队相册";
////                launchActivityCell.contentLB.text = self.detailModel.establishTime;
//                break;
            case 2:
                launchActivityCell.imageV.image = [UIImage imageNamed:@"qdjj"];
                launchActivityCell.promptLB.text = @"球队简介";
//                launchActivityCell.contentLB.text = [NSString stringWithFormat:@"%td人", self.detailModel.userSum];
                break;
            default:
                break;
        }
        
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return launchActivityCell;
        
    }else if (indexPath.section == 3){
        JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        launchActivityCell.imageV.image = [UIImage imageNamed:@"sz"];
        launchActivityCell.promptLB.text = @"个人设置";

        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return launchActivityCell;
        
    }else{
     
        JGImageAndLabelAndLabelTableViewCell *launchActivityCell = [tableView dequeueReusableCellWithIdentifier:@"lbVSlb" forIndexPath:indexPath];
        launchActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            launchActivityCell.promptLB.text = @"球队管理";
        launchActivityCell.imageV.image = [UIImage imageNamed:@"qdgl"];
        launchActivityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.isManager == NO) {
            launchActivityCell.promptLB.text = @"";
            launchActivityCell.imageV.image = nil;
        }
        return launchActivityCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
    }
    else if (indexPath.section == 2){
    
        switch (indexPath.row) {
            case 0:
            {
                //获取球队活动列表
                JGTeamActivityViewController *activiyVC = [[JGTeamActivityViewController alloc] init];
                activiyVC.power = self.power;
                activiyVC.timeKey = [[self.detailDic objectForKey:@"timeKey"] integerValue];
                activiyVC.isMEActivity = 1;
                [self.navigationController pushViewController:activiyVC animated:YES];
                
            }
                break;
            case 1:
            {
                JGTeamMemberController* tmVc = [[JGTeamMemberController alloc]init];
                tmVc.teamMembers = 1;
                tmVc.teamKey = [_detailDic objectForKey:@"timeKey"];
                tmVc.power = self.power;
                [self.navigationController pushViewController:tmVc animated:YES];
            }
                break;
            case 2:
            {
                JGTeamInfoViewController *infoVc = [[JGTeamInfoViewController alloc] init];
                infoVc.string = [self.detailDic objectForKey:@"info"];
                [self.navigationController pushViewController:infoVc animated:YES];
            }
                break;
            case 3:
            {


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
            meter.detailDic = self.detailDic;
            meter.memeDic = self.memBerDic;
            [self.navigationController pushViewController:meter animated:YES];
//            JGLSelfSetViewController *costView = [[JGLSelfSetViewController alloc]init];
//               costView.teamKey = [[self.detailDic objectForKey:@"timeKey"] integerValue];
//            [self.navigationController pushViewController:costView animated:YES];
        }
    }
    else
    {
        /**
         球队管理点击跳转
         */
        JGTeamManageViewController* tmVc = [[JGTeamManageViewController alloc]init];
        tmVc.teamKey = [[self.detailDic objectForKey:@"timeKey"] integerValue];
        tmVc.detailDic = self.detailDic;
        tmVc.power = self.power;
        [self.navigationController pushViewController:tmVc animated:YES];
    }
    
    [self.launchActivityTableView reloadData];
}

#pragma mark --添加活动头像－－JGHTeamActivityImageCellDelegate
-(void)didSelectPhotoImage:(UIButton *)btn{
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [_pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
            if ([Data isKindOfClass:[UIImage class]])
            {
                _headerImage = (UIImage *)Data;
                [self.launchActivityTableView reloadData];
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
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"11010" forKey:@"data"];
                [dict setObject:@"1" forKey:@"nType"];
                [dict setObject:@"team" forKey:@"tag"];
                NSMutableArray *array = [NSMutableArray array];
                
                [array addObject:UIImageJPEGRepresentation(_headerImage, 0.7)];
                
                [[JsonHttp jsonHttp]httpRequestImageOrVedio:@"1" withData:dict andDataArray:array failedBlock:^(id errType) {
                    NSLog(@"errType===%@", errType);
                } completionBlock:^(id data) {
                    NSLog(@"data===%@", data);
                }];
            }
        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:YES completion:nil];
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


