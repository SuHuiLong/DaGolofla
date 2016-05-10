//
//  AppraiseViewController.m
//  DagolfLa
//
//  Created by bhxx on 15/10/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "AppraiseViewController.h"
#import "IWTextView.h"

#import "ComDetailViewCell.h"

#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "Helper.h"
#import "AppraiseModel.h"

@interface AppraiseViewController ()<UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView* _scrollView;
    
    IWTextView* _textView;
    
    UITableView* _tableView;
    
    
    NSMutableDictionary* _dict;
    NSMutableArray* _dataArray;
    UIButton* _btntijiao;
    
    NSInteger _page;
}
@end

@implementation AppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"评价";
    _page = 1;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _dict = [[NSMutableDictionary alloc]init];
    
    [self createTitle];
    
    [self createDianzan];
    
    [self createtextView];
    
    [self createTableview];
}


-(void)createTitle
{
    UIView* viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 75*ScreenWidth/375)];
    [_scrollView addSubview:viewTitle];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 65*ScreenWidth/375, 30*ScreenWidth/375)];
    labelTitle.text = @"悬赏标题:";
    labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    labelTitle.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    [viewTitle addSubview:labelTitle];
    
    UILabel* labelName = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 10*ScreenWidth/375, ScreenWidth-90*ScreenWidth/375, 30*ScreenWidth/375)];
    labelName.text = @"1231231231231231231";
    labelName.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewTitle addSubview:labelName];
    
    
    UILabel* labelJin = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 40*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    labelJin.text = @"悬赏金额:￥200";
    labelJin.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewTitle addSubview:labelJin];
    
    
    UILabel* labelPeople = [[UILabel alloc]initWithFrame:CGRectMake(120*ScreenWidth/375, 40*ScreenWidth/375, 120*ScreenWidth/375, 30*ScreenWidth/375)];
    labelPeople.text = @"发布人:闻醉山清风";
    labelPeople.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewTitle addSubview:labelPeople];
    
    UILabel* labelTime = [[UILabel alloc]initWithFrame:CGRectMake(250*ScreenWidth/375, 40*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    labelTime.text = @"2013-12-12";
    labelTime.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewTitle addSubview:labelTime];
    
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 74*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    [viewTitle addSubview:viewLine];
}

-(void)createDianzan
{
    UIView* viewZan = [[UIView alloc]initWithFrame:CGRectMake(0, 75*ScreenWidth/375, ScreenWidth, 100*ScreenWidth/375)];
    [_scrollView addSubview:viewZan];
    viewZan.userInteractionEnabled = YES;
    
    UIButton* buttonGood = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonGood.frame = CGRectMake(10*ScreenWidth/375, 0, (ScreenWidth-20*ScreenWidth/375)/3, 100*ScreenWidth/375);
    [buttonGood setImage:[UIImage imageNamed:@"01"] forState:UIControlStateNormal];
    [buttonGood setTitle:@"满意(+1)" forState:UIControlStateNormal];
    [viewZan addSubview:buttonGood];
    buttonGood.titleEdgeInsets = UIEdgeInsetsMake(30*ScreenWidth/375, -30*ScreenWidth/375, -20*ScreenWidth/375, 0);
    buttonGood.imageEdgeInsets = UIEdgeInsetsMake(-30*ScreenWidth/375, 45*ScreenWidth/375, 0, 30*ScreenWidth/375);
    [buttonGood setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonGood.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [buttonGood addTarget:self action:@selector(pingjiaClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonGood.tag = 100;
    
    UIButton* btnNormal = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNormal.frame = CGRectMake(10*ScreenWidth/375+(ScreenWidth-20*ScreenWidth/375)/3, 0, (ScreenWidth-20*ScreenWidth/375)/3, 100*ScreenWidth/375);
    [btnNormal setImage:[UIImage imageNamed:@"02"] forState:UIControlStateNormal];
    [btnNormal setTitle:@"一般( 0 )" forState:UIControlStateNormal];
    [viewZan addSubview:btnNormal];
    btnNormal.titleEdgeInsets = UIEdgeInsetsMake(30*ScreenWidth/375, -30*ScreenWidth/375, -20*ScreenWidth/375, 0);
    btnNormal.imageEdgeInsets = UIEdgeInsetsMake(-30*ScreenWidth/375, 45*ScreenWidth/375, 0, 30*ScreenWidth/375);
    [btnNormal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnNormal.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [btnNormal addTarget:self action:@selector(pingjiaClick:) forControlEvents:UIControlEventTouchUpInside];
    btnNormal.tag = 102;
    
    UIButton* btnBad = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBad.frame = CGRectMake(10*ScreenWidth/375+(ScreenWidth-20*ScreenWidth/375)/3*2, 0, (ScreenWidth-20*ScreenWidth/375)/3, 100*ScreenWidth/375);
    [btnBad setImage:[UIImage imageNamed:@"03"] forState:UIControlStateNormal];
    [btnBad setTitle:@"不满意(+1)" forState:UIControlStateNormal];
    btnBad.titleEdgeInsets = UIEdgeInsetsMake(30*ScreenWidth/375, -30*ScreenWidth/375, -20*ScreenWidth/375, 0);
    btnBad.imageEdgeInsets = UIEdgeInsetsMake(-30*ScreenWidth/375, 45*ScreenWidth/375, 0, 30*ScreenWidth/375);
    [viewZan addSubview:btnBad];
    [btnBad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnBad.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [btnBad addTarget:self action:@selector(pingjiaClick:) forControlEvents:UIControlEventTouchUpInside];
    btnBad.tag = 102;
}

-(void)pingjiaClick:(UIButton *)btn
{
    for (UIButton *btnchoose in btn.superview.subviews) {
        
        if ([btnchoose isKindOfClass:[UIButton class]]) {
            [btnchoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        if (btn.tag == 100) {
            [_dict setValue:@1 forKey:@"appraiseState"];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else if (btn.tag == 101)
        {
            [_dict setValue:@0 forKey:@"appraiseState"];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [_dict setValue:@-1 forKey:@"appraiseState"];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }

        
    }

}


-(void)createtextView
{

    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 180*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 100*ScreenWidth/375)];
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;       //设置代理方法的实现类
    _textView.placeholder = @"请输入评价内容";
    [_scrollView addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textView.tag = 100;
    // 1.监听textView文字改变的通知
    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    
    _btntijiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btntijiao setTitle:@"提交" forState:UIControlStateNormal];
    _btntijiao.backgroundColor = [UIColor orangeColor];
    _btntijiao.layer.cornerRadius = 8*ScreenWidth/375;
    _btntijiao.layer.masksToBounds = YES;
    _btntijiao.frame = CGRectMake(10*ScreenWidth/375, 290*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [_btntijiao addTarget:self action:@selector(tijiaoClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btntijiao];
    
}

-(void)tijiaoClick
{
    [_dict setValue:_textView.text forKey:@"content"];
    
    [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    
    [_dict setValue:@2 forKey:@"aboutBallReId"];
    
    if (![Helper isBlankString:_textView.text]) {
        if ([_dict objectForKey:@"appraiseState"] != nil) {
            [[PostDataRequest sharedInstance] postDataRequest:@"aboutBallRewardAppraise/save.do" parameter:_dict success:^(id respondsData) {
                
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                //////NSLog(@"%@",userData);
                if ([[userData objectForKey:@"success"] boolValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [_btntijiao setTitle:@"已评价" forState:UIControlStateNormal];
                    _btntijiao.backgroundColor = [UIColor lightGrayColor];
                    _btntijiao.userInteractionEnabled = NO;
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            } failed:^(NSError *error) {
                ////NSLog(@"%@",error);
            }];

        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请评分" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入评价内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
}

#pragma mark --键盘响应事件
//键盘响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    
    [textField resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)createTableview
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 334*ScreenWidth/375, ScreenWidth, 80*ScreenWidth/375*_dataArray.count) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ComDetailViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ComDetailViewCell"];

    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:@"aboutBallRewardAppraise/queryPage.do" parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                AppraiseModel *model = [[AppraiseModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
                ////NSLog(@"%@",dataDict);
            }
            _page++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}

    
    
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComDetailViewCell" forIndexPath:indexPath];
    [cell showAppData:_dataArray[indexPath.row]];
    return cell;
}

@end
