//
//  JGLNewFuncTionViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLNewFuncTionViewController.h"
#import "UITool.h"
#import "JGLWriteReplyViewController.h"
@interface JGLNewFuncTionViewController ()<UITextViewDelegate>
{
    UITextView* _textView;
    NSString* _str;//标记textView上显示的字
}
@end

@implementation JGLNewFuncTionViewController
/**
 *  产品新功能建议
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品新功能建议";
    self.view.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    [self createView];
    [self createBtn];
}

-(void)createView
{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 200*ProportionAdapter)];
    [self.view addSubview:view];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 10*ProportionAdapter, screenWidth - 40*ProportionAdapter, 190*ProportionAdapter)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.text = @"请针对我们的产品给出您宝贵的意见";
    if ([_textView.text isEqualToString:@"请针对我们的产品给出您宝贵的意见"] == YES) {
        _textView.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    }
    else{
        _textView.textColor = [UIColor blackColor];
    }
    _textView.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [view addSubview:_textView];
    
}


#pragma mark --textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //    [UIView animateWithDuration:0.2 animations:^{
    //        _scrollView.contentOffset = CGPointMake(0, 300);
    //    }];
    //判断为空
    if ([Helper isBlankString:_str]) {
        textView.text = nil;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([_textView.text isEqualToString:@"请针对我们的产品给出您宝贵的意见"] == YES || [Helper isBlankString:_textView.text]) {
        _textView.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    }
    else{
        _textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([Helper isBlankString:textView.text]) {
        textView.text = @"请针对我们的产品给出您宝贵的意见";
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


-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screenWidth/2 - 50*ProportionAdapter, 280*ProportionAdapter, 100*ProportionAdapter, 44*ProportionAdapter);
    btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    [self.view addSubview:btn];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 22*ProportionAdapter;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)upDataClick:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]]) {
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"userMobile"];
    }
    
    [dict setObject:@2 forKey:@"type"];//意见
    if ([Helper isBlankString:_textView.text] || [_textView.text isEqualToString:@"请针对我们的产品给出您宝贵的意见"] == YES) {
        [[ShowHUD showHUD]showToastWithText:@"请填写您宝贵的意见再进行提交，谢谢！" FromView:self.view];
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        [self.view endEditing:YES];
        return;
    }
    else{
        [dict setObject:_textView.text forKey:@"describe"];
    }
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"feedback/createFeedback" JsonKey:@"feedBack" withData:dict failedBlock:^(id errType) {
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    } completionBlock:^(id data) {
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            JGLWriteReplyViewController* reVc = [[JGLWriteReplyViewController alloc]init];
            [self.navigationController pushViewController:reVc animated:YES];
        }
        else{
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
