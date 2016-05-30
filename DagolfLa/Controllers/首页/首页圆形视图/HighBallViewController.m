//
//  HighBallViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "HighBallViewController.h"

#import "XuanshangSearchController.h"
#import "PostRewordViewController.h"
#import "PostRewardCell.h"
//悬赏详情
#import "PostDetailViewController.h"
//我的悬赏
#import "MineRewardViewController.h"


#import "Helper.h"
#import "PostDataRequest.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "RewordModel.h"
#define kReword_url @"aboutBallReward/queryPage.do"

#import "CityChooseView.h"
#import "CityHighChooseView.h"

#import "UserDataInformation.h"
#import "EnterViewController.h"

#import "YueBallHallView.h"
#import "Helper.h"




@interface HighBallViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UISearchController* _controller;
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataLastArray;
    NSMutableArray* _dataModelArr;
    
    UIView* _viewMore;
    BOOL _showView;
    BOOL _isChooseView;
    YueBallHallView *_viewTanTu;
    CityHighChooseView* _cityChooseView;
    UIButton* _btnCityChoose;
    NSInteger _indexNum;
    
    UITextField *_textField;
    
    NSMutableDictionary* _dict;
    
    BOOL _isTimeClick;
    BOOL _isDisClick;
    UIButton* _btnLeft,*_btnCenter,*_btnRight;
    UIImageView * _imgvJtCent;
    UIImageView * _imgvJtRight;
    
    NSString* _strPro;
    NSString* _strCity;
    
    NSNumber* _strSmall;
    NSNumber* _strBigger;
    
    UIImageView* _imgvBackG;
    
    NSInteger _page;
//    NSMutableDictionary* dict
    
}
@end

@implementation HighBallViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _showView = NO;
    //    _viewMore.hidden = YES;
    //    _dataArray = [[NSMutableArray alloc]init];
    //    _dataLastArray = [[NSMutableArray alloc]init];
    //    _dataModelArr = [[NSMutableArray alloc]init];
    //
    //    _dict = [[NSMutableDictionary alloc]init];
    
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //列表
//    [_tableView headerBeginRefreshing];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiRefreshing) name:@"Refreshing" object:nil];

    
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    _dataLastArray = [[NSMutableArray alloc]init];
    _dataModelArr = [[NSMutableArray alloc]init];
    
    _dict = [[NSMutableDictionary alloc]init];
    
    _strCity = @"";
    _strPro = @"";
    _strBigger = [NSNumber numberWithInt:-1];
    _strSmall = [NSNumber numberWithInt:-1];
    
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.title = @"悬赏大厅";
    //搜索框
    [self createSeachBar];
    //分段和筛选
    [self createSegmentAndChoose];
    //发布
    [self createFabu];
    
    [self uiConfig];
    
    _indexNum = 1;
    _isChooseView = NO;
    _cityChooseView = [[CityHighChooseView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375)];
    [self.view addSubview:_cityChooseView];
    
    
    _btnCityChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCityChoose.frame = CGRectMake(0, 0, ScreenWidth, 77*ScreenWidth/375);
    _btnCityChoose.backgroundColor = [UIColor blackColor];
    _btnCityChoose.alpha = 0.5;
    _btnCityChoose.hidden = YES;
    [_btnCityChoose addTarget:self action:@selector(btnPostCityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCityChoose];
    
}

-(void)notiRefreshing{
    [_tableView.header endRefreshing];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refreshing" object:nil];
}




-(void)btnPostCityClick
{
    if (_isChooseView == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            _cityChooseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375);
            _isChooseView = NO;
            _btnCityChoose.hidden = YES;
            
        }];
        
    }
}
-(void)ShowViewClick{
    if (_showView == NO) {
        
        _viewMore.hidden = NO;
        
        _showView = YES;
        
        if (_viewTanTu) {
            _viewTanTu.hidden = NO;
        } else {
            [self createBtnView];
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
    [_textField addTarget:self action:@selector(keyboardDown3:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入悬赏名称进行搜索";
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [imageView addSubview:_textField];
    _textField.delegate = self;
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 3, 60*ScreenWidth/375, 30);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachCitysClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
-(void)keyboardDown3:(UITextField *)tf{
    
}

/**
 *  搜索按钮
 */
-(void)seachCitysClick{
    [_textField resignFirstResponder];
    // 延迟几秒，为了键盘消失， alertview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
  
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
            [_tableView.header beginRefreshing];
   
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        ////NSLog(@"延迟几秒执行");
    });
}


//分段选择
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
    [SeachButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [viewSeg addSubview:SeachButton];
    
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
//筛选
-(void)chooseButtonClick
{
    ////NSLog(@"%d",_isChooseView);
    if (_isChooseView == NO) {
        [UIView animateWithDuration:0.2 animations:^{
            _cityChooseView.frame = CGRectMake(0, 77*ScreenWidth/375, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375);
            _isChooseView = YES;
            _btnCityChoose.hidden = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _cityChooseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375);
            _isChooseView = NO;
            _btnCityChoose.hidden = YES;
        }];
        
    }
    _cityChooseView.blockArea = ^(NSString* strPro, NSString* strCity, NSNumber* strsmall, NSNumber* strBig){
        _strPro = strPro;
        _strCity = strCity;
        _strSmall = strsmall;
        _strBigger = strBig;
        
        _isChooseView = NO;
        _btnCityChoose.hidden = YES;
        
//        [_dataArray removeAllObjects];
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
        [_tableView.header beginRefreshing];
        
    };


}

-(void)createFabu
{
    UIView* viewFabu = [[UIView alloc]initWithFrame:CGRectMake(0, 77, ScreenWidth, 30)];
    viewFabu.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewFabu];
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, viewFabu.frame.size.width, viewFabu.frame.size.height);
    [viewFabu addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(xuanshangClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 3, 20*ScreenWidth/375, 20);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(xuanshangClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 5, 60*ScreenWidth/375, 20);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];

    [btnText setTitle:@"发布悬赏" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(xuanshangClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"icon_001"];
    [viewBtn addSubview:imgvJian];
    
}
//发布悬赏点击事件，跳转界面
-(void)xuanshangClick
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        PostRewordViewController* postVc = [[PostRewordViewController alloc]init];
        [self.navigationController pushViewController:postVc animated:YES];
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    
    
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:@171 forKey:@"teamKey"];
//    [dict setObject:@244 forKey:@"userKey"];
//    [dict setObject:@"我叫邱思宇" forKey:@"name"];
//    [dict setObject:@"XXXXXXXXXXXXXXDDDDDDDDDDDDDSSSSSSS" forKey:@"info"];
//    [dict setObject:@"公告公告公告公告公告公告公告公告公告" forKey:@"notice"];
//    [[JsonHttp jsonHttp]httpRequest:@"team/updateTeam" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
//        NSLog(@"err");
//    } completionBlock:^(id data) {
//        
//    }];
    
    
    
    
      
}

-(void)createBtnView
{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"我的悬赏", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home", @"nes", @"xsbar", nil];
    
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    [_viewTanTu showString:arr];
    [_viewTanTu showImage:imageArr];
    __weak UINavigationController *nav = self.navigationController;
    _viewTanTu.isXuanSang = 2;
    _viewTanTu.block = ^(UIViewController *vc){
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        ////NSLog(@"%@", vc.title);
        [nav pushViewController:vc animated:YES];
    };
    _viewTanTu.blockFirstPage = ^(UIViewController *vc){
        [nav popViewControllerAnimated:YES];
    };
    // 设置xib视图的尺寸
    _viewTanTu.frame = CGRectMake((self.view.frame.size.width - 110), 0, 102, 102);
    [self.view addSubview:_viewTanTu];
}

//跳转我的悬赏界面
-(void)PostClick:(UIButton*)btn
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        if (btn.tag == 152) {
            MineRewardViewController* mineVc = [[MineRewardViewController alloc]init];
            [self.navigationController pushViewController:mineVc animated:YES];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}



#pragma mark --TableView
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    //    [_tableView registerNib:[UINib nibWithNibName:@"PostRewardCell" bundle:nil] forCellReuseIdentifier:@"PostRewardCell"];
    [_tableView registerClass:[PostRewardCell class] forCellReuseIdentifier:@"PostRewardCell"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    [_dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [_dict setObject:@10 forKey:@"rows"];
    if (self.lng != nil) {
        [_dict setObject:self.lng forKey:@"yIndex"];
    }
    if (self.lat != nil) {
        [_dict setObject:self.lat forKey:@"xIndex"];
    }
    if (![Helper isBlankString:_textField.text]) {
        [_dict setObject:_textField.text forKey:@"ballNames"];
    }
    else
    {
        [_dict setObject:@"" forKey:@"ballNames"];
    }
    if (![Helper isBlankString:_strPro]) {
        [_dict setObject:_strPro forKey:@"provinceName"];
    }
    else
    {
        [_dict setObject:@"" forKey:@"provinceName"];
    }
    if (![Helper isBlankString:_strCity]) {
        [_dict setObject:_strCity forKey:@"cityName"];
    }
    else
    {
        [_dict setObject:@"" forKey:@"cityName"];

    }
    if (_strSmall != nil) {
        [_dict setObject:_strSmall forKey:@"moneyDown"];
    }
    else
    {
        [_dict setObject:@-1 forKey:@"moneyDown"];

    }
    if (_strBigger != nil) {
        [_dict setObject:_strBigger forKey:@"moneyUp"];
    }
    else
    {
        [_dict setObject:@-1 forKey:@"moneyDown"];

    }
    [_dict setObject:@0 forKey:@"userType"];
    [_dict setObject:[NSNumber numberWithInteger:_indexNum] forKey:@"orderType"];
    [_dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];

    
    ////NSLog(@"%@",_textField.text);
    [_dict setObject:_textField.text forKey:@"ballNames"];
    
    [[PostDataRequest sharedInstance] postDataRequest:kReword_url parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (isReshing){
                [_dataArray removeAllObjects];
                [_dataLastArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                RewordModel *model = [[RewordModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                if ([model.states integerValue]== 0) {
                    [_dataArray addObject:model];
                }
                else
                {
                    [_dataLastArray addObject:model];
                }
            }
            _page++;
            [_tableView reloadData];
        }else {
            if (isReshing){
                [_dataArray removeAllObjects];
                [_dataLastArray removeAllObjects];
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
        return _dataLastArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if (_dataLastArray.count == 0) {
            return 0;
        }
        else
        {
            return 30*ScreenWidth/375;
        }
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _viewTanTu.hidden = YES;
    _showView = YES;
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
        label.text = @"以下为已经结束的悬赏活动";
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        
        
        return view;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73*ScreenWidth/320;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostRewardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PostRewardCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell showData:_dataArray[indexPath.row]];
    }
    else
    {
        [cell showData:_dataLastArray[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_textField resignFirstResponder];
    if (indexPath.section == 0) {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
            
            PostDetailViewController* detailVc = [[PostDetailViewController alloc]init];
            detailVc.blockRefresh = ^(){
                [_tableView.header endRefreshing];
                _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
                [_tableView.header beginRefreshing];
            };
            detailVc.aboutBallId = [_dataArray[indexPath.row] aboutBallReId];
            [self.navigationController pushViewController:detailVc animated:YES];
            /**
             *  更新浏览人数
             */
            ////NSLog(@"%@",[_dataArray[indexPath.row] aboutBallReId]);
            [[PostDataRequest sharedInstance] postDataRequest:@"aboutBallReward/updateSee.do" parameter:@{@"aboutBallReId":[_dataArray[indexPath.row] aboutBallReId]} success:^(id respondsData) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            } failed:^(NSError *error) {
                ////NSLog(@"%@",error);
            }];
            
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
    else
    {
        
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
            ////NSLog(@"%@",_dataLastArray);
            
            PostDetailViewController* detailVc = [[PostDetailViewController alloc]init];
            detailVc.blockRefresh = ^(){
                [_tableView.header endRefreshing];
                _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
                [_tableView.header beginRefreshing];
            };
            detailVc.aboutBallId = [_dataLastArray[indexPath.row] aboutBallReId];
            [self.navigationController pushViewController:detailVc animated:YES];
            /**
             *  更新浏览人数
             */
//            [_dict setValue:[_dataLastArray[indexPath.row] aboutBallReId] forKey:@"aboutBallId"];
            ////NSLog(@"%@",[_dataLastArray[indexPath.row] aboutBallReId]);
            [[PostDataRequest sharedInstance] postDataRequest:@"aboutBallReward/updateSee.do" parameter:@{@"aboutBallReId":[_dataLastArray[indexPath.row] aboutBallReId]} success:^(id respondsData) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                
                [tableView deselectRowAtIndexPath:indexPath animated:NO];

            } failed:^(NSError *error) {
                ////NSLog(@"%@",error);
            }];
            
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
        
    }
    
    //    aboutBallReward/updateSee.do
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        EnterViewController *vc = [[EnterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [_tableView reloadData];
}








@end
