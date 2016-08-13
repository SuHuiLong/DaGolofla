//
//  EnrollViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "EnrollViewController.h"

#import "PasswordViewController.h"

#define kRegist_URL @"user/queryMobileVaild.do"

#import "Helper.h"
#import "PostDataRequest.h"

#import "MBProgressHUD.h"
#import "UITool.h"
#import "ResponseViewController.h"

@interface EnrollViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    //手机号
    UITextField* _textPhone;
    //验证码
    UITextField* _textCaptChe;
    //获取验证码
    UIButton* _btnCaptChe;
    //绑定
    UIButton* _btnBind;
    
    //免责条款
    UIButton* _btnResponse;
    UIButton* _gouXuan;
    UILabel*  _labelResponse;
    BOOL _isxuan;
    
    BOOL _isDidSelect;
    NSMutableDictionary *_dict;
    NSTimer *_timer;
    NSString *_testStr;//输入验证码
    NSNumber *_testStr1;//接收验证码
    
    NSString* _strName;
    
    // 判断用户点击的是哪一个输入框
    NSInteger _isShowAlertView;
    
    MBProgressHUD* _progressHud;
    
    MBProgressHUD* _progress;
}
@end

@implementation EnrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    
    _dict = [[NSMutableDictionary alloc]init];
    _strName = [[NSString alloc]init];
    [self createView];
    _isxuan = YES;
    
    //用户名
    [self createCaptChe];
    //手机号
    [self createBtnBind];
    
    //安全责任条款
    [self createResponsibility];
}

-(void)createBtnBind
{
    _btnBind = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    _btnBind.frame = CGRectMake(10*ScreenWidth/375, 118*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnBind];
    [_btnBind setTitle:@"下一步" forState:UIControlStateNormal];
    [_btnBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnBind.layer.masksToBounds = YES;
    _btnBind.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnBind addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  下一步，点击跳转页面
 */
-(void)nextClick
{
    [self.view endEditing:YES];
    
    if (_isxuan == YES) {
        if ([Helper testMobileIsTrue:_textPhone.text]) {
            if ([[NSString stringWithFormat:@"%@",_textCaptChe.text] isEqualToString:_testStr]) {
                PasswordViewController* pasVc = [[PasswordViewController alloc]init];
                
                pasVc.userName = [_dict objectForKey:@"userName"];
                pasVc.phoneNum = [_dict objectForKey:@"mobile"];
                pasVc.capChe = _textCaptChe.text;
                
                [self.navigationController pushViewController:pasVc animated:YES];
            }
            else
            {
                [Helper alertViewWithTitle:@"请确认验证码是否填写正确" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
        }else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertView.tag = 1001;
//            [alertView show];
//            
            [Helper alertViewWithTitle:@"手机号码格式错误!" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];

        }
    }
    else
    {
        [Helper alertViewWithTitle:@"请先阅读《使用条款和隐私政策》，并勾选同意后方可注册" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}



-(void)createCaptChe
{
    _textCaptChe = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 64*ScreenWidth/375, ScreenWidth/3*2-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textCaptChe];
    _textCaptChe.delegate = self;
    _textCaptChe.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textCaptChe.placeholder = @"请输入短信验证码";
    _textCaptChe.textColor = [UIColor blackColor];
    _textCaptChe.backgroundColor = [UIColor whiteColor];
    _textCaptChe.borderStyle = UITextBorderStyleRoundedRect;
    _textCaptChe.clearButtonMode = UITextFieldViewModeAlways;
    
    
    _btnCaptChe = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCaptChe.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    _btnCaptChe.frame = CGRectMake(ScreenWidth/3*2, 64*ScreenWidth/375, ScreenWidth/3-10*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnCaptChe];
    [_btnCaptChe setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnCaptChe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnCaptChe.layer.masksToBounds = YES;
    _btnCaptChe.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _btnCaptChe.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnCaptChe addTarget:self action:@selector(captCheClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  获取短信验证码
 */

static int timeNumber = 60;
-(void)captCheClick:(UIButton *)btn
{
    //    ////NSLog(@"12 dict = =%@",_dict);
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    [_textPhone resignFirstResponder];
    [_textCaptChe resignFirstResponder];
    _btnCaptChe.userInteractionEnabled = NO;
    _btnCaptChe.backgroundColor = [UIColor lightGrayColor];
    
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"验证码发送中，请稍后...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    if (_strName != nil) {
        if ([Helper testMobileIsTrue:_textPhone.text]) {
            [_dict setValue:_strName forKey:@"userName"];
            btn.userInteractionEnabled = YES;
//            [btn setBackgroundColor:[UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f]];
            btn.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
            //手机获得验证码
            [[PostDataRequest sharedInstance] postDataRequest:kRegist_URL parameter:@{@"mobile":_textPhone.text} success:^(id respondsData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                _btnCaptChe.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
                _btnCaptChe.userInteractionEnabled = YES;
                if ([[dict objectForKey:@"success"] boolValue]) {
                    _btnCaptChe.userInteractionEnabled = NO;
                    _testStr1 = [NSNumber numberWithInteger:[_textCaptChe.text integerValue]];
                    ////NSLog(@"1234 == %@",_testStr1);
                    timeNumber = 60;
                    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertView.tag = 1003;
                    [alertView show];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertView dismissWithClickedButtonIndex:0 animated:YES];
                    });
                }
            } failed:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
            }];
        }else {
            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号输入错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 1004;
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            });
        }
    }else {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        alertView.tag = 1001;
        [alertView show];
    }
    
}

- (void)autoMove {
    timeNumber--;
    _btnCaptChe.titleLabel.font = [UIFont systemFontOfSize:11];
    [_btnCaptChe setTitle:[NSString stringWithFormat:@"(%d)后重新获取",timeNumber] forState:UIControlStateNormal];
    if (timeNumber == 0) {
        _btnCaptChe.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnCaptChe setTitle:@"   发送验证码   " forState:UIControlStateNormal];
        [_timer invalidate];
        _btnCaptChe.userInteractionEnabled = YES;
    }
}
-(void)createView
{
    _textPhone = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:_textPhone];
    _textPhone.delegate = self;
    _textPhone.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPhone.placeholder = @"请输入手机号码";
    _textPhone.textColor = [UIColor blackColor];
    _textPhone.backgroundColor = [UIColor whiteColor];
    //    _textPhone.layer.cornerRadius = 10*ScreenWidth/375;
    //    _textPhone.layer.masksToBounds = YES;
    _textPhone.borderStyle = UITextBorderStyleRoundedRect;
    _textPhone.clearButtonMode = UITextFieldViewModeAlways;
    _textPhone.returnKeyType = UIReturnKeyNext;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_textPhone == textField){
        [_dict setValue:str forKey:@"mobile"];
        if ([str length] > 20) {
            textField.text = [str substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }else if(textField == _textCaptChe){
        _testStr = str;
        ////NSLog(@"yanzhen%@",_testStr);
    }
    
    return YES;
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    if (textField == _textPhone)
    {
        [_textPhone resignFirstResponder];
        
        [_textCaptChe becomeFirstResponder];
    }
    else
    {
        [_textPhone resignFirstResponder];
        
        [_textCaptChe resignFirstResponder];
    }
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textPhone resignFirstResponder];
    [_textCaptChe resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textPhone) {
        [_dict setValue:textField.text forKey:@"mobile"];
        
        
        
        
    }else if(textField == _textCaptChe) {
        _testStr = textField.text;
        
    }
}
-(void)dealloc
{
    _timer = nil;
}

#pragma mark --免责条款
-(void)createResponsibility
{
    
    _gouXuan = [UIButton buttonWithType:UIButtonTypeCustom];
    _gouXuan.frame = CGRectMake(10*ScreenWidth/375, 170*ScreenWidth/375, 44*ScreenWidth/375, 44*ScreenWidth/375);
    //    _gouXuan.backgroundColor = [UIColor redColor];
    [self.view addSubview:_gouXuan];
    [_gouXuan setImage:[UIImage imageNamed:@"y"] forState:UIControlStateNormal];
    [_gouXuan addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _labelResponse = [[UILabel alloc]initWithFrame:CGRectMake(54*ScreenWidth/375, 170*ScreenWidth/375, 90*ScreenWidth/375, 44*ScreenWidth/375)];
    _labelResponse.text = @"已阅读并同意";
    _labelResponse.textColor = [UIColor darkGrayColor];
    _labelResponse.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:_labelResponse];
    
    _btnBind = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBind.frame = CGRectMake(144*ScreenWidth/375, 170*ScreenWidth/375, 170*ScreenWidth/375, 44*ScreenWidth/375);
    [_btnBind setTitle:@"《使用条款和隐私政策》" forState:UIControlStateNormal];
    [_btnBind setTitleColor:[UITool colorWithHexString:@"32b14d" alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:_btnBind];
    _btnBind.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_btnBind addTarget:self action:@selector(responseClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//是否同意选择服务条款
-(void)agreeClick
{
    if(_isxuan == YES)
    {
        [_gouXuan setImage:[UIImage imageNamed:@"w"] forState:UIControlStateNormal];
        _isxuan = NO;
    }
    else
    {
        [_gouXuan setImage:[UIImage imageNamed:@"y"] forState:UIControlStateNormal];
        _isxuan = YES;
    }
}

-(void)responseClick
{
    ResponseViewController* resVc = [[ResponseViewController alloc]init];
    [self.navigationController pushViewController:resVc animated:YES];
}



@end
