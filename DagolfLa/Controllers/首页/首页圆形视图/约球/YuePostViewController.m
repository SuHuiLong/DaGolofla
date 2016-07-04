//
//  YuePostViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YuePostViewController.h"
#import "IWTextView.h"
#import "RewardAreaViewController.h"
#import "CustomIOSAlertView.h"
#import "DateTimeViewController.h"
#import "BallParkViewController.h"
#import "JobChooseViewController.h"

#import "TeamInviteViewController.h"
#import "TeamMessageController.h"

#import "FabuYueBallViewCell.h"
#import "FabuYueTitleCell.h"
#import "YuePriceTableViewCell.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "UIView+ChangeFrame.h"

#import "UIButton+WebCache.h"
#define kBallsave_URL @"aboutBall/save.do"

#import "YueBallHallView.h"

#import "FriendModel.h"

#import "YueMyBallViewController.h"

#import "MBProgressHUD.h"

@interface YuePostViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray* _messageArray;
    NSMutableArray* _telArray;
    
    UIScrollView* _scrollView;
    //发布的文字视图
    IWTextView* _textView;
    UIView* _viewBase;
    CGFloat _contentSizeY;
    
    NSString* _strPeople;
    
    //点击事件影响坐标
    UIButton* _btnChange;
    UITableView* _tableView;
    NSArray* _dataArray;
    NSArray* _clickArr;
    //    UIView* _viewLine;
    NSInteger _count;
    BOOL _isClick;
    
    
    UIButton* _btnLeft;
    UIButton* _btnRight;
    UIButton* _btnFabu;
    
    //选择器
    UIButton *_button1;
    UIButton *_button2;
    UIView* _selectDateView;
    UIPickerView *_pickerView;
    NSMutableArray* _firstArray;
    NSMutableArray* _secondArray;
    
    
    NSInteger _indexChoose;
    
    //    NSInteger firstIndex;
    //    NSInteger seconeIndex;
    NSString* _firstString;
    NSString* _secondString;
    
    NSMutableArray* _arrayChange;
    
    BOOL _isChooseTime;
    BOOL _isChoosePrice;
    BOOL _isChooseAge;
    BOOL _isChooseChadian;
    BOOL _isChooseSex;
    BOOL _isChooseBall;
    BOOL _isChooseArea;
    
    /**
     *  添加联系人的控件
     *
     *  @return nil
     */
    UIView* _viewPeople;
    BOOL _isGenduo;
    
    CGFloat _Height;
    
    NSString* _strBall, *_strTime, *_strJob;
    //请求所需的字典
    NSMutableDictionary* _dict;
    NSInteger type;
    YueBallHallView *_viewTanTu;
    BOOL _showView;
    UIButton* _btnBack;
    
    
    //好友列表请求的数据
    NSMutableArray* _arrayIndex;
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayData1;
    
    MBProgressHUD* _progress;
    
    
}

// 性别，球龄，差点的数据
@property (nonatomic, strong) UIPickerView *pickerView1;
@property (nonatomic, strong) UIPickerView *pickerView2;
@property (nonatomic, strong) NSMutableArray *timerArr1;
@property (nonatomic, strong) NSMutableArray *timerArr2;
@property (nonatomic, strong) NSMutableArray *priceArr1;
@property (nonatomic, strong) NSMutableArray *priceArr2;
@property (nonatomic, strong) NSMutableArray *sexArr1;
@property (nonatomic, strong) NSMutableArray *ageArr1;
@property (nonatomic, strong) NSMutableArray *ageArr2;
@property (nonatomic, strong) NSMutableArray *ballAgeArr1;
@property (nonatomic, strong) NSMutableArray *ballAgeArr2;
@property (nonatomic, strong) NSMutableArray *chaDianArr1;
@property (nonatomic, strong) NSMutableArray *chaDianArr2;
// 根据distinctionNumber，区分性别，球龄，差点的选择器
@property (nonatomic, assign) NSInteger distinctionNumber;

@end

@implementation YuePostViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _showView = NO;
    
    
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}
#pragma mark --右上角视图展示隐藏
-(void)ShowViewClick{
    
    
    if (_showView == NO) {
        
        
        
        _showView = YES;
        
        if (_viewTanTu) {
            _viewTanTu.hidden = NO;
        } else {
            [self createBtnView];
        }
    }
    else
    {
        _showView = NO;
        
        _viewTanTu.hidden = YES;
    }
    
}
#pragma mark --右上角视图弹出框
//点击弹出窗
-(void)createBtnView
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"首页", @"消息", nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:@"home", @"nes", nil];
    
    // 加载xib视图
    _viewTanTu = [[[NSBundle mainBundle] loadNibNamed:@"YueBallHallView" owner:self options:nil] lastObject];
    __weak UINavigationController *nav = self.navigationController;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起约球";
    
    // 初始化性别，球龄，差点的数据
    [self initializationData];
    
    _selectDateView = [[UIView alloc]init];
    _pickerView = [[UIPickerView alloc]init];
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _firstArray = [[NSMutableArray alloc]init];
    _secondArray = [[NSMutableArray alloc]init];
    
    //好友列表
    _arrayData = [[NSMutableArray alloc]init];
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData1=[[NSMutableArray alloc] init];
    
    //短信好友
    _messageArray = [[NSMutableArray alloc]init];
    _telArray     = [[NSMutableArray alloc]init];
    
    _isClick = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _scrollView.contentSize = CGSizeMake(0, 568-49);
    
    _arrayChange = [[NSMutableArray alloc]initWithArray:@[@"",@"请选择球场",@"请选择日期",@"请选择时间",@"请选择价格",@"",@"",@"",@"不限",@"不限",@"不限",@"不限",@"不限"]];
    
    
    _dict = [[NSMutableDictionary alloc]init];
    type = 100;
    
    [self createTableView];
    _viewPeople = [[UIView alloc]initWithFrame:CGRectMake(0, 170*ScreenWidth/375, ScreenWidth, 35*ScreenWidth/375)];
    //详情
    [self createDetail];
    //
    [self createBtn];
    //折叠按钮
    [self createChangeView];
    //选择打球人
    [self createPeople];
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBack.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _btnBack.hidden = YES;
    //    _btnBack.backgroundColor = [UIColor blackColor];
    //    _btnBack.alpha = 0.5;
    [self.view addSubview:_btnBack];
    [_btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}
-(void)btnBackClick
{
//    [UIView animateWithDuration:0.2 animations:^{
//        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        _btnBack.hidden = YES;
//    }];
}

#pragma mark --初始化选择器的数据
// 初始化性别，球龄，差点的数据
- (void)initializationData
{
    self.timerArr1 = [NSMutableArray array];
    [self addPickerDateSource:_timerArr1 maxNumber:20 minNumber:5 distanceNumber:1];
    self.timerArr2 = [NSMutableArray array];
    [self addPickerDateSource:_timerArr2 maxNumber:60 minNumber:0 distanceNumber:1];
    
    self.priceArr1 = [NSMutableArray array];
    //    self.priceArr2 = [NSMutableArray array];
    //    [self addPickerViewSource:_priceArr2 maxNumber:200 minNumber:100 distanceNumber:10];
    
    
    self.sexArr1 = [NSMutableArray arrayWithObjects:@"不限", @"男", @"女", nil];
    
    self.ageArr1 = [NSMutableArray array];
    [self addPickerViewSource:_ageArr1 maxNumber:101 minNumber:1 distanceNumber:1];
    self.ageArr2 = [NSMutableArray array];
    [self addPickerViewSource:_ageArr2 maxNumber:101 minNumber:1 distanceNumber:1];
    
    self.ballAgeArr1 = [NSMutableArray array];
    [self addPickerViewSource:self.ballAgeArr1 maxNumber:101 minNumber:0 distanceNumber:1];
    self.ballAgeArr2 = [NSMutableArray array];
    [self addPickerViewSource:self.ballAgeArr2 maxNumber:101 minNumber:0 distanceNumber:1];
    
    self.chaDianArr1 = [NSMutableArray arrayWithObjects:@"不限", @"-5",@"-4",@"-3",@"-2",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"10",@"20",@"30", @"40",@"50", nil];
    self.chaDianArr2 = [NSMutableArray arrayWithObjects:@"不限", @"-5",@"-4",@"-3",@"-2",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"10",@"20",@"30", @"40",@"50", nil];
    
}

// 为选择器添加数据
- (void)addPickerViewSource:(NSMutableArray *)array maxNumber:(NSInteger)maxNumber minNumber:(NSInteger)minNumber distanceNumber:(NSInteger)distanceNumber
{
    for (NSInteger i = minNumber; i < maxNumber; i += distanceNumber) {
        [array addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
}
- (void)addPickerDateSource:(NSMutableArray *)array maxNumber:(NSInteger)maxNumber minNumber:(NSInteger)minNumber distanceNumber:(NSInteger)distanceNumber
{
    for (NSInteger i = minNumber; i < maxNumber; i += distanceNumber) {
        if (i < 10) {
            [array addObject:[NSString stringWithFormat:@"0%ld", (long)i]];
        }
        else
        {
            [array addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        
    }
}
-(void)createPeople

{
    if (_arrayData.count == 0) {
        _viewPeople.frame = CGRectMake(0, 170*ScreenWidth/375, ScreenWidth, 35*ScreenWidth/375);
    }
    else
    {
        _viewPeople.frame = CGRectMake(0, 170*ScreenWidth/375, ScreenWidth, 35*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1));
      
    }
    
    _viewPeople.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_viewPeople];
    
    
    _viewPeople.userInteractionEnabled = YES;
    //  单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    //  点击的次数
    tapGesture.numberOfTapsRequired = 1;
    //  允许（可需）一个手指
    tapGesture.numberOfTouchesRequired = 1;
    [_viewPeople addGestureRecognizer:tapGesture];
    
    
    //    UIView* viewhi = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, ScreenWidth-20*ScreenWidth/375, 1)];
    //    viewhi.backgroundColor = [UIColor lightGrayColor];
    //    [_viewPeople addSubview:viewhi];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 5*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    labelTitle.text = @"选择打球人";
    labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewPeople addSubview:labelTitle];
    //    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-25*ScreenWidth/375, 7*ScreenWidth/375, 13*ScreenWidth/375, 16*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@"left_jt"];
    [_viewPeople addSubview:imgv];
    //存放选择的打球人id
    NSMutableArray* arrayId = [[NSMutableArray alloc]init];
    for (int i = 0; i < _arrayData.count; i++) {
        UIButton* btnImgv = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btnImgv setImage:[UIImage imageNamed:@"tx4"] forState:UIControlStateNormal];
        FriendModel* model = [[FriendModel alloc]init];
        if ([_arrayData[i] isKindOfClass:[FriendModel class]]) {
            model = _arrayData[i];
            [btnImgv sd_setBackgroundImageWithURL:[Helper imageIconUrl:model.pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
            [arrayId addObject:model.userId];
        }
        else
        {
            [btnImgv setImage:[UIImage imageNamed:@"moren.jpg"] forState:UIControlStateNormal];
        }
        
        [_viewPeople addSubview:btnImgv];
        //60*ScreenWidth/375*((_nameAgreeArr.count-1)/6+1)
        btnImgv.frame = CGRectMake(25*ScreenWidth/375+50*ScreenWidth/375*(i%6), 35*ScreenWidth/375 + 50*ScreenWidth/375*(i/6), 50*ScreenWidth/375, 50*ScreenWidth/375);
        btnImgv.layer.cornerRadius = 50*ScreenWidth/375/2;
        btnImgv.layer.masksToBounds = YES;
    }
    NSString* strId;
    if (arrayId.count != 0) {
        strId = [arrayId componentsJoinedByString:@","];
    }
    if (![Helper isBlankString:strId]) {
        [_dict setObject:strId forKey:@"ballId"];
        [_dict setObject:[NSString stringWithFormat:@"%@邀请您参加他的约球活动",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"message"];
        [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"sender"];
        
    }

    

}
- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    _isGenduo = YES;
    TeamInviteViewController *teamVc = [[TeamInviteViewController alloc]init];
    
    //    [_arrayIndex removeAllObjects];
    //    [_arrayData1 removeAllObjects];
    
    teamVc.block = ^(NSMutableArray* arrayIndex, NSMutableArray* arrayData, NSMutableArray *addressArray){
        //接收数据
        [_arrayIndex removeAllObjects];
        [_arrayData1 removeAllObjects];
        [_arrayData removeAllObjects];
        
        [_messageArray removeAllObjects];
        [_telArray removeAllObjects];
        
        _arrayIndex=arrayIndex;
        _arrayData1=arrayData;
        
        for (int i = 0; i < [addressArray[0] count]; i++) {
            [_telArray addObject:addressArray[0][i]];
        }
      
        
        [_arrayData addObjectsFromArray:arrayData[0]];
        [_arrayData addObjectsFromArray:arrayData[1]];
        [_arrayData addObjectsFromArray:arrayData[2]];
//            //存储短信数组
        [_messageArray addObjectsFromArray:arrayData[2]];
        for (UIView *v in [_viewPeople subviews]) {
            [v removeFromSuperview];
        }
        
        [self createPeople];
    
        _isClick = NO;
        
        if (_arrayData.count == 0) {
            
            _viewPeople.frame = CGRectMake(0, 170*ScreenWidth/375, ScreenWidth, 35*ScreenWidth/375);
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 305*ScreenWidth/375);
            _viewBase.frame = CGRectMake(0, 305*ScreenWidth/375, ScreenWidth, 190*ScreenWidth/375);
            _btnChange.frame = CGRectMake(0, 240*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
            if (ScreenHeight == 480) {
                
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568-44*ScreenWidth/375-64-44, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
            }
            else
            {
                if (_arrayData.count != 0) {
                    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-64+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-44, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                }
                else
                {
                    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                }
                
            }
            _scrollView.contentSize = CGSizeMake(0, ScreenHeight-64);
            if (ScreenHeight == 480) {
                _scrollView.contentSize = CGSizeMake(0, 568-49-44);
            }

        }
        else
        {
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 305*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1));
            //            _viewLine.frame = CGRectMake(0, 369*ScreenWidth/375, ScreenWidth, 1);
            _viewBase.frame = CGRectMake(0, 305*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 190*ScreenWidth/375);
            _btnChange.frame = CGRectMake(0, 240*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375);
            if (ScreenHeight == 480) {
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568-44*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
            }
            else
            {
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-64+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-44, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
            }
            _scrollView.contentSize = CGSizeMake(0, ScreenHeight+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-44-44*ScreenWidth/375);
            if (ScreenHeight == 480) {
                _scrollView.contentSize = CGSizeMake(0, 568-49+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-44);
            }

        }
        
               //
        [_tableView reloadData];
        //        }
    };
    teamVc.arrayIndex = _arrayIndex;
    teamVc.arrayData = _arrayData1;
    
    [self.navigationController pushViewController:teamVc animated:YES];
}

-(void)genduoClick

{
    
}




-(void)createChangeView
{
    
    _btnChange = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnChange.frame = CGRectMake(0, 305*ScreenWidth/375-65*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
    _btnChange.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_btnChange];
    [_btnChange addTarget:self action:@selector(viewChangeClick:) forControlEvents:UIControlEventTouchUpInside];
}

//文字设置
-(void)createDetail
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 305*ScreenWidth/375, ScreenWidth, 190*ScreenWidth/375)];
    if (ScreenHeight == 480) {
        _viewBase.frame = CGRectMake(0*ScreenWidth/375, 305*ScreenWidth/375, ScreenWidth, 200*ScreenWidth/375);
    }
    _viewBase.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [_scrollView addSubview:_viewBase];
    
    UILabel* labeltitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 300*ScreenWidth/375, 30*ScreenWidth/375)];
    labeltitle.backgroundColor = [UIColor clearColor];
    labeltitle.text = @"约球详情";
    labeltitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    //    labeltitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBase addSubview:labeltitle];
    
    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 30*ScreenWidth/375, _viewBase.frame.size.width-20*ScreenWidth/375, 90*ScreenWidth/375)];
    _textView.backgroundColor=[UIColor whiteColor]; //背景色
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;
    //设置代理方法的实现类
    _textView.placeholder = @"请输入发布的内容";
    _textView.returnKeyType = UIReturnKeyDone;
    [_viewBase addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textView.tag = 100;
    // 1.监听textView文字改变的通知
    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    UILabel* labelType = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 120*ScreenWidth/375, 305*ScreenWidth/375, 30*ScreenWidth/375)];
    labelType.backgroundColor = [UIColor clearColor];
    labelType.text = @"约球类型";
    labelType.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBase addSubview:labelType];
    
    
    UIView* viewType = [[UIView alloc]initWithFrame:CGRectMake(0, 150*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    viewType.backgroundColor = [UIColor whiteColor];
    [_viewBase addSubview:viewType];
    //左边按钮
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnLeft setTitle:@"公开约球" forState:UIControlStateNormal];
    _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 70*ScreenWidth/375, 0, 0);
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, -60*ScreenWidth/375, 0, 0);
    [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    _btnLeft.frame = CGRectMake(0, 0, 120*ScreenWidth/375, 30*ScreenWidth/375);
    [viewType addSubview:_btnLeft];
    [_btnLeft addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [_dict setValue:@0 forKey:@"ballType"];
    type = 0;
    _btnLeft.tag = 123;
    //右边按钮
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnRight setTitle:@"仅球友约球" forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    _btnRight.frame = CGRectMake(120*ScreenWidth/375, 0, 120*ScreenWidth/375, 30*ScreenWidth/375);
    _btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 70*ScreenWidth/375, 0, 0);
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -60*ScreenWidth/375, 0, 0);
    [viewType addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.tag = 124;
    
    
}

#pragma mark --textview
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    _btnBack.hidden = NO;

    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
//        [UIView animateWithDuration:0.2 animations:^{
//            _scrollView.contentOffset = CGPointMake(0, 0);
            [self.view endEditing:YES];
            _btnBack.hidden = YES;
//        }];
        return NO;
    }
    return YES;
}
#pragma mark --textField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text integerValue] >= 100000) {
        textField.text = @"";
        textField.placeholder = @"请输入小于十万的数";
        [textField resignFirstResponder];
    }
    
//    _strTeamName = textField.text;
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _btnBack.hidden = NO;
    
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

//约球类型点击事件
-(void)btnLeftClick
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    [_btnLeft setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    [_dict setValue:@0 forKey:@"ballType"];
    type = 0;
    
    
}
//约球类型点击事件
-(void)btnRightClick
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    [_btnLeft setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    [_dict setValue:@1 forKey:@"ballType"];
    type = 1;
}

/**
 *  监听文字改变
 */
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = (_textView.text.length != 0);
    
}


-(void)createTableView
{
    _dataArray = [[NSArray alloc]init];
    _clickArr = [[NSArray alloc]init];
    _dataArray = @[@"",@"球场",@"日期",@"时间",@"人均价格",@"",@"短信通知好友",@"",@"性别",@"年龄",@"球龄",@"差点",@"行业"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 305*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_scrollView addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FabuYueBallViewCell" bundle:nil] forCellReuseIdentifier:@"FabuYueBallViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FabuYueTitleCell" bundle:nil] forCellReuseIdentifier:@"FabuYueTitleCell"];
//    YuePriceTableViewCell
    [_tableView registerClass:[YuePriceTableViewCell class] forCellReuseIdentifier:@"YuePriceTableViewCell"];

}

#pragma mark --tableview的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}
//返回每一行所对应的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 || indexPath.row == 7) {
        FabuYueTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FabuYueTitleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"基本信息";
            cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
            cell.jtImage.hidden = YES;
        }
        else
        {
            cell.titleLabel.text = @"约球要求";
            cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        }
        cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        YuePriceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YuePriceTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.tag = 2211;
        cell.textField.delegate = self;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.textColor = [UIColor lightGrayColor];
        cell.textField.returnKeyType = UIReturnKeyDone;
        return cell;
    }
    else
    {
        FabuYueBallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FabuYueBallViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 6) {
            cell.detailLabel.hidden = YES;
            cell.xuanBtn.hidden = NO;
            if (_messageArray.count == 0) {
                cell.strlegth = 0;
            }
            else{
                cell.strlegth = 1;
            }

            cell.dataArray = _messageArray;
            cell.telArray = _telArray;
            ////NSLog(@"%@   %@",cell.dataArray,cell.telArray);
            cell.block = ^(UIViewController *vc)
            {
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
        else
        {
            cell.detailLabel.hidden = NO;
            cell.xuanBtn.hidden = YES;
            
        }
        //        NSArray* array = @[@"",@"请选择球场",@"2012-12-12  星期五",@"请选择时间",@"请选择价格",@"",@"",@"",@"不限",@"不限",@"不限",@"不限",@"不限"];
        cell.detailLabel.text = _arrayChange[indexPath.row];
        cell.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        cell.detailLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        
        
        return cell;
        
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0 || indexPath.row == 7) {
        height = 30*ScreenWidth/375;
    }
    else
    {
        if (_isGenduo == NO) {
            if (indexPath.row == 5) {
                height = 35*ScreenWidth/375;
            }
            else
            {
                height = 35*ScreenWidth/375;
            }
        }
        else
        {
            if (indexPath.row == 5) {
                ////NSLog(@"%f",_viewPeople.frame.size.height);
                height = _viewPeople.frame.size.height;
            }
            else
            {
                height = 35*ScreenWidth/375;
            }
        }
    }
    
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [UIView animateWithDuration:0.2 animations:^{
//        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        _btnBack.hidden = YES;
//    }];
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    _indexChoose = indexPath.row;
    switch (indexPath.row) {
        case 1:
        {
            //选择球场
            BallParkViewController* ballVc = [[BallParkViewController alloc]init];
            [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
                _strBall = balltitle;
                [_dict setValue:[NSNumber numberWithInteger:ballid] forKey:@"golfCourse"];
                [_arrayChange replaceObjectAtIndex:_indexChoose withObject:_strBall];
                [_tableView reloadData];
                
            }];
            
            [self.navigationController pushViewController:ballVc animated:YES];
            
        }
            break;
        case 2:
        {
            //日期
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                _strTime = dateStr;
                //                    [_dict setValue:[NSNumber numberWithInteger:dateSte] forKey:@"golfCourse"];
                [_arrayChange replaceObjectAtIndex:_indexChoose withObject:dateWeek];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:dateVc animated:YES];
            
        }
            break;
        case 3:
        {
            //时间
            if (_isChooseTime == NO) {
                [self createDataClick:@"timer"];
            }
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 8:
        {
            //性别
            if (_isChooseSex == NO) {
                [self createDataClick:@"sex"];
            }
        }
            break;
        case 9:
        {
            //年龄
            if (_isChooseAge == NO) {
                [self createDataClick:@"age"];
            }
        }
            break;
        case 10:
        {
            //球龄
            if (_isChooseBall == NO) {
                [self createDataClick:@"ballAge"];
            }
        }
            break;
        case 11:
        {
            //差点
            if (_isChooseChadian == NO) {
                [self createDataClick:@"chaDian"];
            }
        }
            break;
            
        case 12:
        {
            //行业
            JobChooseViewController *jobVc = [[JobChooseViewController alloc]init];
            [jobVc setCallback:^(NSString *jobtitle, NSInteger jobid) {
                _strJob = jobtitle;
                [_dict setValue:[NSNumber numberWithInteger:jobid] forKey:@"workId"];
                [_arrayChange replaceObjectAtIndex:_indexChoose withObject:_strJob];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:jobVc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark --自定义UIalert
//自定义alert视图
- (UIView *)createMoneyView
{
    UIView *moneyView = [[UIView alloc] init];
    
    //
    return moneyView;
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:124];
    [textField resignFirstResponder];
    ////NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}


/**
 * 点击按钮折叠tableview，并且改变tableview下面空间的坐标
 *
 *  @param btn tableview上覆盖的按钮
 */
#pragma mark --点击弹出展示列表和关闭展示列表
-(void)viewChangeClick:(UIButton *)btn
{
    /**
     *  隐藏选择器
     */
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    _isChooseAge     = NO;
    _isChooseTime    = NO;
    _isChoosePrice   = NO;
    _isChooseChadian = NO;
    _isChooseSex     = NO;
    _isChooseArea    = NO;
    _isChooseBall    = NO;
    
//    _viewPeople.frame = CGRectMake(0, 170*ScreenWidth/375, ScreenWidth, 35*ScreenWidth/375);
    _Height = 100*ScreenWidth/375;
    
    if (_isClick == YES) {
        
        _count = 1;
        if (_arrayData.count == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = CGRectMake(0, 0, ScreenWidth, 305*ScreenWidth/375);
                //            _viewLine.frame = CGRectMake(0, 369*ScreenWidth/375, ScreenWidth, 1);
                _viewBase.frame = CGRectMake(0, 305*ScreenWidth/375, ScreenWidth, 190*ScreenWidth/375);
                
                _btnChange.frame = CGRectMake(0, 240*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
                
                
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                if (ScreenHeight == 480) {
                    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568-44*ScreenWidth/375-64-50*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                }
                
                _scrollView.contentSize = CGSizeMake(0, 0);
                if (ScreenHeight == 480) {
                    _scrollView.contentSize = CGSizeMake(0, 568-70);
                }
            }];
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = CGRectMake(0, 0, ScreenWidth, 305*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1));
                //            _viewLine.frame = CGRectMake(0, 369*ScreenWidth/375, ScreenWidth, 1);
                _viewBase.frame = CGRectMake(0, 305*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 190*ScreenWidth/375);
                
                _btnChange.frame = CGRectMake(0, 240*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375);
                
                
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-64+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-49, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                if (ScreenHeight == 480) {
                    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568-44*ScreenWidth/375-64+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-49, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                }
//                _scrollView.contentOffset = CGPointMake(0, 0);
                _scrollView.contentSize = CGSizeMake(0, ScreenHeight-49+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-49);
                if (ScreenHeight == 480) {
                    _scrollView.contentSize = CGSizeMake(0, 568-49+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-49);
                }
            }];
        }
        
        //        }
        
        _isClick = NO;
        
    }
    else
    {
        _count = 6;
        if (_arrayData.count == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = CGRectMake(0, 0, ScreenWidth, 445*ScreenWidth/375);
                //            _viewLine.frame = CGRectMake(0, 479*ScreenWidth/375+65*ScreenWidth/375, ScreenWidth, 1);
                _viewBase.frame = CGRectMake(0, 445*ScreenWidth/375, ScreenWidth, 190*ScreenWidth/375);
                _btnChange.frame = CGRectMake(0, 240*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight+35*ScreenWidth/375-49, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                if (ScreenHeight == 480) {
                    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568+50*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                }
                
            }];
            _scrollView.contentSize = CGSizeMake(0, ScreenHeight+105*ScreenWidth/375-49);
            if (ScreenHeight == 480) {
                _scrollView.contentSize = CGSizeMake(0, 568+55*ScreenWidth/375);
            }
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = CGRectMake(0, 0, ScreenWidth, 445*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1));
                //            _viewLine.frame = CGRectMake(0, 479*ScreenWidth/375+65*ScreenWidth/375, ScreenWidth, 1);
                _viewBase.frame = CGRectMake(0, 445*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 190*ScreenWidth/375);
                _btnChange.frame = CGRectMake(0, 240*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 30*ScreenWidth/375);
                _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight+35*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-49, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                if (ScreenHeight == 480) {
                    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568+50*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
                }
            }];
            _scrollView.contentSize = CGSizeMake(0, ScreenHeight+105*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1)-49);
            if (ScreenHeight == 480) {
                _scrollView.contentSize = CGSizeMake(0, 568+55*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1));
            }
        }
        
        _isClick = YES;
        //        _isGenduo = YES;
    }
}
//选择器
-(void)createDataClick:(NSString *)string
{
    _isChooseTime    = YES;
    _isChoosePrice   = YES;
    _isChooseAge     = YES;
    _isChooseChadian = YES;
    _isChooseSex     = YES;
    _isChooseArea    = YES;
    _isChooseBall    = YES;
    _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    [UIView animateWithDuration:0.2 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight/3*2 - 49, ScreenWidth, ScreenHeight/3);
        _scrollView.userInteractionEnabled = NO;
    } completion:nil];
    _selectDateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectDateView];
    
    
    _button1.frame = CGRectMake(20, 5, 30, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(buttonShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectDateView addSubview:_button1];
    
    _button2.frame = CGRectMake(ScreenWidth-50, 5, 30, 30);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(buttonMissClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectDateView addSubview:_button2];
    
    // 性别，年龄，差点的选择器
    // UIPickerView只有三个高度， heights for UIPickerView (162.0, 180.0 and 216.0)，用代码设置 pickerView.frame=cgrectmake()...
    
    // 设定选中默认值
    if ([string isEqualToString:@"timer"]) {
        
        self.distinctionNumber = 0;
        [self setUpPickerView:2 frame:CGRectMake(50, _button1.frameY + _button1.height, _selectDateView.width / 2 - 80, 162)];
        
    } else if ([string isEqualToString:@"price"]) {
        
        self.distinctionNumber = 1;
        [self setUpPickerView:1 frame:CGRectMake(50, _button1.frameY + _button1.height, _selectDateView.width / 2 - 80, 162)];
    } else if ([string isEqualToString:@"sex"]) {
        // 确定distinctionNumber，才确定行数和组件数
        self.distinctionNumber = 2;
        [self setUpPickerView:1 frame:CGRectMake(50, _button1.frameY + _button1.height, _selectDateView.width / 2 - 80, 162)];
    } else if ([string isEqualToString:@"age"]) {
        self.distinctionNumber = 3;
        [self setUpPickerView:2 frame:CGRectMake(50, _button1.frameY + _button1.height, _selectDateView.width / 2 - 80, 162)];
    } else if ([string isEqualToString:@"ballAge"]) {
        self.distinctionNumber = 4;
        [self setUpPickerView:2 frame:CGRectMake(50, _button1.frameY + _button1.height, _selectDateView.width / 2 - 80, 162)];
    } else if ([string isEqualToString:@"chaDian"]) {
        self.distinctionNumber = 5;
        [self setUpPickerView:2 frame:CGRectMake(50, _button1.frameY + _button1.height, _selectDateView.width / 2 - 80, 162)];
    }
    
    
}

// 根据选择器的数量和尺寸建立选择器
- (void)setUpPickerView:(NSInteger)pickerViewNumber frame:(CGRect)frame
{
    // 注意尺寸的设定
    if (pickerViewNumber == 1) {
        self.pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.showsSelectionIndicator = YES;
        
        self.pickerView1.frame = CGRectMake(50, frame.origin.y, _selectDateView.width - 100, 162);
        ////NSLog(@"%f    %f",frame.origin.y,frame.size.height);
        _pickerView1.delegate = self;
        _pickerView1.dataSource = self;
        [_pickerView1 selectRow:1 inComponent:0 animated:YES];
        [_selectDateView addSubview:_pickerView1];
    } else if (pickerViewNumber == 2) {
        // 确定distinctionNumber，才确定行数和组件数
        
        
        self.pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.showsSelectionIndicator = YES;
        self.pickerView1.frame = CGRectMake(50, frame.origin.y, _selectDateView.width / 2 - 80, 162);
        
        // 时间
        if (self.distinctionNumber == 0) {
            UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(_pickerView1.frameX + _pickerView1.width + 30, _pickerView1.frameY + 75, 5, 15)];
            imag.contentMode = UIViewContentModeScaleAspectFit;
            imag.image = [UIImage imageNamed:@"timeLiangDian"];
            imag.tag = 1001;
            //            imag.backgroundColor = [UIColor redColor];
            [_selectDateView addSubview:imag];
        } else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_pickerView1.frameX + _pickerView1.width + 20, _pickerView1.frameY + 40 * 2, 20, 1)];
            view.tag = 1001;
            view.backgroundColor = [UIColor redColor];
            [_selectDateView addSubview:view];
        }
        
        self.pickerView2 = [[UIPickerView alloc] init];
        _pickerView2.showsSelectionIndicator = YES;
        self.pickerView2.frame = CGRectMake(_pickerView1.frameX + _pickerView1.width + 60, _pickerView1.frameY, _pickerView1.width, 162);
        [_selectDateView addSubview:_pickerView1];
        [_selectDateView addSubview:_pickerView2];
        
        _pickerView1.delegate = self;
        _pickerView1.dataSource = self;
        _pickerView2.delegate = self;
        _pickerView2.dataSource = self;
        [_pickerView1 selectRow:1 inComponent:0 animated:YES];
        [_pickerView2 selectRow:1 inComponent:0 animated:YES];

    }
    
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (self.distinctionNumber) {
        case 0:
            if (pickerView == self.pickerView1) {
                return self.timerArr1.count;
            } else {
                return self.timerArr2.count;
            }
            break;
        case 1:
            if (pickerView == self.pickerView1) {
                return self.priceArr1.count;
            } else {
                return self.priceArr2.count;
            }
            break;
        case 2:
            
            return self.sexArr1.count;
            break;
        case 3:
            if (pickerView == self.pickerView1) {
                return self.ageArr1.count;
            } else {
                return self.ageArr2.count;
            }
            break;
        case 4:
            if (pickerView == self.pickerView1) {
                return self.ballAgeArr1.count;
            } else {
                return self.ballAgeArr2.count;
            }
            break;
        case 5:
            if (pickerView == self.pickerView1) {
                return self.chaDianArr1.count;
            } else {
                return self.chaDianArr2.count;
            }
            break;
        default:
            return 0;
            break;
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.distinctionNumber) {
        case 0:
            if (pickerView == self.pickerView1) {
                return [self.timerArr1 objectAtIndex:row];
            } else {
                return [self.timerArr2 objectAtIndex:row];
            }
            break;
        case 1:
            if (pickerView == self.pickerView1) {
                return [self.priceArr1 objectAtIndex:row];
            } else {
                return [self.priceArr2 objectAtIndex:row];
            }
            break;
        case 2:
            
            return [self.sexArr1 objectAtIndex:row];
            break;
        case 3:
            if (pickerView == self.pickerView1) {
                return [self.ageArr1 objectAtIndex:row];
            } else {
                return [self.ageArr2 objectAtIndex:row];
            }
            break;
        case 4:
            if (pickerView == self.pickerView1) {
                return [self.ballAgeArr1 objectAtIndex:row];
            } else {
                return [self.ballAgeArr2 objectAtIndex:row];
            }
            break;
        case 5:
            if (pickerView == self.pickerView1) {
                return [self.chaDianArr1 objectAtIndex:row];
            } else {
                return [self.chaDianArr2 objectAtIndex:row];
            }
            break;
        default:
            return 0;
            break;
    }
    
}

// 确定tableViewCell的数值
- (void)tableViewChangeCellValue
{
    // uitableview已经伸缩，出现性别球龄和差点
    NSInteger pickerView1SelectedNumber = [self.pickerView1 selectedRowInComponent:0];
    NSInteger pickerView2SelectedNumber = [self.pickerView2 selectedRowInComponent:0];
    switch (self.distinctionNumber) {
        case 0:
        {
            NSString *str1 =[self.timerArr1 objectAtIndex:pickerView1SelectedNumber];
            NSString *str2 = [self.timerArr2 objectAtIndex:pickerView2SelectedNumber];

            [_arrayChange replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@:%@", str1, str2]];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case 1:
        {
            NSString *str1 =[self.priceArr1 objectAtIndex:pickerView1SelectedNumber];
            [_arrayChange replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@", str1]];
            //            [_tableView reloadData];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
        }
            break;
        case 2:
            
        {
            NSString *str1 =[self.sexArr1 objectAtIndex:pickerView1SelectedNumber];
            [_arrayChange replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%@", str1]];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([str1 isEqualToString:@"不限"]) {
                [_dict setObject:@-1 forKey:@"sex"];
            }
            else if ([str1 isEqualToString:@"男"])
            {
                [_dict setObject:@1 forKey:@"sex"];
            }
            else
            {
                [_dict setObject:@0 forKey:@"sex"];
            }
        }
            break;
        case 3:
        {
            NSString *str1 =[self.ageArr1 objectAtIndex:pickerView1SelectedNumber];
            NSString *str2 = [self.ageArr1 objectAtIndex:pickerView2SelectedNumber];
            if ([str1 integerValue] < [str2 integerValue]) {
                [_arrayChange replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%@-%@", str1, str2]];
                [_dict setObject:[NSString stringWithFormat:@"%@-%@", str1, str2] forKey:@"age"];
            }
            else
            {
                [_arrayChange replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%@-%@", str2, str1]];
                [_dict setObject:[NSString stringWithFormat:@"%@-%@", str2, str1] forKey:@"age"];
            }
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        case 4:
        {
            NSString *str1 =[self.ballAgeArr1 objectAtIndex:pickerView1SelectedNumber];
            NSString *str2 = [self.ballAgeArr2 objectAtIndex:pickerView2SelectedNumber];
            if ([str1 integerValue] < [str2 integerValue]) {
                [_arrayChange replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@-%@", str1, str2]];
//
                [_dict setObject:[NSString stringWithFormat:@"%@-%@", str1, str2] forKey:@"ballYear"];
            }
            else
            {
                [_arrayChange replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@-%@", str2, str1]];
                [_dict setObject:[NSString stringWithFormat:@"%@-%@", str2, str1] forKey:@"ballYear"];
            }

            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:10 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        case 5:
        {
            NSString *str1 =[self.chaDianArr1 objectAtIndex:pickerView1SelectedNumber];
            NSString *str2 = [self.chaDianArr2 objectAtIndex:pickerView2SelectedNumber];
            if ([str1 integerValue] < [str2 integerValue] && ![str1 isEqualToString:@"不限"] && ![str2 isEqualToString:@"不限"]) {
                [_arrayChange replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@-%@", str1, str2]];
                [_dict setObject:[NSString stringWithFormat:@"%@-%@", str1, str2] forKey:@"almost"];
            }
            else
            {
                [_arrayChange replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@-%@", str2, str1]];
                [_dict setObject:[NSString stringWithFormat:@"%@-%@", str2, str1] forKey:@"almost"];
            }
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:11 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        default:
            
            break;
    }
    
    
    
}
- (void)buttonShowClick:(UIButton*)button {
    _isGenduo = YES;
    _scrollView.userInteractionEnabled = YES;
    _isChooseAge     = NO;
    _isChooseChadian = NO;
    _isChooseSex     = NO;
    _isChooseArea    = NO;
    _isChooseBall    = NO;
    _isChooseTime    = NO;
    _isChoosePrice   = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    } completion:nil];
    
    // 移除选择器和减号
    UIView *vi = [_selectDateView viewWithTag:1001];
    [vi removeFromSuperview];
    [_pickerView1 removeFromSuperview];
    [_pickerView2 removeFromSuperview];
}
- (void)buttonMissClick:(UIButton*)button {
    _isGenduo = YES;
    _scrollView.userInteractionEnabled = YES;
    _isChooseAge     = NO;
    _isChooseChadian = NO;
    _isChooseSex     = NO;
    _isChooseArea    = NO;
    _isChooseBall    = NO;
    _isChooseTime    = NO;
    _isChoosePrice   = NO;
    [self tableViewChangeCellValue];
    [UIView animateWithDuration:0.2 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    } completion:nil];
    
    
    // 移除选择器和减号
    UIView *vi = [_selectDateView viewWithTag:1001];
    [vi removeFromSuperview];
    [_pickerView1 removeFromSuperview];
    [_pickerView2 removeFromSuperview];
}


//提交按钮
-(void)createBtn
{
    
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    _btnFabu = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-44*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
    if (ScreenHeight == 480) {
        _btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568-54*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 40*ScreenWidth/375);
    }
    [_scrollView addSubview:_btnFabu];
    [_btnFabu setTitle:@"发起约球" forState:UIControlStateNormal];
    [_btnFabu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnFabu.backgroundColor = [UIColor orangeColor];
    [_btnFabu addTarget:self action:@selector(fabuClick) forControlEvents:UIControlEventTouchUpInside];
    
    _btnFabu.layer.cornerRadius = 10;
    _btnFabu.layer.masksToBounds = YES;
    
}

-(void)fabuClick{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在发布...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    UITextField* texf = (UITextField *)[self.view viewWithTag:2211];
    [_dict setObject:texf.text forKey:@"pPrice"];
    [_dict setValue:_textView.text forKey:@"ballInfo"];
    NSString* str = [[NSString alloc]init];
    str = [NSString stringWithFormat:@"%@  %@:00",_strTime,_arrayChange[3]];
    [_dict setValue:str forKey:@"getDate"];
    
    //用户id
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    if (_isChooseSex == 0) {
        [_dict setObject:@-1 forKey:@"sex"];
    }
    
    ////NSLog(@"%@",_dict);
    //验证球场是否选择
    if (_strBall != nil) {
        
        if (![_arrayChange isEqual:@"请重新选择"]) {
            
            if(type != 100)
                
            {
                [[PostDataRequest sharedInstance] postDataRequest:kBallsave_URL parameter:_dict success:^(id respondsData) {
                    
                    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([[userData objectForKey:@"success"] boolValue]) {

                        [Helper alertViewWithTitle:@"发布成功" withBlockCancle:^{
                            
                        } withBlockSure:^{
                            YueMyBallViewController* yueVc = [[YueMyBallViewController alloc]init];
                            yueVc.popViewNumber = 2;
                            [self.navigationController pushViewController:yueVc animated:YES];
                        } withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                        
                    }else {
                        [Helper alertViewWithTitle:@"发布失败，请检查填写信息是否正确" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }
                } failed:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Helper alertViewWithTitle:@"请选择约球类型" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
            
        }else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [Helper alertViewWithTitle:@"请重新选择时间" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
    }else {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *mobileAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请重新选择球场" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [mobileAlertView show];
        [Helper alertViewWithTitle:@"请重新选择球场" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 1000) {

        
        YueMyBallViewController* yueVc = [[YueMyBallViewController alloc]init];
        yueVc.popViewNumber = 2;
        [self.navigationController pushViewController:yueVc animated:YES];
        
        
    }
}
#pragma mark --滑动视图弹窗消失
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}


@end
