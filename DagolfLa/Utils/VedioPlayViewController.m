//
//  VedioPlayViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/4/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "VedioPlayViewController.h"
#import "ALMoviePlayerController.h"
#import "ContantHead.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSString *const NotificationName = @"AFNetworkReachabilityStatusReachableViaWWAN";

@interface VedioPlayViewController ()<ALMoviePlayerControllerDelegate, ALMoviePlayerAutorotateDelegate>
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;//视频播放器
@property (nonatomic, strong) ALMoviePlayerControls *movieControls;
@property (nonatomic) CGRect defaultFrame;
@property (nonatomic, strong) UIButton *downloadBtn;
@end

@implementation VedioPlayViewController
{
    BOOL isEverPlayer;//当前视频是否获取链接播放过
    NSString *_savedPath;//TMP视频路径
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self _initItems];
    [self _initRightItems];
    //添加视频控件
    [self addVideoPlayer];
    
}

- (void)_initItems
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = BackBtnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initItemsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark ---  关闭
- (void)initItemsBtnClick:(UIButton *)btn{
    [self.moviePlayer stop];
    if (self.delegate) {
        [self.delegate closeVideo];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        //        [self.delegate closeVideo];
        
    }];
}
- (void)_initRightItems
{
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = RightNavItemFrame;
    self.downloadBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [self.downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    self.downloadBtn.userInteractionEnabled = YES;
    [self.downloadBtn addTarget:self action:@selector(riightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.downloadBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -- 下载视频 -- 逻辑，下载到tmp目录后转到用户相册
- (void)riightBtnClick:(UIButton *)btn{
    self.downloadBtn.userInteractionEnabled = NO;
    [self.downloadBtn setTitle:@"下载中..." forState:UIControlStateNormal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    formatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    NSString *vedioFileName = [NSString stringWithFormat:@"%@.mp4", fileName];
    _savedPath = [NSTemporaryDirectory() stringByAppendingString:vedioFileName];
    NSLog(@"%@", _savedPath);
    __weak VedioPlayViewController *vedioCtrl = self;
    
    
    [PostDataRequest downloadFileWithURL:self.vedioURL parameters:nil savedPath:_savedPath downloadSuccess:^(NSURLResponse *response, NSURL *filePath) {
        NSLog(@"%@", response);
        [vedioCtrl saveVedioForPhotosAssets];
    } downloadFailure:^(NSError *error) {
        
    } downloadProgress:^(NSProgress *downloadProgress) {
        
    }];
    
    
    
    
}
#pragma mark -- 保存视频到相册
- (void)saveVedioForPhotosAssets{
    NSURL *vedio = [NSURL fileURLWithPath:_savedPath];
    ALAssetsLibrary *alaLibarary = [[ALAssetsLibrary alloc]init];
    [alaLibarary writeVideoAtPathToSavedPhotosAlbum:vedio completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"Save video fail:%@",error);
        } else {
            UIAlertView *dowloadView = [[UIAlertView alloc]initWithTitle:nil message:@"已下载到相册中！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [dowloadView show];
            [self performSelector:@selector(hidenDownloadView:) withObject:dowloadView afterDelay:0.8f];
            self.downloadBtn.userInteractionEnabled = NO;
            [self.downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
        }
    }];
}
- (void)hidenDownloadView:(UIAlertView *)alertView{
    
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
//添加视频播放控件
- (void)addVideoPlayer{
    //create a player
    
    self.navigationController.navigationBarHidden = NO;
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    self.moviePlayer.view.alpha = 0.f;
    self.moviePlayer.delegate = self; //IMPORTANT!
    
    //create the controls
    self.movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
    self.movieControls.AutorotateDelegate = self;
    //    [self.movieControls setBarColor:RGB(85, 80, 78, 0.5)];
    [self.movieControls setTimeRemainingDecrements:YES];
    [self.moviePlayer setControls:self.movieControls];
    [self.view addSubview:self.moviePlayer.view];
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self configureViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.moviePlayer.view.alpha = 1.f;
            
        } completion:^(BOOL finished) {
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    });
    
    [self.moviePlayer play];
    [self.moviePlayer setContentURL:[NSURL URLWithString:self.vedioURL]];
    isEverPlayer = YES;
}

#pragma mark -- 设置默认的 frame
- (void)configureViewForOrientation:(UIInterfaceOrientation)orientation {
    //设置默认的frame
    self.defaultFrame = CGRectMake(0, 0, self.moviePlayer.view.frame.size.width, screenHeight-64);
    if (self.moviePlayer.isFullscreen){
        return;
    }
    //MUST use [ALMoviePlayerController setFrame:] to adjust frame
    [self.moviePlayer setFrame:self.defaultFrame];
}
#pragma mark -- ALMoviePlayerControllerDelegate
- (void)movieTimedOut {
    NSLog(@"MOVIE TIMED OUT");
}

#pragma mark --- ALMoviePlayerControllerDelegate
- (void)moviePlayerWillMoveFromWindow {
    //    if (![self.playerView.subviews containsObject:self.moviePlayer.view]){
    //        [self.playerView addSubview:self.moviePlayer.view];
    //    }
    [self.moviePlayer setFrame:self.defaultFrame];
}

#pragma mark - ALMoviePlayerAutorotateDelegate
- (void)isFullScreen:(BOOL)isClickFull{
    if (isClickFull) {
        //设置应用程序的状态栏到指定的方向
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        //view旋转
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        
        //隐藏navigationController
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        //隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        self.moviePlayer.view.frame = CGRectMake(0, 0, screenHeight, screenWidth);
        self.movieControls.frame = CGRectMake(0, 0, screenHeight, screenWidth);//触摸事件
    }else{
        //状态栏旋转
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI * 2)];
        
        //显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        //显示navigationController
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        [self.moviePlayer setFrame:self.defaultFrame];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
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
