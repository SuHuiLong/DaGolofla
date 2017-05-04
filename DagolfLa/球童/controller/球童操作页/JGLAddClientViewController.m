//
//  DPSweepCodeViewController.m
//  24HMB
//
//  Created by Mac on 16/3/9.
//  Copyright © 2016年 24hmb. All rights reserved.
//
#define KBARITEN_WH  (22.0f)
#define QRCodeWidth  260.0   //正方形二维码的边长
#define SCREENWidth  [UIScreenmainScreen].bounds.size.width   //设备屏幕的宽度
#define SCREENHeight [UIScreen mainScreen].bounds.size.height //设备屏幕的高度

#import <AVFoundation/AVFoundation.h>
#import "JGLAddClientViewController.h"
#import "JGMyBarCodeViewController.h"
#import "UITool.h"
#import "JGLScoreSureViewController.h"
#import "JGLCaddieChooseStyleViewController.h"
#import "JGLCaddieSelfScoreViewController.h"
#import "JGDPlayerQRCodeViewController.h"

@interface JGLAddClientViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;//输入输出的中间桥梁
    NSInteger isCheck;
}

@property (nonatomic,strong) UIImageView      *line;
@property (nonatomic,strong) NSTimer          *timer;

@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (assign, nonatomic) BOOL cameraIsValid, cameraIsAuthorised;

@end

@implementation JGLAddClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCheck = 0;
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"扫码添加打球人";
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    //    [self setNavigationBarItem];
    [self setupMaskView];//设置扫描区域之外的阴影视图
    
    [self setupScanWindowView];//设置扫描二维码区域的视图
//    [self sweepCode];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isCheck == 0) {
        [self checkCameraAuth];
    }
}

-(BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//判断相机是否可用
-(BOOL)canUseCamera {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设备的“设置-隐私-相机”中允许访问相机。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

-(void)checkCameraAuth {
    isCheck = 1;
    //判断相机权限
    NSString *mediaType = AVMediaTypeVideo;//Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {//拒绝授权
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设备的“设置-隐私-相机”中允许访问相机。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if(authStatus == AVAuthorizationStatusAuthorized){//已经授权
        //启动扫码
        [self sweepCode];
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
                //启动扫码
                [self sweepCode];
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }
}

- (void)setupMaskView
{
    //设置统一的视图颜色和视图的透明度
    UIColor *color = [UIColor blackColor];
    float alpha = 0.7;
    
    //设置扫描区域外部上部的视图
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, -64, screenWidth, (screenHeight-QRCodeWidth)/2.0);
    topView.backgroundColor = color;
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, topView.frame.size.height-64, (screenWidth-QRCodeWidth)/2.0,QRCodeWidth);
    leftView.backgroundColor = color;
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    UIView *rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake((screenWidth-QRCodeWidth)/2.0+QRCodeWidth,topView.frame.size.height-64, (screenWidth-QRCodeWidth)/2.0,QRCodeWidth);
    rightView.backgroundColor = color;
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    UIView *botView = [[UIView alloc]init];
    botView.frame = CGRectMake(0, QRCodeWidth+topView.frame.size.height-64,screenWidth,SCREENHeight-QRCodeWidth-topView.frame.size.height);
    botView.backgroundColor = color;
    botView.alpha = alpha;
    
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:botView];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, QRCodeWidth+topView.frame.size.height-64 + 30*screenWidth/375, screenWidth, 30)];
    label.text = @"请将二维码放入框内";
    label.font = [UIFont systemFontOfSize:15*screenWidth/375];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    /*
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, QRCodeWidth+topView.frame.size.height-64 + 60*screenWidth/375, screenWidth, 40);
    [btn setTintColor:[UITool colorWithHexString:@"#32b14d" alpha:1]];
    [btn setTitle:@"我的二维码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(myCodeBarClick) forControlEvents:UIControlEventTouchUpInside];
    */
}



- (void)setupScanWindowView
{
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((screenWidth-QRCodeWidth)/2.0,(screenHeight-QRCodeWidth-64)/2.0-32*screenWidth/375,QRCodeWidth,QRCodeWidth+31*screenWidth/375)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    //    scanWindow.backgroundColor = [UIColor redColor];
    
    //设置扫描区域的动画效果
    CGFloat scanNetImageViewH = 241;
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    UIImageView *scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"saoma_tiao"]];
    scanNetImageView.frame = CGRectMake(0, 0, QRCodeWidth, QRCodeWidth+30);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath =@"transform.translation.y";
    scanNetAnimation.byValue = @(QRCodeWidth);
    scanNetAnimation.duration = 1.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    //    scanNetImageView.backgroundColor = [UIColor orangeColor];
    //这是扫码的边框
    UIImageView *backRoundImgv = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, QRCodeWidth,QRCodeWidth)];
    backRoundImgv.image = [UIImage imageNamed:@"saoma_kuang"];
    [scanWindow addSubview:backRoundImgv];
    
    
    //    //设置扫描区域的四个角的边框
    //    CGFloat buttonWH = 18;
    //    UIButton *topLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,0, buttonWH, buttonWH)];
    //    [topLeft setImage:[UIImage imageNamed:@"scan_1"]forState:UIControlStateNormal];
    //    [scanWindow addSubview:topLeft];
    //
    //    UIButton *topRight = [[UIButton alloc]initWithFrame:CGRectMake(QRCodeWidth - buttonWH,0, buttonWH, buttonWH)];
    //    [topRight setImage:[UIImage imageNamed:@"scan_2"]forState:UIControlStateNormal];
    //    [scanWindow addSubview:topRight];
    //
    //    UIButton *bottomLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,QRCodeWidth - buttonWH, buttonWH, buttonWH)];
    //    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"]forState:UIControlStateNormal];
    //    [scanWindow addSubview:bottomLeft];
    //
    //    UIButton *bottomRight = [[UIButton alloc]initWithFrame:CGRectMake(QRCodeWidth-buttonWH,QRCodeWidth-buttonWH, buttonWH, buttonWH)];
    //    [bottomRight setImage:[UIImage imageNamed:@"scan_4"]forState:UIControlStateNormal];
    //    [scanWindow addSubview:bottomRight];
    
    
    
}
-(void)myCodeBarClick
{
//    JGMyBarCodeViewController* barVc = [[JGMyBarCodeViewController alloc]init];
//    [self.navigationController pushViewController:barVc animated:YES];
    
    JGDPlayerQRCodeViewController* barVc = [[JGDPlayerQRCodeViewController alloc]init];
    [self.navigationController pushViewController:barVc animated:YES];
}
#pragma mark - 启动扫码
- (BOOL)sweepCode {//初始化配置
    NSError * error;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.cameraIsValid = [self validateCamera];
    self.cameraIsAuthorised = [self canUseCamera];
    if (self.cameraIsAuthorised && self.cameraIsValid) {
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            NSLog(@"%@", [error localizedDescription]);
            return NO;
        }
        //创建输出流
        _output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];//这个设置为high，扫描会很快，但是对性能要求高，
        
        [_session addInput:input];
        [_session addOutput:_output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [_session startRunning];
        
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
        } else {
            [_timer setFireDate:[NSDate distantPast]];
        }
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"没有摄像头或相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    return YES;
}
-(void)dealloc
{
    _timer = nil;
}

#pragma mark - lineAnimation
- (void)lineAnimation {//扫码时横线的动画
    CGFloat width = 250;
    [UIView animateWithDuration:0.9 animations:^{
        CGRect frame = self.line.frame;
        frame.origin.y += width - 2;
        self.line.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = self.line.frame;
        frame.origin.y = (self.view.frame.size.height - width) / 2;
        self.line.frame = frame;
    }];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        //得到二维码上的所有数据
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0 ];
        NSString *str = metadataObject.stringValue;
        if ([str containsString:@"dagolfla"] == YES) {
            [_session stopRunning];
            NSMutableDictionary* dict =[[NSMutableDictionary alloc]init];
            NSLog(@"%@",[Helper returnUrlString:str WithKey:@"qcodeID"]);
            [dict setObject:[Helper returnUrlString:str WithKey:@"qcodeID"] forKey:@"qCodeID"];
            [dict setObject:DEFAULF_USERID forKey:@"scanUserKey"];
            [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/doQCodeFinish" JsonKey:nil withData:dict failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    if ([data objectForKey:@"bean"]) {
                        
                        NSDictionary *dataDic = [data objectForKey:@"bean"];
                        if ([[data objectForKey:@"acBoolean"] integerValue] == 1) {
                            if ([[dataDic objectForKey:@"isQCodeCaddie"] integerValue] == 1) {//球童扫码
                                _blockQcodeActivityScore([dataDic objectForKey:@"scanUserKey"], [dataDic objectForKey:@"scanUserName"], [[dataDic objectForKey:@"sex"] integerValue]);
                            }else{//客户扫码
                                _blockQcodeActivityScore([dataDic objectForKey:@"qcodeUserKey"], [dataDic objectForKey:@"qcodeUserName"], [[dataDic objectForKey:@"sex"] integerValue]);
                                
                            }
//                            [self.navigationController pushViewController:choVc animated:YES];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else{
                            
                            
                            if ([[dataDic objectForKey:@"isQCodeCaddie"] integerValue] == 1) {//球童扫码
                                _blockQcodeScore([dataDic objectForKey:@"scanUserKey"], [dataDic objectForKey:@"scanUserName"], [[dataDic objectForKey:@"sex"] integerValue]);
                            }
                            else{//客户扫码
                                _blockQcodeScore([dataDic objectForKey:@"qcodeUserKey"], [dataDic objectForKey:@"qcodeUserName"], [[dataDic objectForKey:@"sex"] integerValue]);
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }
                }
                else{
                    
                    [self.timer invalidate];
                    self.timer = nil;
                    //1，二维码未找到，2，球童扫描球童，3，打球人扫打球人
                    if ([[data objectForKey:@"errorState"] integerValue] == 2) {
                        JGLScoreSureViewController* suVc = [[JGLScoreSureViewController alloc]init];
                        suVc.errorState = 2;
                        [self.navigationController pushViewController:suVc animated:YES];
                        return ;
                    }else if ([[data objectForKey:@"errorState"] integerValue] == 3){
                        
                    }else{
                        [[ShowHUD showHUD]showToastWithText:@"二维码失效" FromView:self.view];
                    }
                    [_session startRunning];
                }
            }];
        }
    }
}

- (BOOL)regexGUID:(NSString *)result{
    NSString *GUID = @"[a-fA-F0-9]{8}(-[a-fA-F0-9]{4}){3}-[a-fA-F0-9]{12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",GUID];
    BOOL isMatch = [pred evaluateWithObject:result];
    return isMatch;
}

- (BOOL)validateURL:(NSString *)textString
{
    NSString* number=@"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}


-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.71 blue:0.29 alpha:1]];
//    
//}

//- (UIAlertController *)alertController{
//    if (!_alertController) {
//        _alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    }
//    return _alertController;
//}
//
//- (SignInViewModel *)signInViewModel{
//    if (!_signInViewModel) {
//        _signInViewModel = [[SignInViewModel alloc]init];
//    }
//    return _signInViewModel;
//}

@end
