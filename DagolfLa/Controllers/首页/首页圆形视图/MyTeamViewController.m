//
//  MyTeamViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyTeamViewController.h"
#import "LazyPageScrollView.h"
#import "MyTeamsTableViewCell.h"
#import "TeamDetailViewController.h"
#import "TeamDeMessViewController.h"

#import "TeamCreateViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "TeamModel.h"

#import "TeamActiveDeController.h"

#import "YueBallHallView.h"

#import "TeamAreaChooseView.h"

@interface MyTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    //UISearchController* _controller;
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    BOOL _isClick;
    UIView* _viewMore;
    BOOL _showView;
    BOOL _isChooseView;
    TeamAreaChooseView* _cityChooseView;
    UIButton* _btnCityChoose;
    UIButton* _btnBase;
    
    //条件选择
    UIButton* _btnLeft,*_btnCenter,*_btnRight;
    UIImageView * _imgvJtCent;
    UIImageView * _imgvJtRight;
    NSInteger _indexNum;
    //记录点击的是哪一个cell；
    NSInteger _indexNumber;
    
    BOOL _isTimeClick;
    BOOL _isDisClick;
    
    UIAlertView *_alert;
    
    NSInteger _page;
    
    YueBallHallView *_viewTanTu;
    //判断球队有没有创建过
    BOOL _isCreate;
    
    NSMutableDictionary* _dict;
    
    UIImageView* _imgvBackG;
    //搜索框
    UITextField *_textField;
    
    //筛选框里面的城市
    
    NSString* _strPro;
    NSString* _strCity;
    NSNumber* _numforr;
}
@end

@implementation MyTeamViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _showView = NO;
    _viewMore.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //////NSLog(@"%d",_isClick);
    self.title = @"球队大厅";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiRefreshing) name:@"Refreshing" object:nil];

    _numforr = @-100;
    _page = 1;
    _dict = [[NSMutableDictionary alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewTeamClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    [self uiConfig];
    [self createSeachBar];
    
    [self createSegmentAndChoose];
    [self createChoose];
    [self createWanderOrder];
    
    
    _isChooseView = NO;
    _cityChooseView = [[TeamAreaChooseView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64-77*ScreenWidth/375)];
    [self.view addSubview:_cityChooseView];
    
    _btnBase = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBase.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_btnBase];
    _btnBase.hidden = YES;
    [_btnBase addTarget:self action:@selector(btnBaseClick) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCityChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCityChoose.frame = CGRectMake(0, 0, ScreenWidth, 77*ScreenWidth/375);
    _btnCityChoose.backgroundColor = [UIColor blackColor];
    _btnCityChoose.alpha = 0.5;
    _btnCityChoose.hidden = YES;
    [_btnCityChoose addTarget:self action:@selector(btnPostCityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCityChoose];
    
    
    
}

-(void)notiRefreshing{
    //NSLog(@"返回刷新");
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

-(void)btnBaseClick
{
    [self.view endEditing:YES];
    _btnBase.hidden = YES;
}
-(void)ShowViewTeamClick{
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

//点击弹出窗
-(void)createBtnView
{
    _isCreate = YES;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"我的球队", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home", @"nes", @"qdbar", nil];
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    __weak UINavigationController *nav = self.navigationController;
    _viewTanTu.isXuanSang = 3;
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
//我的约球，弹出框点击事件
-(void)myorderClick:(UIButton *)btn
{
    if (btn.tag == 102) {
        TeamActiveDeController *yueVc = [[TeamActiveDeController alloc]init];
        [self.navigationController pushViewController:yueVc animated:YES];
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
    [_textField addTarget:self action:@selector(keyboardDown4:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入球队名称进行搜索";
    [imageView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    _textField.delegate = self;
    _textField.tag = 122;
    
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 122) {
        _btnBase.hidden= NO;
    }
}

-(void)seachcityClick{
    [self.view endEditing:YES];
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
    [SeachButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SeachButton];
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
    _cityChooseView.blockArea = ^(NSString* strPro, NSString* strCity){
        _strPro = strPro;
        _strCity = strCity;
        
        _isChooseView = NO;
        _btnCityChoose.hidden = YES;
        
        //        [_dataArray removeAllObjects];
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
    [viewBtn addTarget:self action:@selector(teamCreateClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 5, 20*ScreenWidth/375, 20);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(teamCreateClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 5, 60*ScreenWidth/375, 20);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];

    [btnText setTitle:@"创建球队" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(teamCreateClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 10, 10*ScreenWidth/375, 10)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];
    
}
//创建球队点击事件
-(void)teamCreateClick
{
    TeamCreateViewController* teamVc = [[TeamCreateViewController alloc]init];

    [self.navigationController pushViewController:teamVc animated:YES];
}


#pragma mark --tableview
-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-15*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"MyTeamsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTeamsTableViewCell"];
    //    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    if (self.lat != nil) {
        [_dict setObject:self.lat forKey:@"xIndex"];
    }
    if (self.lng != nil) {
        [_dict setObject:self.lng forKey:@"yIndex"];
    }
    [_dict setObject:_textField.text forKey:@"ballNames"];
    [_dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [_dict setObject:@10 forKey:@"rows"];
    [_dict setObject:@0 forKey:@"userType"];
    [_dict setObject:[NSNumber numberWithInteger:_indexNum] forKey:@"orderType"];
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    if (![Helper isBlankString:_strPro]) {
        [_dict setObject:_strPro forKey:@"provinceName"];
    }
    if (![Helper isBlankString:_strCity]) {
        [_dict setObject:_strCity forKey:@"cityName"];
    }
    [[PostDataRequest sharedInstance] postDataRequest:@"team/queryPage.do" parameter:_dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page==1)
            {
                [_dataArray removeAllObjects];
                _numforr = @-100;
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamModel *model = [[TeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            if (page == 1) {
                [_dataArray removeAllObjects];
                _numforr = @-100;
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTeamsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamsTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cell.areaLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    cell.detailLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    if (_dataArray.count != 0) {
        [cell showData:_dataArray[indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamDeMessViewController* teamVc = [[TeamDeMessViewController alloc]init];
    
    teamVc.forBlock = ^(NSNumber* forrevent, NSInteger indexNum){
        _numforr = forrevent;
        _indexNumber = indexNum;
    };
    teamVc.isBack = YES;
    teamVc.teamId = [_dataArray[indexPath.row] teamId];
    teamVc.modelMian = _dataArray[indexPath.row];
    if ([_numforr integerValue] == -100) {
        teamVc.forrelvant = [_dataArray[indexPath.row] forrelevant];
    }else{
        if (indexPath.row == _indexNumber) {
            teamVc.forrelvant = _numforr;
        }
        else
        {
            teamVc.forrelvant = [_dataArray[indexPath.row] forrelevant];
        }
        
    }
    teamVc.indexNum = indexPath.row;
    [self.navigationController pushViewController:teamVc animated:YES];
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
