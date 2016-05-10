//
//  EnterViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "EnterViewController.h"

#import "ForgetViewController.h"
#import "EnrollViewController.h"

#import "Helper.h"
#import "UserDataInformation.h"
#import "PostDataRequest.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "UMSocialDataService.h"
#import "MySetBindViewController.h"

#import "MySetViewController.h"

#import "MeViewController.h"


#import "MBProgressHUD.h"

#import "UserInformationModel.h"

#import "JPUSHService.h"

#import "NoteHandlle.h"
#import "NoteModel.h"

#define kUserLogin_URL @"user/login.do"
@interface EnterViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField* _textPhone;
    UITextField* _textPassWord;
    
    NSMutableDictionary* _dict, * _userInfoDict;
    
    // 判断用户点击的是哪一个输入框
    NSInteger _isShowAlertView;
    
    MBProgressHUD* _progress;
}
@end

@implementation EnterViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    [super viewWillAppear:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录账户";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];

    _dict = [[NSMutableDictionary alloc]init];
    _userInfoDict = [[NSMutableDictionary alloc]init];
    [self enterView];
    
    [self enrollViewAndFoget];
    
    [self weixinView];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(enrollClick)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    
}


-(void)enterView
{
    
    UIView* viewPhone = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    viewPhone.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewPhone];
    
    UIImageView* imgePhone = [[UIImageView alloc]initWithFrame:CGRectMake(17*ScreenWidth/375, 14*ScreenWidth/375, 10*ScreenWidth/375, 16*ScreenWidth/375)];
    imgePhone.image = [UIImage imageNamed:@"phone"];
    [viewPhone addSubview:imgePhone];
    imgePhone.backgroundColor = [UIColor whiteColor];
    
    UIView * viewline = [[UIView alloc]initWithFrame:CGRectMake(43*ScreenWidth/375, 0, 1*ScreenWidth/375, 44*ScreenWidth/375)];
    viewline.backgroundColor = [UIColor colorWithRed:0.62f green:0.63f blue:0.63f alpha:1.00f];
    [viewPhone addSubview:viewline];
    
    
    _textPhone = [[UITextField alloc]initWithFrame:CGRectMake(50*ScreenWidth/375, 0, ScreenWidth-70*ScreenWidth/375, 44*ScreenWidth/375)];
    _textPhone.placeholder = @"请输入手机号码/账号";
    _textPhone.backgroundColor = [UIColor whiteColor];
    _textPhone.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textPhone.delegate = self;
    [viewPhone addSubview:_textPhone];
    _textPhone.tag = 101;
    _textPhone.returnKeyType = UIReturnKeyNext;
    _textPhone.clearButtonMode = UITextFieldViewModeAlways;
    
    
    UIView* viewPass = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 64*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    viewPass.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewPass];
    
    UIImageView* imgaPass = [[UIImageView alloc]initWithFrame:CGRectMake(17*ScreenWidth/375, 14*ScreenWidth/375, 10*ScreenWidth/375, 16*ScreenWidth/375)];
    imgaPass.image = [UIImage imageNamed:@"mima"];
    [viewPass addSubview:imgaPass];
    imgaPass.tintColor = [UIColor whiteColor];
    
    UIView * viewline1 = [[UIView alloc]initWithFrame:CGRectMake(43*ScreenWidth/375, 0, 1*ScreenWidth/375, 44*ScreenWidth/375)];
    viewline1.backgroundColor = [UIColor colorWithRed:0.62f green:0.63f blue:0.63f alpha:1.00f];
    [viewPass addSubview:viewline1];
    
    
    
    _textPassWord = [[UITextField alloc]initWithFrame:CGRectMake(50*ScreenWidth/375, 0*ScreenWidth/375, ScreenWidth-70*ScreenWidth/375, 44*ScreenWidth/375)];
    _textPassWord.placeholder = @"请输入密码";
    _textPassWord.delegate = self;
    _textPassWord.backgroundColor = [UIColor whiteColor];
    _textPassWord.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewPass addSubview:_textPassWord];
    _textPassWord.tag = 102;
    _textPassWord.returnKeyType = UIReturnKeyDone;
    _textPassWord.clearButtonMode = UITextFieldViewModeAlways;
    _textPassWord.secureTextEntry = YES;
    
    UIButton* btnEnter = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnter.frame = CGRectMake(10*ScreenWidth/375, 118*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [btnEnter setTitle:@"登录" forState:UIControlStateNormal];
    btnEnter.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    btnEnter.layer.cornerRadius = 10*ScreenWidth/375;
    btnEnter.layer.masksToBounds = YES;
    [self.view addSubview:btnEnter];
    [btnEnter addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark --键盘响应事件
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == _textPhone) {
        [_textPhone resignFirstResponder];
        [_textPassWord becomeFirstResponder];
    }
    else
    {
        [_textPassWord resignFirstResponder];
    }
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_textPassWord resignFirstResponder];
    [_textPhone resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textPhone resignFirstResponder];
    [_textPassWord resignFirstResponder];
}

#pragma mark - 获取用户登录信息
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *userStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 101) {
//        [self reapUserLoginInformation:userStr key:@"mobile"];
    }else if(textField.tag == 102) {
//        [self reapUserLoginInformation:userStr key:@"passWord"];
    }
    return YES;
}
- (void)reapUserLoginInformation:(NSString*)value key:(NSString*)key{
    [_dict setValue:value forKey:key];
    
}

/**
 *  登录按钮
 */
-(void)enterClick
{
    
    [_textPhone resignFirstResponder];
    [_textPassWord resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //验证手机号码格式
//    if ([Helper testMobileIsTrue:_textPhone.text]) {
        //手机号码格式正确
    [_dict setObject:_textPhone.text forKey:@"mobile"];
    [_dict setObject:_textPassWord.text forKey:@"passWord"];
        [[PostDataRequest sharedInstance] postDataRequest:kUserLogin_URL parameter:_dict success:^(id respondsData) {
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            
            if ([[userData objectForKey:@"success"] boolValue]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                //登陆成功
                
                
                UserInformationModel* model = [[UserInformationModel alloc]init];
                [model setValuesForKeysWithDictionary:[userData objectForKey:@"rows"]];
                [[UserDataInformation sharedInstance] saveUserInformation:model];
                NSNumber* i = [[userData objectForKey:@"rows"] objectForKey:@"userId"];
                [_dict setValue:i forKey:@"userId"];
          
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                //判断是否登录，用来社区的刷新
                [user setObject:@1 forKey:@"isFirstEnter"];
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"userId"] forKey:@"userId"];
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"mobile"] forKey:@"mobile"];
                
                if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"pic"]]) {
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
                }
                if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"userName"]]) {
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"userName"] forKey:@"userName"];
                }
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"rongTk"] forKey:@"rongTk"];
                [user synchronize];
                
                [self getAllNote];
                //保存信息
                [self saveUserMobileAndPassword];
                //极光推送的id和数据
                [self postAppJpost];
                
                NSString *token = [[userData objectForKey:@"rows"] objectForKey:@"rongTk"];
                //注册融云
                [self requestRCIMWithToken:token];
                
                if (_jiazai) {
                    _jiazai();
                }
                
                //退出登录之后 重新登录 跳转到个人页面
                    if (self.popViewNumber == 101) {
                        UIViewController *target=nil;
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[MeViewController class]]) {
                                target=vc;
                            }
                        }
                        if (target) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refreshing" object:nil];
                            
                            [self.navigationController popToViewController:target animated:YES];
                        }
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                
            }else {
                //登录失败
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                _isShowAlertView = 1;
                [alertView show];
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }];
}


#pragma mark ------ 获取服务器上所有备注存储到本地

- (void)getAllNote{
    
    [NoteHandlle deleteAll];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/doGetUserList.do" parameter:dic success:^(id respondsData) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            NSArray *array = [dic objectForKey:@"rows"];
            if (array) {
                for (NSDictionary *newDic in array) {
                    NoteModel *model = [[NoteModel alloc] init];
                    [model setValuesForKeysWithDictionary:newDic];
                    [NoteHandlle insertNote:model];
                }
            }
        }
        
        
        
    } failed:^(NSError *error) {
        
    }];
    
    
    
    
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
        //自动登录   连接融云服务器
        [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
        
    }error:^(RCConnectErrorCode status) {
        // Connect 失败
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

-(void)enrollViewAndFoget
{
    UIButton* btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForget.frame = CGRectMake(10*ScreenWidth/375, 200*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [btnForget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [btnForget setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnForget.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:btnForget];
    [btnForget addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* labelEnroll = [[UILabel alloc]initWithFrame:CGRectMake(20*ScreenWidth/375, 230*ScreenWidth/375, ScreenWidth/2, 44*ScreenWidth/375)];
    labelEnroll.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    labelEnroll.text = @"没有账号?点击";
    labelEnroll.textAlignment = NSTextAlignmentRight;
    labelEnroll.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    [self.view addSubview:labelEnroll];
    
    
    
    UIButton* btnEnroll = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnroll.frame = CGRectMake(ScreenWidth/2+20*ScreenWidth/375, 230*ScreenWidth/375, 60*ScreenWidth/375, 44*ScreenWidth/375);
    [btnEnroll setTitle:@"快速注册" forState:UIControlStateNormal];
    [btnEnroll setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnEnroll.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:btnEnroll];
    [btnEnroll addTarget:self action:@selector(enrollClick) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  忘记密码点击事件
 */
-(void)forgetClick
{
    ForgetViewController* forVc = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forVc animated:YES];
}
/**
 *  注册界面点击事件
 */
-(void)enrollClick
{
    EnrollViewController* enrVc = [[EnrollViewController alloc]init];
    [self.navigationController pushViewController:enrVc animated:YES];
}


/**
 *  微信登录视图创建
 */
-(void)weixinView
{
    
    UIButton* btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChat.frame = CGRectMake(ScreenWidth/2-30*ScreenWidth/375, ScreenHeight-245*ScreenWidth/375-64, 60*ScreenWidth/375, 60*ScreenWidth/375);
    [btnChat setImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
    [self.view addSubview:btnChat];
    [btnChat addTarget:self action:@selector(weChatClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(2*ScreenWidth/375, ScreenHeight-170*ScreenWidth/375-64, ScreenWidth, 20*ScreenWidth/375)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"无需注册,微信登录";
    [self.view addSubview:labelTitle];
    labelTitle.textColor = [UIColor colorWithRed:0.62f green:0.63f blue:0.63f alpha:1.00f];
    
}


-(void)weChatClick
{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSMutableDictionary* dictWx = [[NSMutableDictionary alloc]init];
            [dictWx setObject:@1 forKey:@"login"];
            [dictWx setObject:snsAccount.openId forKey:@"openid"];
            [dictWx setObject:snsAccount.userName forKey:@"uid"];
            [dictWx setObject:snsAccount.iconURL forKey:@"wxPicUrl"];
//            [dictWx setObject:snsAccount.gender forKey:@"sex"];
            [[PostDataRequest sharedInstance] postDataRequest:@"UserTHirdLogin/weixinLogin.do" parameter:dictWx success:^(id respondsData) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([[dict objectForKey:@"success"] integerValue] == 1) {
                    //登陆成功
                    UserInformationModel* model = [[UserInformationModel alloc]init];
                    [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                    [[UserDataInformation sharedInstance] saveUserInformation:model];
                    NSNumber* i = [[dict objectForKey:@"rows"] objectForKey:@"userId"];
                    [_dict setValue:i forKey:@"userId"];
                    ////NSLog(@"%@",_userInfoDict);
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    //判断是否登录，用来社区的刷新
                    [user setObject:@1 forKey:@"isFirstEnter"];
                    [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"mobile"] forKey:@"mobile"];
                    [user setObject:snsAccount.openId forKey:@"openId"];
                    [user setObject:snsAccount.userName forKey:@"uid"];
                    [user setObject:@1 forKey:@"isWeChat"];
                    [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"userId"] forKey:@"userId"];
                    if (![Helper isBlankString:[[dict objectForKey:@"rows"] objectForKey:@"pic"]]) {
                        [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
                    }
                    if (![Helper isBlankString:[[dict objectForKey:@"rows"] objectForKey:@"userName"] ]) {
                        [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"userName"] forKey:@"userName"];
                       
                    }
                    [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"rongTk"] forKey:@"rongTk"];
                    [user synchronize];
                    //保存信息
                    [self saveUserMobileAndPassword];
                    
                    //极光推送的id和数据
                    [self postAppJpost];
                    
                    NSString *token = [[dict objectForKey:@"rows"] objectForKey:@"rongTk"];
                    //注册融云
                    [self requestRCIMWithToken:token];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    MySetBindViewController* myVc = [[MySetBindViewController alloc]init];
                    myVc.tokenStr = snsAccount.openId;
                    myVc.uid = snsAccount.userName;
                    myVc.pic = snsAccount.iconURL;
                    [self.navigationController pushViewController:myVc animated:YES];
                }
                
            } failed:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
        
        
       });
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        ////NSLog(@"SnsInformation is %@",response.data);
    }];


}

@end
