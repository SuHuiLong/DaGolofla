//
//  JGDChangePWDViewController.m
//  DagolfLa
//
//  Created by 東 on 16/11/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDChangePWDViewController.h"

static int timeNumber = 60;

@interface JGDChangePWDViewController ()

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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    // Do any additional setup after loading the view.
    
    [self createUI];
}


- (void)createUI{
    
    UIView *mobileView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
    mobileView.backgroundColor = [UIColor whiteColor];
    mobileView.layer.cornerRadius = 6 * ProportionAdapter;
    mobileView.clipsToBounds = YES;
    [self.view addSubview:mobileView];
    
    UIImageView *firstV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50 * ProportionAdapter, 50 * ProportionAdapter)];
    firstV.image = [UIImage imageNamed:@"icon_login_verify"];
    firstV.contentMode = UIViewContentModeCenter;
    [mobileView addSubview:firstV];
    
    UILabel *line1LB = [[UILabel alloc] initWithFrame:CGRectMake(50 * ProportionAdapter, 0, 1, 50 * ProportionAdapter)];
    line1LB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [mobileView addSubview:line1LB];
    
    self.mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(70 * ProportionAdapter, 0, 160 * ProportionAdapter, 50 * ProportionAdapter)];
    self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTF.placeholder = @"发送至";
    self.mobileTF.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    [mobileView addSubview:self.mobileTF];
    
    UILabel *line2LB = [[UILabel alloc] initWithFrame:CGRectMake(240 * ProportionAdapter, 10 * ProportionAdapter, 1, 30 * ProportionAdapter)];
    line2LB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
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
    PWDView.layer.cornerRadius = 6 * ProportionAdapter;
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
    self.PWDTF.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    [PWDView addSubview:self.PWDTF];
    
    self.eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(PWDView.frame.size.width - 50 * ProportionAdapter, 0, 50 * ProportionAdapter, 50 * ProportionAdapter)];
    [self.eyeBtn setImage:[UIImage imageNamed:@"icn_login_eyeopen"] forState:(UIControlStateNormal)];
    [self.eyeBtn addTarget:self action:@selector(eyeAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [PWDView addSubview:self.eyeBtn];
    
    // 提交
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 250 * ProportionAdapter, screenWidth - 20, 50 * ProportionAdapter)];
    commitBtn.backgroundColor = [UIColor colorWithHexString:@"#F59826"];
    commitBtn.layer.cornerRadius = 6 * ProportionAdapter;
    [commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [commitBtn addTarget:self action:@selector(commitAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:commitBtn];
}

// 获取验证码
- (void)codelAct{
    [self.view endEditing:YES];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    if (self.mobileTF.text.length == 0) {
        [LQProgressHud showMessage:@"请输入验证码！"];
        return;
    }
    
    [codeDict setObject:@15221882010 forKey:@"telphone"];
    self.codeBtn.userInteractionEnabled = NO;
    //----判断手机号是否注册过 18637665180
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/hasMobileRegistered" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
        self.codeBtn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([[data objectForKey:@"hasMobileRegistered"] integerValue] == 1) {
                [Helper alertViewWithTitle:@"手机号已注册！" withBlockCancle:^{
                    
                } withBlockSure:^{
                    
                } withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
                self.codeBtn.userInteractionEnabled = YES;
                return;
            }else{
                [codeDict setObject:@"" forKey:@"countryCode"];
                self.codeBtn.userInteractionEnabled = NO;
                [[JsonHttp jsonHttp]httpRequestWithMD5:@"reg/doSendRegisterUserSms" JsonKey:nil withData:codeDict failedBlock:^(id errType) {
                    self.codeBtn.userInteractionEnabled = YES;
                } completionBlock:^(id data) {
                    NSLog(@"%@", data);
                    if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                        //
                        
                        
                        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                        
                    }else{
                        self.codeBtn.userInteractionEnabled = YES;
                        if ([data objectForKey:@"packResultMsg"]) {
                            [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
                        }
                    }
                }];
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
    
}

-(void)dealloc
{
    _timer = nil;
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
