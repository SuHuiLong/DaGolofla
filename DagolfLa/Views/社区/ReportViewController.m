//
//  ReportViewController.m
//  DagolfLa
//
//  Created by 豆凯强 on 16/3/3.
//  Copyright © 2016年 bhxx. All rights reserved.
//


#define kRegist_URL @"shileAndRep/repeaboutball.do"

#import "ReportViewController.h"

@interface ReportViewController ()<UITextViewDelegate>
{
    
    //绑定
    UIButton* _btnBind;
    
    NSMutableDictionary *_dict;
    // 判断用户点击的是哪一个输入框
    NSInteger _isShowAlertView;
    
    MBProgressHUD* _progressHud;
    
    UILabel *_placeholder_label;
    UITextView * _textView;
    
    
}
@end

@implementation ReportViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dict = [[NSMutableDictionary alloc]init];
    [self createView];
    
    [self createBtnBind];
}

-(void)createView{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.cornerRadius = 5.0;
    _textView.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [self.view addSubview:_textView];
    
    _placeholder_label = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, 300, 30)];
    _placeholder_label.text = @"请输入举报理由";
    _placeholder_label.font =  [UIFont boldSystemFontOfSize:13];
    _placeholder_label.textColor = [UIColor lightGrayColor];
    _placeholder_label.layer.cornerRadius = 10;
    _placeholder_label.layer.masksToBounds = YES;
    [self.view addSubview:_placeholder_label];
    
}

-(void)createBtnBind{
    _btnBind = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBind.backgroundColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.30f alpha:1.00f];
    _btnBind.frame = CGRectMake(10*ScreenWidth/375, 118*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnBind];
    [_btnBind setTitle:@"确定" forState:UIControlStateNormal];
    [_btnBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnBind.layer.masksToBounds = YES;
    _btnBind.layer.cornerRadius = 5*ScreenWidth/375;
    [_btnBind addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  举报Btn
 */
-(void)nextClick
{
    [self.view endEditing:YES];
    
    if ([Helper isBlankString:_textView.text]) {
        UIAlertController *alerT = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入举报理由!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alerT addAction:aler1];
        [self.navigationController presentViewController:alerT animated:YES completion:nil];
    }else{
        
        [[PostDataRequest sharedInstance] postDataRequest:kRegist_URL parameter:@{@"objid":_objId,@"orderUserId":_otherUserId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"message":_textView.text,@"type":_typeNum} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            
            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            
            if ([[dict objectForKey:@"success"] boolValue]) {
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                
                _textView.text = @"";
                
                UIAlertController *alerT = [UIAlertController alertControllerWithTitle:@"提示" message:@"举报成功! 我们会在12小时之内进行审查!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *aler1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alerT addAction:aler1];
                [self.navigationController presentViewController:alerT animated:YES completion:nil];
                
            }else {
                [MBProgressHUD hideHUDForView:self.view  animated:NO];
                
                [Helper alertViewNoHaveCancleWithTitle:@"网络状况不佳,请稍后再试!" withBlock:^(UIAlertController *alertView) {
                    
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view  animated:NO];
            //NSLog(@"%@",error);
        }];
        
        
    }
}



#pragma textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (_textView.text.length != 0) {
        _placeholder_label.text = @"";
        _placeholder_label.hidden = YES;
    }
    else{
        _placeholder_label.text = @"请输入举报理由";
        _placeholder_label.hidden = NO;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    _placeholder_label.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        if (_textView.text.length == 0)
        {
            //NSLog(@"ssssss");
            _placeholder_label.text = @"请输入举报理由";
            _placeholder_label.hidden = NO;
        }
        return NO;
    }
    return YES;
}

//键盘响应事件
- (BOOL)textFieldShouldReturn:(UITextView *)textView{
    
    if (textView == _textView){
        [_textView resignFirstResponder];
    }else{
        [_textView resignFirstResponder];
        
    }
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextView *)textView {
    if (textView == _textView) {
        [_dict setValue:textView.text forKey:@"mobile"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
