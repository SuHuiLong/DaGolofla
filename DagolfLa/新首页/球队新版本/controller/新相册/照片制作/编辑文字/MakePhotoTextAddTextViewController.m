
//
//  MakePhotoTextAddTextViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MakePhotoTextAddTextViewController.h"
#import "ShlTextView.h"
@interface MakePhotoTextAddTextViewController ()<UITextViewDelegate>{
    //可输入文字个数
    NSInteger _canEnterNum;
}
//输入框
@property(nonatomic, copy)ShlTextView *textView;
//剩余可输入文字个数
@property(nonatomic, copy)UILabel *canEnterLabel;
//是否需要限制字数
@property(nonatomic, assign)BOOL needLimit;
@end

@implementation MakePhotoTextAddTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - CreateView
-(void)createView{
    self.view.backgroundColor = Back_Color;
    [self createNavagationView];
    [self createTextView];
}
//创建上导航
-(void)createNavagationView{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnCLick)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
//textView
-(void)createTextView{
    //白色背景
    UIView *backGrondView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(103))];
    
    [self.view addSubview:backGrondView];
    //默认提示
    NSString *placeStr = nil;
    if ([self.title isEqualToString:@"标题"]) {
        placeStr = @"请输入标题";
    }else if ([self.title isEqualToString:@"文字描述"]){
        placeStr = @"请输入需要编辑的文字";
    }
    if (_DefaultText) {
        placeStr = nil;
    }
    UILabel *placeLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(0), kWvertical(20), kHvertical(16)) textColor:RGB(160,160,160) fontSize:kHorizontal(16) Title:placeStr];
    
    _textView = [[ShlTextView alloc] initWithFrame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(60)) placeLabel:placeLabel];
    _textView.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _textView.delegate = self;
    _textView.text = _DefaultText;
    [backGrondView addSubview:_textView];
    
    if (![self.title isEqualToString:@"文字描述"]) {
        _needLimit = true;
        _canEnterLabel = [Factory createLabelWithFrame:CGRectMake(screenWidth-kWvertical(110), _textView.y_height, kWvertical(100), kHvertical(33)) textColor:RGB(160,160,160) fontSize:kHorizontal(16) Title:@"60"];
        _canEnterNum = 60;
        [_canEnterLabel setTextAlignment:NSTextAlignmentRight];
        [backGrondView addSubview:_canEnterLabel];
    }
    
}


#pragma mark - Action
//取消返回
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//确认返回
-(void)rightBtnCLick{
    
    NSString *textStr = _textView.text;
    if (_addText!=nil) {
        NSString *strUrl = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (strUrl.length!=0) {
            _addText(textStr);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self leftBtnClick];
}

-(void)setAddTextBlock:(AddText)AddText{
    
    _addText = AddText;
}

#pragma mark - textViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSString *str = textView.text;
    [_textView textViewDidChange:str];
    
    if (_needLimit) {
        NSInteger len = textView.text.length;
        _canEnterNum = 60 - len;
        if (_canEnterNum <= 0) {
            NSString *str = textView.text;
            textView.text = [str substringToIndex:60];
            _canEnterLabel.text = [NSString stringWithFormat:@"0"];
            
        }else{
            _canEnterLabel.text = [NSString stringWithFormat:@"%ld",(long)_canEnterNum];
        }
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_needLimit) {
        
        //判断加上输入的字符，是否超过界限
        NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
        if (string.length > 60){
            return NO;
        }
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
