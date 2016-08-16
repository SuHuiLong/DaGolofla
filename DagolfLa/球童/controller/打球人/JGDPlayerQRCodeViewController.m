//
//  JGMyBarCodeViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPlayerQRCodeViewController.h"
#import "UITool.h"
#import "PostDataRequest.h"
#import <CoreImage/CoreImage.h>

@interface JGDPlayerQRCodeViewController ()

@property (nonatomic, copy) NSString *qcodeID;
@property (nonatomic, strong) UIImageView* imgvBar;
@property (nonatomic, strong)  NSTimer * timer;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation JGDPlayerQRCodeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

// 解析图片的方法
- (void)readQRCodeFromImageWithFileURL:(NSURL *)url{
    
    CIImage *image = [CIImage imageWithContentsOfURL:url];
    UIImage *barImage = [UIImage imageWithCIImage:image];
    self.imgvBar.image = barImage;
    
    if (image) {
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *features = [qrDetector featuresInImage:image];
        if ([features count] > 0) {
            if (![features[0] isKindOfClass:[CIQRCodeFeature class]]) {
                return;
            }
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)features[0];
            
            NSString *code = [qrFeature.messageString mutableCopy];
            NSArray *stringArray = [code componentsSeparatedByString:@"qcodeID="];
            NSArray *newStringArray = [stringArray[1] componentsSeparatedByString:@"&md5="];
            self.qcodeID = newStringArray[0];
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:DEFAULF_USERID forKey:@"qcodeUserKey"];
            [dic setObject:self.qcodeID forKey:@"qCodeID"];
            NSLog(@"%@", DEFAULF_USERID);
            [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/doRegUserQCode" JsonKey:nil withData:dic failedBlock:^(id errType) {
                [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
            } completionBlock:^(id data) {
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    
                    NSLog(@"-------%@-----------", self.qcodeID);
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loopAct) userInfo:nil repeats:YES];
                    [self.timer fire];
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [self createView];
}

- (void)loopAct{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.qcodeID forKey:@"qCodeID"];
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/queryLoopCaddieQCodeState" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"bean"]) {
                
                self.dataDic = [data objectForKey:@"bean"];
                if ([[self.dataDic objectForKey:@"state"] integerValue] == 1) {

                    // 1 扫码成功  2 同意  3 拒绝
                    [self.timer invalidate];
                    self.timer = nil;
                    if ([data objectForKey:@"bean"]) {
                        _clipBlock([[data objectForKey:@"bean"] objectForKey:@"qcodeUserName"], 10);
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                }
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}


// 监听状态改变后
/*
 if ([data objectForKey:@"bean"]) {
 _clipBlock([[data objectForKey:@"bean"] objectForKey:@"qcodeUserName"], 10);
 [self.navigationController popViewControllerAnimated:YES];
 
 }
 */

- (void)alertAct{
    NSString *alertStr; //
    if ([[self.dataDic objectForKey:@"isQCodeCaddie"] integerValue] == 1) {
        alertStr = [NSString stringWithFormat:@"客户 %@ 请你代为记分", [self.dataDic objectForKey:@"scanUserName"]];
    }else if ([[self.dataDic objectForKey:@"isScanCaddie"] integerValue] == 1) {
        alertStr = [NSString stringWithFormat:@"球童 %@ 希望为您记分", [self.dataDic objectForKey:@"scanUserName"]];
    }
    [Helper alertViewWithTitle:alertStr withBlockCancle:^{
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.qcodeID forKey:@"qCodeID"];
        [dic setObject:@3 forKey:@"state"];
        [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/doCommitCaddieQCode" JsonKey:nil withData:dic failedBlock:^(id errType) {
            [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                if ([data objectForKey:@"bean"]) {
                    NSDictionary *dataDic = [data objectForKey:@"bean"];
                    if ([[dataDic objectForKey:@"state"] integerValue] == 1) {
                        // 1 扫码成功  2 同意  3 拒绝
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
        
    } withBlockSure:^{
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.qcodeID forKey:@"qCodeID"];
        [dic setObject:@2 forKey:@"state"];
        [[JsonHttp jsonHttp] httpRequestWithMD5:@"score/doCommitCaddieQCode" JsonKey:nil withData:dic failedBlock:^(id errType) {
            [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"%@",errType] FromView:self.view];
        } completionBlock:^(id data) {
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                if ([data objectForKey:@"bean"]) {
                    NSDictionary *dataDic = [data objectForKey:@"bean"];
                    if ([[dataDic objectForKey:@"state"] integerValue] == 1) {
                        // 1 扫码成功  2 同意  3 拒绝
                        
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
        
    } withBlock:^(UIAlertController *alertView) {
        
        [self presentViewController:alertView animated:YES completion:nil];
    }];
}


-(void)createView
{
    UIView* viewBack = [[UIView alloc]initWithFrame:CGRectMake(15*screenWidth/375, 25*screenWidth/375, screenWidth - 30*screenWidth/375, screenHeight - 77*screenWidth/375 - 64)];
    viewBack.backgroundColor = [UIColor whiteColor];
    viewBack.layer.cornerRadius = 8*screenWidth/375;
    viewBack.layer.masksToBounds = YES;
    [self.view addSubview:viewBack];
    
    
    
    
    UIImageView* imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 30*screenWidth/375, 60*screenWidth/375, 60*screenWidth/375)];
    [viewBack addSubview:imgvIcon];
    imgvIcon.layer.cornerRadius = 6*screenWidth/375;
    imgvIcon.layer.masksToBounds = YES;
    [imgvIcon sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[DEFAULF_USERID integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    /**
     
     */
    UIImageView* imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(80*screenWidth/375, 54*screenWidth/375, 14*screenWidth/375, 17*screenWidth/375)];
    [viewBack addSubview:imgvSex];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] == 0) {
        imgvSex.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        imgvSex.image = [UIImage imageNamed:@"xb_nn"];
    }
    
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/375, 30*screenWidth/375, 200*screenWidth/375, 60*screenWidth/375)];
    labelName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    labelName.font = [UIFont systemFontOfSize:20*screenWidth/375];
    [viewBack addSubview:labelName];
    
    
    
    
    self.imgvBar = [[UIImageView alloc]initWithFrame:CGRectMake(viewBack.frame.size.width/2 - 125*screenWidth/375, 130*screenWidth/375, 250*screenWidth/375, 250*screenWidth/375)];
    [viewBack addSubview:self.imgvBar];
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.imgvBar.frame.size.width / 2 - 30, self.imgvBar.frame.size.height / 2 - 30, 60*screenWidth/375, 60*screenWidth/375)];
    [self.imgvBar addSubview:imageV];
    imageV.layer.cornerRadius = 6*screenWidth/375;
    imageV.layer.masksToBounds = YES;
    [imageV sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[DEFAULF_USERID integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    //添加边框
    CALayer * layer = [imageV layer];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 2.0f;
    NSString* strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%tddagolfla.com",[DEFAULF_USERID integerValue] ]];
    //清楚缓存
    NSString *bgUrl = [NSString stringWithFormat:@"http://mobile.dagolfla.com/qcode/userQCode?userKey=%@&md5=%@",DEFAULF_USERID,strMd];
    
    [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES];
    
    
    NSString* strUrl = [NSString stringWithFormat:@"http://mobile.dagolfla.com/qcode/userQCode?userKey=%@&md5=%@",DEFAULF_USERID,strMd];
    //    [self.imgvBar sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:TeamBGImage]];
    [self readQRCodeFromImageWithFileURL:[NSURL URLWithString:strUrl]];
    
    UILabel* labelSign = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, viewBack.frame.size.height - 70*screenWidth/375, viewBack.frame.size.width - 20*screenWidth/375, 40*screenWidth/375)];
    labelSign.text = @"扫一扫图上二维码，添加好友。";
    labelSign.font = [UIFont systemFontOfSize:20*screenWidth/375];
    labelSign.textAlignment = NSTextAlignmentCenter;
    [viewBack addSubview:labelSign];
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
