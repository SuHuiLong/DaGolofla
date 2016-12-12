//
//  ScoreSimpleViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreSimpleViewController.h"

#import "Setbutton.h"
#import "ScoreFootViewController.h"
#import "ScoreSimpleTableViewCell.h"
#import "CustomIOSAlertView.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "ScorePeopleModel.h"

#import "MBProgressHUD.h"
@interface ScoreSimpleViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomIOSAlertViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray1, *_dataArray2, *_dataArray3;
    
    NSMutableArray* _arrayDetail;
    
    BOOL _isaddImgv2;
    BOOL _isaddImgv3;
    BOOL _isaddImgv4;
    BOOL _isSelected;
    
    UIView* _viewBaseName;
    UIButton* _buttonImg2, *_buttonImg3, *_buttonImg4;
    NSInteger _btnIndex;
    
    //提交到简单积分卡的数据
    NSMutableDictionary* _dict;
    
    UITextField* _textPhone;
    UITextField* _textTui;
    NSString* strText;
    
    UILabel* _labelDetail;
    UILabel* _labelDetail1;
    UILabel* _labelDetail2;
    
    NSMutableArray* _arrayMobile;
    NSMutableArray* _arratNum;
    
    UIButton* _btnBase;
    NSString* _strScoreBg;
    
    UILabel* _labelSc;
    MBProgressHUD* _progressView;
    
    NSMutableArray* _arrayUserId;
    
    NSString* _strScoreSelf;
    
    NSString* _strSecMobile;//用来保存第二个用户的手机号
    NSString* _strThiMobile;//用来保存第三个用户的手机号
    NSString* _strFourMobile;//用来保存第四个用户的手机号
    //权限
    int isQx;
}
@end

@implementation ScoreSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    self.title = @"简单记分";
    //获取系统时间
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:[NSDate date]];
    ////NSLog(@"locationString:%@",locationString);
    _strDate = locationString;
    _arrayDetail = [[NSMutableArray alloc]init];
    
  
    ////NSLog(@"%@,%@",_objId,_strType);
    if ([_strType integerValue]== 11 || [_strType integerValue]== 12) {
        isQx = 0;
    }
    else{
        isQx = 1;
    }
    
    if (![Helper isBlankString:_strTitle]) {
        [_arrayDetail addObject:_strTitle];
    }else
    {
        [_arrayDetail addObject:@""];
    }
    if (![Helper isBlankString:_strBallName]) {
        [_arrayDetail addObject:_strBallName];
    }else
    {
        [_arrayDetail addObject:@""];
    }
    if (![Helper isBlankString:_strDate]) {
        [_arrayDetail addObject:_strDate];
    }else
    {
        [_arrayDetail addObject:@""];
    }
    if (![Helper isBlankString:_strTee]) {
        [_arrayDetail addObject:_strTee];
    }else
    {
        [_arrayDetail addObject:@""];
    }
    _arrayMobile = [[NSMutableArray alloc]init];
    [_arrayMobile addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]];
    _dict = [[NSMutableDictionary alloc]init];
    _dataArray1 = [[NSMutableArray alloc]init];
    _dataArray2 = [[NSMutableArray alloc]init];
    _dataArray3 = [[NSMutableArray alloc]init];
    
    _arratNum = [[NSMutableArray alloc]init];
    _arrayUserId = [[NSMutableArray alloc]init];
    
    [self uiConfig];
    //添加头像，标题
    [self createViewTitle];
    //最下面记分
    [self createViewScore];
    [self createFinish];
    
    [self progress];
    
    NSMutableDictionary* dictBg = [[NSMutableDictionary alloc]init];
    [dictBg setObject:_strSite0 forKey:@"scoreSite0"];
    [dictBg setObject:_strSite1 forKey:@"scoreSite1"];
    [dictBg setObject:_ballId forKey:@"ballId"];
    [[PostDataRequest sharedInstance]postDataRequest:@"score/getBg.do" parameter:dictBg success:^(id respondsData) {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        ////NSLog(@"11222 --- %@",dict);
        
        _strScoreBg = [dict objectForKey:@"total"];
        ////NSLog(@"%@",_strScoreBg);
        _labelSc.text = [NSString stringWithFormat:@"%@",_strScoreBg];
        _labelSc.textColor = [UIColor redColor];
//        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
    }];
    
    
    
    _btnBase = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBase.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _btnBase.hidden = YES;
    [self.view addSubview:_btnBase];
    [_btnBase addTarget:self action:@selector(textClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)progress
{
    _progressView = [[MBProgressHUD alloc] initWithView:self.view];
    _progressView.mode = MBProgressHUDModeIndeterminate;
    _progressView.labelText = @"正在刷新...";
    [self.view addSubview:_progressView];
    [_progressView show:YES];
}

-(void)textClick
{
    _btnBase.hidden = YES;
    [self.view endEditing:YES];
//    [_arratNum addObject:strText];
    
}
-(void)createViewScore
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 4*44*ScreenWidth/375+ 52*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    [self.view addSubview:viewBase];
    viewBase.backgroundColor = [UIColor whiteColor];
    UILabel* labelScore = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 5*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
    labelScore.text = @"18";
    labelScore.textAlignment = NSTextAlignmentCenter;
    labelScore.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewBase addSubview:labelScore];
//    +61*ScreenWidth/375
    
    _labelSc = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375+61*ScreenWidth/375, 5*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
    _labelSc.text = @"72";
    _labelSc.textAlignment = NSTextAlignmentCenter;
    _labelSc.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewBase addSubview:_labelSc];
    
    //输入框
    for (int i = 2; i < 6; i++) {
        _textTui = [[UITextField alloc]initWithFrame:CGRectMake(10*ScreenWidth/375+61*ScreenWidth/375*i, 5*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
        _textTui.delegate = self;
        _textTui.tag = 2000+i;
        _textTui.placeholder = @"请输入总杆数";
        _textTui.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _textTui.textAlignment = NSTextAlignmentCenter;
        _textTui.keyboardType = UIKeyboardTypeNumberPad;
        if (i > 2) {
            _textTui.userInteractionEnabled = NO;
        }
       
        [viewBase addSubview:_textTui];
        
        
    }
    
    
    UILabel* labelPs = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 4*44*ScreenWidth/375+82*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    labelPs.textAlignment = NSTextAlignmentLeft;
    labelPs.text = @"注释：简单记分的成绩将不被加入到记分统计";
    [self.view addSubview:labelPs];
    labelPs.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
}


#pragma mark --textfield代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    strText = textField.text;
    //
    if (textField.tag >= 2002 && textField.tag <= 2005) {
        if (![Helper isBlankString:textField.text]) {
            [_arratNum addObject:textField.text];
        }
        if (textField.tag == 2002) {
            _strScoreSelf = textField.text;
        }
    }
    
}
//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    _btnBase.hidden = YES;
    [self.view endEditing:YES];
    
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _btnBase.hidden = YES;
    UITextField * textField=(UITextField*)[self.view viewWithTag:101];
    
    [textField resignFirstResponder];
    
    UITextField * textField1=(UITextField*)[self.view viewWithTag:102];
    
    [textField1 resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _btnBase.hidden = NO;
    return YES;
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
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入数字" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil];
            [alert show];
            _btnBase.hidden = YES;
            return NO;
        }
        else
        {
            
        }
    }
    //其他的类型不需要检测，直接写入
    return YES;
}



-(void)createViewTitle
{
    _viewBaseName = [[UIView alloc]initWithFrame:CGRectMake(0, 4*44*ScreenWidth/375, ScreenWidth, 50*ScreenWidth/375)];
    _viewBaseName.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_viewBaseName];

    for (int i = 0; i < 2; i++) {
        NSArray* titleArr = @[@"Hole",@"Par",@"球洞",@"标准杆"];
        UILabel *labeltitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375+61*ScreenWidth/375*i, 5*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
        labeltitle.text = titleArr[i];
        labeltitle.textAlignment = NSTextAlignmentCenter;
        labeltitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewBaseName addSubview:labeltitle];
        
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375+61*ScreenWidth/375*i, 25*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.textAlignment = NSTextAlignmentCenter;
        labelDetail.text = titleArr[i+2];
        labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewBaseName addSubview:labelDetail];
    }
    
    for (int i = 0; i < 4; i++) {
        if (i == 0) {
            UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(140*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375)];
            [_viewBaseName addSubview:imgv];
            imgv.layer.masksToBounds = YES;
            imgv.layer.cornerRadius = imgv.frame.size.height/2;
            if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]]) {
                [imgv sd_setImageWithURL:[Helper imageIconUrl:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
            }else{
                 imgv.image = [UIImage imageNamed:DefaultHeaderImage];
            }
            
        }
        else if (i == 1)
        {
            _buttonImg2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_buttonImg2 setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
            [_buttonImg2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 8*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_viewBaseName addSubview:_buttonImg2];
            [_buttonImg2 addTarget:self action:@selector(btnImgvClick2:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImg2.tag = 1002;
            _buttonImg2.layer.masksToBounds = YES;
            _buttonImg2.layer.cornerRadius = _buttonImg2.frame.size.height/2;
        }
        else if (i == 2)
        {
            _buttonImg3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_buttonImg3 setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
            _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 8*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_buttonImg3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_viewBaseName addSubview:_buttonImg3];
            [_buttonImg3 addTarget:self action:@selector(btnImgvClick3:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImg3.tag = 1003;
            _buttonImg3.layer.masksToBounds = YES;
            _buttonImg3.layer.cornerRadius = _buttonImg3.frame.size.height/2;
        }
        else
        {
            _buttonImg4 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_buttonImg4 setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
            _buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 8*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_buttonImg4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_viewBaseName addSubview:_buttonImg4];
            [_buttonImg4 addTarget:self action:@selector(btnImgvClick4:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImg4.tag = 1004;
            _buttonImg4.layer.masksToBounds = YES;
            _buttonImg4.layer.cornerRadius = _buttonImg4.frame.size.height/2;
        }
        
    }

    UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
    labelDetail.textAlignment = NSTextAlignmentCenter;
    
    
    labelDetail.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    
    labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_viewBaseName addSubview:labelDetail];
    
}
/**
 *  头像按钮点击事件
 *
 *  @param btn
 */
-(void)btnImgvClick2:(UIButton *)btn
{

    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    //[alertView setDelegate:self];
    alertView.delegate = self;
    [alertView setContainerView:[self createAddPeopleView]];
    
    _btnIndex = btn.tag-1000;
//    _isaddImgv2 = YES;
    [alertView show];

}
-(void)btnImgvClick3:(UIButton *)btn
{
    _btnIndex = btn.tag-1000;
//    btn.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    //[alertView setDelegate:self];
    alertView.delegate = self;
    [alertView setContainerView:[self createAddPeopleView]];
    if (_isaddImgv2 == NO) {
        _btnIndex = 2;
    }
    else
    {
        _btnIndex = btn.tag-1000;
    }
    
    _isaddImgv3 = YES;
    [alertView show];
    
}
-(void)btnImgvClick4:(UIButton *)btn
{
    _btnIndex = btn.tag-1000;
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    //[alertView setDelegate:self];
    alertView.delegate = self;
    [alertView setContainerView:[self createAddPeopleView]];
    if (_isaddImgv2 == NO) {
        _btnIndex = 2;
    }
    else if (_isaddImgv3 == NO)
    {
        _btnIndex = 3;
    }
    else
    {
        _btnIndex = btn.tag-1000;
    }
    
    [alertView show];
//    btn.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
}


#pragma mark --弹窗
- (UIView *)createAddPeopleView
{
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300*ScreenWidth/375, 100*ScreenWidth/375)];
    //    moneyView.backgroundColor = [UIColor redColor];
    //标题
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, addView.frame.size.width, 30*ScreenWidth/375)];
    labelTitle.text = @"添加打球人";
    labelTitle.textColor = [UIColor purpleColor];
    labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [addView addSubview:labelTitle];
    //划线
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29*ScreenWidth/375, addView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [labelTitle addSubview:lineView];
    
    //提示信息
    UILabel *labelNews = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 50*ScreenWidth/375, 150*ScreenWidth/375, 30*ScreenWidth/375)];
    labelNews.text = @"请输入添加人手机号";
    labelNews.textColor = [UIColor lightGrayColor];
    labelNews.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [addView addSubview:labelNews];
    
    //textfield
    _textPhone = [[UITextField alloc]initWithFrame:CGRectMake(150*ScreenWidth/375, 50*ScreenWidth/375, 130*ScreenWidth/375, 30*ScreenWidth/375)];
    _textPhone.placeholder = @"请输入手机号";
    _textPhone.backgroundColor = [UIColor clearColor];
    _textPhone.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPhone.textAlignment = NSTextAlignmentRight;
    _textPhone.tag = 124;
    _textPhone.textAlignment = NSTextAlignmentCenter;
    _textPhone.delegate = self;
    [addView addSubview:_textPhone];
    _textPhone.borderStyle = UITextBorderStyleLine;
    
    return addView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{

    if (buttonIndex == 1) {
        if (_btnIndex == 2) {
            if ([Helper testMobileIsTrue:_textPhone.text]) {
                if (![_textPhone.text isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]]) {
                    
                    
                    [self progress];
                    [[PostDataRequest sharedInstance] postDataRequest:@"score/getUserMobile.do" parameter:@{@"mobile":_textPhone.text,@"type":_strType,@"objid":_objId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"isQx":[NSNumber numberWithInt:isQx]} success:^(id respondsData) {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        _strSecMobile = _textPhone.text;
                        if ([[dict objectForKey:@"success"] integerValue] == 1) {
                            
                            ScorePeopleModel *model = [[ScorePeopleModel alloc] init];
                            [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                            [_dataArray1 addObject:model];
                            
                            UITextField* text = (UITextField *)[self.view viewWithTag:2003];
                            text.userInteractionEnabled = YES;
                            [_arrayUserId addObject:model.userId];
                            //                        }
                            _isaddImgv2 = YES;
                            //                        [_buttonImg2 setImage:[UIImage imageNamed:@"tx3"] forState:UIControlStateNormal];
                            [_buttonImg2 sd_setImageWithURL:[Helper imageIconUrl:[_dataArray1[0] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                            _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                            _buttonImg2.userInteractionEnabled = NO;
                            _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                            _labelDetail.textAlignment = NSTextAlignmentCenter;
                            _labelDetail.text = [_dataArray1[0] userName];
                            _labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            [_viewBaseName addSubview:_labelDetail];
                            [_arrayMobile addObject:_textPhone.text];
                            
                        }
                        else
                        {
                            [_arrayUserId addObject:@0];
                            _isaddImgv2 = YES;
                            UITextField* text = (UITextField *)[self.view viewWithTag:2003];
                            text.userInteractionEnabled = YES;
                            [_buttonImg2 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
                            _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                            _buttonImg2.userInteractionEnabled = NO;
                            _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                            _labelDetail.textAlignment = NSTextAlignmentCenter;
                            _labelDetail.text = _textPhone.text;
                            _labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            [_viewBaseName addSubview:_labelDetail];
                            [_arrayMobile addObject:_textPhone.text];
                        }
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                }
                else
                {
                    [Helper alertViewWithTitle:@"您已经添加了这个用户" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                }

            }
            else
            {
                [Helper alertViewWithTitle:@"您填写的手机号格式错误" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }
        else if (_btnIndex == 3)
        {
            if ([Helper testMobileIsTrue:_textPhone.text]) {
                if (![_textPhone.text isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]] && ![_textPhone.text isEqualToString:_strSecMobile])
                {
                    [self progress];
                    [[PostDataRequest sharedInstance] postDataRequest:@"score/getUserMobile.do" parameter:@{@"mobile":_textPhone.text,@"type":_strType,@"objid":_objId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"isQx":[NSNumber numberWithInt:isQx]} success:^(id respondsData) {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        _strThiMobile = _textPhone.text;
                        if ([[dict objectForKey:@"success"] integerValue] == 1) {
                            
                            //                        for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                            ScorePeopleModel *model = [[ScorePeopleModel alloc] init];
                            [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                            [_dataArray2 addObject:model];
                            //                        }
                            UITextField* text = (UITextField *)[self.view viewWithTag:2004];
                            text.userInteractionEnabled = YES;
                            [_arrayUserId addObject:model.userId];
                            _isaddImgv3 = YES;
                            [_buttonImg3 sd_setImageWithURL:[Helper imageIconUrl:[_dataArray2[0] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                            _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                            _buttonImg3.userInteractionEnabled = NO;
                            _labelDetail1 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*2, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                            _labelDetail1.textAlignment = NSTextAlignmentCenter;
                            _labelDetail1.text = [_dataArray2[0] userName];
                            _labelDetail1.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            [_viewBaseName addSubview:_labelDetail1];
                            [_arrayMobile addObject:_textPhone.text];
                        }
                        else
                        {
                            _isaddImgv3 = YES;
                            [_arrayUserId addObject:@0];
                            UITextField* text = (UITextField *)[self.view viewWithTag:2004];
                            text.userInteractionEnabled = YES;
                            [_buttonImg3 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
                            _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                            _buttonImg3.userInteractionEnabled = NO;
                            _labelDetail1 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*2, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                            _labelDetail1.textAlignment = NSTextAlignmentCenter;
                            _labelDetail1.text = _textPhone.text;
                            _labelDetail1.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            [_viewBaseName addSubview:_labelDetail1];
                            [_arrayMobile addObject:_textPhone.text];
                        }
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                }
                else
                {
                    [Helper alertViewWithTitle:@"您已经添加了这个用户" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                }

            }
            else
            {
                [Helper alertViewWithTitle:@"您填写的手机号格式错误" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
            
        }
        else
        {
            if ([Helper testMobileIsTrue:_textPhone.text]) {
                if (![_textPhone.text isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]] && ![_textPhone.text isEqualToString:_strSecMobile] && ![_textPhone.text isEqualToString:_strThiMobile])
                {
                    [self progress];
                    [[PostDataRequest sharedInstance] postDataRequest:@"score/getUserMobile.do" parameter:@{@"mobile":_textPhone.text,@"type":_strType,@"objid":_objId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"isQx":[NSNumber numberWithInt:isQx]} success:^(id respondsData) {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if ([[dict objectForKey:@"success"] integerValue] == 1) {
                            
                            //                        for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                            ScorePeopleModel *model = [[ScorePeopleModel alloc] init];
                            [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                            [_dataArray3 addObject:model];
                            //                        }
                            UITextField* text = (UITextField *)[self.view viewWithTag:2005];
                            text.userInteractionEnabled = YES;
                            [_arrayUserId addObject:model.userId];
                            _isaddImgv4 = YES;
                            [_buttonImg4 sd_setImageWithURL:[Helper imageIconUrl:[_dataArray3[0] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                            _buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                            _buttonImg4.userInteractionEnabled = NO;
                            _labelDetail2 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*3, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                            _labelDetail2.textAlignment = NSTextAlignmentCenter;
                            _labelDetail2.text = [_dataArray3[0] userName];
                            _labelDetail2.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            [_viewBaseName addSubview:_labelDetail2];
                            [_arrayMobile addObject:_textPhone.text];
                        }
                        else
                        {
                            _isaddImgv4 = YES;
                            [_arrayUserId addObject:@0];
                            UITextField* text = (UITextField *)[self.view viewWithTag:2005];
                            text.userInteractionEnabled = YES;
                            [_buttonImg4 setImage:[UIImage imageNamed:DefaultHeaderImage] forState:UIControlStateNormal];
                            _buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                            _buttonImg4.userInteractionEnabled = NO;
                            _labelDetail2 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*3, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                            _labelDetail2.textAlignment = NSTextAlignmentCenter;
                            _labelDetail2.text = _textPhone.text;
                            _labelDetail2.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                            [_viewBaseName addSubview:_labelDetail2];
                            [_arrayMobile addObject:_textPhone.text];
                        }
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                }
                else
                {
                    [Helper alertViewWithTitle:@"您已经添加了这个用户" withBlock:^(UIAlertController *alertView) {
                        [self.navigationController presentViewController:alertView animated:YES completion:nil];
                    }];
                }
                
            }
            else
            {
                [Helper alertViewWithTitle:@"您填写的手机号格式错误" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }
        
    }
    else
    {
        
    }
    [alertView close];
}


-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 4*44*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[ScoreSimpleTableViewCell class] forCellReuseIdentifier:@"ScoreSimpleTableViewCell"];
}


-(void)createFinish
{
    UIButton* btnFinish = [UIButton buttonWithType:UIButtonTypeSystem];
    btnFinish.backgroundColor = [UIColor orangeColor];
    btnFinish.frame = CGRectMake(10*ScreenWidth/375, 4*44*ScreenWidth/375 + 120*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btnFinish];
    [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFinish.layer.masksToBounds = YES;
    btnFinish.layer.cornerRadius = 10*ScreenWidth/375;
    [btnFinish addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --跳转到发布页面
-(void)finishClick:(UIButton *)btn
{
    [self progress];
    [self.view endEditing:YES];
    btn.userInteractionEnabled = NO;
    
    
    [_dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"scoreWhoScoreUserId"];
    [_dict setObject:_ballId forKey:@"scoreballId"];
    [_dict setObject:_strBallName forKey:@"scoreballName"];
    [_dict setObject:_strSite0 forKey:@"scoreSite0"];
    [_dict setObject:_strSite1 forKey:@"scoreSite1"];
    [_dict setObject:_strTee forKey:@"scoreTTaiwan"];
    [_dict setObject:@1 forKey:@"scoreIsSimple"];
    [_dict setObject:_strType forKey:@"scoreType"];
    
    NSString *strMobile = [_arrayMobile componentsJoinedByString:@","];
    [_dict setObject:strMobile forKey:@"userMobile"];
    ////NSLog(@"%@",_arratNum);
    NSString *strNum = [_arratNum componentsJoinedByString:@","];
    if (_arratNum.count != 0) {
        
        [_dict setObject:strNum forKey:@"professionalPolenumber"];
    }
    else
    {
        [_dict setObject:@0 forKey:@"professionalPolenumber"];
    }
    
    [_dict setObject:@0 forKey:@"scoreIsClaim"];
    [_dict setObject:_strDate forKey:@"beginDates"];
    
    if (_objId == nil) {
        int x = arc4random() % 1000000;
        [_dict setObject:[NSNumber numberWithInt:x] forKey:@"scoreObjectId"];
    }
    else
    {
        [_dict setObject:_objId forKey:@"scoreObjectId"];
    }
    
    [_dict setObject:_strTitle forKey:@"scoreObjectTitle"];
    

    [_dict setObject:[NSString stringWithFormat:@"%@帮您记录了一次简单记分",[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]] forKey:@"message"];
    
    NSString *strUserId = [_arrayUserId componentsJoinedByString:@","];
    if (_arrayUserId.count != 0) {
        [_dict setObject:strUserId forKey:@"userIds"];
    }
    else{
        [_dict setObject:@0 forKey:@"userIds"];
    }

    [[PostDataRequest sharedInstance] postDataRequest:@"score/simpleSave.do" parameter:_dict success:^(id respondsData) {
        NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        btn.userInteractionEnabled = YES;
//        ////NSLog(@"111222 ===   %@",dictD);
        if ([[dictD objectForKey:@"success"] integerValue] == 1) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            ScoreFootViewController* footVc = [[ScoreFootViewController alloc]init];
            footVc.strTime = _strDate;
            footVc.strNums = _strScoreSelf;
            footVc.strBallName = _strBallName;
            footVc.ballId = _ballId;
            [self.navigationController pushViewController:footVc animated:YES];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"填写的内容标准杆不正确，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [Helper alertViewNoHaveCancleWithTitle:@"填写的标准杆不正确，请重新输入" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        btn.userInteractionEnabled = YES;
        
    }];
    
    
}

#pragma  mark --tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ScoreSimpleTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"ScoreSimpleTableViewCell" forIndexPath:indexPath];
    NSArray* array = [[NSArray alloc]init];
    array = @[@"标题",@"选择球场",@"打球日期",@"Tee台"];
    cellid.labelTitle.text = array[indexPath.row];
    cellid.labelDetail.text = _arrayDetail[indexPath.row];
    cellid.labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellid;
}


@end
