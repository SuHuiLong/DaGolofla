//
//  AddVipCardViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "AddVipCardViewController.h"

@interface AddVipCardViewController ()<UITextFieldDelegate>

//获取验证码按钮
@property (nonatomic,strong)UIButton *getCaptchaBtn;
//验证按钮
@property (nonatomic,strong)UIButton *verifyBtn;
//勾选图标
@property (nonatomic,strong)UIButton *checkView;
//定时器
@property (nonatomic, strong) NSTimer *countTimer;
//剩余显示时间
@property (nonatomic, assign) int count;
@end

@implementation AddVipCardViewController
//初始化定时器
- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加会员卡";
    self.view.backgroundColor = RGBA(238, 238, 238, 1);
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigation];

    [self createTextFeild];
}
//创建导航
-(void)createNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航背景
    [self.navigationController.navigationBar setTintColor:WhiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

//backL
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

//创建各个输入框
-(void)createTextFeild{
    //图标数组
    NSArray *iconArray = @[@"icon_login_verify",@"", @"icn_allianceMen"];
    //输入框默认提示
    NSArray *placeholderArray = @[@"请输入会员姓名",@"请输入手机号",@"请输入验证码"];
    for (int i = 0; i<3; i++) {
        //白色背景
        UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(7.5), kHvertical(20) + kHvertical(60)*i, screenWidth - kWvertical(20), kHvertical(50))];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = kHvertical(5);
        [self.view addSubview:backView];
        //图标
        UIImageView *iconImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(19), kHvertical(15), kWvertical(17), kHvertical(19)) Image:[UIImage imageNamed:iconArray[i]]];
        [backView addSubview:iconImageView];
        //086
        UILabel *numberLable = [Factory createLabelWithFrame:CGRectMake(0, 0, kWvertical(55), kHvertical(50)) textColor:[UIColor colorWithHexString:@"#c8c8c8"] fontSize:kHorizontal(17) Title:@"086"];
        numberLable.textAlignment = NSTextAlignmentCenter;
        if (i==1) {
            [backView addSubview:numberLable];
            //勾选图标
            _checkView = [Factory createButtonWithFrame:CGRectMake(backView.width - backView.height, 0, backView.height, backView.height) NormalImage:@"icn_allianceNormal" SelectedImage:@"icn_allianceSelect" target:self selector:nil];
            _checkView.selected = FALSE;
//            [backView addSubview:_checkView];
        }
        //竖线
        UIView *lineView = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:@"#d2d2d2"]  frame:CGRectMake(numberLable.x_width, 0, 1, backView.height)];
        
        [backView addSubview:lineView];
        //输入框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lineView.x_width + kWvertical(25), 0, backView.width - lineView.x_width - kWvertical(25), backView.height)];
        textField.placeholder = placeholderArray[i];
        textField.tag = 101+i;
        textField.tintColor = [UIColor colorWithHexString:@"#32b14d"];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        if (i!=0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        [backView addSubview:textField];
        
        if (i==2) {
            //输入框不能超过验证码按钮前的竖线
            textField.width = backView.width - lineView.x_width - kWvertical(25) - kWvertical(135);
           //验证码前面竖线
            UIView *verticalLineView = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:@"#d2d2d2"] frame:CGRectMake(backView.width - kWvertical(135), kHvertical(16), 1, kHvertical(16))];
            
           //验证码按钮设置
            self.getCaptchaBtn  = [Factory createButtonWithFrame:CGRectMake(verticalLineView.x_width+1, 0, kWvertical(135), backView.height) titleFont:kHorizontal(18) textColor:[UIColor colorWithHexString:Nav_Color] backgroundColor:WhiteColor target:self selector:@selector(captchaStart) Title:@"获取验证码"];
            [backView addSubview:self.getCaptchaBtn];
            [backView addSubview:verticalLineView];

            //验证并绑定会员卡
            self.verifyBtn = [Factory createButtonWithFrame:CGRectMake(backView.x, backView.y_height + kHvertical(60), backView.width, backView.height) titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:[UIColor colorWithHexString:@"#32b14d"] target:self selector:@selector(verifyBtnCLick:) Title:@"验证并绑定会员卡"];
            self.verifyBtn.layer.masksToBounds = YES;
            self.verifyBtn.layer.cornerRadius = kHvertical(5);
            [self.view addSubview:self.verifyBtn];
            //底部文字信息
            UILabel *bottomLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), self.verifyBtn.y_height + kHvertical(55), screenWidth - kWvertical(20), kHvertical(100)) textColor:LightGrayColor fontSize:kHorizontal(14) Title:@"*请确保输入信息与会员卡预留信息一致。通过验证后，会绑定会员卡并享受会员预定优惠。"];
            bottomLabel.numberOfLines = 0;
            [bottomLabel sizeToFit];
            [self.view addSubview:bottomLabel];
        }
    }
}


#pragma mark - initData

//获取验证码
-(void)getVerifyCode{
    
    //手机号
    UITextField *phoneTextFeild = (UITextField *)[self.view viewWithTag:102];
    NSString *phoneStr = phoneTextFeild.text;
    NSDictionary *dict = @{
                           @"telphone":phoneStr,
                           @"countryCode":@"086"
                           };
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"league/doSendBuildUserCardSms" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@",data);
    }];

}

//验证用户输入信息
-(void)verifyInputData:(id)sender{
    //昵称
    UITextField *nickNameTextFeild = (UITextField *)[self.view viewWithTag:101];
    NSString *nickName = nickNameTextFeild.text;
    //手机号
    UITextField *phoneTextFeild = (UITextField *)[self.view viewWithTag:102];
    NSString *phoneStr = phoneTextFeild.text;
    //验证码
    UITextField *codeTextField = (UITextField *)[self.view viewWithTag:103];
    NSString *codeStr = codeTextField.text;

    
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"userName":nickName,
                           @"telphone":phoneStr,
                           @"checkCode":codeStr
                           };
    UIButton *senderBtn = (UIButton *)sender;
    senderBtn.userInteractionEnabled = NO;
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"league/doBuildUserCard" JsonKey:nil withData:dict failedBlock:^(id errType) {
        senderBtn.userInteractionEnabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@",data);
        senderBtn.userInteractionEnabled = YES;
        if ([data isKindOfClass:[NSDictionary class]]) {
            BOOL packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
            if (!packSuccess) {
                NSString *packResultMsg = [data objectForKey:@"packResultMsg"];
                [LQProgressHud showLinesMessage:packResultMsg];
            }else{
                [self popBack];
            }
        }
    }];
    
}


#pragma mark - Action
//pop返回
-(void)popBack{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_wbg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}
//获取验证码点击
-(void)captchaStart{
    //会员名
    UITextField *nickNameTextField = (UITextField *)[self.view viewWithTag:101];
    NSString *nickName = nickNameTextField.text;
    if (nickName.length<1) {
        [LQProgressHud showLinesMessage:@"请输入会员姓名！"];
        return;
    }
    //手机号
    UITextField *selectTextField = (UITextField *)[self.view viewWithTag:102];
    NSString *phoneStr = selectTextField.text;
    if (phoneStr.length==11) {
        //光标改变位置
        for (int i = 0; i<3; i++) {
            UITextField *textField = (UITextField *)[self.view viewWithTag:101+i];
            if (i<2) {
                [textField resignFirstResponder];
            }else{
                [textField becomeFirstResponder];
            }
        }
        //使按钮失效
        self.getCaptchaBtn.enabled = FALSE;
        //倒计时开始
        [self startTimer];
    }else{
        [LQProgressHud showLinesMessage:@"手机号码输入错误，请正确输入您会员卡的预留手机号！"];
    }

}
//验证信息按钮点击
-(void)verifyBtnCLick:(id)sender{
    //会员名
    UITextField *nickNameTextField = (UITextField *)[self.view viewWithTag:101];
    NSString *nickName = nickNameTextField.text;
    if (nickName.length<1) {
        [LQProgressHud showLinesMessage:@"请输入会员姓名！"];
        return;
    }
    //手机号
    UITextField *selectTextField = (UITextField *)[self.view viewWithTag:102];
    NSString *phoneStr = selectTextField.text;
    if (phoneStr.length<1) {
        [LQProgressHud showLinesMessage:@"手机号码输入错误，请正确输入您会员卡的预留手机号！"];
        return;
    }
    //验证码
    UITextField *codeTextField = (UITextField *)[self.view viewWithTag:103];
    NSString *codeStr = codeTextField.text;
    if (codeStr.length<1) {
        [LQProgressHud showLinesMessage:@"请输入验证码！"];
        return;
    }
    
    if (nickName.length>0&&phoneStr.length>0&&codeStr.length>0) {
        //调用信息验证
        [self verifyInputData:sender];
    }
}

#pragma mark - 计时器
// 定时器倒计时
- (void)startTimer
{
    //发送验证码
    [self getVerifyCode];
    //设置默认60s才能调用一次
    _count = 60;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}
//计时器运行
- (void)countDown
{
    _count --;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_getCaptchaBtn setTitle:[NSString stringWithFormat:@"%ds",_count] forState:UIControlStateNormal];
    });
    
    
    if (_count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        _getCaptchaBtn.enabled = TRUE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_getCaptchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        });

    }
}


#pragma mark - UITextfieldDelegate
//隐藏键盘
-(BOOL)textViewShouldBeginEditing:(UITextField *)textField{
    for (int i = 0; i<3; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:101+i];
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (int i = 0; i<3; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:101+i];
        [textField resignFirstResponder];
    }
}
//内容改变
-(void)textFieldChange:(UITextField *)textField{
    NSInteger selectTag = textField.tag;
    if (selectTag==102) {
        NSString *inputStr = textField.text;
        _checkView.selected = FALSE;
        if (inputStr.length==11) {
            _checkView.selected = TRUE;
        }
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
