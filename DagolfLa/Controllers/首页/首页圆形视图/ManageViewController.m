//
//  ManageViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageViewController.h"
//赛事的搜索界面
#import "ManageSearchViewController.h"
//赛事详情界面
#import "ManageDetailController.h"
//赛事创建界面
#import "ManageCreateController.h"
//我的赛事界面
#import "ManageForMeController.h"

#import "ManageMainTableCell.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "PostDataRequest.h"
#import "Helper.h"

#import "CustomIOSAlertView.h"

#import "GameModel.h"


#import "YueBallHallView.h"
#import "ManageForMeController.h"


//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface ManageViewController ()<UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate,UITextFieldDelegate>
{
    UISearchController* _controller;
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataLastArr;
    
    UIView* _viewMore;
    BOOL _showView;
    BOOL _isChooseView;
    UIView* _cityChooseView;
    YueBallHallView *_viewTanTu;
    
    UIButton* _btnLeft,*_btnCenter,*_btnRight;
    UIImageView * _imgvJtCent;
    UIImageView * _imgvJtRight;
    
    UIImageView* _imgvBackG;
    NSInteger _indexNum;
    BOOL _isTimeClick;
    BOOL _isDisClick;
    
    //通知是否有赛事的弹窗
    CustomIOSAlertView* _alertView;
    
    NSInteger _page;
    //搜索输入框
    UITextField *_textField;
    //弹出框
    UIAlertView *_alert;
    //判断弹窗有没有创建过
    BOOL _isCreate;
    NSMutableDictionary* _dict;
    
    BOOL _isChooseType, _isChooseState;
    
}
@end

@implementation ManageViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _showView = NO;
    _viewMore.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _dict = [[NSMutableDictionary alloc]init];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.view addSubview:view];
    
    _dataArray = [[NSMutableArray alloc]init];
    _dataLastArr = [[NSMutableArray alloc]init];
    
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.title = @"赛事大厅";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiRefreshing) name:@"Refreshing" object:nil];

    
    //搜索框
    [self createSeachBar];
    //分段和筛选
    [self createSegmentAndChoose];
    //发布
    [self createFabu];
    
    //列表
    [self uiConfig];
    
//    [self createBtnView];
    
    _isChooseView = NO;
    _cityChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375)];
//    _cityChooseView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_cityChooseView];
    
}

-(void)notiRefreshing{
    [_tableView.header endRefreshing];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refreshing" object:nil];
}


-(void)ShowViewClick{
    if (_showView == NO) {
        _viewMore.hidden = NO;
        _showView = YES;
        if (_viewTanTu) {
            _viewTanTu.hidden = NO;
        } else {
            if (_isCreate == NO) {
                [self createBtnView];
            }
            else
            {
                _viewTanTu.hidden = YES;
            }
        }
        [self.view endEditing:YES];
    }
    else
    {
        _showView = NO;
        _viewMore.hidden = YES;
        _viewTanTu.hidden = YES;
    }
}

//自定义searchbar
#pragma mark --自定义searchbar
-(void)createSeachBar{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37)];
    view.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f];
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13*ScreenWidth/375, 5, ScreenWidth-80*ScreenWidth/375, 27)];
    imageView.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    imageView.layer.cornerRadius=13;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 4, 16*ScreenWidth/375, 16);
    [imageView addSubview:imageView2];
    
    _textField=[[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 26)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    _textField.delegate = self;
//    [_textField addTarget:self action:@selector(keyboardDown3:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入赛事名称进行搜索";
    [imageView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 3, 60*ScreenWidth/375, 30);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _showView = NO;
    _viewTanTu.hidden = YES;
    return YES;
}
-(void)seachButtonClick{
    [_textField resignFirstResponder];
    // 延迟几秒，为了键盘消失， alertview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
                [_tableView.header endRefreshing];
                _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
                //                _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
                [_tableView.header beginRefreshing];
            }else{
                //空白搜索
            }
        
    });

}
-(BOOL)isBlankString:(NSString *)string{
    if (string==nil||string==NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark --分段选择
-(void)createSegmentAndChoose
{
    UIView* viewSeg = [[UIView alloc]initWithFrame:CGRectMake(0, 37, ScreenWidth, 40)];
    viewSeg.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [self.view addSubview:viewSeg];
    
    
    _imgvBackG = [[UIImageView alloc]initWithFrame:CGRectMake(13*ScreenWidth/375, 5, ScreenWidth-120*ScreenWidth/375, 30)];
    _imgvBackG.image = [UIImage imageNamed:@"leftSeg"];
    _imgvBackG.userInteractionEnabled = YES;
    [viewSeg addSubview:_imgvBackG];
    //    CALayer *imgvLayer = [imgv layer];
    //    [imgvLayer setBorderColor:[UIColor lightGrayColor].CGColor];
    //    [imgvLayer setBorderWidth:1];
    
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLeft.frame = CGRectMake(1, 0, (ScreenWidth-120*ScreenWidth/375)/3-1, 30-1);
    [_btnLeft setTitle:@"时间" forState:UIControlStateNormal];
    [_imgvBackG addSubview:_btnLeft];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    _btnLeft.tag = 124;
    [_btnLeft addTarget:self action:@selector(segmentPostClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _imgvJtCent = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-120*ScreenWidth/375)/3-15, 6, 9, 18)];
    [_btnLeft addSubview:_imgvJtCent];
    _imgvJtCent.image = [UIImage imageNamed:@"shangb"];
    
    
    
    _btnCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCenter.frame = CGRectMake((ScreenWidth-120*ScreenWidth/375)/3, 0, (ScreenWidth-120*ScreenWidth/375)/3, 30);
    [_btnCenter setTitle:@"热门" forState:UIControlStateNormal];
    _btnCenter.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_imgvBackG addSubview:_btnCenter];
    [_btnCenter addTarget:self action:@selector(segmentPostClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnCenter.tag = 123;
    CALayer *buttonLayer = [_btnCenter layer];
    [buttonLayer setBorderColor:[UIColor lightGrayColor].CGColor];
    [buttonLayer setBorderWidth:1];
    
    
    
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake((ScreenWidth-120*ScreenWidth/375)/3*2, 0, (ScreenWidth-120*ScreenWidth/375)/3-1, 30-1);
    //    btnRight.backgroundColor = [UIColor whiteColor];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_btnRight setTitle:@"距离" forState:UIControlStateNormal];
    [_imgvBackG addSubview:_btnRight];
    [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(segmentPostClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.tag = 125;
    
    
    _imgvJtRight = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-120*ScreenWidth/375)/3-15, 6, 9, 18)];
    [_btnRight addSubview:_imgvJtRight];
    _imgvJtRight.image = [UIImage imageNamed:@"jt_up"];
    
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-80*ScreenWidth/375, 5, 60*ScreenWidth/375, 30);
    SeachButton.layer.masksToBounds = YES;
    SeachButton.layer.cornerRadius = 5;
    [SeachButton setTitle:@"筛选" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    SeachButton.backgroundColor = [UIColor lightGrayColor];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(choosebtnClick) forControlEvents:UIControlEventTouchUpInside];
    [viewSeg addSubview:SeachButton];
    
}



#pragma mark --筛选点击事件
-(void)choosebtnClick
{
    //自定义的显示框
    _alertView = [[CustomIOSAlertView alloc] init];
    _alertView.backgroundColor = [UIColor whiteColor];
    [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定",nil]];//添加按钮
    //[alertView setDelegate:self];
    _alertView.delegate = self;
    [_alertView setContainerView:[self createChooseView]];
    [_alertView show];
}

#pragma mark --自定义UIalert
//自定义alert视图
- (UIView *)createChooseView
{
    UIView* actView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 200*ScreenWidth/375)];
    
    UILabel* labelType = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 80*ScreenWidth/375, 30*ScreenWidth/375)];
    [actView addSubview:labelType];
    labelType.text = @"选择类型:";
    labelType.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    labelType.textColor = [UIColor lightGrayColor];
    
    
    NSArray *arrayType = [[NSArray alloc]initWithObjects:@"直播中",@"未开始",@"已结束",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentType = [[UISegmentedControl alloc]initWithItems:arrayType];
    segmentType.frame = CGRectMake(10*ScreenWidth/375, 50*ScreenWidth/375, ScreenWidth-60*ScreenWidth/375, 40*ScreenWidth/375);
    segmentType.selectedSegmentIndex = 1;//设置默认选择项索引
    segmentType.tintColor = [UIColor colorWithRed:0.63f green:0.63f blue:0.63f alpha:1.00f];
    [actView addSubview:segmentType];
    segmentType.tag = 1088;
    [segmentType addTarget:self action:@selector(segTypeClick:) forControlEvents:UIControlEventValueChanged];
    
    
    UILabel* labelState = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 100*ScreenWidth/375, 80*ScreenWidth/375, 30*ScreenWidth/375)];
    [actView addSubview:labelState];
    labelState.text = @"选择类型:";
    labelState.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    labelState.textColor = [UIColor lightGrayColor];
    
    
    NSArray *arrayState = [[NSArray alloc]initWithObjects:@"不限",@"公开赛",@"私密赛",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentState = [[UISegmentedControl alloc]initWithItems:arrayState];
    segmentState.frame = CGRectMake(10*ScreenWidth/375, 140*ScreenWidth/375, ScreenWidth-60*ScreenWidth/375, 40*ScreenWidth/375);
    segmentState.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentState.tintColor = [UIColor colorWithRed:0.63f green:0.63f blue:0.63f alpha:1.00f];
    [actView addSubview:segmentState];
    segmentState.tag = 1099;
    [segmentState addTarget:self action:@selector(segStateClick:) forControlEvents:UIControlEventValueChanged];
    return actView;
}
-(void)segTypeClick:(UISegmentedControl *)sender
{
    _isChooseType = YES;
//    UISegmentedControl *control = (UISegmentedControl *)sender;
    [_dict setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex + 1] forKeyedSubscript:@"eventisEndStart"];
    
}
-(void)segStateClick:(UISegmentedControl *)sender
{
    _isChooseState = YES;
//    UISegmentedControl *control = (UISegmentedControl *)sender;
    [_dict setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKeyedSubscript:@"eventIsPrivate"];
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    
    if ((int)buttonIndex == 0) {
        
    }
    else
    {
        if (_isChooseType == NO) {
            [_dict setObject:@2 forKeyedSubscript:@"eventisEndStart"];
        }
        if (_isChooseState == NO) {
            [_dict setObject:@1 forKeyedSubscript:@"eventIsPrivate"];
        }
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    }
    [alertView close];
}



-(void)segmentPostClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    //放到中间的热门
    if (btn.tag == 123) {
        _indexNum = 0;
        
        _imgvJtCent.image = [UIImage imageNamed:@"jt_up"];
        _imgvJtRight.image = [UIImage imageNamed:@"jt_up"];
        _imgvBackG.image = [UIImage imageNamed:@"centerSeg"];
        
        [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        //        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
        [_tableView.header beginRefreshing];
    }
    //时间到左边
    else if (btn.tag == 124)
    {
        //        _imgvJtCent.image = [UIImage imageNamed:@"jt_up"];
        _imgvJtRight.image = [UIImage imageNamed:@"jt_up"];
        [_imgvJtCent setTintColor:[UIColor whiteColor]];
        if (_isTimeClick == NO) {
            
            _isTimeClick = YES;
            _indexNum = 2;
            _imgvBackG.image = [UIImage imageNamed:@"leftSeg"];
            _imgvJtCent.image = [UIImage imageNamed:@"shangb"];
            
            [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
            //            _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
            [_tableView.header beginRefreshing];
        }
        else
        {
            _isTimeClick = NO;
            _indexNum = 1;
            _imgvBackG.image = [UIImage imageNamed:@"leftSeg"];
            
            [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _imgvJtCent.image = [UIImage imageNamed:@"xiab"];
            //            [_dataArray removeAllObjects];
            //            [_IconAgreeArr removeAllObjects];
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
            //            _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
            [_tableView.header beginRefreshing];
        }
    }
    else
    {
        _imgvJtCent.image = [UIImage imageNamed:@"jt_up"];
        //        _imgvJtRight.image = [UIImage imageNamed:@"jt_up"];
        if (_isDisClick == NO) {
            _isDisClick = YES;
            _indexNum = 4;
            _imgvBackG.image = [UIImage imageNamed:@"rightSeg"];
            _imgvJtRight.image = [UIImage imageNamed:@"shangb"];
            
            [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            //            [_dataArray removeAllObjects];
            //            [_IconAgreeArr removeAllObjects];
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
            //            _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
            [_tableView.header beginRefreshing];
        }
        else
        {
            _isDisClick = NO;
            _indexNum = 3;
            _imgvBackG.image = [UIImage imageNamed:@"rightSeg"];
            _imgvJtRight.image = [UIImage imageNamed:@"xiab"];
            
            [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [_dataArray removeAllObjects];
            //            [_IconAgreeArr removeAllObjects];
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
            //            _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
            [_tableView.header beginRefreshing];
        }
    }
}



-(void)createFabu
{
    UIView* viewFabu = [[UIView alloc]initWithFrame:CGRectMake(0, 77, ScreenWidth, 30)];
    viewFabu.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:viewFabu];
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, viewFabu.frame.size.width, viewFabu.frame.size.height);
    [viewFabu addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeCustom];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 3*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeCustom];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 5*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];

    [btnText setTitle:@"创建赛事" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 21*ScreenWidth/375, 5, 13*ScreenWidth/375, 20*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];
    
}
//赛事点击事件，跳转界面
-(void)createClick
{
//    ManageCreateController* createVc = [[ManageCreateController alloc]init];
//
//    [self.navigationController pushViewController:createVc animated:YES];
    
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@0 forKey:@"orderType"];
    [dict setObject:@527 forKey:@"srcKey"];
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        
        /*
         partner="2088911674587712"&seller_id="2088911674587712"&out_trade_no="Order_583"&subject="测试"&body="奶奶的"&total_fee="0.01"&notify_url="http://xiaoar.oicp.net:16681/pay/onCallbackAlipay"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&sign="EbYezU%2BZDT%2FFwDDMTRnxgHztxZ9U2r%2BuB9hzo874Tkp1qSY1z3Nyean2%2B%2BPwFocbXg64VpYF4hNvnNYxAVF8NsSJRgZhghGsDf8XVqV3Q9Z%2FvJOchyUjalgl9D8EPoxLWaedkmT%2Bygvkbuekm5Q2VLU%2BOiuL8ofslX79eKNzQFE%3D"&sign_type="RSA"
         */
        
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"陈公");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
            } else {
                NSLog(@"支付失败");
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
        
        
    }];
    
    
    
}

//点击弹出窗
-(void)createBtnView
{
    _isCreate = YES;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"我的赛事", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home", @"nes", @"ssbar", nil];
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    __weak UINavigationController *nav = self.navigationController;
    _viewTanTu.isXuanSang = 4;
    _viewTanTu.block = ^(UIViewController *vc){
        [nav pushViewController:vc animated:YES];
    };
    _viewTanTu.blockFirstPage = ^(UIViewController *vc){
        [nav popViewControllerAnimated:YES];
    };
    [_viewTanTu showString:arr];
    [_viewTanTu showImage:imageArr];
    // 设置xib视图的尺寸
    _viewTanTu.frame = CGRectMake((self.view.frame.size.width - 110), 0, 102, 102);
    [self.view addSubview:_viewTanTu];
    
}




#pragma mark --TableView
-(void)uiConfig
{
    _indexNum = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ManageMainTableCell class] forCellReuseIdentifier:@"cellid"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    if (self.lng != nil) {
        [_dict setObject:self.lng forKey:@"yIndex"];
    }
    if (self.lat != nil) {
        [_dict setObject:self.lat forKey:@"xIndex"];
    }
    //    if (![Helper isBlankString:_textField.text]) {
    //        [dict setObject:_textField.text forKey:@"ballNames"];
    //    }
    
    [_dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [_dict setObject:@10 forKey:@"rows"];
    [_dict setObject:@0 forKey:@"userType"];
    [_dict setObject:[NSNumber numberWithInteger:0] forKey:@"orderType"];
    [_dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    //,@"eventisEndStart":@"",@"eventIsPrivate":@""
    
     [_dict setObject:_textField.text forKey:@"eventName"];
    [[PostDataRequest sharedInstance] postDataRequest:@"tballevent/querybyList.do" parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_dataLastArr removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                if ([[dataDict objectForKey:@"isEndStart"] integerValue] == 2) {
                    for (NSDictionary *dict0 in [dataDict objectForKey:@"list"]) {
                        GameModel *model = [[GameModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict0];
                        [_dataArray addObject:model];
                    }
                }else{
                    for (NSDictionary *dict1 in [dataDict objectForKey:@"list"]) {
                        GameModel *model = [[GameModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict1];
                        [_dataLastArr addObject:model];
                    }
                }
            }
            _page++;
            [_tableView reloadData];
            
        }else {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_dataLastArr removeAllObjects];
            }
            [_tableView reloadData];

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
- (void)headRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataArray.count;
    }
    else
    {
        return _dataLastArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if (_dataLastArr.count != 0) {
            return 30*ScreenWidth/375;
        }else {
            return 0;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
        view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        
        //        93 5
        UIImageView* imgvLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12*ScreenWidth/375, 93*ScreenWidth/375, 6*ScreenWidth/375)];
        imgvLeft.image = [UIImage imageNamed:@"left_line"];
        [view addSubview:imgvLeft];
        
        UIImageView* imgvRight = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-93*ScreenWidth/375, 12*ScreenWidth/375, 93*ScreenWidth/375, 6*ScreenWidth/375)];
        imgvRight.image = [UIImage imageNamed:@"right_line"];
        [view addSubview:imgvRight];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"以下为已经结束的赛事活动";
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        
        
        return view;
    }
    return nil;
}
//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*ScreenWidth/375;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ManageMainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        ManageMainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        [cell showData:_dataLastArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManageDetailController* manVc = [[ManageDetailController alloc]init];
    manVc.blockRefresh = ^(){
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    };
    if (indexPath.section == 0) {
        manVc.eventId = [_dataArray[indexPath.row] eventId];
    }
    else
    {
        manVc.eventId = [_dataLastArr[indexPath.row] eventId];
    }
    [self.navigationController pushViewController:manVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [_tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _viewTanTu.hidden = YES;
    _showView = NO;
}


@end
