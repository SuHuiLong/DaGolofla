//
//  ScoreByGameViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreByActiveViewController.h"


#import "ScoreSimpleViewController.h"
#import "ScoreProfessViewController.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "CustomIOSAlertView.h"
#import "ScoreGameModel.h"
#import "MBProgressHUD.h"

#import "ScoreTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "ScoreBySelfViewController.h"

#import "BallParkViewController.h"
#import "DateTimeViewController.h"

#define HEADER_BUTTON1_TAG 100
#define HEADER_BUTTON2_TAG 1000
#define HEADER_BUTTON3_TAG 10000
@interface ScoreByActiveViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataBallIdArr;
    NSMutableArray* _dataBallNameArr;
    NSMutableArray* _dataTypeArray;
    
    NSMutableArray* _dataBallArray;
    NSMutableArray* _dataTeeArray;
    NSArray *_titleArray;
    
    NSString* _strBall;
    
    UILabel* _labelAreaDet;
    
    UIButton* _btnSimp;
    UIButton* _btnProFe;
    
    //第几九洞
    NSString* _strSite0,* _strSite1;
    NSString* _strTee;
    //通知是否有赛事的弹窗
    CustomIOSAlertView* _alertView;
    MBProgressHUD* _proressHud;
    MBProgressHUD* _progress;
    //显示在自定义弹窗视图上的按钮
    UIButton* _btnFirst;
    UIButton* _btnSecond;
    UIButton* _btnThird;
    
    //头视图
    UIView *_viewBase;
    UILabel* _labelPark;
    UILabel* _labelTime;
    UITextField* _textTitle;
    
    //如果选择了活动，则使用如下空间
    UIImageView* _imgvAct;
    UILabel* _labelTitleAct;
    UILabel* _labelParkAct;
    UILabel* _labelTimeAct;
    
    NSMutableDictionary* _dict;
    
    NSNumber* _numberObjId;
    NSMutableArray* _objectIdArray;
    
    
    BOOL _isHaveId;
}

@end

@implementation ScoreByActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _numberObjId = @-1;
    _objectIdArray = [[NSMutableArray alloc]init];
    //    _ballId = 21;
    self.title = @"活动记分";
    //三个数组 分别放家人 好友 同学
    _dataArray = [[NSMutableArray alloc]init];
    _dataBallIdArr =[[NSMutableArray alloc]init];
    _dataBallNameArr = [[NSMutableArray alloc]init];
    _dataTypeArray = [[NSMutableArray alloc]init];
    
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
    _strBall = _ballName;
    if (_scoreType != nil) {
        [self uiConfig];
        [self createHead];
        [self createBtnScore];
        
        [[PostDataRequest sharedInstance] postDataRequest:@"ball/getBallCode.do" parameter:@{@"ballId":[NSNumber numberWithInteger:_ballId]} success:^(id respondsData) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            ////NSLog(@"%@",dict);
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                //点击事件选中后传值
                
                _numberObjId = _activeObjId;
                _isHaveId = YES;
                [_dataBallArray removeAllObjects];
                
                [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"tAll"]];
                
                [_tableView reloadData];
            }
            
        } failed:^(NSError *error) {
            
        }];
        
    }
    else
    {
        _scoreType = @11;
        //查询是否有正在进行的活动或者记分
        [[PostDataRequest sharedInstance] postDataRequest:@"score/getIntheAct.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"success"] integerValue]==1) {
                for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                    
                    ScoreGameModel *model = [[ScoreGameModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    [_dataArray addObject:model];
                    [_dataBallIdArr addObject:model.ballId];
                    [_dataBallNameArr addObject:model.ballName];
                    [_dataTypeArray addObject:model.type];
                    [_objectIdArray addObject:model.ida];
                }
                ////NSLog(@"%@",_dataArray);
                [self uiConfig];
                [self createHead];
                [self createBtnScore];
                if (_dataArray.count != 0) {
                    //自定义的显示框
                    _alertView = [[CustomIOSAlertView alloc] init];
                    _alertView.backgroundColor = [UIColor whiteColor];
                    [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",nil]];//添加按钮
                    //[alertView setDelegate:self];
                    _alertView.delegate = self;
                    [_alertView setContainerView:[self createMoneyView]];
                    [_alertView show];
                }
                else
                {
                    for(UIView *view in _viewBase.subviews)
                    {
                        [view removeFromSuperview];
                    }
                    
                    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
                    [imgv sd_setImageWithURL:[Helper imageIconUrl:_pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
                    [_viewBase addSubview:imgv];
                    
                    _textTitle = [[UITextField alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-120*ScreenWidth/375, 30*ScreenWidth/375)];
                    _textTitle.placeholder = @"请输入活动标题";
                    _textTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                    [_viewBase addSubview:_textTitle];
                    _textTitle.delegate = self;
                    
                    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
                    viewLine.backgroundColor = [UIColor lightGrayColor];
                    [_viewBase addSubview:viewLine];
                    
                    UIButton* btnPark = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnPark.frame = CGRectMake(0, 95*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
                    [_viewBase addSubview:btnPark];
                    [btnPark addTarget:self action:@selector(btnParkClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    _labelPark = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
                    _labelPark.text = @"请选择球场";
                    _labelPark.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                    [btnPark addSubview:_labelPark];
                    
                    UIButton* btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnTime.frame = CGRectMake(0, 125*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
                    [_viewBase addSubview:btnTime];
                    
                    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
                    _labelTime.text = @"请选择时间";
                    _labelTime.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                    [btnTime addSubview:_labelTime];
                    [btnTime addTarget:self action:@selector(btnTimeClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 159*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
                    viewLine1.backgroundColor = [UIColor lightGrayColor];
                    [_viewBase addSubview:viewLine1];
                }
                
                
            }
            //查询失败就用选择的球场进行查询
            else
            {
                [self uiConfig];
                [self createHead];
                [self createBtnScore];
                if (_dataArray.count != 0) {
                    //自定义的显示框
                    _alertView = [[CustomIOSAlertView alloc] init];
                    _alertView.backgroundColor = [UIColor whiteColor];
                    [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",nil]];//添加按钮
                    //[alertView setDelegate:self];
                    _alertView.delegate = self;
                    [_alertView setContainerView:[self createMoneyView]];
                    [_alertView show];
                }
                else
                {
                    for(UIView *view in _viewBase.subviews)
                    {
                        [view removeFromSuperview];
                    }
                    
                    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
                    [imgv sd_setImageWithURL:[Helper imageIconUrl:_pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
                    [_viewBase addSubview:imgv];
                    
                    _textTitle = [[UITextField alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-120*ScreenWidth/375, 30*ScreenWidth/375)];
                    _textTitle.placeholder = @"请输入活动标题";
                    _textTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                    [_viewBase addSubview:_textTitle];
                    _textTitle.delegate = self;
                    
                    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
                    viewLine.backgroundColor = [UIColor lightGrayColor];
                    [_viewBase addSubview:viewLine];
                    
                    UIButton* btnPark = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnPark.frame = CGRectMake(0, 95*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
                    [_viewBase addSubview:btnPark];
                    [btnPark addTarget:self action:@selector(btnParkClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    _labelPark = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
                    _labelPark.text = @"请选择球场";
                    _labelPark.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                    [btnPark addSubview:_labelPark];
                    
                    UIButton* btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnTime.frame = CGRectMake(0, 125*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
                    [_viewBase addSubview:btnTime];
                    
                    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
                    _labelTime.text = @"请选择时间";
                    _labelTime.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                    [btnTime addSubview:_labelTime];
                    [btnTime addTarget:self action:@selector(btnTimeClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 159*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
                    viewLine1.backgroundColor = [UIColor lightGrayColor];
                    [_viewBase addSubview:viewLine1];
                }
                
            }
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }];

    }
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:124];
    [textField resignFirstResponder];
    ////NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if ((int)buttonIndex == 0) {
        for(UIView *view in _viewBase.subviews)
        {
            [view removeFromSuperview];
        }
        
        UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
        [imgv sd_setImageWithURL:[Helper imageIconUrl:_pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
        [_viewBase addSubview:imgv];
        
        _textTitle = [[UITextField alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-120*ScreenWidth/375, 30*ScreenWidth/375)];
        _textTitle.placeholder = @"请输入活动标题";
        _textTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_viewBase addSubview:_textTitle];
        _textTitle.delegate = self;
        
        UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
        viewLine.backgroundColor = [UIColor lightGrayColor];
        [_viewBase addSubview:viewLine];
        
        UIButton* btnPark = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPark.frame = CGRectMake(0, 95*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
        [_viewBase addSubview:btnPark];
        [btnPark addTarget:self action:@selector(btnParkClick) forControlEvents:UIControlEventTouchUpInside];
        
        _labelPark = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
        _labelPark.text = @"请选择球场";
        _labelPark.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [btnPark addSubview:_labelPark];
        
        UIButton* btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTime.frame = CGRectMake(0, 125*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
        [_viewBase addSubview:btnTime];
        
        _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
        _labelTime.text = @"请选择时间";
        _labelTime.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [btnTime addSubview:_labelTime];
        [btnTime addTarget:self action:@selector(btnTimeClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 159*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
        viewLine1.backgroundColor = [UIColor lightGrayColor];
        [_viewBase addSubview:viewLine1];
    }
    [alertView close];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


//球场选择
-(void)btnParkClick
{
    //球场
    [self.view endEditing:YES];
    BallParkViewController* ballVc = [[BallParkViewController alloc]init];
    ballVc.type1=1;
    ballVc.callback1=^(NSDictionary *dict, NSNumber *num){
        ////NSLog(@"%@",dict);
        
        [_dataBallArray removeAllObjects];
        [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
        [_dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
        [_dataBallArray addObject:[dict objectForKey:@"tAll"]];
        [_tableView reloadData];
    };
    [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
        _labelPark.text = balltitle;
        _strBall = balltitle;
        _ballId = ballid;
        
        
        [[PostDataRequest sharedInstance] postDataRequest:@"ball/getBallCode.do" parameter:@{@"ballId":[NSNumber numberWithInteger:_ballId]} success:^(id respondsData) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            ////NSLog(@"%@",dict);
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                //点击事件选中后传值
                
                
                [_dataBallArray removeAllObjects];
                
                [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
                [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"tAll"]];
                
            }
            
        } failed:^(NSError *error) {
            
        }];
        
    }];
    [self.navigationController pushViewController:ballVc animated:YES];
    
}
//时间选择
-(void)btnTimeClick
{
    [self.view endEditing:YES];
    DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
    [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
        //        _strDateBegin = dateStr;
        _labelTime.text = dateStr;
    }];
    [self.navigationController pushViewController:dateVc animated:YES];
    
}
/**
 *  创建头标题视图
 */
-(void)createHead
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 160*ScreenWidth/375)];
    _viewBase.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _viewBase;
    
    _imgvAct = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
    [_imgvAct sd_setImageWithURL:[Helper imageIconUrl:_pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    [_viewBase addSubview:_imgvAct];
    
    _labelTitleAct = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-120*ScreenWidth/375, 30*ScreenWidth/375)];
    
    _labelTitleAct.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBase addSubview:_labelTitleAct];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [_viewBase addSubview:viewLine];
    
    _labelParkAct = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 95*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    
    _labelParkAct.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBase addSubview:_labelParkAct];
    
    _labelTimeAct = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 120*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    
    _labelTimeAct.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBase addSubview:_labelTimeAct];
    
    UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 159*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    viewLine1.backgroundColor = [UIColor lightGrayColor];
    [_viewBase addSubview:viewLine1];
    
    if ([Helper isBlankString:_strTitle]) {
        _labelTitleAct.text = @"标题";
        _labelParkAct.text = @"球场";
        _labelTimeAct.text = @"打球日期";
        
    }
    else
    {
        _labelTitleAct.text = [NSString stringWithFormat:@"标题:%@",_strTitle];
        _labelParkAct.text = [NSString stringWithFormat:@"球场:%@",_ballName];
        _labelTimeAct.text = [NSString stringWithFormat:@"打球日期:%@",_createTime];
    }
    
    
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
    //    labelTitle.text = @"     XXXX客户,您今天参加了以下内容，请点击确认具体赛事";
    
    labelTitle.text = [NSString stringWithFormat:@"%@您好，您今天参加了以下内容，请点击确认具体活动",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    labelTitle.numberOfLines = 0;
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [actView addSubview:labelTitle];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth-56*ScreenWidth/375, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    [actView addSubview:viewLine];
    if (_dataArray.count >= 3) {
        _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFirst setTitle:[_dataArray[0] title] forState:UIControlStateNormal];
        _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
        _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [actView addSubview:_btnFirst];
        [_btnFirst addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSecond setTitle:[_dataArray[1] title] forState:UIControlStateNormal];
        _btnSecond.frame = CGRectMake(0, 100*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
        _btnSecond.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_btnSecond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [actView addSubview:_btnSecond];
        [_btnSecond addTarget:self action:@selector(secondClick) forControlEvents:UIControlEventTouchUpInside];
        
        _btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnThird setTitle:[_dataArray[2] title] forState:UIControlStateNormal];
        _btnThird.frame = CGRectMake(0, 140*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
        _btnThird.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [_btnThird setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [actView addSubview:_btnThird];
        [_btnThird addTarget:self action:@selector(thirdClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if (_dataArray.count == 2) {
            _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnFirst setTitle:[_dataArray[0] title] forState:UIControlStateNormal];
            _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
            _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [actView addSubview:_btnFirst];
            [_btnFirst addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
            
            _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnSecond setTitle:[_dataArray[1] title] forState:UIControlStateNormal];
            
            _btnSecond.frame = CGRectMake(0, 100*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
            _btnSecond.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            [_btnSecond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [actView addSubview:_btnSecond];
            actView.frame = CGRectMake(0*ScreenWidth/375, 0, ScreenWidth-40*ScreenWidth/375, 160*ScreenWidth/375);
            [_btnSecond addTarget:self action:@selector(secondClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(_dataArray.count == 1)
        {
            actView.frame = CGRectMake(0*ScreenWidth/375, 0, ScreenWidth-40*ScreenWidth/375, 110*ScreenWidth/375);
            
            {
                _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
                [_btnFirst setTitle:[_dataArray[0] title] forState:UIControlStateNormal];
                _btnFirst.frame = CGRectMake(0, 60*ScreenWidth/375, actView.frame.size.width, 40*ScreenWidth/375);
                _btnFirst.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
                [_btnFirst setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [actView addSubview:_btnFirst];
                [_btnFirst addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        else
        {
            
        }
    }
    
    
    return actView;
}
//第一场比赛选择点击事件
-(void)firstClick
{
    ////NSLog(@"1");
    _numberObjId = _objectIdArray[0];
    _isHaveId = YES;
    [self.view endEditing:YES];
    [[PostDataRequest sharedInstance] postDataRequest:@"ball/getBallCode.do" parameter:@{@"ballId":_dataBallIdArr[0]} success:^(id respondsData) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_dataBallArray removeAllObjects];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"]  objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"]  objectForKey:@"tAll"]];
            //                    [_tableView reloadData];
            
            _ballId = [_dataBallIdArr[0] integerValue];
            _strBall = _dataBallNameArr[0];
            _scoreType = _dataTypeArray[0];
            [_alertView close];
            
            [_imgvAct sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[0] loginPic]] placeholderImage:[UIImage imageNamed:@"zwt"]];
            _labelTitleAct.text = [_dataArray[0] title];
            _labelTimeAct.text = [_dataArray[0] startDate];
            _labelParkAct.text = _dataBallNameArr[0];
            
            
        }
    } failed:^(NSError *error) {
        
    }];
    
}
//选择第二场比赛点击事件
-(void)secondClick
{
    ////NSLog(@"2");
    _numberObjId = _objectIdArray[1];
    _isHaveId = YES;
    [self.view endEditing:YES];
    [[PostDataRequest sharedInstance] postDataRequest:@"ball/getBallCode.do" parameter:@{@"ballId":_dataBallIdArr[1]} success:^(id respondsData) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_dataBallArray removeAllObjects];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"]  objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"]  objectForKey:@"tAll"]];
            //                    [_tableView reloadData];
            
            _ballId = [_dataBallIdArr[1] integerValue];
            _strBall = _dataBallNameArr[1];
            _scoreType = _dataTypeArray[1];
            [_alertView close];
            
            [_alertView close];
            
            [_imgvAct sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[1] loginPic]] placeholderImage:[UIImage imageNamed:@"zwt"]];
            _labelTitleAct.text = [_dataArray[1] title];
            _labelTimeAct.text = [_dataArray[1] startDate];
            _labelParkAct.text = _dataBallNameArr[1];

        }
    } failed:^(NSError *error) {
        
    }];
}
//选择第三场比赛点击事件
-(void)thirdClick
{
    ////NSLog(@"3");
    _numberObjId = _objectIdArray[2];
    _isHaveId = YES;
    [self.view endEditing:YES];
    [[PostDataRequest sharedInstance] postDataRequest:@"ball/getBallCode.do" parameter:@{@"ballId":_dataBallIdArr[2]} success:^(id respondsData) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([dict objectForKey:@"success"]) {
            
            [_dataBallArray removeAllObjects];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"] objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"]  objectForKey:@"ballAreas"]];
            [_dataBallArray addObject:[[dict objectForKey:@"rows"]  objectForKey:@"tAll"]];
            //                    [_tableView reloadData];
            
            _ballId = [_dataBallIdArr[2] integerValue];
            _strBall = _dataBallNameArr[2];
            _scoreType = _dataTypeArray[2];
            [_alertView close];
            
            [_alertView close];
            
            [_imgvAct sd_setImageWithURL:[Helper imageIconUrl:[_dataArray[2] loginPic]] placeholderImage:[UIImage imageNamed:@"zwt"]];
            _labelTitleAct.text = [_dataArray[2] title];
            _labelTimeAct.text = [_dataArray[2] startDate];
            _labelParkAct.text = _dataBallNameArr[2];
        }
    } failed:^(NSError *error) {
        
    }];
}

-(void)selfScoreClick
{
    [self.view endEditing:YES];
    for(UIView *view in _viewBase.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
    [imgv sd_setImageWithURL:[Helper imageIconUrl:_pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    [_viewBase addSubview:imgv];
    
    _textTitle = [[UITextField alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-120*ScreenWidth/375, 30*ScreenWidth/375)];
    _textTitle.placeholder = @"请输入活动标题";
    _textTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBase addSubview:_textTitle];
    _textTitle.delegate = self;
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [_viewBase addSubview:viewLine];
    
    UIButton* btnPark = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPark.frame = CGRectMake(0, 95*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
    [_viewBase addSubview:btnPark];
    [btnPark addTarget:self action:@selector(btnParkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _labelPark = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    _labelPark.text = @"请选择球场";
    _labelPark.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [btnPark addSubview:_labelPark];
    
    UIButton* btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTime.frame = CGRectMake(0, 125*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
    [_viewBase addSubview:btnTime];
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    _labelTime.text = @"请选择时间";
    _labelTime.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [btnTime addSubview:_labelTime];
    [btnTime addTarget:self action:@selector(btnTimeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 159*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    viewLine1.backgroundColor = [UIColor lightGrayColor];
    [_viewBase addSubview:viewLine1];

    [_alertView close];
}



-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44*2*ScreenWidth/375-30*ScreenWidth/375-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:@"ScoreTableViewCell"];
    
    //    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
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

//简单记分
-(void)simpleClick
{
    [self.view endEditing:YES];
//    if (![Helper isBlankString:_textTitle.text]) {
        if (![Helper isBlankString:_strBall]) {
            if (![Helper isBlankString:_strTee]) {
                if (![Helper isBlankString:_strSite0] && ![Helper isBlankString:_strSite1]) {
                    if (![Helper isBlankString:_textTitle.text]) {
                        _textTitle.text = [NSString stringWithFormat:@"%@",_textTitle.text];
                    }
                    else
                    {
                        _textTitle.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                    }
                    ScoreSimpleViewController *simpVc = [[ScoreSimpleViewController alloc]init];
                    if (_textTitle != nil) {
                        simpVc.strTitle = _textTitle.text;
                    }else
                    {
                        simpVc.strTitle = _labelTitleAct.text;
                    }
                    simpVc.strBallName = _strBall;
                    simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                    simpVc.strDate = _labelTime.text;
                    simpVc.strSite0 = _strSite0;
                    simpVc.strSite1 = _strSite1;
                    simpVc.strType = _scoreType;
                    simpVc.strTee = _strTee;
                    //                if (_isSave != nil) {
                    //                    simpVc.isSave = @10;
                    //                }
                    if (_isHaveId == YES) {
                        simpVc.objId = [NSNumber numberWithInteger:[_numberObjId integerValue]];
                    }
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
//    }
}
//专业记分
-(void)professonClick
{
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在添加记分卡...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    [self.view endEditing:YES];
//    if (![Helper isBlankString:_textTitle.text]) {
        if (![Helper isBlankString:_strBall]) {
            if (![Helper isBlankString:_strTee]) {
                if (![Helper isBlankString:_strSite0] && ![Helper isBlankString:_strSite1]) {
                    if (![Helper isBlankString:_textTitle.text]) {
                        _textTitle.text = [NSString stringWithFormat:@"%@",_textTitle.text];
                    }
                    else
                    {
                        _textTitle.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                    }
                    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"scoreWhoScoreUserId"];
                    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"scoreScoreMobile"];
                    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"scoreScoreUserId"];
                    NSString* scoreOId = [self createDate];
                    if (_isHaveId == YES) {
                        [_dict setObject:_numberObjId forKey:@"scoreObjectId"];
                    }
                    else
                    {
                        [_dict setObject:scoreOId forKey:@"scoreObjectId"];
                    }
                    if (_textTitle != nil) {
                        [_dict setObject:_textTitle.text forKey:@"scoreObjectTitle"];
                    }else
                    {
                        [_dict setObject:_labelTitleAct.text forKey:@"scoreObjectTitle"];
                    }
                    [_dict setObject:[NSNumber numberWithInteger:_ballId] forKey:@"scoreballId"];
                    [_dict setObject:_strBall forKey:@"scoreballName"];
                    [_dict setObject:_strSite0 forKey:@"scoreSite0"];
                    [_dict setObject:_strSite1 forKey:@"scoreSite1"];
                    [_dict setObject:_strTee forKey:@"scoreTTaiwan"];
                    [_dict setObject:@0 forKey:@"scoreIsClaim"];
                    [_dict setObject:@2 forKey:@"scoreIsSimple"];
                    [_dict setObject:_scoreType forKey:@"scoreType"];
                    [[PostDataRequest sharedInstance]postDataRequest:@"score/save.do" parameter:_dict success:^(id respondsData) {
                        NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                            if (_textTitle != nil) {
                                simpVc.strTitle = _textTitle.text;
                            }else
                            {
                                simpVc.strTitle = _labelTitleAct.text;
                            }
                            simpVc.strBallName = _strBall;
                            //                simpVc.strDate ;
                            simpVc.strSite0 = _strSite0;
                            simpVc.strSite1 = _strSite1;
                            simpVc.strType = _scoreType;
                            simpVc.strTee = _strTee;
                            if (_isSave != nil) {
                                simpVc.isSave = @10;
                            }
                            simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                            if (_isHaveId == YES) {
                                simpVc.scoreObjectId = [NSNumber numberWithInteger:[_numberObjId integerValue]];
                            }
                            else
                            {
                                simpVc.scoreObjectId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                            }
                            [self.navigationController pushViewController:simpVc animated:YES];
                        }
                        else
                        {
                            
                            if ([[dictD objectForKey:@"total"] integerValue] == 1) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                                if (_textTitle != nil) {
                                    simpVc.strTitle = _textTitle.text;
                                }else
                                {
                                    simpVc.strTitle = _labelTitleAct.text;
                                }
                                simpVc.strBallName = _strBall;
                                //                simpVc.strDate ;
                                simpVc.strSite0 = _strSite0;
                                simpVc.strSite1 = _strSite1;
                                simpVc.strType = _scoreType;
                                simpVc.strTee = _strTee;
                                if (_isSave != nil) {
                                    simpVc.isSave = @10;
                                }
                                if (_isHaveId == YES) {
                                    simpVc.scoreObjectId = [NSNumber numberWithInteger:[_numberObjId integerValue]];
                                }
                                else
                                {
                                    simpVc.scoreObjectId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                                }
                                simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                                [self.navigationController pushViewController:simpVc animated:YES];
                            }
                            else if ([[dictD objectForKey:@"total"] integerValue] == 2)
                            {
                                [[PostDataRequest sharedInstance] postDataRequest:@"score/getMyQx.do" parameter:@{@"userMobile":[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"],@"type":_scoreType,@"scoreObjectId":@-1,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId "]} success:^(id respondsData) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                                    if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                                        ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                                        if (_textTitle != nil) {
                                            simpVc.strTitle = _textTitle.text;
                                        }else
                                        {
                                            simpVc.strTitle = _labelTitleAct.text;
                                        }
                                        simpVc.strBallName = _strBall;
                                        //                simpVc.strDate ;
                                        simpVc.strSite0 = _strSite0;
                                        simpVc.strSite1 = _strSite1;
                                        simpVc.strType = _scoreType;
                                        simpVc.strTee = _strTee;
                                        if (_isSave != nil) {
                                            simpVc.isSave = @10;
                                        }
                                        if (_isHaveId == YES) {
                                            simpVc.scoreObjectId = [NSNumber numberWithInteger:[_numberObjId integerValue]];
                                        }
                                        else
                                        {
                                            simpVc.scoreObjectId = [NSNumber numberWithInteger:[scoreOId integerValue]];
                                        }
                                        simpVc.ballId = [NSNumber numberWithInteger:_ballId];
                                        [self.navigationController pushViewController:simpVc animated:YES];
                                    }
                                    
                                } failed:^(NSError *error) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }];
                            }
                        }
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [Helper alertViewWithTitle:@"请选择九洞" withBlock:^(UIAlertController *alertView) {
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

#pragma mark -- tableview代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataBallArray.count;
    
}

//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //头视图
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
    //    if (![Helper isBlankString:_strBall]) {
    
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
    //    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
    //    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //    }
    //    else
    //    {
    //        ////NSLog(@"1");
    //    }
}



//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    ////NSLog(@"%s", __func__);
    ////NSLog(@"%@",_dataBallArray[section]);
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
        //    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
        //    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
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
        _strTee = _dataBallArray[indexPath.section][indexPath.row];
    }
}

@end
