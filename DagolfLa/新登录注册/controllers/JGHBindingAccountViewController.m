//
//  JGHBindingAccountViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBindingAccountViewController.h"
#import "UserInformationModel.h"
#import "UserDataInformation.h"
#import "JPUSHService.h"

static int timeNumber = 60;

@interface JGHBindingAccountViewController ()<UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    
    NSArray *_titleArray;
    NSArray *_titleCodeArray;
    
    NSString *_codeing;
    NSTimer *_timer;
}

@end

@implementation JGHBindingAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"忘记密码";
    
    self.oneViewH.constant = 50 *ProportionAdapter;
    self.oneViewLeft.constant = 8 *ProportionAdapter;
    self.oneViewTop.constant = 10 *ProportionAdapter;
    self.oneViewRight.constant = 8 *ProportionAdapter;
    self.twoViewTop.constant = 10 *ProportionAdapter;
    
    self.mobileBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [self.mobileBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    self.mobileBtnW.constant = 50 *ProportionAdapter;
    
    self.mobileLable.backgroundColor = [UIColor colorWithHexString:Line_Color];
    
    self.mobiletext.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.mobiletext.keyboardType = UIKeyboardTypeNumberPad;
    self.mobiletextLeft.constant = 22 *ProportionAdapter;
    self.codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.codeText.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTwoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeTextLeft.constant = 22 *ProportionAdapter;
    
    self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [self.getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    
    self.bindingAccount.titleLabel.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
    self.bindingAccountW.constant = 50 *ProportionAdapter;
    self.bindingAccount.layer.masksToBounds = YES;
    self.bindingAccount.layer.cornerRadius = 5 *ProportionAdapter;
    self.bindingAccountBtnLeft.constant = 5 *ProportionAdapter;
    self.bindingAccountBtnTop.constant = 35 *ProportionAdapter;
    self.bindingAccountBtnRight.constant = 5 *ProportionAdapter;
    [self.bindingAccount setBackgroundColor:[UIColor colorWithHexString:Bar_Color]];
    
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    self.twoview.layer.masksToBounds = YES;
    self.twoview.layer.cornerRadius = 3.0 *ProportionAdapter;
    
    _titleArray = @[@"中国", @"香港", @"澳门", @"台湾"];
    _titleCodeArray = @[@"0086", @"00886", @"00852", @"00853"];
    _codeing = @"0086";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 区域选择
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
#pragma mark -- 获取验证码
- (IBAction)getCodeBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    if (_mobiletext.text.length == 0) {
        [LQProgressHud showMessage:@"请输入手机号！"];
        return;
    }
    
    [codeDict setObject:_mobiletext.text forKey:@"telphone"];
    //
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
#pragma mark -- 绑定
- (IBAction)bindingAccount:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_codeing isEqualToString:@"0086"]) {
        if (_mobiletext.text.length != 11) {
            [LQProgressHud showMessage:@"手机号码格式有误！"];
            return;
        }
    }
    
    if (_codeText.text.length == 0) {
        [LQProgressHud showMessage:@"请输入验证码"];
        return;
    }
    
    [_weiChetDict setObject:_codeing forKey:@"countryCode"];
    [_weiChetDict setObject:_mobiletext.text forKey:@"telphone"];
    [_weiChetDict setObject:_codeText.text forKey:@"checkCode"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doBindWechat" JsonKey:nil withData:_weiChetDict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSDictionary *userDict = [NSDictionary dictionary];
            if ([data objectForKey:@"user"]) {
                userDict = [data objectForKey:@"user"];
            }
            
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            if ([userDict objectForKey:@"userId"]) {
                [userdef setObject:[userDict objectForKey:@"userId"] forKey:@"userId"];
                [userdef setObject:[userDict objectForKey:@"mobile"] forKey:@"mobile"];
                [userdef setObject:[userDict objectForKey:@"sex"] forKey:@"sex"];
                //判断是否登录，用来社区的刷新
                [userdef setObject:@1 forKey:@"isFirstEnter"];
                [userdef setObject:[userDict objectForKey:@"userName"] forKey:@"userName"];
                [userdef setObject:[userDict objectForKey:@"rongTk"] forKey:@"rongTk"];
                [userdef synchronize];
            }
            
            NSString *token = [[userDict objectForKey:@"rows"] objectForKey:@"rongTk"];
            //注册融云
            [self requestRCIMWithToken:token];
            [self postAppJpost];
            
            [Helper alertViewWithTitle:@"注册成功!" withBlockCancle:^{
                [self.navigationController popViewControllerAnimated:YES];
                _blackCtrl();
            } withBlockSure:^{
                //
            } withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
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
    timeNumber--;
    [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"(%d)后重新获取",timeNumber] forState:UIControlStateNormal];
    if (timeNumber == 0) {
        [_getCodeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        timeNumber = 60;
        
        _getCodeBtn.userInteractionEnabled = YES;
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
#pragma mark -- textdelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_mobiletext resignFirstResponder];
    [_codeText resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == _mobiletext) {
        [_mobiletext resignFirstResponder];
        [_codeText becomeFirstResponder];
    }
    else
    {
        [_codeText resignFirstResponder];
    }
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mobiletext resignFirstResponder];
    [_codeText resignFirstResponder];
    _pickerView.hidden = YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSCharacterSet *cs;
    if(textField)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            [LQProgressHud showMessage:@"请输入数字"];
            return NO;
        }
    }
    //其他的类型不需要检测，直接写入
    return YES;

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
    [_mobileBtn setTitle:_titleArray[row] forState:UIControlStateNormal];
    _codeing = [NSString stringWithFormat:@"%@", _titleCodeArray[row]];
}
@end
