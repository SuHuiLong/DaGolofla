//
//  MySetBindViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/26.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MySetBindViewController.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "MBProgressHUD.h"
#import "UserDataInformation.h"
#import "ResetPassViewController.h"
#import "UserInformationModel.h"

//#import "APService.h"
#import "JPUSHService.h"
@interface MySetBindViewController ()<UITextFieldDelegate>
{
    //手机号
    UITextField* _textPhone;
    //验证码
    UITextField* _textCaptChe;
    //获取验证码
    UIButton* _btnCaptChe;
    //绑定
    UIButton* _btnBind;
    
    NSMutableDictionary* _dict;
    
    NSString* _testStr1;//获取到的短信验证码
    NSString* _testStr; //输入的短信验证码
    
    NSTimer *_timer;
    
    MBProgressHUD *_progressHud;
    
    
}
@end

@implementation MySetBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _dict = [[NSMutableDictionary alloc]init];
    
    [self createView];
    
    //验证码
    [self createCaptC];
    //绑定按钮
    [self createBtnBind];
}

-(void)createBtnBind
{
    _btnBind = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBind.backgroundColor = [UIColor colorWithRed:0.95f green:0.60f blue:0.19f alpha:1.00f];
    _btnBind.frame = CGRectMake(10*ScreenWidth/375, 118*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnBind];
    [_btnBind setTitle:@"绑定" forState:UIControlStateNormal];
    [_btnBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnBind.layer.masksToBounds = YES;
    _btnBind.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnBind addTarget:self action:@selector(bindClick) forControlEvents:UIControlEventTouchUpInside];
}
//绑定
-(void)bindClick
{
    [_dict setObject:_textPhone.text forKey:@"mobile"];
    [_dict setObject:_tokenStr forKey:@"openid"];
    [_dict setObject:@2 forKey:@"login"];
    [_dict setObject:_uid forKey:@"uid"];
    [_dict setObject:_pic forKey:@"wxPicUrl"];
    if ([Helper testMobileIsTrue:_textPhone.text]) {
        if ([_testStr1 isEqualToString:_textCaptChe.text]) {
           //先要验证验证码是否正确
            [_dict setObject:_textCaptChe.text forKey:@"vcode"];
            
            [[PostDataRequest sharedInstance] postDataRequest:@"UserTHirdLogin/weixinLogin.do" parameter:_dict success:^(id respondsData) {
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                //////NSLog(@"%@",userData);
                
                if ([[userData objectForKey:@"success"] boolValue]) {
//                    //注册成功

                    
                    //登陆成功
                    UserInformationModel* model = [[UserInformationModel alloc]init];
                    [model setValuesForKeysWithDictionary:[userData objectForKey:@"rows"]];
                    [[UserDataInformation sharedInstance] saveUserInformation:model];
                    NSNumber* i = [[userData objectForKey:@"rows"] objectForKey:@"userId"];
                    [_dict setValue:i forKey:@"userId"];
                    //                ////NSLog(@"%@",_userInfoDict);
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    //判断是否登录，用来社区的刷新
                    [user setObject:@1 forKey:@"isFirstEnter"];
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"mobile"] forKey:@"mobile"];
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"userId"] forKey:@"userId"];
                    if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"pic"]]) {
                        [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
                    }
                    if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"userName"] ]) {
                        [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"userName"]forKey:@"userName"];
                    }
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"rongTk"] forKey:@"rongTk"];
                    [user synchronize];
                    
                    //极光推送的id和数据
                    [self postAppJpost];
                    
                    NSString *token = [[userData objectForKey:@"rows"] objectForKey:@"rongTk"];
                    //注册融云
                    [self requestRCIMWithToken:token];
                    //保存信息
                    [self saveUserMobileAndPassword];
                    [self.navigationController popViewControllerAnimated:YES];

 
                }else {
                    //注册失败
                    //////NSLog(@"%@",[userData objectForKey:@"message"]);
                    ResetPassViewController * resetVc = [[ResetPassViewController alloc]init];
                    resetVc.tokenStr = _tokenStr;
                    resetVc.uid = _uid;
                    resetVc.mobile = _textPhone.text;
                    resetVc.vcode = _textCaptChe.text;
                    resetVc.pic = _pic;
                    [self.navigationController pushViewController:resetVc animated:YES];
                    
                }
            } failed:^(NSError *error) {
                ////NSLog(@"%@",error);
            }];
        }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"4手机号码格式错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        }
    }
}

-(void)postAppJpost
{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    if ([JPUSHService registrationID] != nil) {
        [dict setObject:[JPUSHService registrationID] forKey:@"jgpush"];
    }
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"user/updateUserInfo.do" parameter:dict success:^(id respondsData) {
    } failed:^(NSError *error) {
    }];
}
-(void)requestRCIMWithToken:(NSString *)token{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40*ScreenWidth/375, 40*ScreenWidth/375);
    [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
    [[RCIM sharedRCIM] setUserInfoDataSource:[UserDataInformation sharedInstance]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:[UserDataInformation sharedInstance]];
    NSString *str1=[NSString stringWithFormat:@"%@",[user objectForKey:@"userId"]];
    NSString *str2=[NSString stringWithFormat:@"%@",[user objectForKey:@"userName"]];
    NSString *str3=[NSString stringWithFormat:@"http://139.196.9.49:8081/small_%@",[user objectForKey:@"pic"]];
    RCUserInfo *userInfo=[[RCUserInfo alloc] initWithUserId:str1 name:str2 portrait:str3];
    [RCIM sharedRCIM].currentUserInfo=userInfo;
    [RCIM sharedRCIM].enableMessageAttachUserInfo=NO;
    //            [RCIM sharedRCIM].receiveMessageDelegate=self;
    // 快速集成第二步，连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //NSLog(@"1111");
        //自动登录   连接融云服务器
        [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
        
    }error:^(RCConnectErrorCode status) {
        // Connect 失败
        //NSLog(@"11111");
    }tokenIncorrect:^() {
        // Token 失效的状态处理
        
    }];
}

#pragma mark - 保存登陆信息
- (void)saveUserMobileAndPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValuesForKeysWithDictionary:_dict];
    [userDefaults synchronize];
}

-(void)createCaptC
{
    _textCaptChe = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 64*ScreenWidth/375, ScreenWidth/3*2-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textCaptChe];
    _textCaptChe.delegate = self;
    _textCaptChe.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textCaptChe.placeholder = @"请输入短信验证码";
    _textCaptChe.textColor = [UIColor blackColor];
    _textCaptChe.backgroundColor = [UIColor whiteColor];
    _textCaptChe.borderStyle = UITextBorderStyleRoundedRect;
    _textCaptChe.clearButtonMode = UITextFieldViewModeAlways;
    
    
    _btnCaptChe = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCaptChe.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    _btnCaptChe.frame = CGRectMake(ScreenWidth/3*2, 64*ScreenWidth/375, ScreenWidth/3-10*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnCaptChe];
    [_btnCaptChe setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnCaptChe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnCaptChe.layer.masksToBounds = YES;
    _btnCaptChe.layer.cornerRadius = 5*ScreenWidth/375;
    _btnCaptChe.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_btnCaptChe addTarget:self action:@selector(captCClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 *  获取短信验证码
 */

static int timeNumber = 60;
-(void)captCClick
{
    [self.view endEditing:YES];
    _btnCaptChe.userInteractionEnabled = NO;
    _btnCaptChe.backgroundColor = [UIColor lightGrayColor];
    if ([Helper testMobileIsTrue:_textPhone.text]) {
        
        [[PostDataRequest sharedInstance] postDataRequest:@"user/queryMobileVaild.do" parameter:@{@"mobile":_textPhone.text,@"isreg":@0} success:^(id respondsData) {
            NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            _btnCaptChe.userInteractionEnabled = YES;
            _btnCaptChe.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
            if ([[dict1 objectForKey:@"success"] boolValue]) {
                
                _testStr1 = [NSString stringWithFormat:@"%@",[dict1 objectForKey:@"message"]];
                ////NSLog(@"1234 == %@",[dict1 objectForKey:@"message"]);
                timeNumber = 60;
                _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMoveTime) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict1 objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
            }
        } failed:^(NSError *error) {
            _btnCaptChe.userInteractionEnabled = YES;
            _btnCaptChe.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        }];
    }else {
        _btnCaptChe.userInteractionEnabled = YES;
        _btnCaptChe.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


#pragma mark - 加载效果
- (void)progressView {
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"正在刷新...";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
}

- (void)autoMoveTime {
    timeNumber--;
    _btnCaptChe.titleLabel.font = [UIFont systemFontOfSize:11];
    [_btnCaptChe setTitle:[NSString stringWithFormat:@"(%d)后重新获取",timeNumber] forState:UIControlStateNormal];
    if (timeNumber == 0) {
        _btnCaptChe.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnCaptChe setTitle:@"   发送验证码   " forState:UIControlStateNormal];
        [_timer invalidate];
        _btnCaptChe.userInteractionEnabled = YES;
    }
}
-(void)createView
{
    _textPhone = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textPhone];
    _textPhone.delegate = self;
    _textPhone.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPhone.placeholder = @"请输入手机号码";
    _textPhone.textColor = [UIColor blackColor];
    _textPhone.backgroundColor = [UIColor whiteColor];
//    _textPhone.layer.cornerRadius = 10*ScreenWidth/375;
//    _textPhone.layer.masksToBounds = YES;
    _textPhone.borderStyle = UITextBorderStyleRoundedRect;
    _textPhone.clearButtonMode = UITextFieldViewModeAlways;
    _textPhone.returnKeyType = UIReturnKeyNext;
   
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_textPhone == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == _textPhone) {
        [_textPhone resignFirstResponder];
        [_textCaptChe becomeFirstResponder];
    }
    else
    {
        [_textCaptChe resignFirstResponder];
    }
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textPhone resignFirstResponder];
    [_textCaptChe resignFirstResponder];
}


@end
