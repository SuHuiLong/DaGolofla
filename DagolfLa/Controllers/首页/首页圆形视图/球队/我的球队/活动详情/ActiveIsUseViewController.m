//
//  ActiveIsUseViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ActiveIsUseViewController.h"
#import "Helper.h"
@interface ActiveIsUseViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    
    UITableView* _tableView;
    NSArray* _arrayTitle;
    
    UITextView* _textView;
    NSString* _str;
    
    
}

@end

@implementation ActiveIsUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布活动";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, 34*9*ScreenWidth/375+180*ScreenWidth/375 + 104*ScreenWidth/375);
    
    _arrayTitle = [[NSArray alloc]init];
    _arrayTitle = @[@"标题",@"球场",@"打球人数",@"人均价格",@"联系人",@"联系人电话",@"活动开始日期",@"活动开始时间",@"活动结束日期"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 9*34*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    [_scrollView addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    
    [self createXinxi];
    [self createDetail];
    [self createBrnFabu];
}

-(void)createXinxi
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
    label.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    label.text = @"  基本信息";
    label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_scrollView addSubview:label];
}
-(void)createDetail
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 9*34*ScreenWidth/375+30*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    label.text = @"  活动内容";
    label.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_scrollView addSubview:label];
    
    
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 9*34*ScreenWidth/375+30*ScreenWidth/375+30*ScreenWidth/375, ScreenWidth, 130*ScreenWidth/375)];
    viewBase.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [_scrollView addSubview:viewBase];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, ScreenWidth-10*ScreenWidth/375, 120*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.text = @"输入赛事相关介绍...";
    _textView.returnKeyType = UIReturnKeyDone;
    [viewBase addSubview:_textView];
    
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
        textView.text = @"输入赛事相关介绍...";
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


-(void)createBrnFabu
{
    
    UIButton* btnFabu = [UIButton buttonWithType:UIButtonTypeSystem];
    if (ScreenHeight < 568) {
        btnFabu.frame = CGRectMake(10*ScreenWidth/375, 9*34*ScreenWidth/375+30*ScreenWidth/375+180*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    }
    else
    {
        btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-54*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    }
    
    btnFabu.backgroundColor = [UIColor orangeColor];
    [btnFabu setTitle:@"发布" forState:UIControlStateNormal];
    [btnFabu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:btnFabu];
    btnFabu.layer.masksToBounds = YES;
    btnFabu.layer.cornerRadius = 10*ScreenWidth/375;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = _arrayTitle[indexPath.row];
    return cell;
}
@end
