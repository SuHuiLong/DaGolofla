//
//  JGHLoginViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLoginViewController.h"
#import "UserInformationModel.h"
#import "MySetBindViewController.h"
#import "UserDataInformation.h"
#import "JPUSHService.h"
#import "JGHForgotPasswordViewController.h"
#import "JGHRegistersViewController.h"
#import "JGHBindingAccountViewController.h"

@interface JGHLoginViewController ()<UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate, JGHRegistersViewControllerDelegate>

{
    UIView *_bgView;
    UIView *_passwordView;//密码输入框试图
    UIView *_codeView;//验证码试图
    
    NSMutableDictionary* _dict;
    
    UITextField *_mobileText;
    
    UITextField *_passwordText;
    
    UILabel *_loginLable;
    
    NSInteger _showId;
    
    UITextField *_codeText;//验证码
    
    UIPickerView *_pickerView;
    
    NSArray *_titleArray;
    NSArray *_titleCodeArray;
    
    UIButton *_areaBtn;
    
    NSString *_codeing;
    NSTimer *_timer;
    UIButton *_getCodeBtn;
    
    NSUInteger _timeNumber;
}

@property (nonatomic, strong)NSMutableDictionary *weiChetDict;

@end

@implementation JGHLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
//    [super viewWillAppear:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"登录账户";
    _showId = 0;
    _dict = [NSMutableDictionary dictionary];
    self.weiChetDict = [NSMutableDictionary dictionary];
    
    _titleArray = @[@"中国大陆      +0086", @"中国香港      ＋00886", @"中国澳门      ＋00852", @"中国台湾      ＋00853"];
    _titleCodeArray = @[@"0086", @"00886", @"00852", @"00853"];
    _codeing = @"0086";
    _timeNumber = 60;
    
    [self createNavViewBtn];
}
- (void)backClcik{
    if (_index == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SetOutToIndexNot" object:nil];
    }else{
        _reloadCtrlData();
        
        //    NSMutableArray *ctrlArray = [self.navigationController.viewControllers mutableCopy];
        //    [ctrlArray removeObjectAtIndex:1];
        //    self.navigationController.viewControllers = ctrlArray;
        //    NSLog(@"%@", ctrlArray);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createNavViewBtn{
    //密码登陆
    UIButton *passwordLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2, 50 *ProportionAdapter)];
    [passwordLoginBtn setTitle:@"账户密码登录" forState:UIControlStateNormal];
    passwordLoginBtn.titleLabel.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    [passwordLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [passwordLoginBtn addTarget:self action:@selector(passwordLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [passwordLoginBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:passwordLoginBtn];
    
    _loginLable = [[UILabel alloc]initWithFrame:CGRectMake(30 *ProportionAdapter, 50 *ProportionAdapter -2, screenWidth/2-60*ProportionAdapter, 2)];
    _loginLable.backgroundColor = [UIColor colorWithHexString:Bar_Color];
    [self.view addSubview:_loginLable];
    
    //验证码登录
    UIButton *codeLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, 50 *ProportionAdapter)];
    [codeLoginBtn setTitle:@"动态密码登录" forState:UIControlStateNormal];
    codeLoginBtn.titleLabel.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    [codeLoginBtn addTarget:self action:@selector(codeLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [codeLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeLoginBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:codeLoginBtn];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 50*ProportionAdapter, screenWidth, screenHeight -50*ProportionAdapter -44)];
    _bgView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:_bgView];
    
    //手机号
    UIView *mobileView = [[UIView alloc]initWithFrame:CGRectMake(8 *ProportionAdapter, 15 *ProportionAdapter, screenWidth -16*ProportionAdapter, 50*ProportionAdapter)];
    mobileView.backgroundColor = [UIColor whiteColor];
    mobileView.layer.masksToBounds = YES;
    mobileView.layer.borderWidth = 0.5;
    mobileView.layer.borderColor = [UIColor colorWithHexString:Line_Color].CGColor;
    mobileView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    _areaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*ProportionAdapter, 50 *ProportionAdapter)];
    _areaBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _areaBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [_areaBtn setTitle:@"086" forState:UIControlStateNormal];
    [_areaBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    [_areaBtn addTarget:self action:@selector(regionPickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mobileView addSubview:_areaBtn];
    
    UILabel *regionLine = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 0, 1, 50 *ProportionAdapter)];
    regionLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [mobileView addSubview:regionLine];
    
    _mobileText = [[UITextField alloc]initWithFrame:CGRectMake(72*ProportionAdapter +1, 0, screenWidth - ((16 +50+22)*ProportionAdapter +1), 50 *ProportionAdapter)];
    _mobileText.placeholder = @"请输入手机号码";
    _mobileText.tag = 187;
    _mobileText.clearButtonMode = UITextFieldViewModeAlways;
    _mobileText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    _mobileText.delegate = self;
    _mobileText.keyboardType = UIKeyboardTypeNumberPad;
    [mobileView addSubview:_mobileText];
    
    [_bgView addSubview:mobileView];

    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(8*ProportionAdapter, 245 *ProportionAdapter, screenWidth - 16 *ProportionAdapter, 50 *ProportionAdapter)];
    [loginBtn setBackgroundColor:[UIColor colorWithHexString:Bar_Color]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5.0 *ProportionAdapter;
    [loginBtn addTarget:self action:@selector(loginIn:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:loginBtn];
    
    UILabel *accountLable = [[UILabel alloc]initWithFrame:CGRectMake(90 *ProportionAdapter, 315 *ProportionAdapter, 113 *ProportionAdapter, 20 *ProportionAdapter)];
    accountLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    accountLable.text = @"没有账号？点击";
    accountLable.textAlignment = NSTextAlignmentRight;
    accountLable.textColor = [UIColor colorWithHexString:Line_Color];
    [_bgView addSubview:accountLable];
    
    UIButton *quickRegistrationBtn = [[UIButton alloc]initWithFrame:CGRectMake(206 *ProportionAdapter, 315 *ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
    [quickRegistrationBtn setTitle:@"快速注册！" forState:UIControlStateNormal];
    quickRegistrationBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    quickRegistrationBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [quickRegistrationBtn setTitleColor:[UIColor colorWithHexString:Nav_Color] forState:UIControlStateNormal];
    [quickRegistrationBtn addTarget:self action:@selector(quickRegistrationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:quickRegistrationBtn];
    
    UILabel *weiLable = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight -(71 +44+64)*ProportionAdapter, screenWidth, 18 *ProportionAdapter)];
    weiLable.textColor = [UIColor colorWithHexString:Line_Color];
    weiLable.font = [UIFont systemFontOfSize:12 *ProportionAdapter];
    weiLable.text = @"微信登录";
    weiLable.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:weiLable];
    
    UIButton *weiBtn = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth -76*ProportionAdapter)/2, screenHeight -(10+71 +44+64 +76)*ProportionAdapter, 76 *ProportionAdapter, 76 *ProportionAdapter)];
    [weiBtn setImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
    [weiBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:weiBtn];
    
    [self createPasswordView];
}
#pragma mark -- 区域选择
- (void)regionPickBtn:(UIButton *)btn{
    [_mobileText resignFirstResponder];
    [_passwordText resignFirstResponder];
    
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.frame = CGRectMake(0, (screenHeight/3)*2 -64, screenWidth, screenHeight/3);
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self.view addSubview:_pickerView];
    }else{
        if (_pickerView.hidden == NO) {
            _pickerView.hidden = YES;
        }else{
            _pickerView.hidden = NO;
        }
    }
}
#pragma mark -- 快速注册
- (void)quickRegistrationBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    
    JGHRegistersViewController *registerCtrl = [[JGHRegistersViewController alloc]initWithNibName:@"JGHRegistersViewController" bundle:nil];
    registerCtrl.delegate = self;
    registerCtrl.blackCtrl = ^(){
        _reloadCtrlData();
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:registerCtrl animated:YES];
}
#pragma mark -- 登录
- (void)loginIn:(UIButton *)btn{
    [self.view endEditing:YES];
    _pickerView.hidden = YES;
    
    if (_mobileText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    NSString *urlString;
    if (_showId == 0) {
        if (_passwordText.text.length == 0) {
            [LQProgressHud showMessage:@"请输入密码！"];
            return;
        }
        
        if (_passwordText.text.length < 6) {
            [LQProgressHud showMessage:@"密码长度至少6位！"];
            return;
        }
        
        //手机号密码登录
        urlString = @"login/doLoginByTelphonePassword";
        [_dict setObject:_mobileText.text forKey:@"telphone"];
        [_dict setObject:_passwordText.text forKey:@"password"];
    }else{
        if (_codeText.text.length == 0) {
            [LQProgressHud showMessage:@"请输入验证码！"];
            return;
        }
        
        //验证码登录
        urlString = @"login/doLoginByTelphoneCheckCode";
        [_dict setObject:_mobileText.text forKey:@"telphone"];
        [_dict setObject:_codeText.text forKey:@"checkCode"];
    }
    /*
     18637665180
     123456
     */
    [[ShowHUD showHUD]showAnimationWithText:@"登录中..." FromView:self.view];
    btn.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [[JsonHttp jsonHttp]httpRequestWithMD5:urlString JsonKey:nil withData:_dict failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        btn.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSDictionary *userDict = [NSDictionary dictionary];
            if ([data objectForKey:@"user"]) {
                userDict = [data objectForKey:@"user"];
            }
            
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            NSLog(@"-----%@", [userDict objectForKey:userID]);
            if ([userDict objectForKey:userID]) {
                //登录PHP
                [Helper callPHPLoginUserId:[NSString stringWithFormat:@"%@", [userDict objectForKey:userID]]];
                [userdef setObject:[userDict objectForKey:userID] forKey:userID];
                [userdef setObject:[userDict objectForKey:Mobile] forKey:Mobile];
                [userdef setObject:[userDict objectForKey:@"sex"] forKey:@"sex"];
                //判断是否登录，用来社区的刷新
                [userdef setObject:@1 forKey:@"isFirstEnter"];
                [userdef setObject:[userDict objectForKey:@"userName"] forKey:@"userName"];
                [userdef setObject:[userDict objectForKey:@"rongTk"] forKey:@"rongTk"];
                [userdef synchronize];
                
                NSLog(@"----%@", DEFAULF_USERID);
                
                NSString *token = [[userDict objectForKey:@"rows"] objectForKey:@"rongTk"];
                //注册融云
                [self requestRCIMWithToken:token];
                [self postAppJpost];
                _reloadCtrlData();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}
#pragma mark -- 微信登录
- (void)weixinLogin:(UIButton *)btn{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSMutableDictionary* dictWx = [[NSMutableDictionary alloc]init];
//            [dictWx setObject:@1 forKey:@"login"];
            if (![Helper isBlankString:snsAccount.openId]) {
                [dictWx setObject:snsAccount.openId forKey:@"openid"];
                [_weiChetDict setObject:snsAccount.openId forKey:@"openid"];
            }else{
                [Helper alertViewWithTitle:@"微信登录失败" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                    return ;
                }];
                return ;
            }
            
            [_weiChetDict setObject:snsAccount.userName forKey:@"uid"];
            [_weiChetDict setObject:snsAccount.iconURL forKey:@"wxPicUrl"];
//            [_weiChetDict setObject:snsAccount.gender forKey:@"sex"];
            [[JsonHttp jsonHttp]httpRequestWithMD5:@"login/doWeiXinLogin" JsonKey:nil withData:dictWx failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {
                NSLog(@"%@", data);
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    if ([[data objectForKey:@"needRegister"] integerValue] == 0) {
                        NSDictionary *userDict = [NSDictionary dictionary];
                        if ([data objectForKey:@"user"]) {
                            userDict = [data objectForKey:@"user"];
                        }
                        
                        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                        NSLog(@"----%@", [userDict objectForKey:userID]);
                        if ([userDict objectForKey:userID]) {
                            //登录PHP
                            [Helper callPHPLoginUserId:[NSString stringWithFormat:@"%@", [userDict objectForKey:userID]]];
                            [userdef setObject:[userDict objectForKey:userID] forKey:userID];
                            [userdef setObject:[userDict objectForKey:Mobile] forKey:Mobile];
                            [userdef setObject:[userDict objectForKey:@"sex"] forKey:@"sex"];
                            //判断是否登录，用来社区的刷新
                            [userdef setObject:@1 forKey:@"isFirstEnter"];
                            [userdef setObject:[userDict objectForKey:@"userName"] forKey:@"userName"];
                            [userdef setObject:[userDict objectForKey:@"rongTk"] forKey:@"rongTk"];
                            [userdef synchronize];
                            
                            
                            NSString *token = [[userDict objectForKey:@"rows"] objectForKey:@"rongTk"];
                            //注册融云
                            [self requestRCIMWithToken:token];
                            [self postAppJpost];
                            _reloadCtrlData();
                            [self.navigationController popViewControllerAnimated:YES];
                        }

                        self.navigationItem.leftBarButtonItem.enabled = YES;
                    }else{
                        JGHBindingAccountViewController *bindctrl = [[JGHBindingAccountViewController alloc]initWithNibName:@"JGHBindingAccountViewController" bundle:nil];
                        [bindctrl setWeiChetDict:_weiChetDict];
                        bindctrl.blackCtrl = ^(){
                            
                            _reloadCtrlData();
                            [self.navigationController popViewControllerAnimated:YES];
                        };
                        [self.navigationController pushViewController:bindctrl animated:YES];
                        self.navigationItem.leftBarButtonItem.enabled = YES;
                    }
                    
                }else{
                    //
                    [LQProgressHud showMessage:@"微信登录失败！"];
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                }
            }];
        }else{
            [LQProgressHud showMessage:@"微信登录失败！"];
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
    });
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        ////NSLog(@"SnsInformation is %@",response.data);
    }];
}
#pragma mark -- 创建密码登录 视图
- (void)createPasswordView{
    //密码
    _passwordView = [[UIView alloc]initWithFrame:CGRectMake(8 *ProportionAdapter, (15 + 10 +50) *ProportionAdapter, screenWidth -16*ProportionAdapter, 50*ProportionAdapter)];
    _passwordView.backgroundColor = [UIColor whiteColor];
    _passwordView.layer.masksToBounds = YES;
    _passwordView.layer.borderWidth = 0.5;
    _passwordView.layer.borderColor = [UIColor colorWithHexString:Line_Color].CGColor;
    _passwordView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    UIButton *passwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*ProportionAdapter, 50 *ProportionAdapter)];
    passwordBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    passwordBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [passwordBtn setImage:[UIImage imageNamed:@"icon_login_password"] forState:UIControlStateNormal];
    [_passwordView addSubview:passwordBtn];
    
    UILabel *passwordLine = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 0, 1, 50 *ProportionAdapter)];
    passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [_passwordView addSubview:passwordLine];
    
    _passwordText = [[UITextField alloc]initWithFrame:CGRectMake(72*ProportionAdapter +1, 0, screenWidth - ((16 +50+30+22+22)*ProportionAdapter +1), 50 *ProportionAdapter)];
    _passwordText.placeholder = @"请输入密码";
    _passwordText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    _passwordText.secureTextEntry = NO;
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;
    _passwordText.delegate = self;
    [_passwordView addSubview:_passwordText];
    
    UIButton *forgotPasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 88*ProportionAdapter, (15 + 10 +50 +50 +15) *ProportionAdapter, 80 *ProportionAdapter, 15 *ProportionAdapter)];
    [forgotPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgotPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgotPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    [forgotPasswordBtn addTarget:self action:@selector(forgotPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:forgotPasswordBtn];
    
    UIButton *entryBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -(30 +22 +8)*ProportionAdapter, 18 *ProportionAdapter, 22*ProportionAdapter, 14*ProportionAdapter)];
    [entryBtn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:UIControlStateNormal];
    [entryBtn addTarget:self action:@selector(entry:) forControlEvents:UIControlEventTouchUpInside];
    [_passwordView addSubview:entryBtn];
    
    [_bgView addSubview:_passwordView];
}
#pragma mark -- 忘记密码
- (void)forgotPasswordBtn:(UIButton *)btn{
    JGHForgotPasswordViewController *forCtrl = [[JGHForgotPasswordViewController alloc]initWithNibName:@"JGHForgotPasswordViewController" bundle:nil];
    forCtrl.blackCtrl = ^(){
        [self backClcik];
    };
    [self.navigationController pushViewController:forCtrl animated:YES];
}
#pragma mark -- 验证码登录试图
- (void)createlogInView{
    _codeView = [[UIView alloc]initWithFrame:CGRectMake(8 *ProportionAdapter, (15 + 10 +50) *ProportionAdapter, screenWidth -16*ProportionAdapter, 50*ProportionAdapter)];
    _codeView.backgroundColor = [UIColor whiteColor];
    _codeView.layer.masksToBounds = YES;
    _codeView.layer.borderWidth = 0.5;
    _codeView.layer.borderColor = [UIColor colorWithHexString:Line_Color].CGColor;
    _codeView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    UIButton *passwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*ProportionAdapter, 50 *ProportionAdapter)];
    passwordBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    passwordBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [passwordBtn setImage:[UIImage imageNamed:@"icon_login_verify"] forState:UIControlStateNormal];
    [_codeView addSubview:passwordBtn];
    
    UILabel *passwordLine = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 0, 1, 50 *ProportionAdapter)];
    passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [_codeView addSubview:passwordLine];
    
    _codeText = [[UITextField alloc]initWithFrame:CGRectMake(72*ProportionAdapter +1, 0, screenWidth - ((16 +50+2+22+130)*ProportionAdapter +1), 50 *ProportionAdapter)];
    _codeText.placeholder = @"请输入动态密码";
    _codeText.clearButtonMode = UITextFieldViewModeAlways;
    _codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView addSubview:_codeText];
    
    UILabel *codeLine = [[UILabel alloc]initWithFrame:CGRectMake(_codeText.frame.origin.x + _codeText.frame.size.width +1, 12 *ProportionAdapter, 1, 26 *ProportionAdapter)];
    codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [_codeView addSubview:codeLine];
    
    _getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(codeLine.frame.origin.x +1, 18 *ProportionAdapter, 130*ProportionAdapter, 14*ProportionAdapter)];
    [_getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [_getCodeBtn addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_codeView addSubview:_getCodeBtn];
    
    [_bgView addSubview:_codeView];
}
#pragma mark -- entry
- (void)entry:(UIButton *)btn{
    if (_passwordText.secureTextEntry == YES) {
        _passwordText.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:UIControlStateNormal];
    }else{
        _passwordText.secureTextEntry = YES;
        _passwordText.text = @"";
        [btn setImage:[UIImage imageNamed:@"icn_login_eyeclose"] forState:UIControlStateNormal];
    }
}
#pragma mark -- 获取验证码
- (void)getCodeBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    if (_mobileText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"发送中..." FromView:self.view];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _getCodeBtn.userInteractionEnabled = NO;
    [codeDict setObject:_mobileText.text forKey:@"telphone"];
    //
    [codeDict setObject:_codeing forKey:@"countryCode"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"login/doSendLoginCheckCodeSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        _getCodeBtn.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }else{
            _getCodeBtn.userInteractionEnabled = YES;
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}
-(void)dealloc
{
    _timer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)autoMove {
    _timeNumber--;
    [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"(%tds)后重新获取", _timeNumber] forState:UIControlStateNormal];
    if (_timeNumber == 0) {
        [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        [_getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timeNumber = 60;
        
        _getCodeBtn.userInteractionEnabled = YES;
    }
}
#pragma mark -- 密码登录 View
- (void)passwordLoginBtn{
    [self.view endEditing:YES];
    _loginLable.frame = CGRectMake(30 *ProportionAdapter, 50 *ProportionAdapter -2, screenWidth/2-60*ProportionAdapter, 2);
    [self.view bringSubviewToFront:_loginLable];
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    if (_showId != 0) {
        [_codeView removeFromSuperview];
    }
    
    [self createPasswordView];
    
    _showId = 0;
}
#pragma mark -- 验证码登录 View
- (void)codeLoginBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    _loginLable.frame = CGRectMake(30 *ProportionAdapter + screenWidth/2, 50 *ProportionAdapter -2, screenWidth/2-60*ProportionAdapter, 2);
    [self.view bringSubviewToFront:_loginLable];
    
    if (_showId == 1) {
        [_passwordView removeFromSuperview];
    }

    _timeNumber = 60;
    
    [self createlogInView];
    
    _showId = 1;
}
#pragma mark - 保存登陆信息
- (void)saveUserMobileAndPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValuesForKeysWithDictionary:_dict];
    [userDefaults synchronize];
}
#pragma mark -- 极光推送的id和数据
-(void)postAppJpost
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:userID];
    
    if ([JPUSHService registrationID] != nil) {
        [dict setObject:[JPUSHService registrationID] forKey:@"jgpush"];
    }
    
    
    [[PostDataRequest sharedInstance] postDataRequest:@"user/updateUserInfo.do" parameter:dict success:^(id respondsData) {
    } failed:^(NSError *error) {
    }];
}
#pragma mark -- 注册融云
-(void)requestRCIMWithToken:(NSString *)token{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40*ScreenWidth/375, 40*ScreenWidth/375);
    [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
    [[RCIM sharedRCIM] setUserInfoDataSource:[UserDataInformation sharedInstance]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:[UserDataInformation sharedInstance]];
    NSString *str1=[NSString stringWithFormat:@"%@",[user objectForKey:userID]];
    NSString *str2=[NSString stringWithFormat:@"%@",[user objectForKey:@"userName"]];
    NSString *str3=[NSString stringWithFormat:@"http://www.dagolfla.com:8081/small_%@",[user objectForKey:@"pic"]];
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
#pragma mark -- textdelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_mobileText resignFirstResponder];
    [_passwordText resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == _mobileText) {
        [_mobileText resignFirstResponder];
        [_passwordText becomeFirstResponder];
    }
    else
    {
        [_passwordText resignFirstResponder];
    }
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mobileText resignFirstResponder];
    [_passwordText resignFirstResponder];
    _pickerView.hidden = YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.tag == 187) {
        NSCharacterSet *cs;
        if(textField)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if(!basicTest)
            {
                [[ShowHUD showHUD]showToastWithText:@"请输入数字" FromView:self.view];
                return NO;
            }
        }
        //其他的类型不需要检测，直接写入
        return YES;
    }else{
        return YES;
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _titleArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _titleArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableString *code = [_titleCodeArray[row] mutableCopy];
    NSString *cddd;
    if ([code isEqualToString:@"0086"]) {
        cddd = [code substringFromIndex:1];
    }else{
        cddd = [code substringFromIndex:2];
    }
    [_areaBtn setTitle:cddd forState:UIControlStateNormal];
    _codeing = [NSString stringWithFormat:@"%@", _titleCodeArray[row]];
}
#pragma mark -- 忘记密码 返回
//- (void)fillLoginViewAccount:(NSString *)account andPassword:(NSString *)password andCodeing:(NSString *)codeing{
//    [self passwordLoginBtn];
//    _mobileText.text = account;
//    _passwordText.text = password;
//    [_areaBtn setTitle:[codeing stringByReplacingOccurrencesOfString:@"0" withString:@""] forState:UIControlStateNormal];
//}
#pragma mark -- 注册－－已经注册返回登录
- (void)registerForLoginWithMobile:(NSString *)mobile andCodeing:(NSString *)code{
    [self passwordLoginBtn];
    _mobileText.text = mobile;
    [_areaBtn setTitle:[code stringByReplacingOccurrencesOfString:@"0" withString:@""] forState:UIControlStateNormal];
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
