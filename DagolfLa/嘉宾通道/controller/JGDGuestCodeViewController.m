//
//  JGDGuestCodeViewController.m
//  DagolfLa
//
//  Created by 東 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDGuestCodeViewController.h"
#import "JGDGuestChannelViewController.h"
#import "JGTeamDeatilWKwebViewController.h"

@interface JGDGuestCodeViewController ()

@end

@implementation JGDGuestCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"嘉宾参赛码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * ProportionAdapter, screenWidth, 100 * ProportionAdapter)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 36 * ProportionAdapter, 80 * ProportionAdapter, 30 * ProportionAdapter)];
    label.text = @"参赛码：";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [whiteView addSubview:label];
    // Do any additional setup after loading the view.
    
    UILabel *keyLB = [[UILabel alloc] initWithFrame:CGRectMake(200 * ProportionAdapter, 36 * ProportionAdapter, 160 * ProportionAdapter, 30 * ProportionAdapter)];
    keyLB.text = self.timeKey;
    keyLB.textColor = [UIColor redColor];
    keyLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [whiteView addSubview:keyLB];
    UILabel *introLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 125 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 60 * ProportionAdapter)];
    introLB.numberOfLines = 0;
    introLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    NSMutableAttributedString *intro = [[NSMutableAttributedString alloc] initWithString:@"说明：系统为每个活动生成唯一“嘉宾参赛码“，嘉宾在我的球队－嘉宾通道中输入该码，可以直达嘉宾报名页，完成活动报名与付款"];
    [intro addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"6cb8ff"] range:NSMakeRange(25, 9)];
    introLB.attributedText = intro;
    introLB.font = [UIFont systemFontOfSize: 13 * ProportionAdapter];
    [self.view addSubview:introLB];
    introLB.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guestAct)];;
    [introLB addGestureRecognizer:tapGest];
    
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareBtn)];
    barBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barBtn;
    
}

- (void)shareBtn{
    
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
    
//    JGTeamDeatilWKwebViewController *wkVC = [[JGTeamDeatilWKwebViewController alloc] init];
//    
//    [self.navigationController pushViewController:wkVC animated:YES];
}

#pragma mark - 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData = [[NSData alloc]init];
    NSString*  shareUrl;
        fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:[self.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES]];
        shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/teamActivityCode.html?activityKey=%@", self.timeKey];
 

    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@ 活动嘉宾参赛码", self.activityName];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"您的嘉宾参赛码是：%@", self.timeKey]  image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];

    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"您的嘉宾参赛码是：%@", self.timeKey] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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



- (void)guestAct{
    JGDGuestChannelViewController *guestVC = [[JGDGuestChannelViewController alloc] init];
    guestVC.activityKey = self.timeKey;
    [self.navigationController pushViewController:guestVC animated:YES];
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
