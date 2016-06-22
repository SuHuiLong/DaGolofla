//
//  JGLManageCancelViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLManageCancelViewController.h"
#import "UITool.h"
@interface JGLManageCancelViewController ()
{
    NSTimer *_timer;
    UIButton* _btnCode;
    UITextField* _textCode;
}
@end

@implementation JGLManageCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"设置资金管理权限";
    self.view.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    
    [self createHeaderView];
    
    [self createCodeView];
    
    [self createSureCode];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];

}

/**
 *  创建顶部视图
 */
-(void)createHeaderView
{
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 15*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
    labelTitle.font = [UIFont systemFontOfSize:16*screenWidth/375];
    [self.view addSubview:labelTitle];
    
    
    UILabel* labelDetail = [[UILabel alloc]init];
    //1是取消  0是设置
    NSString* string;
    if (_isCancel == 1) {
        labelTitle.text = @"取消方式";
        string = @"                   为了球队资金的安全和管理，取消资金管理者管理权限，请先输入资金管理验证码。";
        labelDetail.numberOfLines = 2;
        labelDetail.frame = CGRectMake(10*screenWidth/375, 55*screenWidth/375, screenWidth - 20*screenWidth/375, 40*screenWidth/375);
    }
    else
    {
        labelTitle.text = @"设置方式";
        string = @"                   为了球队资金的安全和管理，球队资金管理权限只能设置一人，取消资金管理者时，需进行手机验证。";
        labelDetail.numberOfLines = 3;
        labelDetail.frame = CGRectMake(10*screenWidth/375, 45*screenWidth/375, screenWidth - 20*screenWidth/375, 60*screenWidth/375);
    }
    labelDetail.text = string;
    
    labelDetail.textColor = [UIColor lightGrayColor];
    labelDetail.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [self.view addSubview:labelDetail];
    
    UILabel* labelHint = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70*screenWidth/375, 20*screenWidth/375)];
    labelHint.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [labelDetail addSubview:labelHint];
    labelHint.textColor = [UIColor whiteColor];
    labelHint.text = @"温馨提示";
    labelHint.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    labelHint.textAlignment = NSTextAlignmentCenter;
    
}
/**
 *  验证码
 */
-(void)createCodeView
{
    
    UIView* viewCode = [[UIView alloc]initWithFrame:CGRectMake(0, 120*screenWidth/375, screenWidth, 44*screenWidth/375)];
    [self.view addSubview:viewCode];
    viewCode.backgroundColor = [UIColor whiteColor];
    
    
    UILabel* codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 50*screenWidth/375, 44*screenWidth/375)];
    codeLabel.text = @"验证码";
    codeLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [viewCode addSubview:codeLabel];
    
    
    _textCode = [[UITextField alloc]initWithFrame:CGRectMake(70*screenWidth/375, 0, screenWidth - 160*screenWidth/375, 44*screenWidth/375)];
    _textCode.font = [UIFont systemFontOfSize:15*screenWidth/375];
    [viewCode addSubview:_textCode];
    _textCode.placeholder = @"发送验证码";
    
    
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCode.frame = CGRectMake(screenWidth - 90*screenWidth/375, 5*screenWidth/375, 80*screenWidth/375, 34*screenWidth/375);
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnCode setTitleColor:[UITool colorWithHexString:@"#7fc1ff" alpha:1] forState:UIControlStateNormal];
    [_btnCode.layer setBorderWidth:1.0]; //边框宽度
    _btnCode.layer.borderColor = [[UITool colorWithHexString:@"#7fc1ff" alpha:1] CGColor];
    _btnCode.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 8*screenWidth/375;
    [viewCode addSubview:_btnCode];
    if (_isCancel == 1) {
        [_btnCode addTarget:self action:@selector(cancelCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_btnCode addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
static int timeNumber = 60;

//设置使用的验证码
-(void)codeClick
{
    _btnCode.userInteractionEnabled = NO;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_model.timeKey forKey:@"memberKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doSendSmsCheckCodeFromAccountMgr" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            timeNumber = 60;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}


-(void)cancelCodeClick
{
    _btnCode.userInteractionEnabled = NO;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doSendSmsCheckCodeToAccountMgr" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            timeNumber = 60;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}

/**
 *  定时器
 */
- (void)autoMove {
    timeNumber--;
    _btnCode.titleLabel.font = [UIFont systemFontOfSize:11];
    [_btnCode setTitle:[NSString stringWithFormat:@"(%d)后重新获取",timeNumber] forState:UIControlStateNormal];
    if (timeNumber == 0) {
        _btnCode.titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _btnCode.userInteractionEnabled = YES;
    }
}

/**
 *  确定设置管理权限
 */
-(void)createSureCode
{
    UIButton* btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCode.frame = CGRectMake(10*screenWidth/375, 184*screenWidth/375, screenWidth - 20*screenWidth/375, 44*screenWidth/375);
    //1是取消  0是设置
    if (_isCancel == 1) {
        [btnCode setTitle:@"确认" forState:UIControlStateNormal];
        [btnCode addTarget:self action:@selector(setCancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btnCode setTitle:@"确定设置管理权限" forState:UIControlStateNormal];
        [btnCode addTarget:self action:@selector(setCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    btnCode.titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
    btnCode.layer.masksToBounds = YES;
    btnCode.titleLabel.textColor = [UIColor whiteColor];
    btnCode.layer.cornerRadius = 8*screenWidth/320;
    [self.view addSubview:btnCode];
    btnCode.backgroundColor = [UIColor orangeColor];
    
}

/**
 *  取消
 */
-(void)setCancelClick
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_model.timeKey forKey:@"memberKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_textCode.text forKey:@"checkCode"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doUnSetAccountMgr" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _blockCancel();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
    
}


/**
 *  设置管理权限
 */
-(void)setCodeClick
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_teamKey forKey:@"teamKey"];
    [dict setObject:_model.timeKey forKey:@"memberKey"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_textCode.text forKey:@"checkCode"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doSetAccountMgr" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _blockSetting();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
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
