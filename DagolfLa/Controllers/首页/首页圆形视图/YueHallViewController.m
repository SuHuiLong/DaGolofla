//
//  YueHallViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/3.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueHallViewController.h"
//#import "YueSearchViewController.h"
#import "YueHallTableViewCell.h"
#import "YueMyBallViewController.h"
#import "YueDetailViewController.h"
#import "YuePostViewController.h"
#import "YueHallPeoTableViewCell.h"

#import "CityChooseView.h"
#import "YueHallModel.h"

#import "UITool.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "PostDataRequest.h"

#define kYue_url @"aboutBall/queryPage.do"

#import "UserDataInformation.h"
#import "EnterViewController.h"
#import "Helper.h"
#import "UIButton+WebCache.h"

#import "PersonHomeController.h"


// 约球大厅弹出框
#import "YueBallHallView.h"

@interface YueHallViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    //UISearchController* _controller;
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    BOOL _isClick;
    UIView* _viewMore;
    
    YueBallHallView *_viewTanTu;
    BOOL _showView;
    
    BOOL _isChooseView;
    CityChooseView* _cityChooseView;
    UIButton* _btnCityChoose;
    NSInteger _indexNum;
    
    UITextField *_textField;
    
    
    BOOL _isTimeClick;
    BOOL _isDisClick;
    NSMutableArray* _IconAgreeArr;
    UIButton* _btnLeft,*_btnCenter,*_btnRight;
    UIImageView * _imgvJtCent;
    UIImageView * _imgvJtRight;
    
    UIAlertView *_alert;
    NSString* _strPro;
    NSString* _strCity;
    
   
    UIImageView* _imgvBackG;
    
    NSInteger _page;
    
    NSMutableDictionary* _dict;
}
@end

@implementation YueHallViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _showView = NO;
    //    _viewMore.hidden = YES;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"约球大厅";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiRefreshing) name:@"Refreshing" object:nil];
    
    _page = 1;
    _dict=[[NSMutableDictionary alloc] init];
    _IconAgreeArr =[[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    _strCity = @"";
    _strPro = @"";
    
    [self createSeachBar];
    [self createWanderOrder];
    [self uiConfig];
    [self createSegmentAndChoose];
    //    [self createBtnView];
    [self createChoose];
    
    
    
    _isChooseView = NO;
    _cityChooseView = [[CityChooseView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375)];
    //    _cityChooseView.backgroundColor = [UITool colorWithHexString:@"FFFFFF" alpha:1];
    [self.view addSubview:_cityChooseView];
    
    _btnCityChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCityChoose.frame = CGRectMake(0, 0, ScreenWidth, 77*ScreenWidth/375);
    _btnCityChoose.backgroundColor = [UIColor blackColor];
    _btnCityChoose.alpha = 0.5;
    _btnCityChoose.hidden = YES;
    [_btnCityChoose addTarget:self action:@selector(btnCityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCityChoose];
}
-(void)notiRefreshing{
    //NSLog(@"返回刷新");
    [_tableView.header endRefreshing];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    [_tableView.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refreshing" object:nil];
}



-(void)btnCityClick
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
    [_btnLeft addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _imgvJtCent = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-120*ScreenWidth/375)/3-15, 6, 9, 18)];
    [_btnLeft addSubview:_imgvJtCent];
    _imgvJtCent.image = [UIImage imageNamed:@"shangb"];
    
    
    _btnCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCenter.frame = CGRectMake((ScreenWidth-120*ScreenWidth/375)/3, 0, (ScreenWidth-120*ScreenWidth/375)/3, 30);
    [_btnCenter setTitle:@"热门" forState:UIControlStateNormal];
    _btnCenter.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_imgvBackG addSubview:_btnCenter];
    [_btnCenter addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCenter.tag = 123;
    [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CALayer *buttonLayer = [_btnCenter layer];
    [buttonLayer setBorderColor:[UIColor lightGrayColor].CGColor];
    [buttonLayer setBorderWidth:1];
    
    
    
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake((ScreenWidth-120*ScreenWidth/375)/3*2, 0, (ScreenWidth-120*ScreenWidth/375)/3-1, 30-1);
    //    btnRight.backgroundColor = [UIColor whiteColor];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [_btnRight setTitle:@"距离" forState:UIControlStateNormal];
    [_imgvBackG addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.tag = 125;
    [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _imgvJtRight = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-120*ScreenWidth/375)/3-15, 6, 9, 18)];
    [_btnRight addSubview:_imgvJtRight];
    _imgvJtRight.image = [UIImage imageNamed:@"jt_up"];
    
}


#pragma  mark --选择状态（时间热门距离）
-(void)segmentClick:(UIButton *)btn
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

//点击弹出窗
-(void)createBtnView
{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"我的约球", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home",  @"yqbar", nil];
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    __weak UINavigationController *nav = self.navigationController;
    _viewTanTu.isXuanSang = 1;
    _viewTanTu.block = ^(UIViewController *vc){
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        [nav pushViewController:vc animated:YES];
    };
    _viewTanTu.blockFirstPage = ^(UIViewController *vc){
        [nav popToRootViewControllerAnimated:YES];
    };
    [_viewTanTu showString:arr];
    [_viewTanTu showImage:imageArr];
    // 设置xib视图的尺寸
    _viewTanTu.frame = CGRectMake((self.view.frame.size.width - 110), 0, 102, 102);
    [self.view addSubview:_viewTanTu];
    
}
//我的约球，弹出框点击事件
-(void)myorderClick:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        if (btn.tag == 102) {
            YueMyBallViewController *yueVc = [[YueMyBallViewController alloc]init];
            [self.navigationController pushViewController:yueVc animated:YES];
        }
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
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
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 27)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    [_textField addTarget:self action:@selector(keyboardDown4:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入约球名称进行搜索";
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [imageView addSubview:_textField];
    _textField.delegate = self;
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 3, 60*ScreenWidth/375, 30);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachcityClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}

-(void)keyboardDown4:(UITextField *)tf{
   
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _viewTanTu.hidden = YES;
    _showView = NO;
    return YES;
}
-(void)seachcityClick{
    [_textField resignFirstResponder];

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        [_tableView.header beginRefreshing];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
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


-(void)createChoose
{
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-80*ScreenWidth/375, 42, 60*ScreenWidth/375, 30);
    [SeachButton setTitle:@"筛选" forState:UIControlStateNormal];
    SeachButton.layer.masksToBounds = YES;
    SeachButton.layer.cornerRadius = 5;
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SeachButton.backgroundColor = [UIColor lightGrayColor];
    [SeachButton addTarget:self action:@selector(choosebtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SeachButton];
}
//筛选
-(void)choosebtnClick
{
    [self.view endEditing:YES];
    
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
    _cityChooseView.blockCity = ^(NSString* strPro, NSString* strCity){
        _strPro = strPro;
        _strCity = strCity;
        
        _isChooseView = NO;
        _btnCityChoose.hidden = YES;

        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
        [_tableView.header beginRefreshing];
        
    };
}

-(void)createWanderOrder
{
    UIView* viewFabu = [[UIView alloc]initWithFrame:CGRectMake(0, 77, ScreenWidth, 30)];
    viewFabu.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewFabu];
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, viewFabu.frame.size.width, viewFabu.frame.size.height);
    [viewFabu addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 3, 20*ScreenWidth/375, 20);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 5, 60*ScreenWidth/375, 20);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];

    [btnText setTitle:@"我要约球" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 8, 10*ScreenWidth/375, 14)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];
    
}
//约球点击事件
-(void)orderClick
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        YuePostViewController* yueVc = [[YuePostViewController alloc]init];
        [self.navigationController pushViewController:yueVc animated:YES];

        
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    
}


#pragma mark --tableview
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-15*ScreenWidth/375-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"YueHallTableViewCell" bundle:nil] forCellReuseIdentifier:@"YueHallTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"YueHallPeoTableViewCell" bundle:nil] forCellReuseIdentifier:@"YueHallPeoTableViewCell"];
    _indexNum = 1;
    
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
    if (![Helper isBlankString:_textField.text]) {
        [_dict setObject:_textField.text forKey:@"ballNames"];
    }
    if (![Helper isBlankString:_strPro]) {
        [_dict setObject:_strPro forKey:@"provinceName"];
    }else
    {
        [_dict setObject:@"" forKey:@"provinceName"];
    }
    if (![Helper isBlankString:_strCity]) {
        [_dict setObject:_strCity forKey:@"cityName"];
    }else
    {
        [_dict setObject:@"" forKey:@"cityName"];
    }
    [_dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [_dict setObject:@10 forKey:@"rows"];
    [_dict setObject:@0 forKey:@"userType"];
    [_dict setObject:[NSNumber numberWithInteger:_indexNum] forKey:@"orderType"];
    [_dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    [[PostDataRequest sharedInstance] postDataRequest:kYue_url parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_IconAgreeArr removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                YueHallModel *model = [[YueHallModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
                [_IconAgreeArr addObject:model];
                
                
            }
            _page++;
            [_tableView reloadData];
        }else {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_IconAgreeArr removeAllObjects];
                [_tableView reloadData];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        return 83*ScreenWidth/375;
    }
    else
    {
        return 44*ScreenWidth/320;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count*2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 == 0) {
        
        YueHallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YueHallTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArray.count != 0) {
            [cell showYueData:_dataArray[indexPath.row/2]];
            
        }
        return cell;
    }
    else
    {

        YueHallPeoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YueHallPeoTableViewCell" forIndexPath:indexPath];
        cell.btnPeo1.tag = 10000+indexPath.row;
        cell.btnPeo2.tag = 20000+indexPath.row;
        cell.btnPeo3.tag = 30000+indexPath.row;
        cell.btnPeo4.tag = 40000+indexPath.row;
        cell.btnPeo1.layer.masksToBounds = YES;
        
        YueHallModel *model=[_IconAgreeArr objectAtIndex:indexPath.row/2];
        
        [cell.btnPeo1 sd_setImageWithURL:[Helper imageUrl:[_IconAgreeArr[indexPath.row/2] uPic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
        [cell.btnPeo1 addTarget:self action:@selector(pushSelfPage:) forControlEvents:UIControlEventTouchUpInside];
        for (int i=0; i<3; i++) {
            UIButton *button=(UIButton *)[cell.contentView viewWithTag:20000+indexPath.row+10000*i];
            if (i<model.joinList.count) {
                //NSLog(@"%d",i);
                button.hidden=NO;
                NSDictionary *smallDict=[model.joinList objectAtIndex:i];
                [button sd_setImageWithURL:[Helper imageIconUrl:[smallDict objectForKey:@"pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
                [button addTarget:self action:@selector(pushSelfPage:) forControlEvents:UIControlEventTouchUpInside];
            }else if (i==model.joinList.count){
                //NSLog(@"%d",i);
                button.hidden=NO;
                if ([model.applystate integerValue] == 2) {
                    [button setImage:[UIImage imageNamed:@"tianj"] forState:UIControlStateNormal];
                    [button removeTarget:self action:@selector(pushSelfPage:) forControlEvents:UIControlEventTouchUpInside];
                    [button addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
                }
                else{
                    button.hidden = YES;
                }
            }else{
                button.hidden=YES;
                [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
//    return nil;
    
}

//约球大厅 点头像进入个人主页
-(void)pushSelfPage:(UIButton *)btn {
    //NSLog(@"%ld",(long)btn.tag);
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    if (btn.tag/10000 == 1) {
        //发布人主页
        selfVc.strMoodId = [_IconAgreeArr[btn.tag%10000/2] userId];
    }else{
        //参与人主页
        selfVc.strMoodId =   [[[_IconAgreeArr[btn.tag%10000/2] joinList] objectAtIndex:btn.tag/10000-2] objectForKey:@"userId"];
    }
    selfVc.messType = @2;
    [self.navigationController pushViewController:selfVc animated:YES];
}

-(void)btn1Click:(UIButton *)btn
{
    if (btn.tag < 20000) {
        if (_dataArray.count != 0) {
            if ([[_dataArray[(btn.tag-10000)/2] startState] integerValue] == 1) {
                NSString* str = [NSString stringWithFormat:@"%@申请加入这次约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                
                [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallJoin/save.do" parameter:@{@"aboutBallId":[_dataArray[(btn.tag-10000)/2] aboutBallId],@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"message":str,@"userIds":[_dataArray[(btn.tag-10000)/2] userId]} success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"]integerValue] == 1) {
//                        [btn setImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"tx4"] forState:UIControlStateNormal];
                    }
                    
                } failed:^(NSError *error) {
                    
                }];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:@"这个约球已经结束，无法加入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alertView show];
            }

        }
        
    }
    else if (btn.tag >= 20000 && btn.tag < 30000)
    {
        if (_dataArray.count != 0) {
            if ([[_dataArray[(btn.tag-20000)/2] startState] integerValue]== 1)
            {
                NSString* str = [NSString stringWithFormat:@"%@申请加入这次约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallJoin/save.do" parameter:@{@"aboutBallId":[_dataArray[(btn.tag-20000)/2] aboutBallId],@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"message":str,@"userIds":[_dataArray[(btn.tag-20000)/2] userId]} success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"]integerValue] == 1) {
//                        [btn setImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"tx4"] forState:UIControlStateNormal];
                    }
                    
                } failed:^(NSError *error) {
                    
                }];
                
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:@"这个约球已经结束，无法加入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alertView show];
            }
        }
        
    }
    else if (btn.tag >=30000 && btn.tag < 40000)
    {
        if (_dataArray.count != 0) {
            if ([[_dataArray[(btn.tag-30000)/2] startState] integerValue] == 1) {
                NSString* str = [NSString stringWithFormat:@"%@申请加入这次约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallJoin/save.do" parameter:@{@"aboutBallId":[_dataArray[(btn.tag-30000)/2] aboutBallId],@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"message":str,@"userIds":[_dataArray[(btn.tag-30000)/2] userId]} success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"]integerValue] == 1) {
//                        [btn setImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"tx4"] forState:UIControlStateNormal];
                    }
                    
                } failed:^(NSError *error) {
                    
                }];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:@"这个约球已经结束，无法加入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alertView show];
            }

        }
        
    }
    else
    {
        if (_dataArray.count != 0) {
            if ([[_dataArray[(btn.tag-40000)/2] startState] integerValue] == 1) {
                NSString* str = [NSString stringWithFormat:@"%@申请加入这次约球",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                [[PostDataRequest sharedInstance]postDataRequest:@"aboutBallJoin/save.do" parameter:@{@"aboutBallId":[_dataArray[(btn.tag-40000)/2] aboutBallId],@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"message":str,@"userIds":[_dataArray[(btn.tag-40000)/2] userId]} success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict objectForKey:@"success"]integerValue] == 1) {
//                        [btn setImage:[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"pic"]] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"tx4"] forState:UIControlStateNormal];
                    }
                    
                } failed:^(NSError *error) {
                    
                }];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:@"这个约球已经结束，无法加入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alertView show];
            }

        }
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _viewTanTu.hidden = YES;
    _showView = NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        
        YueDetailViewController* yueDVc = [[YueDetailViewController alloc]init];
        yueDVc.blockRefresh = ^(){
            [_tableView.header endRefreshing];
            _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
            [_tableView.header beginRefreshing];
        };
        yueDVc.aboutBallId = [_dataArray[indexPath.row/2] aboutBallId];
        [self.navigationController pushViewController:yueDVc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == _alert) {
        //        [self.view endEditing:YES];
        
    } else if (buttonIndex == 1) {
        EnterViewController *vc = [[EnterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    [_tableView reloadData];
}






@end
