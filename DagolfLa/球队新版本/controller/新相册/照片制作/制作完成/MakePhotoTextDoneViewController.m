//
//  MakePhotoTextDoneViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextDoneViewController.h"

@interface MakePhotoTextDoneViewController ()
//webView
@property(nonatomic, strong)WKWebView *webView;
@end

@implementation MakePhotoTextDoneViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = true;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = false;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark - CreateView
-(void)createView{
    [self createWebView];
    [self createActionBtn];
}
//展示
-(void)createWebView{
    UIView *backLine = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, 1, 1)];
    [self.view addSubview:backLine];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-kHvertical(51))];
    //2.创建URL
    NSURL *URL = [NSURL URLWithString:_urlStr];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    [webView loadRequest:request];
    //5.添加到视图
    self.webView = webView;
    [self.view addSubview:webView];

}
//编辑&&分享&&删除
-(void)createActionBtn{
    //弹出的view
    UIView *bottomView = [Factory createViewWithBackgroundColor:RGBA(248,248,248,0.97) frame:CGRectMake(0, screenHeight  - kHvertical(51), screenWidth, kHvertical(51))];
    [self.view addSubview:bottomView];
    //各个操作按钮
    NSArray *titleArray = @[@"编辑",@"分享",@"删除"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [Factory createButtonWithFrame:CGRectMake(screenWidth*i/3, 0, screenWidth/3, bottomView.height) titleFont:kHorizontal(18) textColor:NormalColor backgroundColor:ClearColor target:self selector:@selector(handleBtnClick:) Title:titleArray[i]];
        btn.tag = 100 + i;
        [bottomView addSubview:btn];
    }
}

#pragma mark - Action
//返回
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑&&分享&&删除
-(void)handleBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
            [self backBtnClick];
            break;
        case 101:
            [self shareStatisticsDataClick];
            break;
        case 102:
            
            break;
            
        default:
            break;
    }
}



#pragma mark ----- 分享
-(void)shareStatisticsDataClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareWithInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareWithInfo:(int)index
{
    //分享链接
    NSString*  shareUrl = _urlStr;
    //分享图片
    UIImage *iconImageFull = [UIImage imageWithData:[NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[_timeKey integerValue] andIsSetWidth:YES andIsBackGround:NO]]];
    NSData *imageData = UIImageJPEGRepresentation(iconImageFull, 0.1);
    UIImage *iconImage = [UIImage imageWithData:imageData];
    //分享标题
    NSString *desc = _headerStr;
    
    [UMSocialData defaultData].extConfig.title=desc;
    if(index<2){

        NSString *type =  UMShareToWechatTimeline;
        if (index==0) {
            type = UMShareToWechatSession;
        }
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:nil  image:iconImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];

    }else{
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = iconImage;
        data.shareText = [NSString stringWithFormat:@"%@%@",desc,shareUrl];
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
