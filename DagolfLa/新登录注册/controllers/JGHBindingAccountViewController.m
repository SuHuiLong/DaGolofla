//
//  JGHBindingAccountViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBindingAccountViewController.h"
#import "UserInformationModel.h"

@interface JGHBindingAccountViewController ()<UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    
    NSArray *_titleArray;
    NSArray *_titleCodeArray;
    
    NSString *_codeing;
    NSTimer *_timer;
    
    NSInteger _timeNumber;
}

@end

@implementation JGHBindingAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"绑定账号";
    _timeNumber = 60;
    
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
    self.mobiletext.clearButtonMode = UITextFieldViewModeAlways;
    self.mobiletext.keyboardType = UIKeyboardTypeNumberPad;
    self.mobiletextLeft.constant = 22 *ProportionAdapter;
    self.codeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
    self.codeText.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.codeText.clearButtonMode = UITextFieldViewModeAlways;
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
    
    _titleArray = @[@"中国大陆      +0086", @"中国香港      ＋00886", @"中国澳门      ＋00852", @"中国台湾      ＋00853"];
    _titleCodeArray = @[@"0086", @"00886", @"00852", @"00853"];
    _codeing = @"0086";
}

- (void)backClcik{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"微信登录尚未完成，是否继续绑定？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction* action2=[UIAlertAction actionWithTitle:@"继续绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 区域选择
- (IBAction)mobileBtn:(UIButton *)sender {
    [_mobiletext resignFirstResponder];
    [_codeText resignFirstResponder];
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
    
    [[ShowHUD showHUD]showAnimationWithText:@"发送中..." FromView:self.view];
    _getCodeBtn.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [codeDict setObject:_mobiletext.text forKey:@"telphone"];
    //
    [codeDict setObject:_codeing forKey:@"countryCode"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doSendDoBindWechatSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        _getCodeBtn.userInteractionEnabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
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
    
    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    sender.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [_weiChetDict setObject:_codeing forKey:@"countryCode"];
    [_weiChetDict setObject:_mobiletext.text forKey:@"telphone"];
    [_weiChetDict setObject:_codeText.text forKey:@"checkCode"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doBindWechat" JsonKey:nil withData:_weiChetDict failedBlock:^(id errType) {
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
            if ([userDict objectForKey:userID]) {
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
                [Helper requestRCIMWithToken:token];
                
                [LQProgressHud showMessage:@"登录成功！"];
                _blackCtrl();
                [self.navigationController popViewControllerAnimated:YES];
            }
            
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
