//
//  JGDChangePWDViewController.m
//  DagolfLa
//
//  Created by 東 on 16/11/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDChangePWDViewController.h"

static int timeNumber = 60;

@interface JGDChangePWDViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) UITextField *mobileTF;

@property (nonatomic, strong) UIButton * codeBtn;

@property (nonatomic, strong) UITextField *PWDTF;

@property (nonatomic, strong) UIButton * eyeBtn;

@property (nonatomic, strong) NSTimer *timer;;
@end

@implementation JGDChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置登录密码";
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI{
    
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
    mobileView.backgroundColor = [UIColor whiteColor];
    mobileView.layer.cornerRadius = 3.0 * ProportionAdapter;
    mobileView.clipsToBounds = YES;
    [self.view addSubview:mobileView];
    
    UIImageView *firstV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50 * ProportionAdapter, 50 * ProportionAdapter)];
    firstV.image = [UIImage imageNamed:@"icon_login_verify"];
    firstV.contentMode = UIViewContentModeCenter;
    [mobileView addSubview:firstV];
    
    UILabel *line1LB = [[UILabel alloc] initWithFrame:CGRectMake(50 * ProportionAdapter, 0, 1, 50 * ProportionAdapter)];
    line1LB.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [mobileView addSubview:line1LB];
    
    self.mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(70 * ProportionAdapter, 0, 160 * ProportionAdapter, 50 * ProportionAdapter)];
    self.mobileTF.tag = 187;
    self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if ([userdef objectForKey:Mobile]) {
        self.mobileTF.placeholder = [NSString stringWithFormat:@"发送至 %@", [userdef objectForKey:Mobile]];
    }else{
        self.mobileTF.placeholder = @"发送至";
    }
    
    self.mobileTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    [mobileView addSubview:self.mobileTF];
    
    UILabel *line2LB = [[UILabel alloc] initWithFrame:CGRectMake(240 * ProportionAdapter, 10 * ProportionAdapter, 1, 30 * ProportionAdapter)];
    line2LB.backgroundColor = [UIColor colorWithHexString:Line_Color];
    [mobileView addSubview:line2LB];
    
    self.codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(250 * ProportionAdapter, 0, 100 * ProportionAdapter, 50 * ProportionAdapter)];
    [self.codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.codeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    [self.codeBtn addTarget:self action:@selector(codelAct) forControlEvents:(UIControlEventTouchUpInside)];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    [mobileView addSubview:self.codeBtn];
    
    
    // 第二行
    UIView *PWDView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 70 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
    PWDView.backgroundColor = [UIColor whiteColor];
    PWDView.layer.cornerRadius = 3.0 * ProportionAdapter;
    PWDView.clipsToBounds = YES;
    [self.view addSubview:PWDView];
    
    UIImageView *secondV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50 * ProportionAdapter, 50 * ProportionAdapter)];
    secondV.image = [UIImage imageNamed:@"icon_login_password"];
    secondV.contentMode = UIViewContentModeCenter;
    [PWDView addSubview:secondV];
    
    UILabel *line3LB = [[UILabel alloc] initWithFrame:CGRectMake(50 * ProportionAdapter, 0, 1, 50 * ProportionAdapter)];
    line3LB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [PWDView addSubview:line3LB];
    
    self.PWDTF = [[UITextField alloc] initWithFrame:CGRectMake(70 * ProportionAdapter, 0, 220 * ProportionAdapter, 50 * ProportionAdapter)];
    self.PWDTF.placeholder = @"设置登录密码（至少6位）";
    self.PWDTF.secureTextEntry = NO;
    self.PWDTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    [PWDView addSubview:self.PWDTF];
    
    self.eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(PWDView.frame.size.width - 50 * ProportionAdapter, 0, 50 * ProportionAdapter, 50 * ProportionAdapter)];
    [self.eyeBtn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:(UIControlStateNormal)];
    [self.eyeBtn addTarget:self action:@selector(eyeAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [PWDView addSubview:self.eyeBtn];
    
    // 提交
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 250 * ProportionAdapter, screenWidth - 20, 50 * ProportionAdapter)];
    commitBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    commitBtn.layer.cornerRadius = 5.0 * ProportionAdapter;
    [commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [commitBtn addTarget:self action:@selector(commitAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:commitBtn];
}

// 获取验证码
- (void)codelAct{
    [self.view endEditing:YES];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];

    NSUserDefaults *autoMove = [NSUserDefaults standardUserDefaults];
    if ([autoMove objectForKey:Mobile]) {
        [codeDict setObject:[autoMove objectForKey:Mobile] forKey:@"telphone"];
    }else{
        [LQProgressHud showMessage:@"请先登录！"];
        return;
    }
    
    self.codeBtn.userInteractionEnabled = NO;
    //----判断手机号是否注册过 18637665180
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/hasMobileRegistered" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        self.codeBtn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([[data objectForKey:@"hasMobileRegistered"] integerValue] == 1) {
                                
                [codeDict setObject:@"" forKey:@"countryCode"];
                self.codeBtn.userInteractionEnabled = NO;
                [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doSendRegisterUserSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
                    self.codeBtn.userInteractionEnabled = YES;
                } completionBlock:^(id data) {
                    NSLog(@"%@", data);
                    self.codeBtn.userInteractionEnabled = YES;
                    
                    if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                        //
                        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                    }else{
                        if ([data objectForKey:@"packResultMsg"]) {
                            [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                        }
                    }
                }];
            }else{
                self.codeBtn.userInteractionEnabled = YES;
                [Helper alertViewWithTitle:@"手机号未注册！" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
                
                return;
            }
        }else{
            self.codeBtn.userInteractionEnabled = YES;
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
        
    }];


}

- (void)autoMove {
    timeNumber--;
    [self.codeBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"(%d)后重新获取",timeNumber] forState:UIControlStateNormal];
    if (timeNumber == 0) {
        [self.codeBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
        self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        timeNumber = 60;
        
        self.codeBtn.userInteractionEnabled = YES;
    }}


// 明文／暗文
- (void)eyeAct:(UIButton *)btn{
    
    if (self.PWDTF.secureTextEntry == YES) {
        [self.eyeBtn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:(UIControlStateNormal)];
        self.PWDTF.secureTextEntry = NO;
    }else{
        [self.eyeBtn setImage:[UIImage imageNamed:@"icn_login_eyeclose"] forState:(UIControlStateNormal)];
        self.PWDTF.secureTextEntry = YES;
    }
}

#pragma mark -- 提交
- (void)commitAct:(UIButton *)btn{
    if (_mobileTF.text.length == 0) {
        [LQProgressHud showMessage:@"请输入验证码！"];
        return;
    }
    
    if (_PWDTF.text.length == 0) {
        [LQProgressHud showMessage:@"请输入密码！"];
        return;
    }
    
    if (_PWDTF.text.length < 6) {
        [LQProgressHud showMessage:@"密码至少6位！"];
        return;
    }
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (![userdef objectForKey:Mobile]) {
        [Helper alertViewWithTitle:@"请先绑定手机号码！" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        return;
    }
    
    btn.userInteractionEnabled = NO;
    
    NSMutableDictionary *resetDict = [NSMutableDictionary dictionary];
    [resetDict setObject:[userdef objectForKey:Mobile] forKey:@"telphone"];
    [resetDict setObject:_PWDTF.text forKey:@"passWord"];
    [resetDict setObject:_mobileTF.text forKey:@"checkCode"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/updatePassword" JsonKey:nil withData:resetDict failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        btn.userInteractionEnabled = YES;
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [LQProgressHud showMessage:@"新密码设置成功！"];
            [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark -- textdelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_mobileTF resignFirstResponder];
    [_PWDTF resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == _mobileTF) {
        [_mobileTF resignFirstResponder];
        [_PWDTF becomeFirstResponder];
    }
    else
    {
        [_PWDTF resignFirstResponder];
    }
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mobileTF resignFirstResponder];
    [_PWDTF resignFirstResponder];
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
