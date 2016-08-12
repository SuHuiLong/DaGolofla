//
//  ResetPassViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ResetPassViewController.h"

#import "Helper.h"
#import "PostDataRequest.h"
#define kSend_URL @"user/sendPassByMobile.do"
#import "UserDataInformation.h"
#import "UserInformationModel.h"

#import "JPUSHService.h"

@interface ResetPassViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    //手机号
    UITextField* _textPass;
    
    UIButton* _btnBind;
    
    NSMutableDictionary* _dict;

    UIAlertView *_alertView;
}
@end

@implementation ResetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dict = [[NSMutableDictionary alloc]init];

    //手机号
    [self createNewPass];

    //提交
    [self createBtnBind];
}

-(void)createNewPass
{
    _textPass = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textPass];
    _textPass.delegate = self;
    _textPass.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPass.placeholder = @"请设置新密码";
    _textPass.textColor = [UIColor blackColor];
    _textPass.backgroundColor = [UIColor whiteColor];
    //    _textPhone.layer.cornerRadius = 10*ScreenWidth/375;
    //    _textPhone.layer.masksToBounds = YES;
    _textPass.borderStyle = UITextBorderStyleRoundedRect;
    _textPass.clearButtonMode = UITextFieldViewModeAlways;
    _textPass.returnKeyType = UIReturnKeyNext;
    
}

-(void)createBtnBind
{
    _btnBind = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    _btnBind.frame = CGRectMake(10*ScreenWidth/375, 64*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnBind];
    [_btnBind setTitle:@"确定" forState:UIControlStateNormal];
    [_btnBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnBind.layer.masksToBounds = YES;
    _btnBind.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnBind addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  重置
 */
-(void)resetClick
{
    [_textPass resignFirstResponder];
    _btnBind.userInteractionEnabled = NO;
    _btnBind.backgroundColor = [UIColor lightGrayColor];
    [_dict setObject:_textPass.text forKey:@"psw"];
    [_dict setObject:@3 forKey:@"login"];
    [_dict setObject:_tokenStr forKey:@"openid"];
    [_dict setObject:_uid forKey:@"uid"];
    [_dict setObject:_mobile forKey:@"mobile"];
    [_dict setObject:_vcode forKey:@"vcode"];
    [_dict setObject:_pic forKey:@"wxPicUrl"];
    [[PostDataRequest sharedInstance] postDataRequest:@"UserTHirdLogin/weixinLogin.do" parameter:_dict success:^(id respondsData) {
        ////NSLog(@"dicr == %@",_dict);
        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //////NSLog(@"%@",userData);
        if ([[userData objectForKey:@"success"] boolValue]) {
            //注册成功
            //////NSLog(@"%@",[userData objectForKey:@"message"]);
            _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [_alertView show];
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
            
//            //极光推送的id和数据
//            [self postAppJpost];
//            
//            NSString *token = [[userData objectForKey:@"rows"] objectForKey:@"rongTk"];
//            //注册融云
//            [self requestRCIMWithToken:token];
//            //保存信息
//            [self saveUserMobileAndPassword];            
            
            _btnBind.userInteractionEnabled = YES;
            _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            //注册失败
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            _btnBind.userInteractionEnabled = YES;
            _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        }
    } failed:^(NSError *error) {
        ////NSLog(@"%@",error);
        _btnBind.userInteractionEnabled = YES;
        _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    }];
}



//-(void)postAppJpost
//{
//    
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
//    if ([JPUSHService registrationID] != nil) {
//        [dict setObject:[JPUSHService registrationID] forKey:@"jgpush"];
//    }
//    
//    
//    [[PostDataRequest sharedInstance] postDataRequest:@"user/updateUserInfo.do" parameter:dict success:^(id respondsData) {
//    } failed:^(NSError *error) {
//    }];
//}
//-(void)requestRCIMWithToken:(NSString *)token{
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40*ScreenWidth/375, 40*ScreenWidth/375);
//    [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];
//    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
//    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
//    [[RCIM sharedRCIM] setUserInfoDataSource:[UserDataInformation sharedInstance]];
//    [[RCIM sharedRCIM] setGroupInfoDataSource:[UserDataInformation sharedInstance]];
//    NSString *str1=[NSString stringWithFormat:@"%@",[user objectForKey:@"userId"]];
//    NSString *str2=[NSString stringWithFormat:@"%@",[user objectForKey:@"userName"]];
//    NSString *str3=[NSString stringWithFormat:@"http://www.dagolfla.com:8081/small_%@",[user objectForKey:@"pic"]];
//    RCUserInfo *userInfo=[[RCUserInfo alloc] initWithUserId:str1 name:str2 portrait:str3];
//    [RCIM sharedRCIM].currentUserInfo=userInfo;
//    [RCIM sharedRCIM].enableMessageAttachUserInfo=NO;
//    //            [RCIM sharedRCIM].receiveMessageDelegate=self;
//    // 快速集成第二步，连接融云服务器
//    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//        //NSLog(@"1111");
//        //自动登录   连接融云服务器
//        [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
//        
//    }error:^(RCConnectErrorCode status) {
//        // Connect 失败
//        //NSLog(@"11111");
//    }tokenIncorrect:^() {
//        // Token 失效的状态处理
//        
//    }];
//}
//
//#pragma mark - 保存登陆信息
//- (void)saveUserMobileAndPassword {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setValuesForKeysWithDictionary:_dict];
//    [userDefaults synchronize];
//}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    return YES;
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textPass resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == _alertView) {
  
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    [user removeObjectForKey:@"userId"];
    [user synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
    // 让一段代码延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ////NSLog(@"延迟几秒执行");
        
            [_textPass becomeFirstResponder];
        
    });
    
}

@end
