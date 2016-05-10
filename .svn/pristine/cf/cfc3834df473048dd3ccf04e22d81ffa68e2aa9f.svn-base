//
//  TeamIntroCViewController.m
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ActivityIntroViewController.h"

#import "Helper.h"
#import "PostDataRequest.h"

@interface  ActivityIntroViewController()<UITextViewDelegate>
{
    UITextView* _textView;
    NSString* _str;
}
@end

@implementation ActivityIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑球队简介";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    [self createView];
    [self createBtn];
}

-(void)createView
{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, ScreenWidth-10*ScreenWidth/375, 120*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.text = @"输入赛事相关介绍...";
    _textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textView];
    
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    btn.frame = CGRectMake(10*ScreenWidth/375, 130*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)finishClick
{
    _introBlock(_textView.text);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //判断为空
    if ([Helper isBlankString:_str]) {
        textView.text = nil;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([Helper isBlankString:textView.text]) {
        textView.text = @"输入活动相关介绍...";
        _str = nil;
    }else {
        _str = textView.text;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
    }
    return YES;
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
