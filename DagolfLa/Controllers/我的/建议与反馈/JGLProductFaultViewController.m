//
//  JGLBallParkDataViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/9/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLProductFaultViewController.h"
#import "UITool.h"

#define TextViewDetail @"请描述一下您发现的问题"
@interface JGLProductFaultViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView* _scrollView;
    UITextView* _textView;
    UITextField* _textField;
    NSString* _str;
}
@end

@implementation JGLProductFaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品缺陷反馈";
    self.view.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _scrollView.backgroundColor = [UITool colorWithHexString:@"#eeeeee" alpha:1];
    [self.view addSubview:_scrollView];
    
    
    [self createQuestion];
    
    [self createPhoto];
    
    [self createPhoneNum];
    
    [self createBtn];
    
}

-(void)createQuestion
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 107.5*ProportionAdapter)];
    [_scrollView addSubview:view];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 17.5*ProportionAdapter, screenWidth - 40*ProportionAdapter, 75*ProportionAdapter)];
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
    //165.5+102
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 123.5*ProportionAdapter, screenWidth-40*ProportionAdapter, 102*ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10*ProportionAdapter, 20*ProportionAdapter, 63*ProportionAdapter, 63*ProportionAdapter);
    [btn setBackgroundImage:[UIImage imageNamed:@"addPIC"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(85*ProportionAdapter, 20*ProportionAdapter, screenWidth - 135*ProportionAdapter, 63*ProportionAdapter)];
    label.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    label.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    label.numberOfLines = 2;
    label.text = @"拍照上传图片，便于我们正确解读您发现的问题。（选填）";
    [view addSubview:label];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 240*ProportionAdapter, screenWidth, 1*ProportionAdapter)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"dfdfdf" alpha:1];
    [_scrollView addSubview:viewLine];
}

-(void)createPhoneNum
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 240*ProportionAdapter, screenWidth, 45*ProportionAdapter)];
    [_scrollView addSubview:view];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 15*ProportionAdapter, screenWidth - 40*ProportionAdapter, 30*ProportionAdapter)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.placeholder = @"请留下联系方式";
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    [view addSubview:_textField];
    
}

-(void)createBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(screenWidth/2 - 50*ProportionAdapter, 365*ProportionAdapter, 100*ProportionAdapter, 44*ProportionAdapter);
    btn.backgroundColor = [UITool colorWithHexString:@"32b14d" alpha:1];
    [self.view addSubview:btn];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 22*ProportionAdapter;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:20*ProportionAdapter];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(upDataClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)upDataClick
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
