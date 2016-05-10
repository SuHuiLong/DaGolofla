//
//  MySetPasswordController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/26.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MySetPasswordController.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "EnterViewController.h"

#define kReseve_URL @"user/updatePassWord.do"

@interface MySetPasswordController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    
    UIButton* _btnClick;
    
    BOOL _isCLick;
    
    NSMutableDictionary *_dict;
    
    UIAlertView *_alertView;
    
    // 判断用户点击的是哪一个输入框
    NSInteger _isShowAlertView;
}
@end

@implementation MySetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    ////NSLog(@"%@", self.navigationController.viewControllers);
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dict = [[NSMutableDictionary alloc]init];
    
    [self createView];
    
    [self createBtnView];
    
    [self createSubBtn];
}


-(void)createView
{
    NSArray* array = @[@" 当前密码",@" 新密码",@" 确认密码"];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120*ScreenWidth/375)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    for (int i = 0; i < 3; i++) {
        UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 40*ScreenWidth/375*i, ScreenWidth-20*ScreenWidth/375, 1*ScreenWidth/375)];
        if (i == 0) {
            viewLine.backgroundColor = [UIColor clearColor];
        }
        else
        {
            viewLine.backgroundColor = [UIColor lightGrayColor];
        }
        [self.view addSubview:viewLine];
        
        
        UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375+40*ScreenWidth/375*i, 70*ScreenWidth/375, 20*ScreenWidth/375)];
        labelTitle.text = array[i];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [view addSubview:labelTitle];
        
        
        UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 10*ScreenWidth/375+40*ScreenWidth/375*i, ScreenWidth-110*ScreenWidth/375, 20*ScreenWidth/375)];
        [self.view addSubview:textField];
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        textField.placeholder = @"请输入6-20个字符";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = [UIColor blackColor];
        textField.backgroundColor = [UIColor whiteColor];
        //        _textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.tag = i+100;
        textField.secureTextEntry = YES;
        if (i < 2) {
            textField.returnKeyType = UIReturnKeyNext;
        }
        else
        {
            textField.returnKeyType = UIReturnKeySend;
        }
    }
    
}

-(void)createBtnView
{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-120*ScreenWidth/375, 130*ScreenWidth/375, 70*ScreenWidth/375, 20*ScreenWidth/375)];
    label.text = @"显示密码";
    label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [self.view addSubview:label];
    
    _btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClick setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    _btnClick.frame = CGRectMake(ScreenWidth-50*ScreenWidth/375, 120*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375);
    [self.view addSubview:_btnClick];
    [_btnClick addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel* labelHint = [[UILabel alloc]initWithFrame:CGRectMake(20*ScreenWidth/375, 160*ScreenWidth/375, ScreenWidth-40*ScreenWidth/375, 40*ScreenWidth/375)];
    labelHint.text = @"注意：密码需填写6-20位字符，由英文字母，数字和符号组成，不能含空格";
    labelHint.textColor = [UIColor lightGrayColor];
    labelHint.numberOfLines = 0;
    labelHint.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [self.view addSubview:labelHint];
    
}

-(void)chooseClick
{
    UITextField* textf1 = (UITextField*)[self.view viewWithTag:100];
    UITextField* textf2 = (UITextField*)[self.view viewWithTag:101];
    UITextField* textf3 = (UITextField*)[self.view viewWithTag:102];
    [textf1 resignFirstResponder];
    [textf2 resignFirstResponder];
    [textf3 resignFirstResponder];
    if (_isCLick == NO) {
        _isCLick = YES;
        [_btnClick setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
        textf1.secureTextEntry = YES;
        textf2.secureTextEntry = YES;
        textf3.secureTextEntry = YES;
    }
    else
    {
        _isCLick = NO;
        [_btnClick setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
        textf1.secureTextEntry = NO;
        textf2.secureTextEntry = NO;
        textf3.secureTextEntry = NO;
    }
}
-(void)createSubBtn
{
    UIButton* btnSub = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSub setTitle:@"提交密码" forState:UIControlStateNormal];
    btnSub.frame = CGRectMake(10*ScreenWidth/375, 220*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    btnSub.backgroundColor = [UIColor orangeColor];
    btnSub.layer.masksToBounds = YES;
    btnSub.layer.cornerRadius = 8*ScreenWidth/375;
    [btnSub setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSub addTarget:self action:@selector(btnSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSub];
}
-(void)btnSubmit
{
    UITextField* textf1 = (UITextField*)[self.view viewWithTag:100];
    UITextField* textf2 = (UITextField*)[self.view viewWithTag:101];
    UITextField* textf3 = (UITextField*)[self.view viewWithTag:102];
    //    ////NSLog(@"1 %@  2 %@   3 %@",textf1.text, textf2.text, textf3.text);
    [textf1 resignFirstResponder];
    [textf2 resignFirstResponder];
    [textf3 resignFirstResponder];
    
    NSMutableString* strPass = [[NSMutableString alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSMutableString* str = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"mobile"]];
        [_dict setValue:str forKey:@"mobile"];
        //                 ////NSLog(@"%@",str);
        
        
        strPass = [NSMutableString stringWithFormat:@"%@",[defaults objectForKey:@"passWord"]];
        ////NSLog(@"%@",strPass);
    }
    
    
    if (textf2.text.length <= 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置六位密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        _isShowAlertView = 1;
        [alertView show];
        return;
    }
    
    //判断密码中不会出现空格
    if(([textf1.text rangeOfString:@" "].location == NSNotFound) || ([textf2.text rangeOfString:@" "].location == NSNotFound) || ([textf3.text rangeOfString:@" "].location == NSNotFound))
    {
        //判断旧密码
        if ([textf1.text isEqualToString:strPass]) {
            /**
             *  判断输入框是否为空
             */
            if (![Helper isBlankString:textf1.text] || ![Helper isBlankString:textf2.text] || ![Helper isBlankString:textf3.text])
            {
                /**
                 *  判断新密码和确定密码是否相同
                 */
                if ([textf2.text isEqualToString:textf3.text]) {
                    
                    [[PostDataRequest sharedInstance] postDataRequest:kReseve_URL parameter:_dict success:^(id respondsData) {
                        ////NSLog(@"dicr == %@",_dict);
                        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        //////NSLog(@"%@",userData);
                        
                        if ([[userData objectForKey:@"success"] boolValue]) {
                            //修改密码成功
                            //////NSLog(@"%@",[userData objectForKey:@"message"]);
                            _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [_alertView show];
                            
                        }else {
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                    } failed:^(NSError *error) {
                        ////NSLog(@"%@",error);
                    }];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您两次密码输入不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    _isShowAlertView = 2;
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还有密码没输" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _isShowAlertView = 2;
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的旧密码输入不正确" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _isShowAlertView = 0;
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的密码中有空格" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _isShowAlertView = 1;
        [alert show];
    }
    
    
    
}





#pragma mark --键盘响应事件

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    switch (textField.tag) {
        case 100:
            [_dict setValue:str forKey:@"passWord"];
            break;
        case 101:
            [_dict setValue:str forKey:@"newPassWord"];
            break;
            
            
        default:
            break;
    }
    return YES;
}

//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    UITextField* textf1 = (UITextField*)[self.view viewWithTag:100];
    UITextField* textf2 = (UITextField*)[self.view viewWithTag:101];
    UITextField* textf3 = (UITextField*)[self.view viewWithTag:102];
    if (textField.tag == textf1.tag) {
        [textf2 becomeFirstResponder];
        [textf1 resignFirstResponder];
        [textf3 resignFirstResponder];
    }
    else if (textField.tag == textf2.tag)
    {
        [textf1 resignFirstResponder];
        [textf2 resignFirstResponder];
        [textf3 becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField* textf1 = (UITextField*)[self.view viewWithTag:100];
    UITextField* textf2 = (UITextField*)[self.view viewWithTag:101];
    UITextField* textf3 = (UITextField*)[self.view viewWithTag:102];
    
    [textf1 resignFirstResponder];
    [textf2 resignFirstResponder];
    [textf3 resignFirstResponder];
}


#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == _alertView) {
        
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        
        [user removeObjectForKey:@"userId"];
        [user synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        
        // 让一段代码延迟执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ////NSLog(@"延迟几秒执行");
            
            UITextField* textf1 = (UITextField*)[self.view viewWithTag:100];
            UITextField* textf2 = (UITextField*)[self.view viewWithTag:101];
            UITextField* textf3 = (UITextField*)[self.view viewWithTag:102];
            if (_isShowAlertView == 0) {
                [textf1 becomeFirstResponder];
            } else  if (_isShowAlertView == 1){
                [textf2 becomeFirstResponder];
            } else {
                [textf3 becomeFirstResponder];
            }
            
        });
        
    }
}


@end
