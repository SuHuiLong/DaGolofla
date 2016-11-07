//
//  JGHRegistersViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRegistersViewController.h"
#import "JGHUserAgreementViewController.h"
#import "UserInformationModel.h"
#import "MySetBindViewController.h"
#import "UserDataInformation.h"
#import "JPUSHService.h"

@interface JGHRegistersViewController ()<UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSTimer *_timer;
    NSArray *_titleArray;
    NSArray *_titleCodeArray;
    NSString *_codeing;
    UIPickerView *_pickerView;
    
    NSInteger _select;
    
    NSInteger _timeNumber;
}

@end

@implementation JGHRegistersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"注册";
    _timeNumber = 60;
    self.viewLeft.constant = 8 *ProportionAdapter;
    self.viewTop.constant = 10 *ProportionAdapter;
    self.viewRight.constant = 8 *ProportionAdapter;
    self.viewH.constant = 50 *ProportionAdapter;
    
    self.mobileBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.mobileBtnW.constant = 50 *ProportionAdapter;
    [self.mobileBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    
    self.mobileText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.mobileText.delegate = self;
    self.mobileText.tag = 187;
    self.mobileText.clearButtonMode = UITextFieldViewModeAlways;
    
    self.mobileLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeOneLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeTwoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeTwoLineH.constant = 25 *ProportionAdapter;
    self.passwordLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.twoViewTop.constant = 10 *ProportionAdapter;
    self.threeViewTop.constant = 10 *ProportionAdapter;
    
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.codeText.delegate = self;
    self.codeText.tag = 188;
    self.codeText.clearButtonMode = UITextFieldViewModeAlways;
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.getCodeBtnW.constant = 130 *ProportionAdapter;
    [self.getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    self.passwordText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.passwordTextRight.constant = 15 *ProportionAdapter;
    self.passwordText.secureTextEntry = NO;
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;
    
    self.entryBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.entryBtnW.constant = 22 *ProportionAdapter;
    self.entryBtnRight.constant = 15 *ProportionAdapter;
    
    self.registeredLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    
    self.termsBtn.titleLabel.font = [UIFont systemFontOfSize:13 *ProportionAdapter];

    self.completeBtn.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    self.completeBtnTop.constant = 35 *ProportionAdapter;
    
    self.resLableLeft.constant = 10 *ProportionAdapter;
    self.tersmLeft.constant = 5 *ProportionAdapter;
    self.completeBtnLeft.constant = 8 *ProportionAdapter;
    self.completeBtnRight.constant = 8 *ProportionAdapter;
    
    self.mobileBtnLeft.constant =22 *ProportionAdapter;
    self.codeBtnLeft.constant =22 *ProportionAdapter;
    self.passwordTextLeft.constant =22 *ProportionAdapter;
    
    self.completeBtnH.constant = 50 *ProportionAdapter;
    [self.completeBtn setTitleColor:[UIColor colorWithHexString:BG_color] forState:UIControlStateNormal];
    [self.completeBtn setBackgroundColor:[UIColor colorWithHexString:Bar_Color]];
    self.completeBtn.layer.masksToBounds = YES;
    self.completeBtn.layer.cornerRadius = 5.0 *ProportionAdapter;
    
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    self.threeView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    _titleArray = @[@"中国", @"香港", @"澳门", @"台湾"];
    _titleCodeArray = @[@"0086", @"00886", @"00852", @"00853"];
    
    _codeing = @"0086";
    
    _select = 0;
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
    [self.view endEditing:YES];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    if (_mobileText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    [codeDict setObject:_mobileText.text forKey:@"telphone"];
    _getCodeBtn.userInteractionEnabled = NO;
    //----判断手机号是否注册过 18637665180
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/hasMobileRegistered" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        _getCodeBtn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([[data objectForKey:@"hasMobileRegistered"] integerValue] == 1) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"手机号码已注册过，使用该号码登录？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction* action2=[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (self.delegate) {
                        [self.delegate registerForLoginWithMobile:_mobileText.text andCodeing:_codeing];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
                _getCodeBtn.userInteractionEnabled = YES;
            }else{
                [codeDict setObject:_codeing forKey:@"countryCode"];
                _getCodeBtn.userInteractionEnabled = NO;
                [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doSendRegisterUserSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
                    _getCodeBtn.userInteractionEnabled = YES;
                } completionBlock:^(id data) {
                    NSLog(@"%@", data);
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
    [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
     _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"(%tds)后重新获取", _timeNumber] forState:UIControlStateNormal];
    if (_timeNumber == 0) {
        [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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
        [self.entryBtn setImage:[UIImage imageNamed:@"icn_login_eyeclose"] forState:UIControlStateNormal];
    }
}
- (IBAction)selectBtn:(UIButton *)sender {
    if (_select == 0) {
        _select = 1;
        [_selectBtn setImage:[UIImage imageNamed:@"icn_registerlay"] forState:UIControlStateNormal];
        _completeBtn.userInteractionEnabled = NO;
        [_completeBtn setBackgroundColor:[UIColor lightGrayColor]];
        
    }else{
        _select = 0;
        [_selectBtn setImage:[UIImage imageNamed:@"icn_register"] forState:UIControlStateNormal];
        _completeBtn.userInteractionEnabled = YES;
        [_completeBtn setBackgroundColor:[UIColor colorWithHexString:Bar_Color]];
    }
}
#pragma mark -- 条款
- (IBAction)termsBtn:(UIButton *)sender {
    JGHUserAgreementViewController *userAgreemCtrl = [[JGHUserAgreementViewController alloc]init];
    [self.navigationController pushViewController:userAgreemCtrl animated:YES];
}
#pragma mark -- 完成
- (IBAction)completeBtn:(UIButton *)sender {
    if (_select == 1) {
        [LQProgressHud showMessage:@"请同意协议！"];
        return;
    }
    
    if (_mobileText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号码！"];
        return;
    }
    
    if ([_codeing isEqualToString:@"0086"]) {
        if (_mobileText.text.length != 11) {
            [LQProgressHud showMessage:@"请输入正确的手机号码！"];
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
    
    NSMutableDictionary *userdict = [NSMutableDictionary dictionary];
    [userdict setObject:_codeing forKey:@"countryCode"];
    [userdict setObject:_mobileText.text forKey:@"telphone"];
    [userdict setObject:_passwordText.text forKey:@"password"];
    [userdict setObject:_codeText.text forKey:@"checkCode"];
    [userdict setObject:@1 forKey:@"deviceType"];
    NSString * uuid= [FCUUID getUUID];
    [userdict setObject:uuid forKey:@"deviceID"];
    //18721110368  015234  123456
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doRegisterUser" JsonKey:nil withData:userdict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //
            NSDictionary *userDict = [NSDictionary dictionary];
            if ([data objectForKey:@"user"]) {
                userDict = [data objectForKey:@"user"];
            }
            
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            if ([userDict objectForKey:userID]) {
                [userdef setObject:[userDict objectForKey:userID] forKey:userID];
                [userdef setObject:[userDict objectForKey:Mobile] forKey:Mobile];
                [userdef setObject:[userDict objectForKey:@"sex"] forKey:@"sex"];
                //判断是否登录，用来社区的刷新
                [userdef setObject:@1 forKey:@"isFirstEnter"];
                [userdef setObject:[userDict objectForKey:@"userName"] forKey:@"userName"];
                [userdef setObject:[userDict objectForKey:@"rongTk"] forKey:@"rongTk"];
                [userdef synchronize];
            }
//            if (![Helper isBlankString:[[userData objectForKey:@"rows"] objectForKey:@"pic"]]) {
//                [user setObject:[[userData objectForKey:@"rows"] objectForKey:@"pic"] forKey:@"pic"];
//            }
                       
            NSString *token = [[userDict objectForKey:@"rows"] objectForKey:@"rongTk"];
            //注册融云
            [self requestRCIMWithToken:token];
            [self postAppJpost];
            [Helper alertViewWithTitle:@"注册成功！" withBlock:^(UIAlertController *alertView) {
               [self presentViewController:alertView animated:YES completion:nil];
            }];
            _blackCtrl();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            _getCodeBtn.userInteractionEnabled = YES;
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
}
#pragma mark --极光推送信息
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

#pragma mark --融云链接
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
    if (textField.tag == 187 || textField.tag == 188) {
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
    NSString *cddd = [code stringByReplacingOccurrencesOfString:@"0" withString:@""];
    [_mobileBtn setTitle:cddd forState:UIControlStateNormal];
    _codeing = [NSString stringWithFormat:@"%@", _titleCodeArray[row]];
}


@end
