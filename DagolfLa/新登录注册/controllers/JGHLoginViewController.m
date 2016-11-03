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

@interface JGHLoginViewController ()<UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate>

{
    UIView *_bgView;
    UIView *_passwordView;//密码输入框试图
    UIView *_codeView;//验证码试图
    
    NSMutableDictionary* _dict, * _userInfoDict;
    
    UITextField *_mobileText;
    
    UITextField *_passwordText;
    
    UILabel *_loginLable;
    
    NSInteger _showId;
    
    UITextField *_codeText;//验证码
    
    UIPickerView *_pickerView;
    
    NSArray *_titleArray;
    
    UIButton *_areaBtn;
}

@end

@implementation JGHLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"登录账户";
    _showId = 0;
    _dict = [NSMutableDictionary dictionary];
    
    _titleArray = @[@"中国", @"香港", @"澳门", @"台湾"];
    
    [self createNavViewBtn];
}

- (void)createNavViewBtn{
    //密码登陆
    UIButton *passwordLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2, 50 *ProportionAdapter)];
    [passwordLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    passwordLoginBtn.titleLabel.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    [passwordLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [passwordLoginBtn addTarget:self action:@selector(passwordLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [passwordLoginBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:passwordLoginBtn];
    
    _loginLable = [[UILabel alloc]initWithFrame:CGRectMake(43 *ProportionAdapter, 50 *ProportionAdapter -2, screenWidth/2-86*ProportionAdapter, 2)];
    _loginLable.backgroundColor = [UIColor colorWithHexString:Bar_Color];
    [self.view addSubview:_loginLable];
    
    //验证码登录
    UIButton *codeLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, 50 *ProportionAdapter)];
    [codeLoginBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
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
    [_areaBtn setTitle:@"+86" forState:UIControlStateNormal];
    [_areaBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    [_areaBtn addTarget:self action:@selector(regionPickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mobileView addSubview:_areaBtn];
    
    UILabel *regionLine = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 0, 1, 50 *ProportionAdapter)];
    regionLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [mobileView addSubview:regionLine];
    
    _mobileText = [[UITextField alloc]initWithFrame:CGRectMake(72*ProportionAdapter +1, 0, screenWidth - ((16 +50+22)*ProportionAdapter +1), 50 *ProportionAdapter)];
    _mobileText.placeholder = @"请输入手机号";
    _mobileText.tag = 187;
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
#pragma mark -- regionBtn
- (void)regionPickBtn:(UIButton *)btn{
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.frame = CGRectMake(0, (screenHeight/3)*2, screenWidth, screenHeight/3);
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.view addSubview:_pickerView];
}
#pragma mark -- 快速注册
- (void)quickRegistrationBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    
}
#pragma mark -- 登录
- (void)loginIn:(UIButton *)btn{
    [self.view endEditing:YES];
    [_pickerView removeFromSuperview];
    
    [_dict setObject:_mobileText.text forKey:@"telphone"];
    [_dict setObject:_passwordText.text forKey:@"password"];
    
    
    
}
#pragma mark -- 微信登录
- (void)weixinLogin:(UIButton *)btn{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSMutableDictionary* dictWx = [[NSMutableDictionary alloc]init];
            [dictWx setObject:@1 forKey:@"login"];
            if (![Helper isBlankString:snsAccount.openId]) {
                [dictWx setObject:snsAccount.openId forKey:@"openid"];
            }
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
                    
                    [user setObject:[[dict objectForKey:@"rows"] objectForKey:@"sex"] forKey:@"sex"];
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
    _passwordText.delegate = self;
    [_passwordView addSubview:_passwordText];
    
    UIButton *entryBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -(30 +22 +8)*ProportionAdapter, 18 *ProportionAdapter, 22*ProportionAdapter, 14*ProportionAdapter)];
    [entryBtn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:UIControlStateNormal];
    [entryBtn addTarget:self action:@selector(entry:) forControlEvents:UIControlEventTouchUpInside];
    [_passwordView addSubview:entryBtn];
    
    [_bgView addSubview:_passwordView];
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
    [passwordBtn setImage:[UIImage imageNamed:@"icon_login_password"] forState:UIControlStateNormal];
    [_codeView addSubview:passwordBtn];
    
    UILabel *passwordLine = [[UILabel alloc]initWithFrame:CGRectMake(50 *ProportionAdapter, 0, 1, 50 *ProportionAdapter)];
    passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [_codeView addSubview:passwordLine];
    
    _codeText = [[UITextField alloc]initWithFrame:CGRectMake(72*ProportionAdapter +1, 0, screenWidth - ((16 +50+2+22+130)*ProportionAdapter +1), 50 *ProportionAdapter)];
    _codeText.placeholder = @"请输入验证码";
    _codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [_codeView addSubview:_codeText];
    
    UILabel *codeLine = [[UILabel alloc]initWithFrame:CGRectMake(_codeText.frame.origin.x + _codeText.frame.size.width +1, 12 *ProportionAdapter, 1, 26 *ProportionAdapter)];
    codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [_codeView addSubview:codeLine];
    
    UIButton *getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(codeLine.frame.origin.x +1, 18 *ProportionAdapter, 130*ProportionAdapter, 14*ProportionAdapter)];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [_codeView addSubview:getCodeBtn];
    
    [_bgView addSubview:_codeView];
}
#pragma mark -- entry
- (void)entry:(UIButton *)btn{
    if (_passwordText.secureTextEntry == YES) {
        _passwordText.secureTextEntry = NO;
    }else{
        _passwordText.secureTextEntry = YES;
    }
}
#pragma mark -- 密码登录
- (void)passwordLoginBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    _loginLable.frame = CGRectMake(43 *ProportionAdapter, 50 *ProportionAdapter -2, screenWidth/2-86*ProportionAdapter, 2);
    [self.view bringSubviewToFront:_loginLable];
    
    if (_showId != 0) {
        [_codeView removeFromSuperview];
    }
    
    [self createPasswordView];
    
    _showId = 0;
}
#pragma mark -- 验证码登录
- (void)codeLoginBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    _loginLable.frame = CGRectMake(43 *ProportionAdapter + screenWidth/2, 50 *ProportionAdapter -2, screenWidth/2-86*ProportionAdapter, 2);
    [self.view bringSubviewToFront:_loginLable];
    
    if (_showId == 1) {
        [_passwordView removeFromSuperview];
    }

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
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    
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
    NSString *str1=[NSString stringWithFormat:@"%@",[user objectForKey:@"userId"]];
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
    [_pickerView removeFromSuperview];
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
    [_areaBtn setTitle:_titleArray[row] forState:UIControlStateNormal];
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
