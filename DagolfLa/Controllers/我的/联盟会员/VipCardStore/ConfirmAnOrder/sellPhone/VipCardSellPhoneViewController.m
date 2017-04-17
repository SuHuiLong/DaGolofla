//
//  VipCardSellPhoneViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardSellPhoneViewController.h"
#import "ShlTextView.h"
@interface VipCardSellPhoneViewController ()<UITextViewDelegate>

@property(nonatomic, strong)ShlTextView *textView;
@end

@implementation VipCardSellPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
}
//导航栏
-(void)createNavigationView{
    self.title = @"确认订单";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;

}
//输入框
-(void)createTextField{
    //白色背景
    UIView *backGrondView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(103))];
    
    [self.view addSubview:backGrondView];
    //默认提示
    NSString *placeStr = @"请输入标题";

    UILabel *placeLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(0), kWvertical(20), kHvertical(16)) textColor:RGB(160,160,160) fontSize:kHorizontal(16) Title:placeStr];
    
    _textView = [[ShlTextView alloc] initWithFrame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(60)) placeLabel:placeLabel];
    _textView.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _textView.delegate = self;
    _textView.text = _DefaultText;
    [backGrondView addSubview:_textView];
    
}

#pragma mark - Action
//保存
-(void)rightBtnClick{
    if (_addPhoneBlock!=nil) {
        NSString *textStr = _textView.text;
        if (textStr.length>0) {
            self.addPhoneBlock(textStr);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UItextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSString *str = textView.text;
    [_textView textViewDidChange:str];
}

-(void)setAddPhoneBlock:(addPhoneBlock)addPhoneBlock{
    _addPhoneBlock = addPhoneBlock;
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
