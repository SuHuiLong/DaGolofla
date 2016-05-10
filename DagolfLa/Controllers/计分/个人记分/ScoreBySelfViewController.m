//
//  ScoreBySelfViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreBySelfViewController.h"

#import "ScoreSimpleViewController.h"
#import "ScoreProfessViewController.h"
#import "BallParkViewController.h"

#import "ScoreBySelfModel.h"

#import "PostDataRequest.h"
#import "Helper.h"

#import "ScoreTableViewCell.h"
#import "ScoreGameModel.h"

#import "MBProgressHUD.h"

#import "CustomIOSAlertView.h"

#define HEADER_BUTTON1_TAG 100
#define HEADER_BUTTON2_TAG 1000
#define HEADER_BUTTON3_TAG 10000
@interface ScoreBySelfViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,CustomIOSAlertViewDelegate>
{
    
    MBProgressHUD* _proressHud;
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    //金额选择器
    CustomIOSAlertView* _alertView;
    
    NSMutableArray* _dataBallArray;
    NSMutableArray* _dataTeeArray;
    NSArray *_titleArray;
    BOOL _isShowFirst;
    BOOL _isShowSecond;
    CGFloat _height1;
    CGFloat _height2;
    
    UIButton* _btnSimp;
    UIButton* _btnProFe;
    
    NSString* _strBall;
    NSInteger _ballId;
    UILabel* _labelBall;
    UILabel* _labelBallName;
    
//    UILabel* _labelAreaDet;
    
    UITextField* _textField;
    UIButton* btnText;
    BOOL _isEdit;
//    UIScrollView* _scrollView;
    
    NSString* _strTee;
    
    //显示在自定义弹窗视图上的按钮
    UIButton* _btnFirst;
    UIButton* _btnSecond;
    UIButton* _btnThird;
//    UIButton*
    
    NSString* _strSite0,* _strSite1;
    
    NSMutableDictionary* _dict;
    
    MBProgressHUD* _progress;
}

@end

@implementation ScoreBySelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.view addSubview:view];
    self.title = @"个人记分";
    
    ////NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"pic"]);
    _dataArray = [[NSMutableArray alloc]init];
    //三个数组 分别放家人 好友 同学
    _dataBallArray = [[NSMutableArray alloc] init];
    _dataTeeArray = [[NSMutableArray alloc] init];
    _globalDictionary = [[NSDictionary alloc] initWithObjects:@[_dataBallArray, _dataBallArray, _dataTeeArray] forKeys:@[@"第一九洞", @"第二九洞", @"Tee台"]];
    [_dataBallArray addObjectsFromArray:@[@[],@[],@[]]];
    
    _dict = [[NSMutableDictionary alloc]init];
    
    _proressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _proressHud.mode = MBProgressHUDModeIndeterminate;
    _proressHud.labelText = @"加载中...";
    [self.view addSubview:_proressHud];
    [_proressHud show:YES];
    
    
    

    [[PostDataRequest sharedInstance] postDataRequest:@"score/getIntheAct.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] integerValue]==1) {
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                
                ScoreGameModel *model = [[ScoreGameModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            //    [self prepareData];
            
            [self uiConfig];
            [self createHead];
            
            [self createBtnScore];
            
            btnText = [UIButton buttonWithType:UIButtonTypeCustom];
            btnText.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            btnText.hidden = YES;
            [self.view addSubview:btnText];
            [btnText addTarget:self action:@selector(keyboardClick) forControlEvents:UIControlEventTouchUpInside];
//            if (_dataArray.count != 0) {
//                //自定义的显示框
//                _alertView = [[CustomIOSAlertView alloc] init];
//                _alertView.backgroundColor = [UIColor whiteColor];
//                [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",nil]];//添加按钮
//                //[alertView setDelegate:self];
//                _alertView.delegate = self;
////                [_alertView setContainerView:[self createMoneyView]];
////                [_alertView show];
//            }
            
            
        }
        else
        {
            [self uiConfig];
            [self createHead];
            
            [self createBtnScore];
            
            btnText = [UIButton buttonWithType:UIButtonTypeCustom];
            btnText.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            btnText.hidden = YES;
            [self.view addSubview:btnText];
            [btnText addTarget:self action:@selector(keyboardClick) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
    } failed:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];

}
-(void)keyboardClick
{
    if (_isEdit == NO) {
        btnText.hidden = YES;
    }
    else
    {
        btnText.hidden = NO;
    }
    [self.view endEditing:YES];
}


#pragma mark --自定义UIalert
//自定义alert视图
- (UIView *)createMoneyView
{
    
//    UICollectionView
    UIView *actView = [[UIView alloc] initWithFrame:CGRectMake(0*ScreenWidth/375, 0, ScreenWidth-40*ScreenWidth/375, 200*ScreenWidth/375)];
//        actView.backgroundColor = [UIColor redColor];
    //标题
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, actView.frame.size.width-20*ScreenWidth/375, 60*ScreenWidth/375)];
    labelTitle.text = @"     XXXX客户,您今天参加了以下内容，请点击确认具体赛事";
    labelTitle.numberOfLines = 0;
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [actView addSubview:labelTitle];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth-56*ScreenWidth/375, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    [actView addSubview:viewLine];
    
    if (_dataArray.count >= 3) {
        _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFirst setTitle:@"宝马杯非职业巡回赛" forState:UIControlStateNormal];
        _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
        _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [actView addSubview:_btnFirst];
//        [_btnFirst addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSecond setTitle:@"上海君高杯联赛" forState:UIControlStateNormal];
        _btnSecond.frame = CGRectMake(0, 100*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
        _btnSecond.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_btnSecond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [actView addSubview:_btnSecond];
//        [_btnSecond addTarget:self action:@selector(secondClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnThird setTitle:@"宝马杯非职业巡回赛" forState:UIControlStateNormal];
        _btnThird.frame = CGRectMake(0, 140*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
        _btnThird.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_btnThird setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [actView addSubview:_btnThird];
//        [_btnThird addTarget:self action:@selector(thirdClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if (_dataArray.count == 2) {
            _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnFirst setTitle:@"宝马杯非职业巡回赛" forState:UIControlStateNormal];
            _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
            _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [actView addSubview:_btnFirst];
//            [_btnFirst addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
            
            _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnSecond setTitle:@"上海君高杯联赛" forState:UIControlStateNormal];
            _btnSecond.frame = CGRectMake(0, 100*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
            _btnSecond.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            [_btnSecond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [actView addSubview:_btnSecond];
            actView.frame = CGRectMake(0*ScreenWidth/375, 0, ScreenWidth-40*ScreenWidth/375, 160*ScreenWidth/375);
//            [_btnSecond addTarget:self action:@selector(secondClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(_dataArray.count == 1)
        {
            actView.frame = CGRectMake(0*ScreenWidth/375, 0, ScreenWidth-40*ScreenWidth/375, 110*ScreenWidth/375);
            if (_dataArray.count == 0) {
                _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
                [_btnFirst setTitle:@"您当前无任何赛事，点击进入个人记分" forState:UIControlStateNormal];
                _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
                _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [actView addSubview:_btnFirst];
//                [_btnFirst addTarget:self action:@selector(selfScoreClick) forControlEvents:UIControlEventTouchUpInside];

            }
            else
            {
                _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
                [_btnFirst setTitle:@"宝马杯非职业巡回赛" forState:UIControlStateNormal];
                _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
                _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [actView addSubview:_btnFirst];
//                [_btnFirst addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        else
        {
            
        }
    }
    
    
    return actView;
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:124];
    [textField resignFirstResponder];
    ////NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if ((int)buttonIndex == 0) {
        
    }
    else
    {
        
    }
    [alertView close];
}



//-(void)prepareData
//{
//    _dataArray = [[NSMutableArray alloc]init];
//}

-(void)createHead
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 88*ScreenWidth/375)];
    _tableView.tableHeaderView = viewBase;
    viewBase.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 60*ScreenWidth/375, 44*ScreenWidth/375)];
    label.text = @"标题";
    label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewBase addSubview:label];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 0, ScreenWidth-90*ScreenWidth/375, 44*ScreenWidth/375)];
    [viewBase addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textField.placeholder = @"请输入打球标题";
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentRight;
    
    UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 43.5*ScreenWidth/375, ScreenWidth-16*ScreenWidth/375, 0.5*ScreenWidth/375)];
    viewLine1.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    [viewBase addSubview:viewLine1];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375);
    [viewBase addSubview:btn];
    [btn addTarget:self action:@selector(btnBallClick) forControlEvents:UIControlEventTouchUpInside];
    
    _labelBall = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 44*ScreenWidth/375, 60*ScreenWidth/375, 44*ScreenWidth/375)];
    _labelBall.text = @"球场名称";
    _labelBall.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewBase addSubview:_labelBall];
    
    
    _labelBallName = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 44*ScreenWidth/375, ScreenWidth-90*ScreenWidth/375, 44*ScreenWidth/375)];
    _labelBallName.text = @"请选择高尔夫球场";
    _labelBallName.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _labelBallName.textAlignment = NSTextAlignmentRight;
//    _labelBallName.textColor = [UIColor lightGrayColor];
    [viewBase addSubview:_labelBallName];
    
    UIView* viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 87.5*ScreenWidth/375, ScreenWidth-16*ScreenWidth/375, 0.5*ScreenWidth/375)];
    viewLine2.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    [viewBase addSubview:viewLine2];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    btnText.hidden = NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
//选择球场的点击事件
-(void)btnBallClick
{
    
        //球场
        BallParkViewController* ballVc = [[BallParkViewController alloc]init];
        ballVc.type1=1;
        ballVc.callback1=^(NSDictionary *dict){
            ////NSLog(@"%@",dict);
            [_dataBallArray removeAllObjects];
            if (dict.count != 0) {
                [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[dict objectForKey:@"tAll"]];
            }
            [_tableView reloadData];
        };
        [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
            _labelBallName.text = balltitle;
            _strBall = balltitle;
            _ballId = ballid;
        }];
        [self.navigationController pushViewController:ballVc animated:YES];
}
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44*2*ScreenWidth/375-30*ScreenWidth/375-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
//    _tableView.bounces = NO;
//    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:@"ScoreTableViewCell"];
}


#pragma mark -- tableview代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataBallArray.count;
    
}

//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 43*ScreenWidth/375, ScreenWidth-16*ScreenWidth/375, 1*ScreenWidth/375)];
    viewLine1.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    [headerView addSubview:viewLine1];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375);
    [headerView addSubview:btn];
    [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = HEADER_BUTTON1_TAG +  section;
    
    UIButton *buttonJt = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮的tag 让其与区号产生联系
    buttonJt.tag = HEADER_BUTTON1_TAG +  section;
    //旋转或转换 CGAffineTransformIdentity意为回归原位
    buttonJt.transform = _isOpen[section]?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformIdentity;
    if (_isOpen[section]) {
       buttonJt.frame = CGRectMake(ScreenWidth-24*ScreenWidth/375, 16*ScreenWidth/375, 16*ScreenWidth/375, 12*ScreenWidth/375);
    }
    else
    {
        buttonJt.frame = CGRectMake(ScreenWidth-22*ScreenWidth/375, 14*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375);
    }
    [buttonJt setBackgroundImage:[UIImage imageNamed:@"left_jt"] forState:UIControlStateNormal];
    SEL a = @selector(headerButtonClick:);
    [buttonJt addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:buttonJt];
    
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 60*ScreenWidth/375, 44*ScreenWidth/375)];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    NSArray* array = @[@"第一9洞",@"第二9洞",@"Tee台"];
    headerTitleLabel.text = array[section];
    [headerView addSubview:headerTitleLabel];
    headerTitleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    
    
    UILabel* labelAreaDet = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 44*ScreenWidth/375)];
    labelAreaDet.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    labelAreaDet.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:labelAreaDet];
    labelAreaDet.tag = 1234 +  section;
 
    return headerView;
}
#pragma mark -  表开合
- (void)headerButtonClick:(id)sender
{
    ////NSLog(@"%@",_strBall);
    if (![Helper isBlankString:_strBall]) {
        
        UIButton *button = (UIButton *)sender;
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;
        
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行

    }
    else
    {
        ////NSLog(@"1");
    }
}



//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ////NSLog(@"%s", __func__);
    
    //如果当前区为打开状态
    if (_isOpen[section])
    {
        //取出字典中的所有值 一个数组中放着三个小数组
        NSArray *allValues = [_dataBallArray objectAtIndex:section];
        
        //根据每个区 返回行数
        return [allValues count];
    }
    else//如果不等于当前打开的区号 就是合闭状态 用返回0行来模拟出闭合状态
        return 0;
}



//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
    
    NSArray *allValues = [_dataBallArray objectAtIndex:indexPath.section];
    //将数组显示至每行
    cell.textLabel.text = [allValues objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    return cell;
}



//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44*ScreenWidth/375;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////NSLog(@"3");
    if (indexPath.section == 0) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:HEADER_BUTTON1_TAG + indexPath.section];
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;
        
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        
        UILabel* label = (UILabel *)[self.view viewWithTag:1234+section];
        label.text = [NSString stringWithFormat:@"%@",_dataBallArray[indexPath.section][indexPath.row]];
        _strSite0 = _dataBallArray[indexPath.section][indexPath.row];
        
    }
    
    else if (indexPath.section == 1)
    {
       
        UIButton *button = (UIButton *)[self.view viewWithTag:HEADER_BUTTON1_TAG + indexPath.section];
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;
        
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        //    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
        //    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        UILabel* label = (UILabel *)[self.view viewWithTag:1234+section];
        label.text = [NSString stringWithFormat:@"%@",_dataBallArray[indexPath.section][indexPath.row]];
        _strSite1 = _dataBallArray[indexPath.section][indexPath.row];

    }
    else
    {
       
        UIButton *button = (UIButton *)[self.view viewWithTag:HEADER_BUTTON1_TAG + indexPath.section];
        //根据button 获取区号
        NSInteger section = button.tag - HEADER_BUTTON1_TAG;

        _isOpen[section] = !_isOpen[section];
        
        //刷新表  表的相关代理方法会重新执行
//        [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        //    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
        //    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UILabel* label = (UILabel *)[self.view viewWithTag:1234+section];
        label.text = [NSString stringWithFormat:@"%@",_dataBallArray[indexPath.section][indexPath.row]];
        _strTee = _dataBallArray[indexPath.section][indexPath.row];
    }
}



-(void)createBtnScore
{
    
    _btnProFe = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnProFe.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*2*ScreenWidth/375-20*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnProFe];
    _btnProFe.backgroundColor = [UIColor orangeColor];
    [_btnProFe setTitle:@"专业记分" forState:UIControlStateNormal];
    [_btnProFe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnProFe addTarget:self action:@selector(professonClick) forControlEvents:UIControlEventTouchUpInside];
    _btnProFe.layer.masksToBounds = YES;
    _btnProFe.layer.cornerRadius = 8*ScreenWidth/375;
    
    
    _btnSimp = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnSimp.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-10*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    [self.view addSubview:_btnSimp];
    _btnSimp.backgroundColor = [UIColor orangeColor];
    [_btnSimp setTitle:@"简单记分" forState:UIControlStateNormal];
    [_btnSimp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSimp addTarget:self action:@selector(simpleClick) forControlEvents:UIControlEventTouchUpInside];
    _btnSimp.layer.masksToBounds = YES;
    _btnSimp.layer.cornerRadius = 8*ScreenWidth/375;
    
}


#pragma mark --记分点击跳转页面
//简单记分
-(void)simpleClick
{
    if (![Helper isBlankString:_textField.text]) {
        if (![Helper isBlankString:_strBall]) {
            if (![Helper isBlankString:_strTee]) {
                if (![Helper isBlankString:_strSite0] && ![Helper isBlankString:_strSite1]) {
                    ScoreSimpleViewController *simpVc = [[ScoreSimpleViewController alloc]init];
                    NSString* scoreOId = [self createDate];
                    simpVc.objId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                    simpVc.strTitle = _textField.text;
                    simpVc.strBallName = _strBall;
                    //                simpVc.strDate ;
                    simpVc.strSite0 = _strSite0;
                    simpVc.strSite1 = _strSite1;
                    simpVc.strType = @1;
                    simpVc.strTee = _strTee;
                    simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                    [self.navigationController pushViewController:simpVc animated:YES];
                }
                else
                {
                    [Helper alertViewWithTitle:@"请选择九洞" withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
                

            }
            else
            {
                [Helper alertViewWithTitle:@"请选择Tee台" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }
        else
        {
            [Helper alertViewWithTitle:@"请选择球场" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }
    else
    {
        [Helper alertViewWithTitle:@"请输入球场名" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}
//专业记分
-(void)professonClick
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在添加记分卡...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    if (![Helper isBlankString:_textField.text]) {
        if (![Helper isBlankString:_strBall]) {
            if (![Helper isBlankString:_strTee]) {
                if (![Helper isBlankString:_strSite0] && ![Helper isBlankString:_strSite1]) {
                    [_dict setObject:[NSNumber numberWithInteger:_ballId] forKey:@"scoreballId"];
                    [_dict setObject:_strBall forKey:@"scoreballName"];
                    [_dict setObject:_strSite0 forKey:@"scoreSite0"];
                    [_dict setObject:_strSite1 forKey:@"scoreSite1"];
                    [_dict setObject:_strTee forKey:@"scoreTTaiwan"];
                    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"scoreWhoScoreUserId"];
                    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"scoreScoreMobile"];
                    NSString* scoreOId = [self createDate];
                    [_dict setObject:scoreOId forKey:@"scoreObjectId"];
                    ;
                    ////NSLog(@"%@",scoreOId);
                    [_dict setObject:_textField.text forKey:@"scoreObjectTitle"];
                    [_dict setObject:@1 forKey:@"scoreType"];
                    [_dict setObject:@2 forKey:@"scoreIsSimple"];
                    [_dict setObject:@1 forKey:@"scoreIsClaim"];
                    
                    [[PostDataRequest sharedInstance]postDataRequest:@"score/save.do" parameter:_dict success:^(id respondsData) {
                        NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                            ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                            simpVc.strTitle = _textField.text;
                            simpVc.strBallName = _strBall;
                            //                simpVc.strDate ;
                            simpVc.strSite0 = _strSite0;
                            simpVc.strSite1 = _strSite1;
                            simpVc.strType = @1;
                            simpVc.strTee = _strTee;
                            simpVc.scoreObjectId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                            ////NSLog(@"%@",simpVc.scoreObjectId);
                            simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                            [self.navigationController pushViewController:simpVc animated:YES];
                        }
                        else
                        {
                            
                            if ([[dictD objectForKey:@"total"] integerValue] == 1) {
                                
                                
                                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"该计分已经创建,无需重复创建" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                                    simpVc.strTitle = _textField.text;
                                    simpVc.strBallName = _strBall;
                                    //                simpVc.strDate ;
                                    simpVc.scoreObjectId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                                    ////NSLog(@"%@",simpVc.scoreObjectId);
                                    simpVc.strSite0 = _strSite0;
                                    simpVc.strSite1 = _strSite1;
                                    simpVc.strType = @1;
                                    simpVc.strTee = _strTee;
                                    simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                                    [self.navigationController pushViewController:simpVc animated:YES];
                                }];
                                [alert addAction:action2];
                            }
                            else if ([[dictD objectForKey:@"total"] integerValue] == 2)
                            {
                                
                                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"该计分已经创建,无需重复创建" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [[PostDataRequest sharedInstance] postDataRequest:@"score/getMyQx.do" parameter:@{@"userMobile":[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"],@"type":@1,@"scoreObjectId":[NSNumber numberWithInteger:[scoreOId integerValue]],@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId "]} success:^(id respondsData) {
                                        NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                                        if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                                            ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                                            simpVc.strTitle = _textField.text;
                                            simpVc.strBallName = _strBall;
                                            //                simpVc.strDate ;
                                            simpVc.scoreObjectId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                                            ////NSLog(@"%@",simpVc.scoreObjectId);
                                            simpVc.strSite0 = _strSite0;
                                            simpVc.strSite1 = _strSite1;
                                            simpVc.strType = @1;
                                            simpVc.strTee = _strTee;
                                            simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                                            [self.navigationController pushViewController:simpVc animated:YES];
                                        }
                                        
                                    } failed:^(NSError *error) {
                                        
                                    }];
                                }];
                                [alert addAction:action2];
                            }
                        }
                        
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [Helper alertViewNoHaveCancleWithTitle:@"断开连接" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }];
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [Helper alertViewWithTitle:@"请选择九洞" withBlock:^(UIAlertController *alertView)
                    {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
                
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Helper alertViewWithTitle:@"请选择Tee台" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Helper alertViewWithTitle:@"请选择球场" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Helper alertViewWithTitle:@"请输入标题" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }

}

-(NSString *)createDate
{
    //获取当前时间
    NSDate *now = [NSDate date];
//    ////NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int month = [dateComponent month];
    
    int num = arc4random() % 10000;
    NSString* str = [NSString stringWithFormat:@"%d%d",month,num];
    return str;
}


@end
