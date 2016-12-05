//
//  JGHForgotPasswordViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHForgotPasswordViewController.h"
#import "UserInformationModel.h"
#import "UserDataInformation.h"
#import "JPUSHService.h"

@interface JGHForgotPasswordViewController ()<UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate>

{    
    NSTimer *_timer;
    NSArray *_titleArray;
    NSArray *_titleCodeArray;
    NSString *_codeing;
    UIPickerView *_pickerView;
    
    NSInteger _timeNumber;
}

@end

@implementation JGHForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"忘记密码";
    _timeNumber = 60;
    self.oneViewLeft.constant = 8 *ProportionAdapter;
    self.oneViewTop.constant = 10 *ProportionAdapter;
    self.oneViewRight.constant = 8 *ProportionAdapter;
    self.oneviewH.constant = 50 *ProportionAdapter;
    
    self.mobileBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [self.mobileBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    self.mobileBtnW.constant = 50 *ProportionAdapter;
    self.mobileLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.mobileText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.mobileText.clearButtonMode = UITextFieldViewModeAlways;
    self.mobileText.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextLeft.constant = 22 *ProportionAdapter;
    
    self.codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.codeText.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextLeft.constant = 22 *ProportionAdapter;
    self.codeText.clearButtonMode = UITextFieldViewModeAlways;
    self.codeTwoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.getCodeBtnW.constant = 130 *ProportionAdapter;
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [self.getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    
    self.passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.passwordText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;
    
    self.passwordTextRight.constant = 15 *ProportionAdapter;
    self.passwordTextLeft.constant = 22 *ProportionAdapter;
    self.entryBtnW.constant = 22 *ProportionAdapter;
    self.entryBtnRight.constant = 15 *ProportionAdapter;

    self.resetBtnH.constant = 50 *ProportionAdapter;
    self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    self.resetBtnLeft.constant = 8 *ProportionAdapter;
    self.resetBtnTop.constant = 50 *ProportionAdapter;
    self.resetBtnRight.constant = 8 *ProportionAdapter;
    self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    [self.resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resetBtn setBackgroundColor:[UIColor colorWithHexString:Bar_Color]];
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.cornerRadius = 5.0 *ProportionAdapter;
    
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    self.threeView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    _titleArray = @[@"中国大陆      +0086", @"中国香港      ＋00886", @"中国澳门      ＋00852", @"中国台湾      ＋00853"];
    _titleCodeArray = @[@"0086", @"00886", @"00852", @"00853"];
    
    _codeing = @"0086";
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

- (IBAction)mobileBtn:(UIButton *)sender {
    [_mobileText resignFirstResponder];
    [_passwordText resignFirstResponder];
    
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
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

- (IBAction)getCodeBtn:(UIButton *)sender {
    
    if (_mobileText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    if ([_codeing isEqualToString:@"0086"]) {
        if (_mobileText.text.length != 11) {
            [LQProgressHud showMessage:@"手机号码格式有误！"];
            return;
        }
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"发送中..." FromView:self.view];
    _getCodeBtn.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    [codeDict setObject:_mobileText.text forKey:@"telphone"];
    [codeDict setObject:_codeing forKey:@"countryCode"];
    
    //手机号已注册
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doSendForgetPasswordSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        _getCodeBtn.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //
            if ([[data objectForKey:@"hasMobileRegistered"] integerValue] == 1) {
                _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            }else{
                //手机号未注册
                _getCodeBtn.userInteractionEnabled = YES;
                
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"手机号未注册，请先注册！" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
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
}
- (void)autoMove {
    _timeNumber--;
    _getCodeBtn.userInteractionEnabled = NO;
    [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"(%tds)后重新获取", _timeNumber] forState:UIControlStateNormal];
    if (_timeNumber == 0) {
        [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timeNumber = 60;
        
        _getCodeBtn.userInteractionEnabled = YES;
    }
}

- (IBAction)entryBtn:(UIButton *)sender {
    if (_passwordText.secureTextEntry == YES) {
        _passwordText.secureTextEntry = NO;
        [self.entryBtn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:UIControlStateNormal];
    }else{
        _passwordText.secureTextEntry = YES;
        _passwordText.text = @"";
        [self.entryBtn setImage:[UIImage imageNamed:@"icn_login_eyeclose"] forState:UIControlStateNormal];
    }
}
- (IBAction)resetBtn:(UIButton *)sender {
    if (_mobileText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    if ([_codeing isEqualToString:@"0086"]) {
        if (_mobileText.text.length != 11) {
            [LQProgressHud showMessage:@"手机号码格式有误！"];
            return;
        }
    }
    
    if (_codeText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入验证码！"];
        return;
    }
    
    if (_passwordText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入密码！"];
        return;
    }
    
    if (_passwordText.text.length < 6) {
        [LQProgressHud showMessage:@"密码至少6位！"];
        return;
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    sender.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    NSMutableDictionary *resetDict = [NSMutableDictionary dictionary];
    [resetDict setObject:_mobileText.text forKey:@"telphone"];
    [resetDict setObject:_passwordText.text forKey:@"passWord"];
    [resetDict setObject:_codeText.text forKey:@"checkCode"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/updatePassword" JsonKey:nil withData:resetDict failedBlock:^(id errType) {
        sender.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        sender.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
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
                [userdef setObject:[userDict objectForKey:UserName] forKey:UserName];
                [userdef setObject:[userDict objectForKey:@"rongTk"] forKey:@"rongTk"];
                [userdef synchronize];
                
                NSNotification * notice = [NSNotification notificationWithName:@"loadMessageData" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                NSString *token = [[userDict objectForKey:@"rows"] objectForKey:@"rongTk"];
                //注册融云
                [self requestRCIMWithToken:token];
                [self postAppJpost];
                _blackCtrl();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            _getCodeBtn.userInteractionEnabled = YES;
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}
#pragma mark -- 极光推送的id和数据
-(void)postAppJpost
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:DEFAULF_USERID forKey:userID];
    
    if ([JPUSHService registrationID] != nil) {
        [dict setObject:[JPUSHService registrationID] forKey:@"jgpush"];
    }
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        
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
    [_mobileBtn setTitle:cddd forState:UIControlStateNormal];
    _codeing = [NSString stringWithFormat:@"%@", _titleCodeArray[row]];
}

@end
