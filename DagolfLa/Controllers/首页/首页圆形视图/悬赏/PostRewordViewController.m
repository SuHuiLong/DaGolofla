//
//  PostRewordViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "PostRewordViewController.h"
#import "IWTextView.h"
#import "RewardAreaViewController.h"
#import "CustomIOSAlertView.h"
#import "DateTimeViewController.h"
#import "BallParkViewController.h"

#import "FabuPostTableViewCell.h"
#import "UIView+ChangeFrame.h"
#import "MineRewardViewController.h"

#import "MBProgressHUD.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "YueBallHallView.h"
#define kRewordsave_URL @"aboutBallReward/save.do"

@interface PostRewordViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    
    UIScrollView* _scrollView;
    //发布的文字视图
    IWTextView* _textView;
    UIView* _viewBase;
    CGFloat _contentSizeY;
    
    //点击事件影响坐标
    UIButton* _btnChange;
    UITableView* _tableView;
    NSArray* _dataArray;
    NSArray* _clickArr;
    UIView* _viewLine;
    NSInteger _count;
    BOOL _isClick;
    
    BOOL _isMianYi;
    NSString* _strTime;
    NSString* _strBall;
    UITextField* _textPrice;
    
    UITextField* _textTitle;
    
    //选择器
    UIView* _selectDateView;
    BOOL _isChooseAge;
    BOOL _isChooseChadian;
    BOOL _isChooseSex;
    UIPickerView* _pickerView;
    NSInteger _indexChoose;
    NSString* _firstString, *_secondString;
    NSMutableArray* _arrayChange;
    
    NSMutableArray* _firstArray;
    NSMutableArray* _secondArray;
    
    NSMutableDictionary* _dict;
    
    NSString* _momey;
    
    YueBallHallView *_viewTanTu;
    BOOL _showView;
    
    UIButton* _btnBalack;
    CustomIOSAlertView *_alertView;
    
    MBProgressHUD* _progress;
}


// 性别，球龄，差点的数据
@property (nonatomic, strong) UIPickerView *pickerView1;
@property (nonatomic, strong) UIPickerView *pickerView2;
@property (nonatomic, strong) NSMutableArray *sexArr;
@property (nonatomic, strong) NSMutableArray *ballAgeArr1;
@property (nonatomic, strong) NSMutableArray *ballAgeArr2;
@property (nonatomic, strong) NSMutableArray *chaDianArr1;
@property (nonatomic, strong) NSMutableArray *chaDianArr2;
// 根据distinctionNumber，区分性别，球龄，差点的选择器
@property (nonatomic, assign) NSInteger distinctionNumber;
// 根据changeCellValue， 区分是否进行选择性别，球龄，差点
@property (nonatomic, assign) NSInteger changeCellValue;
@property (nonatomic, assign) NSInteger changeCellValue1;
@property (nonatomic, assign) NSInteger changeCellValue2;


// 点击悬赏要求，uitableviw伸缩，cell的值不变
@property (nonatomic, assign) NSInteger changeNumber;

@end

@implementation PostRewordViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _showView = NO;
    
    
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布悬赏";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
    
    // 初始化性别，球龄，差点的数据
    [self initializationData];
    
    _momey = @"面议";
    _dict = [[NSMutableDictionary alloc]init];
    _isMianYi = NO;
    _selectDateView = [[UIView alloc]init];
    _pickerView = [[UIPickerView alloc]init];
    _arrayChange = [[NSMutableArray alloc]init];
    
    _arrayChange = [NSMutableArray arrayWithArray:@[@"不限",@"不限",@"不限"]];
    _strTime = @"请选择";
    _strBall = @"请选择";
    
    _isClick = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _scrollView.contentSize = CGSizeMake(0, 568-49);
    
    [self createTableView];
    
    [self createDetail];
    
    [self createBtn];
    
    [self createChangeView];
    
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"genduo3"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(ShowViewClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    _btnBalack = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnBalack.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _btnBalack.alpha = 0.5;
//    _btnBalack.backgroundColor = [UIColor blackColor];
    _btnBalack.hidden = YES;
    [self.view addSubview:_btnBalack];
    [_btnBalack addTarget:self action:@selector(btnblackClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)btnblackClick
{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        _btnBalack.hidden = YES;
    }];
}
-(void)ShowViewClick{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        _btnBalack.hidden = YES;
    }];
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


-(void)createChangeView
{
    
    _btnChange = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnChange.frame = CGRectMake(0, 170*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375);
    _btnChange.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_btnChange];
    [_btnChange addTarget:self action:@selector(viewChaClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewChaClick:(UIButton *)btn
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    if (_isClick == YES) {
        
        //_count = 1;
        [UIView animateWithDuration:0.1 animations:^{
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 235*ScreenWidth/375);
            _viewLine.frame = CGRectMake(0, 234*ScreenWidth/375, ScreenWidth, 1);
            _viewBase.frame = CGRectMake(10*ScreenWidth/375, 240*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, ScreenHeight-400*ScreenWidth/375-64);
        }];
        //        [_tableView reloadData];
        _isClick = NO;
    }
    else
    {
        //_count = 3;
        
        [UIView animateWithDuration:0.1 animations:^{
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 305*ScreenWidth/375);
            _viewLine.frame = CGRectMake(0, 304*ScreenWidth/375, ScreenWidth, 1);
            _viewBase.frame = CGRectMake(10*ScreenWidth/375, 310*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, ScreenHeight-400*ScreenWidth/375-64);
            
        }];
        //        [_tableView reloadData];
        _isClick = YES;
    }
    
    
}


-(void)createBtn
{
    UIButton* btnFabu = [UIButton buttonWithType:UIButtonTypeSystem];
    btnFabu.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-54*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44);
    if (ScreenHeight == 480) {
        btnFabu.frame = CGRectMake(10*ScreenWidth/375, 568-54*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44);
    }
    [_scrollView addSubview:btnFabu];
    [btnFabu setTitle:@"发布" forState:UIControlStateNormal];
    [btnFabu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFabu.backgroundColor = [UIColor orangeColor];
    [btnFabu addTarget:self action:@selector(fabuClick:) forControlEvents:UIControlEventTouchUpInside];
    btnFabu.layer.cornerRadius = 10;
    btnFabu.layer.masksToBounds = YES;
    
}
//文字设置
-(void)createDetail
{
    _viewBase = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 240*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, ScreenHeight-400*ScreenWidth/375-64)];
    if (ScreenHeight == 480) {
        _viewBase.frame = CGRectMake(10*ScreenWidth/375, 275*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 568-400*ScreenWidth/375-64);
    }
    _viewBase.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _contentSizeY = 10*ScreenWidth/375 + 90*ScreenWidth/375;
    [_scrollView addSubview:_viewBase];
    
    //发布的文字
    _textView = [[IWTextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, ScreenHeight-410*ScreenWidth/375-64)];
    if (ScreenHeight == 480) {
        _textView.frame = CGRectMake(5*ScreenWidth/375, 5*ScreenWidth/375, _viewBase.frame.size.width-10*ScreenWidth/375, 568-415*ScreenWidth/375-64);
    }
    _textView.backgroundColor=[UIColor whiteColor]; //背景色
    //垂直方向上可以拖拽
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;
    //设置代理方法的实现类
    _tableView.scrollEnabled= NO;
    _textView.placeholder = @"请输入发布的内容";
    [_viewBase addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    _textView.tag = 100;
    // 1.监听textView文字改变的通知
    [IWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
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

    _dataArray = @[@[@"悬赏标题",@"悬赏金额",@"开球日期",@"球场"],@[@"性别",@"球龄",@"差点"]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 235*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [_scrollView addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"FabuPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"FabuPostTableViewCell"];
    
    _viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 234*ScreenWidth/375, ScreenWidth, 1)];
    _viewLine.backgroundColor = [UIColor lightGrayColor];
    [_tableView addSubview:_viewLine];
    
    _textTitle = [[UITextField alloc]initWithFrame:CGRectMake(150*ScreenWidth/375, 35*ScreenWidth/375, ScreenWidth-195*ScreenWidth/375, 25)];
    _textTitle.placeholder = @"标题";
    _textTitle.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    _textTitle.textAlignment = NSTextAlignmentRight;
    _textTitle.tag = 123;
    _textTitle.delegate = self;
    _textTitle.textColor = [UIColor lightGrayColor];
    [_tableView addSubview:_textTitle];
    
}

#pragma mark --tableview的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) {
        number = 4;
    }
    else
    {
        _count = 3;
    }
    return section == 0?number:_count;
}
//返回每一行所对应的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FabuPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FabuPostTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _dataArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row < 1) {
        cell.detailLabel.alpha = 0;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell.detailLabel.text = _momey;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        cell.detailLabel.alpha = 1;
        cell.detailLabel.text = _strTime;
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        cell.detailLabel.alpha = 1;
        cell.detailLabel.text = _strBall;
    }
    else
    {
        cell.detailLabel.alpha = 1;
        cell.detailLabel.text = _arrayChange[indexPath.row];
    }
    return cell;
    
}


//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*ScreenWidth/375;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    @"基本信息":@"悬赏要求"
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    if (section == 0) {
        label.text = @"  基本信息";
    }
    else
    {
        label.text = @"  悬赏要求";
        UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20*ScreenWidth/375, 7*ScreenWidth/375, 13*ScreenWidth/375, 16*ScreenWidth/375)];
        imgv.image = [UIImage imageNamed:@"left_jt"];
        imgv.transform = CGAffineTransformMakeRotation(M_PI_2);
        [view addSubview:imgv];
    }
    label.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [view addSubview:label];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _showView = NO;
    _viewTanTu.hidden = YES;
    UITextField* text = (UITextField *)[self.view viewWithTag:123];
    [text resignFirstResponder];
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    [textField resignFirstResponder];
    
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //标题
                
            }
                break;
            case 1:
            {
                //               金额
                _alertView = [[CustomIOSAlertView alloc] init];
                _alertView.backgroundColor = [UIColor whiteColor];
                [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
                //[alertView setDelegate:self];
                _alertView.delegate = self;
                [_alertView setContainerView:[self createMoneyView]];
                [_alertView show];
            }
                break;
            case 2:
            {
                //日期
                DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
                [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                    _strTime = dateStr;
                    
                    [_dict setValue:dateStr forKey:@"getDate"];
                    [_tableView reloadData];
                }];
                [self.navigationController pushViewController:dateVc animated:YES];
                
            }
                break;
            case 3:
            {
                //球场
                BallParkViewController* ballVc = [[BallParkViewController alloc]init];
                [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
                    _strBall = balltitle;
                    [_dict setValue:[NSNumber numberWithInteger:ballid] forKey:@"golfCourse"];
                    [_tableView reloadData];
                }];
                [self.navigationController pushViewController:ballVc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        _indexChoose = indexPath.row;
        switch (indexPath.row) {
            case 0:
            {
                //性别
                if (_isChooseSex == NO) {
                    [self createDateClick:@"sex"];
                }
            }
                break;
            case 1:
            {
                if (_isChooseAge == NO) {
                    [self createDateClick:@"age"];
                }
            }
                break;
            case 2:
            {
                if (_isChooseChadian == NO) {
                    [self createDateClick:@"chadian"];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark --自定义UIalert
//自定义alert视图
- (UIView *)createMoneyView
{
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255*ScreenWidth/375, 200*ScreenWidth/375)];
    //    moneyView.backgroundColor = [UIColor redColor];
    //标题
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, moneyView.frame.size.width, 30*ScreenWidth/375)];
    labelTitle.text = @"  请选择金额";
    labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [moneyView addSubview:labelTitle];
    //划线
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, moneyView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [labelTitle addSubview:lineView];
    //设置按钮
    UIButton* btnPrite = [UIButton buttonWithType:UIButtonTypeSystem];
    btnPrite.frame = CGRectMake(77.5*ScreenWidth/375, 50*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375);
    //    btnPrite.backgroundColor = [UIColor blackColor];
    [btnPrite setTitle:@"面议" forState:UIControlStateNormal];
    [moneyView addSubview:btnPrite];
    [btnPrite addTarget:self action:@selector(mianyiClick) forControlEvents:UIControlEventTouchUpInside];
    
    //textfield
    _textPrice = [[UITextField alloc]initWithFrame:CGRectMake(72.5*ScreenWidth/375, 100*ScreenWidth/375, 110*ScreenWidth/375, 30)];
    _textPrice.placeholder = @"请输入价格";
    _textPrice.backgroundColor = [UIColor clearColor];
    _textPrice.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _textPrice.keyboardType = UIKeyboardTypeNumberPad;
    _textPrice.tag = 124;
    _textPrice.textAlignment = NSTextAlignmentCenter;
    _textPrice.delegate = self;
    _textPrice.keyboardType = UIKeyboardTypeNumberPad;
    [moneyView addSubview:_textPrice];
    CALayer *buttonLayer = [_textPrice layer];
    [buttonLayer setBorderColor:[UIColor blueColor].CGColor];
    [buttonLayer setBorderWidth:1];
    _textPrice.layer.cornerRadius = 5;
    _textPrice.layer.masksToBounds = YES;
    //元
    UILabel *labelYuan = [[UILabel alloc]initWithFrame:CGRectMake(210*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375, 30*ScreenWidth/375)];
    labelYuan.text = @"元";
    labelYuan.textAlignment = NSTextAlignmentCenter;
    labelYuan.textColor = [UIColor blueColor];
    labelYuan.font = [UIFont systemFontOfSize:18*ScreenWidth/375];
    [moneyView addSubview:labelYuan];
    
    return moneyView;
}

-(void)mianyiClick
{
    _isMianYi = YES;
    _momey = @"面议";
    [_tableView reloadData];
    [_alertView  close];
    [_dict setValue:@-1 forKey:@"reMoney"];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:124];
    [textField resignFirstResponder];
    
    if ((int)buttonIndex == 1) {
        _isMianYi = NO;
        _momey = _textPrice.text;
        [_tableView reloadData];
        //判断输入的数字中是否有空格字符
        if (![Helper isBlankString:_textPrice.text]) {
            [_dict setValue:_textPrice.text forKey:@"reMoney"];
        }else
        {
            [_dict setValue:@-1 forKey:@"reMoney"];
            _momey = @"不限";
        }
    }
    [alertView close];
}

#pragma mark --键盘响应事件
//键盘响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:100];
    [textField resignFirstResponder];
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        _btnBalack.hidden = YES;
        
    }];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
        
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
            [self.view endEditing:YES];
            _btnBalack.hidden = YES;
        }];
        return NO;
    }
    
    return YES;
}

#pragma mark --textField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([_textPrice.text integerValue] >= 100000) {
        _textPrice.text = @"";
        _textPrice.placeholder = @"请输入小于十万的数";
        [_textPrice resignFirstResponder];
        return NO;
    }
    if (![Helper isPureNumandCharacters:_textPrice.text]) {
        _textPrice.text = @"";
        _textPrice.placeholder = @"请输入纯数字";
        [_textPrice resignFirstResponder];
        return NO;
    }
    
    //    _strTeamName = textField.text;
//    [_dict setObject:_textPrice.text forKey:@"pPrice"];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _showView = NO;
    _viewTanTu.hidden = YES;
    if (_isClick == NO) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _scrollView.contentOffset = CGPointMake(0, 120);
            _btnBalack.hidden = NO;
//        }];
    }
    else
    {
//        [UIView animateWithDuration:0.2 animations:^{
//            _scrollView.contentOffset = CGPointMake(0, 220);
            _btnBalack.hidden = NO;
//        }];
    }
    
}

#pragma mark --初始化picker数据
// 初始化性别，球龄，差点的数据
- (void)initializationData
{
    self.sexArr = [NSMutableArray arrayWithObjects:@"不限", @"男", @"女", nil];
    
    self.ballAgeArr1 = [[NSMutableArray alloc]init];
    [self addPickerViewSource:_ballAgeArr1 maxNumber:101 minNumber:0 distanceNumber:2];
    self.ballAgeArr2 = [[NSMutableArray alloc]init];
    [self addPickerViewSource:_ballAgeArr2 maxNumber:101 minNumber:0 distanceNumber:2];

    
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

//时间选择器
-(void)createDateClick:(NSString *)string
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    _isChooseAge = YES;
    _isChooseChadian = YES;
    _isChooseSex = YES;
    _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    [UIView animateWithDuration:0.5 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight/3*2 - 49, ScreenWidth, ScreenHeight/3);
        // 利用交互来完成tableView是否可以点击
        _scrollView.userInteractionEnabled = NO;
    } completion:nil];
    _selectDateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectDateView];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(20*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
    
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonfalseClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectDateView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(ScreenWidth-50*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
    [button2 setTitle:@"确认" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonsureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectDateView addSubview:button2];
    
    
    // 性别，年龄，差点的选择器
    // UIPickerView只有三个高度， heights for UIPickerView (162.0, 180.0 and 216.0)，用代码设置 pickerView.frame=cgrectmake()...
    
    // 设定选中默认值
    if ([string isEqualToString:@"sex"]) {
        self.changeCellValue = 1;
        self.distinctionNumber = 0;
        self.pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.showsSelectionIndicator = YES;
        self.pickerView1.frame = CGRectMake(50, button1.frameY + button1.height, _selectDateView.width - 100, 162);
        _pickerView1.delegate = self;
        _pickerView1.dataSource = self;
        [_pickerView1 selectRow:1 inComponent:0 animated:YES];
        [_selectDateView addSubview:_pickerView1];
        
    } else if ([string isEqualToString:@"age"]) {
        self.changeCellValue1 = 1;
        self.distinctionNumber = 1;
        self.pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.showsSelectionIndicator = YES;
        self.pickerView1.frame = CGRectMake(50, button1.frameY + button1.height, _selectDateView.width / 2 - 80, 162);
        _pickerView1.delegate = self;
        _pickerView1.dataSource = self;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_pickerView1.frameX + _pickerView1.width + 20, _pickerView1.frameY + 40 * 2, 20, 1)];
        view.tag = 1001;
//        view.backgroundColor = [UIColor redColor];
        [_selectDateView addSubview:view];
        
        self.pickerView2 = [[UIPickerView alloc] init];
        _pickerView2.showsSelectionIndicator = YES;
        self.pickerView2.frame = CGRectMake(view.frameX + view.width + 20, button1.frameY + button1.height, _pickerView1.width, 162);
        _pickerView2.delegate = self;
        _pickerView2.dataSource = self;
        [_pickerView1 selectRow:1 inComponent:0 animated:YES];
        [_pickerView2 selectRow:1 inComponent:0 animated:YES];
        [_selectDateView addSubview:_pickerView1];
        [_selectDateView addSubview:_pickerView2];
    } else {
        // 确定distinctionNumber，才确定行数和组件数
        self.changeCellValue2 = 1;
        self.distinctionNumber = 2;
        self.pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.showsSelectionIndicator = YES;
        self.pickerView1.frame = CGRectMake(50, button1.frameY + button1.height, _selectDateView.width / 2 - 80, 162);
        _pickerView1.delegate = self;
        _pickerView1.dataSource = self;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_pickerView1.frameX + _pickerView1.width + 20, _pickerView1.frameY + 40 * 2, 20, 1)];
        view.tag = 1001;
//        view.backgroundColor = [UIColor redColor];
        [_selectDateView addSubview:view];
        
        self.pickerView2 = [[UIPickerView alloc] init];
        _pickerView2.showsSelectionIndicator = YES;
        self.pickerView2.frame = CGRectMake(view.frameX + view.width + 20, button1.frameY + button1.height, _pickerView1.width, 162);
        _pickerView2.delegate = self;
        _pickerView2.dataSource = self;
        [_pickerView1 selectRow:1 inComponent:0 animated:YES];
        [_pickerView2 selectRow:1 inComponent:0 animated:YES];
        [_selectDateView addSubview:_pickerView1];
        [_selectDateView addSubview:_pickerView2];
    }
    
    
    
    
    
    
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.distinctionNumber == 0) {
        return self.sexArr.count;
    } else if (self.distinctionNumber == 1) {
        if (pickerView == self.pickerView1) {
            return self.ballAgeArr1.count;
        } else {
            return self.ballAgeArr2.count;
        }
    } else {
        if (pickerView == self.pickerView1) {
            return self.chaDianArr1.count;
        } else {
            return self.chaDianArr2.count;
        }
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.distinctionNumber == 0) {
        return [self.sexArr objectAtIndex:row];
    } else if (self.distinctionNumber == 1) {
        if (pickerView == self.pickerView1) {
            return [self.ballAgeArr1 objectAtIndex:row];
        } else {
            return [self.ballAgeArr2 objectAtIndex:row];
        }
    } else {
        if (pickerView == self.pickerView1) {
            return [self.chaDianArr1 objectAtIndex:row];
        } else {
            return [self.chaDianArr2 objectAtIndex:row];
        }
    }
    
}




- (void)buttonfalseClick:(UIButton*)button {
    _isChooseAge = NO;
    _isChooseChadian = NO;
    _isChooseSex = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    
    _scrollView.userInteractionEnabled = YES;
    // 移除选择器和减号
    UIView *vi = [_selectDateView viewWithTag:1001];
    [vi removeFromSuperview];
    [_pickerView1 removeFromSuperview];
    [_pickerView2 removeFromSuperview];
    
}

// 确定tableViewCell的数值
- (void)tableViewChangeCellValue
{
    // uitableview已经伸缩，出现性别球龄和差点
    NSInteger pickerView1SelectedNumber = [self.pickerView1 selectedRowInComponent:0];
    NSInteger pickerView2SelectedNumber = [self.pickerView2 selectedRowInComponent:0];
    if (self.distinctionNumber == 0) {
        //        // 不用重新刷新， 走每个cell什么样的方法
        //        FabuPostTableViewCell *cell = (FabuPostTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        //        cell.detailLabel.text = [self.sexArr objectAtIndex:pickerView1SelectedNumber];
        NSString *str1 =[self.sexArr objectAtIndex:pickerView1SelectedNumber];
        [_arrayChange replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@", str1]];
        [_tableView reloadData];
        if ([_arrayChange[0] isEqualToString:@"男"]) {
            [_dict setValue:@1 forKey:@"sex"];
        } else if ([_arrayChange[0] isEqualToString:@"女"]) {
            [_dict setValue:@0 forKey:@"sex"];
        } else {
            [_dict setValue:@-1 forKey:@"sex"];
        }
        
    } else if (self.distinctionNumber == 1) {
        // 赋予选中的数值
        NSString *str1 =[self.ballAgeArr1 objectAtIndex:pickerView1SelectedNumber];
        NSString *str2 = [self.ballAgeArr2 objectAtIndex:pickerView2SelectedNumber];
        
        if ([str1 integerValue] < [str2 integerValue]) {
            [_arrayChange replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ - %@", str1, str2]];
        }
        else
        {
            [_arrayChange replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ - %@", str2, str1]];
        }
//        [_arrayChange replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ - %@", str1, str2]];
        [_tableView reloadData];
        
        [_dict setValue:_arrayChange[1] forKey:@"ballYear"];
        
    } else {
        NSString *str1 = [self.chaDianArr1 objectAtIndex:pickerView1SelectedNumber];
        NSString *str2 = [self.chaDianArr2 objectAtIndex:pickerView2SelectedNumber];
        
        if ([str1 integerValue] < [str2 integerValue]) {
            [_arrayChange replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@ - %@", str1, str2]];
        }
        else
        {
            [_arrayChange replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@ - %@", str2, str1]];
        }
        
        [_tableView reloadData];
        
        
        [_dict setValue:_arrayChange[2] forKey:@"almost"];
    }
    
    
    
}
- (void)buttonsureClick:(UIButton*)button {
    _isChooseAge = NO;
    _isChooseChadian = NO;
    _isChooseSex = NO;
    _scrollView.userInteractionEnabled = YES;
    
    // uitableview已经伸缩，出现性别球龄和差点
    self.changeNumber = 1;
    [self tableViewChangeCellValue];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _selectDateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    
    // 移除选择器和减号
    UIView *vi = [_selectDateView viewWithTag:1001];
    [vi removeFromSuperview];
    [_pickerView1 removeFromSuperview];
    [_pickerView2 removeFromSuperview];
    
}


-(void)fabuClick:(UIButton *)btn{
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.mode = MBProgressHUDModeIndeterminate;
    _progress.labelText = @"正在发布...";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
    //球场信息
    [_dict setValue:_textTitle.text forKey:@"reTitle"];
    //详情简介
    [_dict setValue:_textView.text forKey:@"reInfo"];
    //
    [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    
    ////NSLog(@"%@",_dict);
    if ([_momey integerValue] == -1) {
        [_dict setObject:_momey forKeyedSubscript:@"reMoney"];
    }
    
    
    if (![_strBall isEqualToString:@"请选择"]) {
        
        if (![_strTime isEqualToString:@"请选择"]) {
            if (![Helper isBlankString:_momey]) {
                if (![Helper isBlankString:_textTitle.text]) {
                    [[PostDataRequest sharedInstance] postDataRequest:kRewordsave_URL parameter:_dict success:^(id respondsData) {
                        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                        //////NSLog(@"%@",userData);
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if ([[userData objectForKey:@"success"] boolValue]) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            alertView.tag = 1000;
                            
                        }else {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            
                        }
                    } failed:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                        ////NSLog(@"%@",error);
                    }];
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的悬赏标题还未填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的价格还未填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的开球日期还未选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的球场还未选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 1000) {

        MineRewardViewController* mineVc = [[MineRewardViewController alloc]init];
        mineVc.popViewNumber = 2;
        [self.navigationController pushViewController:mineVc animated:YES];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _showView = NO;
    // 从其他页面返回时， 弹出框要隐藏
    _viewTanTu.hidden = YES;
}


@end
