//
//  ScoreProfessViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreProfessViewController.h"
#import "SelfScoreTableViewCell.h"

#import "CustomIOSAlertView.h"

#import "ScoreWriteProController.h"

#import "Helper.h"
#import "PostDataRequest.h"
#import "ScorePeopleModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "ScoreProModel.h"
#import "ScoreProListModel.h"
#import "ScoreProStandedModel.h"

#import "ScoreFootViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "HistoryViewController.h"
#import "MBProgressHUD.h"

@interface ScoreProfessViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataArrayPro;
    NSMutableArray* _dataArrayList0;
    NSMutableArray* _dataArrayList1;
    NSMutableArray* _dataArrayList2;
    NSMutableArray* _dataArrayList3;
    UIScrollView* _scrollView;
    //删除积分卡所用的ids数组
    NSMutableArray* arratIds;
    
    NSInteger _btnIndex;
    
    BOOL _isaddImgv2;
    BOOL _isaddImgv3;
    BOOL _isaddImgv4;
    
    UIButton* _buttonImg1;
    UIButton* _buttonImg2;
    UIButton* _buttonImg3;
    UIButton* _buttonImg4;
    
    UIView* _viewBaseName;
    
    NSMutableArray* _arrayId, *_arrayName;
    NSMutableArray* _dataArray1, *_dataArray2, *_dataArray3;
    //手机号
    UITextField* _textPrice;
    
    //添加手机号后的名字
    UILabel* _labelDetail;
    UILabel* _labelDetail1;
    UILabel* _labelDetail2;
    
    NSMutableArray* _arrayMobile;
    //添加的用户id
    NSMutableArray* _arrayUserId;
    //积分卡id
    NSMutableArray* _arrayCardId;
    
    //自己的头像
    UIImageView *_imgvSelf;
    UILabel* _labelSelfName;
    
    //判断是否保存第二、三、四个人的信息，
    BOOL _isPeople2,_isPeople3,_isPeople4;
    //时间
    UILabel* _labelTime;
    BOOL _isFinish;
    
    UIButton* _btnOver;
    
    MBProgressHUD* _progress;
}
@end

@implementation ScoreProfessViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    //每次进入都需要更新数据
    [self prepareData];
    
    //重写返回按钮，需要一个提示，确定是否返回
    UIBarButtonItem *leftBtn1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreLeftClick)];
    leftBtn1.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBtn1;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100*ScreenWidth/375, ScreenWidth, ScreenHeight-100*ScreenWidth/375-64)];
    _scrollView.contentSize = CGSizeMake(0, 23*50*ScreenWidth/375);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_scrollView];
    _scrollView.bounces = NO;
    self.title = @"专业记分";
    
    _arrayId = [[NSMutableArray alloc]init];
    _arrayName = [[NSMutableArray alloc]init];
    
    _dataArray = [[NSMutableArray alloc]init];
    _dataArrayPro = [[NSMutableArray alloc]init];
    //存用户的记分数据
    _dataArrayList0 = [[NSMutableArray alloc]init];
    _dataArrayList1 = [[NSMutableArray alloc]init];
    _dataArrayList2 = [[NSMutableArray alloc]init];
    _dataArrayList3 = [[NSMutableArray alloc]init];
    
    //用来存用户的姓名
    _dataArray1 = [[NSMutableArray alloc]init];
    _dataArray2 = [[NSMutableArray alloc]init];
    _dataArray3 = [[NSMutableArray alloc]init];
    
    //用来存用户的手机号
    _arrayMobile= [[NSMutableArray alloc]init];
    
    //记分卡id数组
    _arrayCardId = [[NSMutableArray alloc]init];
    
    //添加的用户id
    _arrayUserId = [[NSMutableArray alloc]init];
    
    arratIds = [[NSMutableArray alloc]init];
    //创建标题视图
    [self createViewNameTitle];
    //创建球员视图
    [self createViewScoTitle];
//    [self prepareData];
    [self uiConfig];
    
    
    //把数据存储到本地
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"scoreWhoScoreUserId"];
    [user setObject:_scoreObjectId forKey:@"scoreObjectId"];
    [user setObject:_strTitle forKey:@"scoreObjectTitle"];
    [user setObject:_ballId forKey:@"scoreballId"];
    [user setObject:_strBallName forKey:@"scoreballName"];
    [user setObject:_strSite0 forKey:@"scoreSite0"];
    [user setObject:_strSite1 forKey:@"scoreSite1"];
    [user setObject:_strTee forKey:@"scoreTTaiwan"];
    [user setObject:_strType forKey:@"scoreType"];
    [user setObject:@2 forKey:@"scoreIsSimple"];
    [user setObject:@0 forKey:@"scoreIsClaim"];
    [user synchronize];
    
    
 
}

-(void)progress
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在刷新...";
    [self.view addSubview:_progress];
    [_progress show:YES];
}

-(void)scoreLeftClick
{
    
    if (_isFinish == NO) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"您这次的" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action1=[UIAlertAction actionWithTitle:@"过会儿再记" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            HistoryViewController* hisVc = [[HistoryViewController alloc]init];
            [self.navigationController pushViewController:hisVc animated:YES];
        }];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"删除该记分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除
            NSString* strIds = [arratIds componentsJoinedByString:@","];
            
            
            [[PostDataRequest sharedInstance] postDataRequest:@"score/delete.do" parameter:@{@"ids":strIds} success:^(id respondsData) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                if ([[dict objectForKey:@"success"]integerValue] == 1) {
                    
                    //          删除保存到本地的数据
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    
                    [user removeObjectForKey:@"scoreWhoScoreUserId"];
                    [user removeObjectForKey:@"scoreScoreMobile"];
                    [user removeObjectForKey:@"scoreObjectId"];
                    [user removeObjectForKey:@"scoreObjectTitle"];
                    [user removeObjectForKey:@"scoreballId"];
                    [user removeObjectForKey:@"scoreballName"];
                    [user removeObjectForKey:@"scoreSite0"];
                    [user removeObjectForKey:@"scoreSite1"];
                    [user removeObjectForKey:@"scoreTTaiwan"];
                    [user removeObjectForKey:@"scoreType"];
                    [user removeObjectForKey:@"scoreIsSimple"];
                    [user removeObjectForKey:@"scoreIsClaim"];
                    [user synchronize];
                    
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
                }
                
            } failed:^(NSError *error) {
                
            }];
            
            
        }];
        UIAlertAction *action3=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        
        [alert addAction:action2];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --头视图标题内容
-(void)createViewNameTitle
{
    UIView* viewTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50*ScreenWidth/375)];
    viewTitle.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:viewTitle];
    
    UILabel* labeltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 25*ScreenWidth/375)];
    [viewTitle addSubview:labeltitle];
    labeltitle.text = [NSString stringWithFormat:@"标题:%@",_strTitle];
    labeltitle.textAlignment = NSTextAlignmentCenter;
    labeltitle.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    UILabel* labelArea = [[UILabel alloc]initWithFrame:CGRectMake(0, 25*ScreenWidth/375, ScreenWidth/2 + 60*ScreenWidth/375, 25*ScreenWidth/375)];
    [viewTitle addSubview:labelArea];
    labelArea.text = _strBallName;
    labelArea.textAlignment = NSTextAlignmentCenter;
    labelArea.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 60*ScreenWidth/375, 25*ScreenWidth/375, ScreenWidth/2 - 60*ScreenWidth/375, 25*ScreenWidth/375)];
    [viewTitle addSubview:_labelTime];
    if ([Helper isBlankString:_strDate]) {
        _labelTime.text = @"暂无时间";
    }
    else
    {
        _labelTime.text = _strDate;
    }
    
    _labelTime.textAlignment = NSTextAlignmentCenter;
    _labelTime.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    
}
#pragma mark --创建最上方成员视图
-(void)createViewScoTitle
{
    
    _viewBaseName = [[UIView alloc]initWithFrame:CGRectMake(0, 50*ScreenWidth/375, ScreenWidth, 50*ScreenWidth/375)];
    _viewBaseName.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_viewBaseName];
    
    for (int i = 0; i < 2; i++) {
        NSArray* titleArr = @[@"Hole",@"Par",@"球洞",@"标准杆"];
        UILabel *labeltitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375+61*ScreenWidth/375*i, 5*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
        labeltitle.text = titleArr[i];
        labeltitle.textAlignment = NSTextAlignmentCenter;
        labeltitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewBaseName addSubview:labeltitle];
        
        UILabel* labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375+61*ScreenWidth/375*i, 25*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
        labelDetail.textAlignment = NSTextAlignmentCenter;
        labelDetail.text = titleArr[i+2];
        labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewBaseName addSubview:labelDetail];
    }
    //创建最上方的人员头像和添加按钮
    for (int i = 0; i < 4; i++) {
        if (i == 0) {
            _imgvSelf = [[UIImageView alloc]initWithFrame:CGRectMake(140*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375)];
            
            [_viewBaseName addSubview:_imgvSelf];
            
            [_arrayId addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]];
            _imgvSelf.layer.masksToBounds = YES;
            _imgvSelf.layer.cornerRadius = _imgvSelf.frame.size.height/2;
            
            _labelSelfName = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
            _labelSelfName.textAlignment = NSTextAlignmentCenter;
            _labelSelfName.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            [_viewBaseName addSubview:_labelSelfName];
            
            
        }
        else if (i == 1)
        {
            _buttonImg2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_buttonImg2 setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
            
            [_buttonImg2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 8*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_viewBaseName addSubview:_buttonImg2];
            [_buttonImg2 addTarget:self action:@selector(btnImgvClick2:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImg2.tag = 1002;
        }
        else if (i == 2)
        {
            _buttonImg3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_buttonImg3 setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
            
            _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 8*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_buttonImg3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_viewBaseName addSubview:_buttonImg3];
            //            if (_isaddImgv2 == NO) {
            //                [_buttonImg3 addTarget:self action:@selector(btnImgvClick2:) forControlEvents:UIControlEventTouchUpInside];
            //                 _buttonImg3.tag = 1002;
            //            }
            //            else
            //            {
            [_buttonImg3 addTarget:self action:@selector(btnImgvClick3:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImg3.tag = 1003;
            //            }
        }
        else
        {
            _buttonImg4 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_buttonImg4 setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
    
            _buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 8*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_buttonImg4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
            [_viewBaseName addSubview:_buttonImg4];

            [_buttonImg4 addTarget:self action:@selector(btnImgvClick4:) forControlEvents:UIControlEventTouchUpInside];
            _buttonImg4.tag = 1004;
            
        }
        
    }
    
    
}
/**
 *  头像按钮点击事件
 *
 *  @param btn
 */
#pragma mark --最上方头像和添加点击事件
-(void)btnImgvClick2:(UIButton *)btn
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    //[alertView setDelegate:self];
    
    _btnIndex = btn.tag-1000;
    //    ////NSLog(@"%ld",_btnIndex);
    alertView.delegate = self;
    [alertView setContainerView:[self createAddPeopleView]];
    [alertView show];
}
-(void)btnImgvClick3:(UIButton *)btn
{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    //[alertView setDelegate:self];
    alertView.delegate = self;
    if ([_isSave integerValue] != 10) {
        if (_isaddImgv2 == NO) {
            _btnIndex = 2;
        }
        else
        {
            _btnIndex = btn.tag-1000;
        }
    }
    else
    {
        if (_isPeople2 == NO && _isPeople3 == NO) {
            _btnIndex = 2;
        }
        else if (_isPeople2 == YES && _isPeople3 == NO)
        {
            _btnIndex = 3;
        }
        else
        {
            _btnIndex = btn.tag-1000;
        }

    }
    //    ////NSLog(@"%ld",_btnIndex);
    [alertView setContainerView:[self createAddPeopleView]];
    [alertView show];
}
-(void)btnImgvClick4:(UIButton *)btn
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    //[alertView setDelegate:self];
    alertView.delegate = self;
    if ([_isSave integerValue] != 10) {
        if (_isaddImgv2 == NO) {
            _btnIndex = 2;
        }
        else if (_isaddImgv3 == NO)
        {
            _btnIndex = 3;
        }
        else
        {
            _btnIndex = btn.tag-1000;
        }
    }
    else
    {
        if (_isPeople2 == NO && _isPeople3 == NO && _isPeople4 == NO) {
            _btnIndex = 2;
        }
        else if (_isPeople2 == NO && _isPeople3 == NO)
        {
            _btnIndex = 3;
        }
        else if (_isPeople2 == NO && _isPeople3 == NO && _isPeople4 == NO)
        {
            _btnIndex = btn.tag-1000;
        }
        else
        {
            
        }
    }
    
    
    [alertView setContainerView:[self createAddPeopleView]];
    [alertView show];
}
#pragma mark --弹窗
- (UIView *)createAddPeopleView
{
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300*ScreenWidth/375, 100*ScreenWidth/375)];
    //    moneyView.backgroundColor = [UIColor redColor];
    //标题
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, addView.frame.size.width, 30*ScreenWidth/375)];
    labelTitle.text = @"添加打球人";
    labelTitle.textColor = [UIColor purpleColor];
    labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [addView addSubview:labelTitle];
    //划线
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29*ScreenWidth/375, addView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [labelTitle addSubview:lineView];
    
    //提示信息
    UILabel *labelNews = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 50*ScreenWidth/375, 150*ScreenWidth/375, 30*ScreenWidth/375)];
    labelNews.text = @"请输入添加人手机号";
    labelNews.textColor = [UIColor lightGrayColor];
    labelNews.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [addView addSubview:labelNews];
    
    //textfield
    _textPrice = [[UITextField alloc]initWithFrame:CGRectMake(150*ScreenWidth/375, 50*ScreenWidth/375, 130*ScreenWidth/375, 30*ScreenWidth/375)];
    _textPrice.placeholder = @"请输入手机号";
    _textPrice.backgroundColor = [UIColor clearColor];
    _textPrice.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPrice.textAlignment = NSTextAlignmentRight;
    _textPrice.tag = 124;
    _textPrice.textAlignment = NSTextAlignmentCenter;
    _textPrice.delegate = self;
    [addView addSubview:_textPrice];
    _textPrice.borderStyle = UITextBorderStyleLine;

    return addView;
}
//弹窗点击确定后的点击事件，刷新数据，添加新的打球人的积分卡
#pragma mark --弹窗点击事件
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:124];
    //    UIButton* btn = [[UIButton alloc]init];
    [textField resignFirstResponder];
    
    if (buttonIndex == 1) {
        
        
        
        if ([Helper testMobileIsTrue:_textPrice.text] == YES) {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"scoreWhoScoreUserId"];
            [dict setObject:_textPrice.text forKey:@"scoreScoreMobile"];
            [dict setObject:_scoreObjectId forKey:@"scoreObjectId"];
            ;
            [dict setObject:_strTitle forKey:@"scoreObjectTitle"];
            [dict setObject:_ballId forKey:@"scoreballId"];
            [dict setObject:_strBallName forKey:@"scoreballName"];
            [dict setObject:_strSite0 forKey:@"scoreSite0"];
            [dict setObject:_strSite1 forKey:@"scoreSite1"];
            [dict setObject:_strTee forKey:@"scoreTTaiwan"];
            [dict setObject:_strType forKey:@"scoreType"];
            [dict setObject:@2 forKey:@"scoreIsSimple"];
            [dict setObject:@0 forKey:@"scoreIsClaim"];
            
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:_textPrice.text forKey:@"scoreScoreMobile"];
            [user synchronize];
            
            //点击第二个按钮添加打球人
            if (_btnIndex == 2) {
                [self progress];
                //根据手机号添加打球人
                [[PostDataRequest sharedInstance] postDataRequest:@"score/getUserMobile.do" parameter:@{@"mobile":_textPrice.text,@"type":_strType,@"objid":_scoreObjectId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
                    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([[dictData objectForKey:@"success"] integerValue] == 1) {
                        
                        ScorePeopleModel *model = [[ScorePeopleModel alloc] init];
                        [model setValuesForKeysWithDictionary:[dictData objectForKey:@"rows"]];
                        [_dataArray1 addObject:model];
                        
                        
                        //添加的打球人积分卡
                        [[PostDataRequest sharedInstance]postDataRequest:@"score/save.do" parameter:dict success:^(id respondsData) {
                            NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            ////NSLog(@"%@",[dictD objectForKey:@"message"]);
                            //NSLog(@"11%@",_dataArray1[0]);
                            if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                                _isaddImgv2 = YES;
                                [_buttonImg2 sd_setImageWithURL:[Helper imageIconUrl:[_dataArray1[0] pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                                _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                                _buttonImg2.imageView.layer.cornerRadius = _buttonImg2.imageView.frame.size.height/2;
                                _buttonImg2.imageView.layer.masksToBounds = YES;
                                _buttonImg2.userInteractionEnabled = NO;
                                _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                                _labelDetail.textAlignment = NSTextAlignmentCenter;
                                _labelDetail.text = [_dataArray1[0] userName];
                                _labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                                [_viewBaseName addSubview:_labelDetail];
                                //NSLog(@"%@",_labelDetail.text);
                                if ([_isSave integerValue] != 10) {
                                    [_arrayName addObject:_labelDetail.text];
                                    [_arrayMobile addObject:_textPrice.text];
                                }
                                if (_dataArray1.count) {
                                    if ([_dataArray1[0] userId] == nil) {
                                        [_arrayUserId addObject:@0];
                                    }
                                    else
                                    {
                                        [_arrayUserId addObject:[_dataArray1[0] userId]];
                                    }
                                }
                                
                                
                                
                                [self prepareData];
                            }
                            else
                            {
                                
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                    }

                } failed:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
                
            }
            //点击第三个按钮添加打球人
            else if (_btnIndex == 3)
            {
                [self progress];
                //根据手机号添加打球人
                [[PostDataRequest sharedInstance] postDataRequest:@"score/getUserMobile.do" parameter:@{@"mobile":_textPrice.text,@"type":_strType,@"objid":_scoreObjectId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
                    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([[dictData objectForKey:@"success"] integerValue] == 1) {
                        
                        ScorePeopleModel *model = [[ScorePeopleModel alloc] init];
                        [model setValuesForKeysWithDictionary:[dictData objectForKey:@"rows"]];
                        [_dataArray2 addObject:model];
                        
                        
                        [[PostDataRequest sharedInstance]postDataRequest:@"score/save.do" parameter:dict success:^(id respondsData) {
                            NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            ////NSLog(@"%@",[dictD objectForKey:@"message"]);
                            ////NSLog(@"11%@",dictD);
                            if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                                
                                //                        }
                                _isaddImgv3 = YES;
                                [_buttonImg3 sd_setImageWithURL:[Helper imageIconUrl:[_dataArray2[0] pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                                _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                                _buttonImg3.imageView.layer.cornerRadius = _buttonImg3.imageView.frame.size.height/2;
                                _buttonImg3.imageView.layer.masksToBounds = YES;
                                _buttonImg3.userInteractionEnabled = NO;
                                _labelDetail1 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*2, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                                _labelDetail1.textAlignment = NSTextAlignmentCenter;
                                _labelDetail1.text = [_dataArray2[0] userName];
                                _labelDetail1.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                                [_viewBaseName addSubview:_labelDetail1];
                                if ([_isSave integerValue] != 10) {
                                    [_arrayName addObject:_labelDetail1.text];
                                    [_arrayMobile addObject:_textPrice.text];
                                }
                                
                                if (_dataArray2.count != 0) {
                                    if ([_dataArray2[0] userId] == nil) {
                                        [_arrayUserId addObject:@0];
                                    }
                                    else
                                    {
                                        [_arrayUserId addObject:[_dataArray2[0] userId]];
                                    }
                                }
                                
                                
                                [self prepareData];
                            }
                            else
                            {
                                
                            }
                            
                            
                        } failed:^(NSError *error) {
                            
                        }];
                    }
                } failed:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
                
                
            }
            //点击第四个按钮添加打球人
            else
            {
                [self progress];
                //根据手机号添加打球人
                [[PostDataRequest sharedInstance] postDataRequest:@"score/getUserMobile.do" parameter:@{@"mobile":_textPrice.text,@"type":_strType,@"objid":_scoreObjectId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
                    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    //添加成功后添加这个人的积分卡
                    if ([[dictData objectForKey:@"success"] integerValue] == 1) {
                        
                        ScorePeopleModel *model = [[ScorePeopleModel alloc] init];
                        [model setValuesForKeysWithDictionary:[dictData objectForKey:@"rows"]];
                        [_dataArray3 addObject:model];
                        
                        
                        [[PostDataRequest sharedInstance]postDataRequest:@"score/save.do" parameter:dict success:^(id respondsData) {
                            NSDictionary *dictD = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            ////NSLog(@"%@",[dictD objectForKey:@"message"]);
                            ////NSLog(@"11%@",dictD);
                            if ([[dictD objectForKey:@"success"] integerValue] == 1) {
                                
                                //                        }
                                _isaddImgv4 = YES;
                                [_buttonImg4 sd_setImageWithURL:[Helper imageIconUrl:[_dataArray3[0] pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                                _buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                                _buttonImg4.imageView.layer.cornerRadius = _buttonImg4.imageView.frame.size.height/2;
                                _buttonImg3.imageView.layer.masksToBounds = YES;
                                _buttonImg4.userInteractionEnabled = NO;
                                _labelDetail2 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*3, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                                _labelDetail2.textAlignment = NSTextAlignmentCenter;
                                _labelDetail2.text = [_dataArray3[0] userName];
                                _labelDetail2.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                                [_viewBaseName addSubview:_labelDetail2];
                                //NSLog(@"%@",_labelDetail2.text);
                                if ([_isSave integerValue] != 10) {
                                    [_arrayName addObject:_labelDetail2.text];
                                    [_arrayMobile addObject:_textPrice.text];
                                }
                                
                                if (_dataArray2.count != 0) {
                                    if ([_dataArray3[0] userId] == nil) {
                                        [_arrayUserId addObject:@0];
                                    }
                                    else
                                    {
                                        [_arrayUserId addObject:[_dataArray3[0] userId]];
                                    }
                                }
                                [self prepareData];
                            }
                            else
                            {
                                
                            }
                            
                            
                        } failed:^(NSError *error) {
                            
                        }];
                    }
                } failed:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
                
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的手机号输入错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        
    }
    
    [alertView close];
}



#pragma mark --tableview方法
-(void)prepareData
{

    [_dataArrayList0 removeAllObjects];
    [_dataArrayList1 removeAllObjects];
    [_dataArrayList2 removeAllObjects];
    [_dataArrayList3 removeAllObjects];
    [_dataArrayPro removeAllObjects];
    [_dataArray removeAllObjects];
    [self progress];
    [[PostDataRequest sharedInstance]postDataRequest:@"score/queryByIne.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"scoreObjectId":_scoreObjectId,@"scoreType":_strType} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            //显示有几个专业记分的人数
            for (NSDictionary* dictD  in [dict[@"rows"] objectForKey:@"result"])
            {
                ScoreProModel *model = [[ScoreProModel alloc] init];
                [model setValuesForKeysWithDictionary:dictD];
                [_dataArrayPro addObject:model];
            }
            if([[_dataArrayPro[0] notcp]integerValue] == 0)
            {
                
                [_btnOver setTitle:@"完成" forState:UIControlStateNormal];
            }
            else if ([[_dataArrayPro[0] notcp]integerValue] == -1)
            {
                _isFinish = YES;
            }
            else
            {
                [_btnOver setTitle:@"保存" forState:UIControlStateNormal];
            }

            arratIds = [dict[@"rows"] objectForKey:@"scoreIds"];
            
            _labelTime.text = [_dataArrayPro[0] scoreCreateTime];
            if (_arrayMobile.count == 0) {
                //设置自己的头像和姓名
                [_imgvSelf sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[0] userPic]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                _labelSelfName.text = [_dataArrayPro[0] userName];
                //把头像和姓名存入数组
                if (![Helper isBlankString:[_dataArrayPro[0] userName]]) {
                    [_arrayName addObject:[_dataArrayPro[0] userName]];
                }
                if (![Helper isBlankString:[_dataArrayPro[0] userMobile]]) {
                     [_arrayMobile addObject:[_dataArrayPro[0] userMobile]];
                }

            }
            
            
            //只有自己
            if (_dataArrayPro.count == 1) {
                for (NSDictionary* dictData in [_dataArrayPro[0] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList0 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList0[0] professionalScoreId]];
            }
            //两个打球人
            else if (_dataArrayPro.count == 2)
            {
                for (NSDictionary* dictData in [_dataArrayPro[0] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList0 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList0[0] professionalScoreId]];
                for (NSDictionary* dictData in [_dataArrayPro[1] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList1 addObject:modelList];
                    
                }
                if ([_isSave integerValue] == 10) {
                    //当有未完成记分的时候，刷新表头的头像，并且赋值
                    _isaddImgv2 = YES;
                    
                    [_buttonImg2 sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[1] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                    _buttonImg2.imageView.layer.cornerRadius = _buttonImg2.imageView.frame.size.height/2;
                    _buttonImg2.imageView.layer.masksToBounds = YES;
                    _buttonImg2.userInteractionEnabled = NO;
                    //把视图删除，重复创建会覆盖
                    [_labelDetail removeFromSuperview];
                    _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                    _labelDetail.textAlignment = NSTextAlignmentCenter;
                    _labelDetail.text = [_dataArrayPro[1] userName];
                    _labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [_viewBaseName addSubview:_labelDetail];
                    //当没有保存过的时候需要保存，一旦保存过则不要
                    if (_isPeople2 == NO) {
                        [_arrayName addObject:[_dataArrayPro[1] userName]];
                        [_arrayMobile addObject:[_dataArrayPro[1] userMobile]];
                        _isPeople2 = YES;
                    }
                    
                    if (_dataArray1.count) {
                        if ([_dataArray1[0] userId] == nil) {
                            [_arrayUserId addObject:@0];
                        }
                        else
                        {
                            [_arrayUserId addObject:[_dataArray1[0] userId]];
                        }
                    }

                }
                
                [_arrayCardId addObject:[_dataArrayList1[0] professionalScoreId]];
            }
            //三个打球人
            else if (_dataArrayPro.count == 3)
            {
                for (NSDictionary* dictData in [_dataArrayPro[0] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList0 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList0[0] professionalScoreId]];
                for (NSDictionary* dictData in [_dataArrayPro[1] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList1 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList1[0] professionalScoreId]];
                for (NSDictionary* dictData in [_dataArrayPro[2] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList2 addObject:modelList];
                }
                
                if ([_isSave integerValue] == 10) {
                    //第二个人
                    //当有未完成记分的时候，刷新表头的头像，并且赋值
                    _isaddImgv2 = YES;
                    
                    [_buttonImg2 sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[1] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                    _buttonImg2.imageView.layer.cornerRadius = _buttonImg2.imageView.frame.size.height/2;
                    _buttonImg2.imageView.layer.masksToBounds = YES;
                    _buttonImg2.userInteractionEnabled = NO;
                    //把视图删除，重复创建会覆盖
                    [_labelDetail removeFromSuperview];
                    _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                    _labelDetail.textAlignment = NSTextAlignmentCenter;
                    _labelDetail.text = [_dataArrayPro[1] userName];
                    _labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [_viewBaseName addSubview:_labelDetail];
                    //当没有保存过的时候需要保存，一旦保存过则不要
                    if (_isPeople2 == NO) {
                        [_arrayName addObject:[_dataArrayPro[1] userName]];
                        [_arrayMobile addObject:[_dataArrayPro[1] userMobile]];
                        _isPeople2 = YES;
                    }
                    
                    if (_dataArray1.count) {
                        if ([_dataArray1[0] userId] == nil) {
                            [_arrayUserId addObject:@0];
                        }
                        else
                        {
                            [_arrayUserId addObject:[_dataArray1[0] userId]];
                        }
                    }
                    
                    //第三个人的头像信息
                    _isaddImgv3 = YES;
                    [_buttonImg3 sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[2] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                    _buttonImg3.imageView.layer.cornerRadius = _buttonImg3.imageView.frame.size.height/2;
                    _buttonImg3.imageView.layer.masksToBounds = YES;
                    _buttonImg3.userInteractionEnabled = NO;
                    [_labelDetail1 removeFromSuperview];
                    _labelDetail1 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*2, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                    _labelDetail1.textAlignment = NSTextAlignmentCenter;
                    _labelDetail1.text = [_dataArrayPro[2] userName];
                    _labelDetail1.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [_viewBaseName addSubview:_labelDetail1];
                    //当没有保存过的时候需要保存，一旦保存过则不要
                    if (_isPeople3 == NO) {
                        [_arrayName addObject:[_dataArrayPro[2] userName]];
                        [_arrayMobile addObject:[_dataArrayPro[2] userMobile]];
                        _isPeople3 = YES;
                    }
                    if (_dataArray1.count) {
                        if ([_dataArray2[0] userId] == nil) {
                            [_arrayUserId addObject:@0];
                        }
                        else
                        {
                            [_arrayUserId addObject:[_dataArray2[0] userId]];
                        }
                    }
                    
                    
                }
                
                
                
                
                
                [_arrayCardId addObject:[_dataArrayList2[0] professionalScoreId]];
            }
            //四个打球人
            else if (_dataArrayPro.count == 4)
            {
                for (NSDictionary* dictData in [_dataArrayPro[0] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList0 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList0[0] professionalScoreId]];
                for (NSDictionary* dictData in [_dataArrayPro[1] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList1 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList1[0] professionalScoreId]];
                for (NSDictionary* dictData in [_dataArrayPro[2] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList2 addObject:modelList];
                }
                [_arrayCardId addObject:[_dataArrayList2[0] professionalScoreId]];
                for (NSDictionary* dictData in [_dataArrayPro[3] list]) {
                    ScoreProListModel* modelList = [[ScoreProListModel alloc]init];
                    [modelList setValuesForKeysWithDictionary:dictData];
                    [_dataArrayList3 addObject:modelList];
                }
                
                
                
                if ([_isSave integerValue] == 10) {
                    //第二个人
                    //当有未完成记分的时候，刷新表头的头像，并且赋值
                    _isaddImgv2 = YES;
                    
                    [_buttonImg2 sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[1] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    _buttonImg2.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                    _buttonImg2.imageView.layer.cornerRadius = _buttonImg2.imageView.frame.size.height/2;
                    _buttonImg2.imageView.layer.masksToBounds = YES;
                    _buttonImg2.userInteractionEnabled = NO;
                    //把视图删除，重复创建会覆盖
                    [_labelDetail removeFromSuperview];
                    _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                    _labelDetail.textAlignment = NSTextAlignmentCenter;
                    _labelDetail.text = [_dataArrayPro[1] userName];
                    _labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [_viewBaseName addSubview:_labelDetail];
                    //当没有保存过的时候需要保存，一旦保存过则不要
                    if (_isPeople2 == NO) {
                        [_arrayName addObject:[_dataArrayPro[1] userName]];
                        [_arrayMobile addObject:[_dataArrayPro[1] userMobile]];
                        _isPeople2 = YES;
                    }
                    if (_dataArray1.count) {
                        if ([_dataArray1[0] userId] == nil) {
                            [_arrayUserId addObject:@0];
                        }
                        else
                        {
                            [_arrayUserId addObject:[_dataArray1[0] userId]];
                        }
                    }
                    
                    //第三个人的头像信息
                    _isaddImgv3 = YES;
                    [_buttonImg3 sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[2] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    _buttonImg3.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*2, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                    _buttonImg3.imageView.layer.cornerRadius = _buttonImg3.imageView.frame.size.height/2;
                    _buttonImg3.imageView.layer.masksToBounds = YES;
                    _buttonImg3.userInteractionEnabled = NO;
                    [_labelDetail1 removeFromSuperview];
                    _labelDetail1 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*2, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                    _labelDetail1.textAlignment = NSTextAlignmentCenter;
                    _labelDetail1.text = [_dataArrayPro[2] userName];
                    _labelDetail1.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [_viewBaseName addSubview:_labelDetail1];
                    //当没有保存过的时候需要保存，一旦保存过则不要
                    if (_isPeople3 == NO) {
                        [_arrayName addObject:[_dataArrayPro[2] userName]];
                        [_arrayMobile addObject:[_dataArrayPro[2] userMobile]];
                        _isPeople3 = YES;
                    }
                    if (_dataArray1.count) {
                        if ([_dataArray2[0] userId] == nil) {
                            [_arrayUserId addObject:@0];
                        }
                        else
                        {
                            [_arrayUserId addObject:[_dataArray2[0] userId]];
                        }
                    }
  
                    _isaddImgv4 = YES;
                    [_buttonImg4 sd_setImageWithURL:[Helper imageIconUrl:[_dataArrayPro[3] userPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
                    _buttonImg4.frame = CGRectMake(140*ScreenWidth/375 + 61*ScreenWidth/375*3, 2*ScreenWidth/375, 33*ScreenWidth/375, 33*ScreenWidth/375);
                    _buttonImg4.imageView.layer.cornerRadius = _buttonImg4.imageView.frame.size.height/2;
                    _buttonImg4.imageView.layer.masksToBounds = YES;
                    _buttonImg4.userInteractionEnabled = NO;
                    [_labelDetail2 removeFromSuperview];
                    _labelDetail2 = [[UILabel alloc]initWithFrame:CGRectMake(132*ScreenWidth/375 + 61*ScreenWidth/375*3, 35*ScreenWidth/375, 50*ScreenWidth/375, 15*ScreenWidth/375)];
                    _labelDetail2.textAlignment = NSTextAlignmentCenter;
                    _labelDetail2.text = [_dataArrayPro[3] userName];
                    _labelDetail2.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
                    [_viewBaseName addSubview:_labelDetail2];
                    //当没有保存过的时候需要保存，一旦保存过则不要
                    if (_isPeople4 == NO) {
                        [_arrayName addObject:[_dataArrayPro[3] userName]];
                        [_arrayMobile addObject:[_dataArrayPro[3] userMobile]];
                        _isPeople4 = YES;
                    }
                    if (_dataArray3.count != 0) {
                        if ([_dataArray3[0] userId] == nil) {
                            [_arrayUserId addObject:@0];
                        }
                        else
                        {
                            [_arrayUserId addObject:[_dataArray3[0] userId]];
                        }
                    }
                    
                    
                }

                [_arrayCardId addObject:[_dataArrayList3[0] professionalScoreId]];
            }
            else
            {
                
            }
            
            
            for (NSDictionary* dictD  in [[dict objectForKey:@"rows"] objectForKey:@"standard"])
            {
                ScoreProStandedModel *model = [[ScoreProStandedModel alloc] init];
                [model setValuesForKeysWithDictionary:dictD];
                [_dataArray addObject:model];
            }
            
            [_tableView reloadData];
            
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 19*50*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.delaysContentTouches = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_tableView];
    
    
    _btnOver = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnOver.frame = CGRectMake(10*ScreenWidth/375, 19*50*ScreenWidth/375 + 10*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 50*ScreenWidth/375);
    [_scrollView addSubview:_btnOver];
    [_btnOver setTitle:@"完成" forState:UIControlStateNormal];
    [_btnOver setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnOver.backgroundColor = [UIColor orangeColor];
    _btnOver.layer.cornerRadius = 8*ScreenWidth/375;
    _btnOver.layer.masksToBounds = YES;
    [_btnOver addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView.contentSize = CGSizeMake(0, 19*50*ScreenWidth/375+20*ScreenWidth/375);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 19;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfScoreTableViewCell* cell = [[SelfScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    //标准杆
    if (_dataArray.count != 0) {
        if (indexPath.row < 19) {
            [cell showStanded:_dataArray[indexPath.row]];
        }
    }
    //分数
    if (_dataArrayList0.count != 0) {
        if (indexPath.row < 19) {
            [cell showScoreData:_dataArrayList0[indexPath.row]];
        }
    }else{
        
    }
    if (_dataArrayList1.count != 0) {
        if (indexPath.row < 19) {
            [cell showScore1Data:_dataArrayList1[indexPath.row]];
        }
    }else{
        
    }
    if (_dataArrayList2.count != 0) {
        if (indexPath.row < 19) {
            [cell showScore2Data:_dataArrayList2[indexPath.row]];
        }
    }else{
        
    }
    if (_dataArrayList3.count != 0) {
        if (indexPath.row < 19) {
            [cell showScore3Data:_dataArrayList3[indexPath.row]];
        }
    }else{
        
    }

    if (indexPath.row < 9) {
        cell.labelHole.text = [NSString stringWithFormat:@"A%ld",indexPath.row + 1];
    }else if (indexPath.row >= 9 && indexPath.row < 18){
        cell.labelHole.text = [NSString stringWithFormat:@"B%ld",indexPath.row - 8];
    }else{
        cell.labelHole.text = @"总计";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 18) {
        ScoreWriteProController* scVc = [[ScoreWriteProController alloc]init];
        scVc.arrayId = _arrayId;
        scVc.arrayName = _arrayName;
        scVc.arrayMobile = _arrayMobile;
        scVc.clickNum = indexPath.row + 1;
        
        
        scVc.array1 = [[NSMutableArray alloc]init];
        scVc.array2 = [[NSMutableArray alloc]init];
        scVc.array3 = [[NSMutableArray alloc]init];
        scVc.array4 = [[NSMutableArray alloc]init];
        scVc.arrayStand = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < _dataArrayList0.count; i++) {
            [scVc.array1 addObject:_dataArrayList0[i]];
        }
        for (int i = 0; i < _dataArrayList1.count; i++) {
            [scVc.array2 addObject:_dataArrayList1[i]];
        }
        for (int i = 0; i < _dataArrayList2.count; i++) {
            [scVc.array3 addObject:_dataArrayList2[i]];
        }
        for (int i = 0; i < _dataArrayList3.count; i++) {
            [scVc.array4 addObject:_dataArrayList3[i]];
        }
        for (int i = 0; i < _dataArray.count; i++) {
            
            [scVc.arrayStand addObject:[_dataArray[i] professionalStandardlever]];
        }
        
        scVc.strType = _strType;
        
        
        
        
        [self.navigationController pushViewController:scVc animated:YES];
    }
    
}

#pragma mark --点击记分完成按钮
-(void)finishClick
{
    
    if ([[_dataArrayPro[0] notcp] integerValue] == 0) {
        [self progress];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        //记分卡id
        //    [dict setObject: forKey:@"ids"];
        NSString *strCard = [arratIds componentsJoinedByString:@","];
        [dict setObject:strCard forKey:@"ids"];
        
        
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        
        [dict setObject:[NSString stringWithFormat:@"您的好友%@帮您记录了一次打球分数",_arrayName[0]] forKey:@"message"];
        
        NSString *strStreet = [_arrayUserId componentsJoinedByString:@","];
        [dict setObject:strStreet forKey:@"userIds"];
        
        [dict setObject:_strTitle forKey:@"title"];

        [[PostDataRequest sharedInstance] postDataRequest:@"score/jfend.do" parameter:dict success:^(id respondsData) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                //            [self.navigationController popToRootViewControllerAnimated:YES];
                
                _isFinish = YES;
                
                
                ScoreFootViewController* footVc = [[ScoreFootViewController alloc]init];
                ////NSLog(@"%@",_strDate);
                if (![Helper isBlankString:[_dataArrayPro[0] scoreCreateTime]]) {
                    footVc.strTime = [_dataArrayPro[0] scoreCreateTime];
                }
                
                

                footVc.strNums = [NSString stringWithFormat:@"%@",[_dataArrayList0[18] professionalPolenumber]];
                footVc.strBallName = _strBallName;
                footVc.ballId = _ballId;
                
                //          删除保存到本地的数据
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                
                [user removeObjectForKey:@"scoreWhoScoreUserId"];
                [user removeObjectForKey:@"scoreScoreMobile"];
                [user removeObjectForKey:@"scoreObjectId"];
                [user removeObjectForKey:@"scoreObjectTitle"];
                [user removeObjectForKey:@"scoreballId"];
                [user removeObjectForKey:@"scoreballName"];
                [user removeObjectForKey:@"scoreSite0"];
                [user removeObjectForKey:@"scoreSite1"];
                [user removeObjectForKey:@"scoreTTaiwan"];
                [user removeObjectForKey:@"scoreType"];
                [user removeObjectForKey:@"scoreIsSimple"];
                [user removeObjectForKey:@"scoreIsClaim"];
                [user synchronize];
                
                [self.navigationController pushViewController:footVc animated:YES];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        } failed:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
