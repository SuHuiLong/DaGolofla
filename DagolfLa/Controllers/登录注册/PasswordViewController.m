//
//  PasswordViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "PasswordViewController.h"
#import "Helper.h"
#import "PostDataRequest.h"
#import "UserInformationModel.h"
#import "UserDataInformation.h"
#import "JPUSHService.h"
#import "SelfViewController.h"
#import "UITool.h"
#define kRegist_URL @"user/regist.do"
@interface PasswordViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    //手机号
    UITextField* _textAgain;
    //用户名
    UITextField* _textPass;
    //绑定
    UIButton* _btnBind;
    
    NSMutableDictionary* _dict;
    
    // 判断用户点击的是哪一个输入框
    NSInteger _isShowAlertView;
    
    UITextField* _textInvite;
}
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dict = [[NSMutableDictionary alloc]init];

    if (![Helper isBlankString:_userName]) {
        [_dict setObject:_userName forKey:@"userName"];
    }
    else{
        
    }
    if (![Helper isBlankString:_phoneNum]) {
        [_dict setObject:_phoneNum forKey:@"mobile"];
    }
    else{
        [_dict setObject:@"" forKey:@"mobile"];
    }
    
    //密码
    [self createPass];
    //确定密码
    [self createAgain];
    //按钮
    [self createBtnBind];
    
    [self createInvite];

    
}

-(void)createPass
{
    _textPass = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textPass];
    _textPass.delegate = self;
    _textPass.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPass.placeholder = @"请输入密码(至少六位)";
    _textPass.textColor = [UIColor blackColor];
    _textPass.backgroundColor = [UIColor whiteColor];
    //    _textPhone.layer.cornerRadius = 10*ScreenWidth/375;
    //    _textPhone.layer.masksToBounds = YES;
    _textPass.borderStyle = UITextBorderStyleRoundedRect;
    _textPass.clearButtonMode = UITextFieldViewModeAlways;
    _textPass.returnKeyType = UIReturnKeyNext;
    
}

-(void)createAgain
{
    _textAgain = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 64*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textAgain];
    _textAgain.delegate = self;
    _textAgain.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textAgain.placeholder = @"请再次输入密码(至少六位)";
    _textAgain.textColor = [UIColor blackColor];
    _textAgain.backgroundColor = [UIColor whiteColor];
    //    _textPhone.layer.cornerRadius = 10*ScreenWidth/375;
    //    _textPhone.layer.masksToBounds = YES;
    _textAgain.borderStyle = UITextBorderStyleRoundedRect;
    _textAgain.clearButtonMode = UITextFieldViewModeAlways;
    _textAgain.returnKeyType = UIReturnKeyNext;
}

#pragma mark --输入框代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_textAgain == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            [Helper alertViewWithTitle:@"超过最大字数不能输入了" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
            return NO;
        }
    }
    return YES;
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == _textPass) {
        [_textAgain becomeFirstResponder];
        [_textPass resignFirstResponder];
    }
    
    else
    {
        [_textAgain resignFirstResponder];
        
    }
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textAgain resignFirstResponder];
}

-(void)createBtnBind
{
    _btnBind = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    _btnBind.frame = CGRectMake(10*ScreenWidth/375, 118*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnBind];
    [_btnBind setTitle:@"完成" forState:UIControlStateNormal];
    [_btnBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnBind.layer.masksToBounds = YES;
    _btnBind.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnBind addTarget:self action:@selector(endClick) forControlEvents:UIControlEventTouchUpInside];
}
//密码完成提交按钮
-(void)endClick
{
    [_textAgain resignFirstResponder];
    [_textPass resignFirstResponder];
    _btnBind.userInteractionEnabled = NO;
//    [_btnBind setBackgroundColor:[UIColor lightGrayColor]];
    _btnBind.backgroundColor = [UIColor lightGrayColor];
    [_dict setObject:_capChe forKey:@"code"];
    if (_textPass.text.length <= 5) {
        _isShowAlertView = 0;
        _btnBind.userInteractionEnabled = YES;
        _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        [Helper alertViewWithTitle:@"请输入大于6位字符的密码" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
//        _textPass.text = @"";
        return;
    }
    else
    {
        [_dict setObject:_textPass.text forKey:@"password"];
    }
    if ([_textPass.text isEqualToString:_textAgain.text]) {
        _btnBind.userInteractionEnabled = YES;
        _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        [[PostDataRequest sharedInstance] postDataRequest:kRegist_URL parameter:_dict success:^(id respondsData) {
            
            NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];

            if ([[userData objectForKey:@"success"] boolValue]) {
    
                [[PostDataRequest sharedInstance]postDataRequest:@"code/saveCodeRecord.do" parameter:@{@"userId":[[userData objectForKey:@"rows"] objectForKey:@"userId"],@"code":_textInvite.text} success:^(id respondsData) {
//                    NSDictionary *dictCode = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    
                } failed:^(NSError *error) {
                    
                }];
                
                
                //登陆成功
                UserInformationModel* model = [[UserInformationModel alloc]init];
                [model setValuesForKeysWithDictionary:[userData objectForKey:@"rows"]];
                [[UserDataInformation sharedInstance] saveUserInformation:model];
                NSNumber* i = [[userData objectForKey:@"rows"] objectForKey:@"userId"];
                [_dict setObject:i forKey:@"userId"];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"userId"] forKey:@"userId"];
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"mobile"] forKey:@"mobile"];
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"sex"] forKey:@"sex"];
                //判断是否登录，用来社区的刷新
                [user setObject:@1 forKey:@"isFirstEnter"];
                if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"pic"]]) {
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
                }
                if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"userName"]]) {
                    [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"userName"] forKey:@"userName"];
                }
                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"rongTk"] forKey:@"rongTk"];
                [user synchronize];
                
                NSString *token = [[userData objectForKey:@"rows"] objectForKey:@"rongTk"];
                //注册融云
                [self requestRCIMWithToken:token];
                [self postAppJpost];
                [Helper alertViewWithTitle:@"注册成功，马上完善个人资料" withBlockCancle:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } withBlockSure:^{
                    SelfViewController* selfVc = [[SelfViewController alloc]init];
                    selfVc.fromEnroll = @1;
                    [self.navigationController pushViewController:selfVc animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
                
                
                
            }else {
                //注册失败
                _isShowAlertView = 0;
                _btnBind.userInteractionEnabled = YES;
                [_btnBind setBackgroundColor:[UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f]];
                [Helper alertViewWithTitle:[userData objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        } failed:^(NSError *error) {
            _btnBind.userInteractionEnabled = YES;
            _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        }];
        
    }
    else
    {
        _isShowAlertView = 1;
        _btnBind.userInteractionEnabled = YES;
        _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        [Helper alertViewWithTitle:@"您填写的密码不一致" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}
#pragma mark --极光推送信息
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

#pragma mark --融云链接
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
    NSString *str3=[NSString stringWithFormat:@"http://www.dagolfla.com:8081/small_%@",[user objectForKey:@"pic"]];
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



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 让一段代码延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ////NSLog(@"延迟几秒执行");
        if (_isShowAlertView == 0) {
             [_textPass becomeFirstResponder];
        } else {
            [_textAgain becomeFirstResponder];
        }
    });

}

#pragma mark --邀请码
-(void)createInvite
{
    UILabel* labelInvite = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 172*ScreenWidth/375, 100*ScreenWidth/375, 44*ScreenWidth/375)];
    labelInvite.text = @"请输入邀请码";
    labelInvite.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:labelInvite];
    labelInvite.textColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    labelInvite.textAlignment = NSTextAlignmentCenter;
    
    
    _textInvite = [[UITextField alloc]initWithFrame:CGRectMake(120*ScreenWidth/375, 172*ScreenWidth/375, ScreenWidth-140*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textInvite];
    _textInvite.delegate = self;
    _textInvite.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textInvite.textColor = [UIColor darkGrayColor];
    _textInvite.backgroundColor = [UIColor whiteColor];
    _textInvite.borderStyle = UITextBorderStyleNone;
    _textInvite.clearButtonMode = UITextFieldViewModeAlways;
    _textInvite.backgroundColor = [UITool colorWithHexString:@"f3f3f3" alpha:1];
}


@end
