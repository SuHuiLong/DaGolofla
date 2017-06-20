//
//  MakePhotoTextDoneViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextDoneViewController.h"
#import "JGDDPhotoAlbumViewController.h"
#import "JGDNewTeamDetailViewController.h"

@interface MakePhotoTextDoneViewController ()<UMSocialUIDelegate>
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

//成功跳转提示框
-(void)createSucessAlertView{

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享已成功！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"再做一份" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[JGDDPhotoAlbumViewController class]]) {
                    [self.navigationController popToViewController:vc animated:false];
                    return;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"回到球队首页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[JGDNewTeamDetailViewController class]]) {
                    [self.navigationController popToViewController:vc animated:false];
                    return;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    });

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
            [self popBack];
            break;
            
        default:
            break;
    }
}



#pragma mark ----- 分享
-(void)shareStatisticsDataClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(210));
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
    NSString*  shareUrl = [NSString stringWithFormat:@"%@&share=1",_urlStr];
    //分享图片
    UIImage *iconImageFull = [UIImage imageWithData:[NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[_timeKey integerValue] andIsSetWidth:YES andIsBackGround:NO]]];
    //分享标题
    NSString *desc = _headerStr;
    
    [UMSocialData defaultData].extConfig.title=desc;
    if (index<2) {
        NSData *imageData = UIImageJPEGRepresentation(iconImageFull, 0.1);
        UIImage *iconImage = [UIImage imageWithData:imageData];

        NSString *type =  UMShareToWechatTimeline;
        if (index==0) {
            type = UMShareToWechatSession;
        }
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        /*
         发送微博内容到多个微博平台
         @param platformTypes    分享到的平台，数组的元素是`UMSocialSnsPlatformManager.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
         @param content          分享的文字内容
         @param image            分享的图片,可以传入UIImage类型或者NSData类型
         @param location         分享的地理位置信息
         @param urlResource      图片、音乐、视频等url资源
         @param completion       发送完成执行的block对象
         @param presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
         */
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: shareUrl];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_writerStr  image:iconImage location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [self createSucessAlertView];
            }
        }];
    }else{
        NSData *imageData = UIImageJPEGRepresentation(iconImageFull, 0.8);
        UIImage *iconImage = [UIImage imageWithData:imageData];

        UMSocialData *data = [UMSocialData defaultData];
        data.title = _headerStr;
        data.shareImage = iconImage;
        data.shareText = [NSString stringWithFormat:@"%@%@",desc,shareUrl];
        
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        [[UMSocialControllerService defaultControllerService] setSocialUIDelegate:self];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
}
//删除
-(void)popBack{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGDDPhotoAlbumViewController class]]) {
            [self.navigationController popToViewController:vc animated:false];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        [self createSucessAlertView];
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
