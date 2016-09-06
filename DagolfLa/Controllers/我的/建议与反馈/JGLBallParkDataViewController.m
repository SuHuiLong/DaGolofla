//
//  JGLBallParkDataViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLBallParkDataViewController.h"
#import "UITool.h"

#define TextViewDetail @"请描述一下您发现的问题"
@interface JGLBallParkDataViewController ()<UITextViewDelegate>
{
    UIScrollView* _scrollView;
    UITextView* _textView;
    NSString* _str;
}
@end

@implementation JGLBallParkDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"球场纠错内容";
    self.view.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _scrollView.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    [self.view addSubview:_scrollView];
    
    
    [self createBallParkChoose];
    
    [self createQuestion];
    
    [self createPhoto];
    
    [self createPhoneNum];
    
    [self createBtn];
    
}

-(void)createBallParkChoose
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, screenWidth, 58*ProportionAdapter);
    [_scrollView addSubview:btn];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 13*ProportionAdapter, screenWidth - 50*ProportionAdapter, 30*ProportionAdapter)];
    label.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @" 选择纠错球场";
    if ([label.text isEqualToString:@" 选择纠错球场"] == YES) {
        label.textColor = [UIColor lightGrayColor];
    }
    else{
        label.textColor = [UIColor blackColor];
    }
    
    [btn addSubview:label];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(screenWidth - 40*ProportionAdapter, 13*ProportionAdapter, 30*ProportionAdapter, 30*ProportionAdapter)];
    view.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    [btn addSubview:view];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@"y_jiantou"];
    [view addSubview:imgv];
    
    UIView* viewLine = [[ UIView alloc]initWithFrame:CGRectMake(0, 57*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [btn addSubview:viewLine];
    
}

-(void)createQuestion
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 58*ProportionAdapter, screenWidth, 107.5*ProportionAdapter)];
    [_scrollView addSubview:view];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 17.5*ProportionAdapter, screenWidth - 20*ProportionAdapter, 75*ProportionAdapter)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.text = TextViewDetail;
    if ([_textView.text isEqualToString:TextViewDetail] == YES) {
        _textView.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    }
    else{
        _textView.textColor = [UIColor blackColor];
    }
    _textView.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [view addSubview:_textView];
    
    UIView* viewLine = [[ UIView alloc]initWithFrame:CGRectMake(0, 107.5*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [view addSubview:viewLine];
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([Helper isBlankString:textView.text]) {
        textView.text = TextViewDetail;
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

-(void)createPhoto
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 165.5*ProportionAdapter, screenWidth, 102*ProportionAdapter)];
    [_scrollView addSubview:view];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10*ProportionAdapter, 20*ProportionAdapter, 63*ProportionAdapter, 63*ProportionAdapter);
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [view addSubview:btn];
}

-(void)createPhoneNum
{
    
}

-(void)createBtn
{
    
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
