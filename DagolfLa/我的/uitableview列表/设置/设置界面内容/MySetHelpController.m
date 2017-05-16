//
//  MySetHelpController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/26.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MySetHelpController.h"
#import "IWTextView.h"

@interface MySetHelpController ()<UITextViewDelegate,UITextFieldDelegate>
{
    IWTextView* _textView;
    UIView* _viewBase;
    CGFloat _contentSizeY;
    
    UITextField* _textPhone;
    
    UIButton* _btnSend;
    NSMutableDictionary* _dict;

    
}
@end

@implementation MySetHelpController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"帮助反馈";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dict = [[NSMutableDictionary alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createView];
    
    [self createPhoneView];
    
    [self createBtnSend];
}

//文字设置
-(void)createView
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 200*ScreenWidth/375)];
    _viewBase.backgroundColor = [UIColor whiteColor];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [self.view addSubview:_viewBase];
    
    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, 190*ScreenWidth/375)];
    _textView.backgroundColor=[UIColor whiteColor]; //背景色
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;       //设置代理方法的实现类
    _textView.placeholder = @"请输入您的意见";
    [_viewBase addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textView.tag = 100;
    // 1.监听textView文字改变的通知
    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
}
/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
    ////NSLog(@"12 ===  %@",_textView.text);
    [_dict setObject:_textView.text forKey:@"content"];
}

/**
 *  创建联系方式视图
 */
-(void)createPhoneView
{
    UILabel* labelContact = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 220*ScreenWidth/375, 65*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:labelContact];
    labelContact.text = @"联系方式";
    labelContact.font = [UIFont systemFontOfSize:15*ScreenWidth/375];

    
    UIView* viewBase  = [[UIView alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 220*ScreenWidth/375, ScreenWidth-90*ScreenWidth/375, 44*ScreenWidth/375)];
    [self.view addSubview:viewBase];
    viewBase.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(12*ScreenWidth/375, 12*ScreenWidth/375, 15*ScreenWidth/375, 20*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@"phone"];
    [viewBase addSubview:imgv];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(37*ScreenWidth/375, 5*ScreenWidth/375, 1*ScreenWidth/375, 34*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [viewBase addSubview:viewLine];
    
    
    _textPhone = [[UITextField alloc]initWithFrame:CGRectMake(40*ScreenWidth/375, 0, viewBase.frame.size.width-40*ScreenWidth/375, 44*ScreenWidth/375)];
    [viewBase addSubview:_textPhone];
    _textPhone.delegate = self;
    _textPhone.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPhone.placeholder = @"请输入您的联系方式";
    _textPhone.textColor = [UIColor blackColor];
    _textPhone.backgroundColor = [UIColor whiteColor];
//    _textPhone.borderStyle = UITextBorderStyleRoundedRect;
    _textPhone.clearButtonMode = UITextFieldViewModeAlways;
    
}

-(void)createBtnSend
{
    _btnSend = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnSend.backgroundColor = [UIColor colorWithRed:0.95f green:0.60f blue:0.19f alpha:1.00f];
    _btnSend.frame = CGRectMake(10*ScreenWidth/375, 274*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnSend];
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [_btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSend.layer.masksToBounds = YES;
    _btnSend.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnSend addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];

}
//发送按钮点击事件
-(void)sendClick
{
    _btnSend.userInteractionEnabled = NO;
    [_textPhone resignFirstResponder];
    [_textView resignFirstResponder];
    [_dict setObject:_textPhone.text forKey:@"contactWay"];
    //验证手机号码格式
    if (![Helper isBlankString:_textView.text]) {
        if ([Helper testMobileIsTrue:_textPhone.text]){
            [[PostDataRequest sharedInstance] postDataRequest:@"feedBack/saveFeedBack.do" parameter:_dict success:^(id respondsData) {
                _btnSend.userInteractionEnabled = YES;
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([[userData objectForKey:@"success"] boolValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[userData objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            } failed:^(NSError *error) {
                ////NSLog(@"%@",error);
                _btnSend.userInteractionEnabled = YES;
            }];
        }
        else
        {
            UIAlertView *mobileAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [mobileAlertView show];
            _btnSend.userInteractionEnabled = YES;
        }

    }
    else
    {
        UIAlertView *mobileAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有填写问题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [mobileAlertView show];
        _btnSend.userInteractionEnabled = YES;
    }
    
}

#pragma mark --键盘响应事件
//键盘响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    
    [textField resignFirstResponder];
    [_textPhone resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [_textPhone resignFirstResponder];
    return YES;
    
}







@end
