//
//  ManageExamDetController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageExamDetController.h"
#import "Setbutton.h"
#import "Helper.h"
@interface ManageExamDetController ()<UIScrollViewDelegate,UITextViewDelegate>
{
    UIView* _viewMore;
    BOOL _showView;
    UIScrollView* _scrollView;
    
    BOOL _isClick;
    
    UITextView* _textView;
    NSString *_str;
    
}
@end

@implementation ManageExamDetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _str = [[NSString alloc]init];
    
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.title = @"赛事详情";
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    if (ScreenHeight <= 568) {
        _scrollView.contentSize = CGSizeMake(0, 568-49*ScreenWidth/375-20+44*ScreenWidth/375);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(0, ScreenHeight-49*ScreenWidth/375-15+44*ScreenWidth/375);
    }
    _scrollView.bounces = NO;
    //基本信息
    [self createBasicInformation];
    //悬赏要求
    [self createRewardRequest];
    //发布人
    [self createReleasePeople];
    //已成功应赏人数
    [self createRewardNumber];
    //导航栏点击按钮
    [self createBtnView];
    
    [self createClickBtn];
    
}

-(void)ShowViewClick{
    if (_showView == NO) {
        _viewMore.hidden = NO;
        _showView = YES;
    }
    else
    {
        _showView = NO;
        _viewMore.hidden = YES;
    }
}

-(void)createBtnView
{
    
    
    _viewMore = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-150*ScreenWidth/375, 10, 120*ScreenWidth/375, 150)];
    _viewMore.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_viewMore];
    _viewMore.hidden = YES;
    //    NSArray* titleArr = @[@"首页",@"消息",@"我的悬赏"];
    for (int i = 0; i < 2; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10, i*50*ScreenWidth/375, 100*ScreenWidth/375, 50*ScreenWidth/375);
        //        btn.titleLabel.text = [NSString stringWithFormat:@"%d",i];
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [_viewMore addSubview:btn];
        btn.tag = 150 + i;
        [btn addTarget:self action:@selector(myYueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//跳转我的悬赏界面
-(void)myYueClick:(UIButton*)btn
{
    if (btn.tag == 152) {
//        YueMyBallViewController* yueVc = [[YueMyBallViewController alloc]init];
//        [self.navigationController pushViewController:yueVc animated:YES];
    }
}

-(void)createBasicInformation
{
    
    UIView* viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    viewTitle.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewTitle];
    
    UILabel* labelTit = [[UILabel alloc]initWithFrame:CGRectMake(70*ScreenWidth/375, 12*ScreenWidth/375, 200*ScreenWidth/375, 20*ScreenWidth/375)];
    labelTit.text = @"赛事名称:宝马杯高尔夫球赛";
    labelTit.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewTitle addSubview:labelTit];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  基本信息";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    NSArray* titleArray = @[@"比赛日期：",@"结束日期：",@"比赛时间：",@"比赛城市：",@"球场：",@"赛事类型："];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 84*ScreenWidth/375 + i * 25*ScreenWidth/375, 75*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelDetail.text = titleArray[i];
        labelDetail.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:labelDetail];
    }
    
    NSArray* detailArray = @[@"2015-04-21 星期六",@"2015-04-25 星期三",@"10:00",@"上海市",@"上海市佘山高尔夫球场",@"公开"];
    for (int i = 0; i < detailArray.count; i++) {
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 84*ScreenWidth/375 + i * 25*ScreenWidth/375, ScreenWidth - 110*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        labelDetail.text = detailArray[i];
        labelDetail.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:labelDetail];
    }
    
    
}
-(void)createRewardRequest
{
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 234*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  赛事简介";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 264*ScreenWidth/375, ScreenWidth, 120*ScreenWidth/375)];
    viewBase.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:viewBase];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 0, ScreenWidth-10*ScreenWidth/375, 120*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.text = @"输入赛事简介...";
    _textView.returnKeyType = UIReturnKeyDone;
    [viewBase addSubview:_textView];
    
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
        textView.text = @"输入赛事简介...";
        _str = nil;
    }else {
        _str = textView.text;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
    }
    return NO;
}
-(void)createReleasePeople
{
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 384*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  发起人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    
    
    Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
    item.frame = CGRectMake(10*ScreenWidth/375, 414*ScreenWidth/375, 60*ScreenWidth/375, 60*ScreenWidth/375);
    [_scrollView addSubview:item];
    item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [item setTitle:@"清风" forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:@"moren.jpg"] forState:UIControlStateNormal];
    item.tag = 100;
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item addTarget:self action:@selector(selfDetailClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)createRewardNumber
{
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 474*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    infoLabel.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:infoLabel];
    infoLabel.text = @"  参与人数：4人";
    infoLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    NSArray* titleArr = @[@"黎明",@"张三",@"李四",@"王二麻子",@"赵六"];
    for (int i = 0; i<titleArr.count; i++) {
        Setbutton *item = [Setbutton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(10*ScreenWidth/375 + 60*ScreenWidth/375*i, 504*ScreenWidth/375, 60*ScreenWidth/375, 60*ScreenWidth/375);
        [_scrollView addSubview:item];
        [item setTitle:titleArr[i] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:@"moren.jpg"] forState:UIControlStateNormal];
        item.tag = 101 + i;
        item.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [item addTarget:self action:@selector(selfDetailClick) forControlEvents:UIControlEventTouchUpInside];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}
//点击跳转到个人中心
-(void)selfDetailClick
{
    //    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    //    [self.navigationController pushViewController:selfVc animated:YES];
}

//屏幕最下方点击事件
-(void)createClickBtn
{
    UIView* viewBasic = [[UIView alloc]initWithFrame:CGRectMake(0, 569*ScreenWidth/375, ScreenWidth, ScreenHeight-64-540*ScreenWidth/375)];
    if (ScreenHeight == 480) {
        viewBasic.frame = CGRectMake(0, 569*ScreenWidth/375, ScreenWidth, 553-64-540*ScreenWidth/375);
    }
    //    viewBasic.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
//    viewBasic.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:viewBasic];
    //同意
    UIButton* agreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    agreeBtn.frame = CGRectMake(0, viewBasic.frame.size.height-49*ScreenWidth/375, ScreenWidth/2-0.5, 49*ScreenWidth/375);
    [viewBasic addSubview:agreeBtn];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.tag = 1000;
    agreeBtn.backgroundColor = [UIColor orangeColor];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [agreeBtn addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    btnChat.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    btnChat.layer.borderWidth = 1.0;
    
    //拒绝
    UIButton* defuseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    defuseBtn.frame = CGRectMake(ScreenWidth/2+0.5, viewBasic.frame.size.height-49*ScreenWidth/375, ScreenWidth/2-0.5, 49*ScreenWidth/375);
    [viewBasic addSubview:defuseBtn];
    [defuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    defuseBtn.tag = 1001;
    defuseBtn.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [defuseBtn addTarget:self action:@selector(refuseClick) forControlEvents:UIControlEventTouchUpInside];
    defuseBtn.backgroundColor = [UIColor orangeColor];
    [defuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ScreenHeight == 480) {
        agreeBtn.frame = CGRectMake(0, -49*ScreenWidth/375, ScreenWidth/2-0.5, 49*ScreenWidth/375);
        defuseBtn.frame = CGRectMake(ScreenWidth/2+0.5, -49*ScreenWidth/375, ScreenWidth/2-0.5, 49*ScreenWidth/375);
    }
}

-(void)clickAction:(UIButton*)btn
{
    
}
-(void)agreeClick
{
    
}
-(void)refuseClick
{
    
}







@end
