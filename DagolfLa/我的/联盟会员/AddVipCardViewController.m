//
//  AddVipCardViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "AddVipCardViewController.h"

@interface AddVipCardViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    //城市区号选择
    UIPickerView *_pickerView;
    //区号标题
    NSArray *_titleArray;
    //区号内容
    NSArray *_titleCodeArray;
}

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
//验证提示
@property (nonatomic, strong)MBProgressHUD *progressView;
//选中区号按钮
@property (nonatomic, strong)UIButton *cityBtn;
//选中区号
@property (nonatomic, copy)NSString *codeing;


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
    NSArray *iconArray = @[ @"icn_allianceMen",@"",@"icon_login_verify"];
    //输入框默认提示
    NSArray *placeholderArray = @[@"请输入会员姓名",@"请输入手机号码",@"请输入验证码"];
    for (int i = 0; i<3; i++) {
        //白色背景
        UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(10), kHvertical(20) + kWvertical(60)*i, screenWidth - kWvertical(20), kWvertical(50))];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = kHvertical(5);
        [self.view addSubview:backView];
        //图标
        UIButton *iconImageView = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(50), kWvertical(50)) image:[UIImage imageNamed:iconArray[i]] target:self selector:nil Title:nil];
        iconImageView.userInteractionEnabled = YES;
        [backView addSubview:iconImageView];
        //086
        _cityBtn = [Factory createButtonWithFrame:CGRectMake(backView.x, backView.y, kWvertical(50), kWvertical(50)) titleFont:kHorizontal(17) textColor:[UIColor colorWithHexString:@"#c8c8c8"] backgroundColor:ClearColor target:self selector:@selector(selectCity:) Title:nil];
        [_cityBtn setTitle:@"086" forState:UIControlStateNormal];

        _titleArray = @[@"中国大陆      +0086", @"中国香港      ＋00886", @"中国澳门      ＋00852", @"中国台湾      ＋00853"];
        _titleCodeArray = @[@"0086", @"00886", @"00852", @"00853"];
        _codeing = @"0086";
        if (i==1) {
            [self.view addSubview:_cityBtn];
            //勾选图标
            _checkView = [Factory createButtonWithFrame:CGRectMake(backView.width - backView.height, 0, backView.height, backView.height) NormalImage:@"icn_allianceNormal" SelectedImage:@"icn_allianceSelect" target:self selector:nil];
            _checkView.selected = FALSE;
//            [backView addSubview:_checkView];
        }
        //竖线
        UIView *lineView = [Factory createViewWithBackgroundColor:[UIColor colorWithHexString:@"#d2d2d2"]  frame:CGRectMake( kWvertical(50), 0, 1, backView.height)];
        
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
            self.getCaptchaBtn  = [Factory createButtonWithFrame:CGRectMake(verticalLineView.x_width+1, 0, kWvertical(135), backView.height) titleFont:kHorizontal(18) textColor:[UIColor colorWithHexString:Bar_Segment] backgroundColor:WhiteColor target:self selector:@selector(captchaStart) Title:@"获取验证码"];
            [backView addSubview:self.getCaptchaBtn];
            [backView addSubview:verticalLineView];

            //验证并绑定会员卡
            self.verifyBtn = [Factory createButtonWithFrame:CGRectMake(backView.x, backView.y_height + kWvertical(60), backView.width, backView.height) titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:RGBA(210, 210, 210, 1) target:self selector:@selector(verifyBtnCLick:) Title:@"验证并绑定会员卡"];
//            self.verifyBtn[UIColor colorWithHexString:@"#32b14d"]
            self.verifyBtn.layer.masksToBounds = YES;
            self.verifyBtn.layer.cornerRadius = kHvertical(5);
            self.verifyBtn.enabled = FALSE;
            [self.view addSubview:self.verifyBtn];
            //底部文字信息
            UILabel *bottomLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), self.verifyBtn.y_height + kHvertical(55), screenWidth - kWvertical(20), kHvertical(100)) textColor:LightGrayColor fontSize:kHorizontal(14) Title:@"*请确保输入信息与会员卡预留信息一致。通过验证后，会绑定会员卡并享受会员预定优惠。"];
            
            [bottomLabel changeLineWithSpace:5.0f];
            bottomLabel.numberOfLines = 0;
            [bottomLabel sizeToFit];
            [self.view addSubview:bottomLabel];
        }
    }
}
//创建提示
-(void)createHUD:(NSString *)text{
    _progressView.hidden = NO;
    _progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.alpha = 1;
    _progressView.mode = MBProgressHUDModeText;
    _progressView.detailsLabel.text = text;
    _progressView.color = BlackColor;
    _progressView.detailsLabel.textColor = WhiteColor;
    _progressView.detailsLabel.font = [UIFont systemFontOfSize:kHorizontal(16)]; //Johnkui - added
    [_progressView hideAnimated:YES afterDelay:1.5];
    
    [self.view addSubview:_progressView];

}

#pragma mark - initData

//获取验证码
-(void)getVerifyCode{
    
    //手机号
    UITextField *phoneTextFeild = (UITextField *)[self.view viewWithTag:102];
    NSString *phoneStr = phoneTextFeild.text;
    NSDictionary *dict = @{
                           @"telphone":phoneStr,
                           @"countryCode":_codeing
                           };
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"league/doSendBuildUserCardSms" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@",data);
    }];
    
}


//验证用户输入信息
-(void)verifyInputData:(id)sender{
    _progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.mode = MBProgressHUDModeIndeterminate;
    _progressView.label.text = @"添加中...";
    _progressView.color = BlackColor;
    _progressView.activityIndicatorColor = WhiteColor;

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
        _progressView.hidden=YES;
        [_progressView removeFromSuperview];
    } completionBlock:^(id data) {
        _progressView.hidden=YES;
        [_progressView removeFromSuperview];
        senderBtn.userInteractionEnabled = YES;
        if ([data isKindOfClass:[NSDictionary class]]) {
            BOOL packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
            if (!packSuccess) {
                NSString *packResultMsg = [data objectForKey:@"packResultMsg"];
                [self createHUD:packResultMsg];
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
        [self createHUD:@"手机号码输入错误，请正确输入您会员卡的预留手机号！"];
    }

}
//验证信息按钮点击
-(void)verifyBtnCLick:(id)sender{
    
    //调用信息验证
    
    [self verifyInputData:sender];
    
}
//区号选择
-(void)selectCity:(UIButton *)btn{
    _cityBtn = btn;
    for (int i = 0; i<3; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:101+i];
        [textField resignFirstResponder];
    }
    
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
        [_getCaptchaBtn setTitleColor:[UIColor colorWithHexString:Line_Color] forState:UIControlStateNormal];
        _getCaptchaBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
        [_getCaptchaBtn setTitle:[NSString stringWithFormat:@"(%ds)后重新获取", _count] forState:UIControlStateNormal];
    });
    
    
    if (_count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        _getCaptchaBtn.enabled = TRUE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_getCaptchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_getCaptchaBtn setTitleColor:[UIColor colorWithHexString:Bar_Segment] forState:UIControlStateNormal];
            _getCaptchaBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(18)];

            
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
    _pickerView.hidden = YES;
    [_pickerView removeFromSuperview];
    _pickerView = nil;
}
//内容改变
-(void)textFieldChange:(UITextField *)textField{
    NSInteger canClickNum = 0;
    for (int i = 0; i<3; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:101+i];
        NSInteger textStrLen = textField.text.length;
        if (i==2) {
            if (textStrLen==6) {
                canClickNum++;
            }
        }else{
            if (textStrLen>0) {
                canClickNum++;
            }
        }
    }
    if (canClickNum==3) {
        self.verifyBtn.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        self.verifyBtn.enabled = TRUE;

    }else{
        self.verifyBtn.backgroundColor = RGBA(210, 210, 210, 1);
        self.verifyBtn.enabled = FALSE;
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
    [_cityBtn setTitle:cddd forState:UIControlStateNormal];
    _codeing = [NSString stringWithFormat:@"%@", _titleCodeArray[row]];
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
