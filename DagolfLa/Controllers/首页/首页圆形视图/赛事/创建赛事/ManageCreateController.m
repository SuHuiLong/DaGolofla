//
//  ManageCreateController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageCreateController.h"
#import "Helper.h"
#import "ManageFinishController.h"

#import "ManageCreateLogoTableViewCell.h"
#import "ManageCreateEditTableViewCell.h"
#import "ManageMessageViewCell.h"

#import "DateTimeViewController.h"
#import "BallParkViewController.h"


#import "Helper.h"
#import "PostDataRequest.h"

#import "TeamInviteViewController.h"
#import "Helper.h"
#import "UIButton+WebCache.h"
#import "ManageFinfishModel.h"

#import "ManageForMeController.h"

#import "MBProgressHUD.h"
#import "FriendModel.h"
@interface ManageCreateController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    
    UITableView* _tableView;
    NSArray* _titleArray;
    NSArray* _detailArray;
    NSMutableArray* _dataArray;
    
    NSMutableDictionary* _dict;
    
    //存储照片
    NSData *_photoData;
    NSMutableArray* _arrayPage;
    
    //存储开始日期
//    NSString* _strTime;
    NSMutableString* _strDayStart, *_strDayEnd;
    
    //存储球场
    NSString* _strBall;
    //好友视图
    UIView* _viewBasePeople;
    
    UITextView* _textView;
    NSString* _str;
    
    UIButton* _btnLeft, *_btnRight;
//    //短信通知
//    UIView* _viewMessage;
    //赛事简介
    UIView* _viewIntro;
    //赛事设置
    UIView* _viewSet;
    //创建按钮
    UIButton *_btnCreate;
    
    //是否公开
    BOOL _isGongkai;
    
    //选择器
    UIPickerView *_pickerView;
    UIView* _selectView;
    UIButton *_button1;
    UIButton *_button2;
    
    NSMutableArray* _arrHour;
    NSMutableArray* _arrMinute;
    
    NSString* _strHour;
    NSString* _strMinute;
    NSString* _strTime;
    
    NSString* _strTitle;
    
    //好友列表请求的数据
    NSMutableArray* _arrayIndex;
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayData1;
    //短信通知好友所需要的数组
    NSMutableArray* _messageArray;
    NSMutableArray* _telArray;
    
    BOOL _isClick;
    NSInteger istextf;
    
    UIButton* _btnBase;
    
}
@property (strong, nonatomic) MBProgressHUD* progressHud;

@end

@implementation ManageCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //增加监听，当键盘出现或改变时收出消息
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.title = @"创建赛事";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _str = [[NSString alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, 44*7*ScreenWidth/375+210*ScreenWidth/375 + 158*ScreenWidth/375);
    
    _arrayPage = [[NSMutableArray alloc]init];
    _dict = [[NSMutableDictionary alloc]init];
    _arrHour = [[NSMutableArray alloc]init];
    _arrMinute = [[NSMutableArray alloc]init];
    
    //好友列表
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    //短信好友
    _messageArray = [[NSMutableArray alloc]init];
    _telArray     = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    
    _isGongkai = YES;
    //建表
    [self uiConfig];
    //邀请好友
    [self createInviteView];
    
    //创建短信通知视图
//    [self createMessage];
    //赛事简介
    [self createIntroduce];
    //赛事设置
    [self createSet];
    //创建按钮
    [self createBtn];
   
    _selectView = [[UIView alloc]init];
    _pickerView = [[UIPickerView alloc]init];
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    for (int i = 0; i < 24; i++) {
        if (i < 10) {
            [_arrHour addObject:[NSString stringWithFormat:@"0%d",i]];
        }
        else
        {
            [_arrHour addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
    for (int i = 0; i < 60; i++) {
        if (i < 10) {
            [_arrMinute addObject:[NSString stringWithFormat:@"0%d",i]];
        }
        else
        {
            [_arrMinute addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    

    
}



-(void)uiConfig
{
    _titleArray = [[NSArray alloc]init];
    _titleArray = @[@"赛事标志",@"赛事名称",@"比赛日期",@"比赛时间",@"结束日期",@"选择球场",@"",@"短信通知好友"];
    
    _detailArray = [[NSArray alloc]init];
    _detailArray = @[@"",@"",@"请选择日期",@"请选择时间",@"请选择结束日期",@"请选择球场",@""];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*7*ScreenWidth/375+60*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView];
       
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[ManageCreateLogoTableViewCell class] forCellReuseIdentifier:@"ManageCreateLogoTableViewCell"];
    [_tableView registerClass:[ManageCreateEditTableViewCell class] forCellReuseIdentifier:@"ManageCreateEditTableViewCell"];
    [_tableView registerClass:[ManageMessageViewCell class] forCellReuseIdentifier:@"ManageMessageViewCell"];
}

#pragma mark --tableview的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60*ScreenWidth/375;
    }
    else if (indexPath.row == 6)
    {
        if (_isClick == NO) {
            return 44*ScreenWidth/375;
        }
        else
        {
            return _viewBasePeople.frame.size.height;
        }
    }
    else
    {
        return 44*ScreenWidth/375;
    }
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ManageCreateLogoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ManageCreateLogoTableViewCell" forIndexPath:indexPath];
        if (_arrayPage.count != 0) {
            cell.iconImage.image = [UIImage imageWithData:_arrayPage[0]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        ManageCreateEditTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ManageCreateEditTableViewCell" forIndexPath:indexPath];
        cell.detailLabel.hidden = YES;
        cell.jtImage.hidden = YES;
       
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.textField.placeholder = @"请输入";
        cell.textField.delegate = self;
        cell.textField.tag = 1234;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 6)
    {
         ManageMessageViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ManageMessageViewCell" forIndexPath:indexPath];
        cell.jtImage.hidden = YES;
        cell.btnMessage.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.view.hidden = YES;
        return cell;
    }
    else if (indexPath.row == 7)
    {
        ManageMessageViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ManageMessageViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.btnMessage addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchDragInside];
//        cell.btnMessage.tag = 100+indexPath.row;
        cell.view.hidden = YES;
        cell.jtImage.hidden = YES;
        if (_messageArray.count == 0) {
            cell.strlegth = 0;
        }
        else{
            cell.strlegth = 1;
        }

        cell.dataArray = _messageArray;
        cell.telArray = _telArray;
        ////NSLog(@"%@      %@",cell.telArray,cell.dataArray);
        cell.block = ^(UIViewController *vc)
        {
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    else
    {
        ManageCreateEditTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ManageCreateEditTableViewCell" forIndexPath:indexPath];
        cell.textField.hidden = YES;
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.detailLabel.text = _detailArray[indexPath.row];
        if (indexPath.row == 2) {
            if (![Helper isBlankString:_strDayStart]) {
                cell.detailLabel.text = _strDayStart;
            }
        }
        else if (indexPath.row == 3)
        {
            if ([Helper isBlankString:_strTime]) {
                cell.detailLabel.text = @"请选择时间";
            }
            else
            {
                cell.detailLabel.text = _strTime;
            }
        }
        else if (indexPath.row == 4)
        {
            if (![Helper isBlankString:_strDayEnd]) {
                cell.detailLabel.text = _strDayEnd;
            }
        }
        else if (indexPath.row == 5)
        {
            if (![Helper isBlankString:_strBall]) {
                cell.detailLabel.text = _strBall;
            }
        }
        if (indexPath.row == 6) {
            cell.jtImage.hidden = YES;
            cell.detailLabel.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
   
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _strTitle = textField.text;
    [_dict setObject:textField.text forKey:@"eventTite"];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self usePhonePhotoAndCamera];
        }
            break;
        case 2:
        {
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                
                NSArray* arr = [dateWeek componentsSeparatedByString:@"  "];
                
                _strDayStart = [NSMutableString stringWithFormat:@"%@,%@",dateStr,arr[1]];
//                _strDayStart = dateWeek;
//                ////NSLog(@"%@",dateWeek);
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_dict setValue:dateStr forKey:@"eventdates"];
                [_dict setValue:arr[1] forKey:@"evnntWeek"];
            }];
            [self.navigationController pushViewController:dateVc animated:YES];

        }
            break;
        case 3:
        {
            [self createDateClick];
        }
            break;
        case 4:
        {
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                
                NSArray* arr = [dateWeek componentsSeparatedByString:@"  "];
                
                _strDayEnd = [NSMutableString stringWithFormat:@"%@,%@",dateStr,arr[1]];
                //                _strDayStart = dateWeek;
                //                ////NSLog(@"%@",dateWeek);
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_dict setValue:dateStr forKey:@"eventendDates"];
                [_dict setValue:arr[1] forKey:@"eventendWeek"];
            }];
            [self.navigationController pushViewController:dateVc animated:YES];
        }
            break;
        case 5:
        {
            //球场
            BallParkViewController* ballVc = [[BallParkViewController alloc]init];
            [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
                _strBall = balltitle;
                [_dict setValue:[NSNumber numberWithInteger:ballid] forKey:@"eventballId"];
                [_dict setValue:balltitle forKey:@"eventBallName"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:ballVc animated:YES];

        }
            break;
        case 6:
        {
            
        }
            break;

            
        default:
            break;
    }
}


/**
 *  邀请好友，添加好友头像
 */
#pragma mark --创建邀请好友，添加好友头像视图
-(void)createInviteView
{
     _viewBasePeople = [[UIView alloc]init];
    _viewBasePeople.tag = 1045;
    if (_arrayData.count == 0) {
        _viewBasePeople.frame = CGRectMake(0, 280*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375);
    }
    else
    {
        _viewBasePeople.frame = CGRectMake(0, 280*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1));
        
    }
    [_tableView addSubview:_viewBasePeople];
    _viewBasePeople.userInteractionEnabled = YES;
    //  单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peopleInviteTap:)];
    //  点击的次数
    tapGesture.numberOfTapsRequired = 1;
    //  允许（可需）一个手指
    tapGesture.numberOfTouchesRequired = 1;
    [_viewBasePeople addGestureRecognizer:tapGesture];
    
    
    
//    //标题
    UILabel* labelTit = [[UILabel alloc]initWithFrame:CGRectMake(9*ScreenWidth/375,12*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375)];
    labelTit.backgroundColor = [UIColor clearColor];
    labelTit.text = @"邀请好友";
    labelTit.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewBasePeople addSubview:labelTit];
    
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-22*ScreenWidth/375, 12*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@"left_jt"];
    [_viewBasePeople addSubview:imgv];
    
    
    
    //存放选择的打球人id
    NSMutableArray* arrayId = [[NSMutableArray alloc]init];
    for (int i = 0; i < _arrayData.count; i++) {
        UIButton* btnImgv = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImgv sd_setImageWithURL:[Helper imageIconUrl:_arrayData[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zwt"]];
        [_viewBasePeople addSubview:btnImgv];
        //60*ScreenWidth/375*((_nameAgreeArr.count-1)/6+1)
        btnImgv.frame = CGRectMake(25*ScreenWidth/375+50*ScreenWidth/375*(i%6), 35*ScreenWidth/375 + 50*ScreenWidth/375*(i/6), 50*ScreenWidth/375, 50*ScreenWidth/375);
        FriendModel* model = [[FriendModel alloc]init];
        if ([_arrayData[i] isKindOfClass:[FriendModel class]]) {
            model = _arrayData[i];
            [arrayId addObject:model.userId];
        }
        else
        {
            [btnImgv setImage:[UIImage imageNamed:@"zwt"] forState:UIControlStateNormal];
        }
        
    }
    NSString* strId;
    if (arrayId.count != 0) {
        strId = [arrayId componentsJoinedByString:@","];
    }
    if (![Helper isBlankString:strId]) {
        [_dict setObject:strId forKey:@"ballId"];
    }
}

-(void)peopleInviteTap:(UITapGestureRecognizer *)gesture
{
    _isClick = YES;
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
        for (UIView *v in [_viewBasePeople subviews]) {
            [v removeFromSuperview];
        }
        for(UIView* v in [_tableView subviews])
        {
            //找到要删除的子视图的对象
            if([v isKindOfClass:[UIView class]])
            {
                UIView *View = (UIView *)v;
                if(View.tag == 1045)   //判断是否满足自己要删除的子视图的条件
                {
                    [View removeFromSuperview]; //删除子视图
                    
                    break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                }
            }
        }
        [self createInviteView];
        
        
        if (_arrayData.count == 0) {
            
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 44*7*ScreenWidth/375+60*ScreenWidth/375);
            _viewBasePeople.frame = CGRectMake(0, 280*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375);
            _viewIntro.frame = CGRectMake(0, 44*7*ScreenWidth/375+60*ScreenWidth/375, ScreenWidth, 150*ScreenWidth/375);
            _viewSet.frame = CGRectMake(0, 44*7*ScreenWidth/375+210*ScreenWidth/375, ScreenWidth, 74*ScreenWidth/375);
            _btnCreate.frame = CGRectMake(10*ScreenWidth/375, 44*7*ScreenWidth/375+210*ScreenWidth/375 +84*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
            _scrollView.contentSize = CGSizeMake(0, ScreenHeight);
            if (ScreenHeight == 480) {
                _scrollView.contentSize = CGSizeMake(0, 568-49-44);
            }
            
        }
        else
        {
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 44*7*ScreenWidth/375+60*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1));
            _viewBasePeople.frame = CGRectMake(0, 280*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375+50*ScreenWidth/375*((_arrayData.count-1)/6+1));
            _viewIntro.frame = CGRectMake(0, 44*7*ScreenWidth/375+60*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 150*ScreenWidth/375);
            _viewSet.frame = CGRectMake(0, 44*7*ScreenWidth/375+210*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth, 74*ScreenWidth/375);
            _btnCreate.frame = CGRectMake(10*ScreenWidth/375, 44*7*ScreenWidth/375+294*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1), ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
            _scrollView.contentSize = CGSizeMake(0, 44*7*ScreenWidth/375+294*ScreenWidth/375+ 50*ScreenWidth/375*((_arrayData.count-1)/6+1)+64*ScreenWidth/375);
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


/**
 *  赛事简介
 */
#pragma  mark --创建赛事
-(void)createIntroduce
{
    _viewIntro = [[UIView alloc]initWithFrame:CGRectMake(0, 44*7*ScreenWidth/375+60*ScreenWidth/375, ScreenWidth, 150*ScreenWidth/375)];
    [_scrollView addSubview:_viewIntro];
    
    UILabel* labelIntro = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    labelIntro.backgroundColor = [UIColor clearColor];
    labelIntro.text = @"赛事简介";
    labelIntro.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_viewIntro addSubview:labelIntro];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5*ScreenWidth/375, 30*ScreenWidth/375, ScreenWidth-10*ScreenWidth/375, 120*ScreenWidth/375)];
    _textView.delegate = self;
    _textView.text = @"输入赛事相关介绍...";
    _textView.returnKeyType = UIReturnKeyDone;
    [_viewIntro addSubview:_textView];
    
}

#pragma mark --textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //判断为空
    if ([Helper isBlankString:_str]) {
        istextf = 300;
        textView.text = nil;
        _btnBase.hidden = NO;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([Helper isBlankString:textView.text]) {
        textView.text = @"输入赛事相关介绍...";
        _btnBase.hidden = YES;
        _str = nil;
    }else {
        _str = textView.text;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        _btnBase.hidden = YES;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    istextf = 300;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    _btnBase.hidden = YES;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _btnBase.hidden = NO;
    istextf= 100;
    return YES;
}

/**
 *  赛事设置
 */
#pragma mark --赛事类型选择
-(void)createSet
{
    _viewSet = [[UIView alloc]initWithFrame:CGRectMake(0, 44*7*ScreenWidth/375+210*ScreenWidth/375, ScreenWidth, 74*ScreenWidth/375)];
    [_scrollView addSubview:_viewSet];
    
    UILabel* labelIntro = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 100*ScreenWidth/375, 30*ScreenWidth/375)];
    labelIntro.backgroundColor = [UIColor clearColor];
    labelIntro.text = @"赛事设置";
    labelIntro.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [_viewSet addSubview:labelIntro];
    
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 30*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375)];
    viewBase.backgroundColor = [UIColor whiteColor];
    [_viewSet addSubview:viewBase];
    
    
    //左边按钮
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLeft.backgroundColor = [UIColor clearColor];
    _btnLeft.frame = CGRectMake(0, 0, ScreenWidth/2, 44*ScreenWidth/375);
    [viewBase addSubview:_btnLeft];
    [_btnLeft addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitle:@"公开赛事" forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, -60*ScreenWidth/375, 0, 0);
    _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 120*ScreenWidth/375, 0, 0);
    [_dict setObject:@1 forKey:@"eventIsPrivate"];
    _btnLeft.tag = 123;
    
    //右边按钮
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.backgroundColor = [UIColor clearColor];
    _btnRight.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 44*ScreenWidth/375);
    [viewBase addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setTitle:@"私密赛事" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -60*ScreenWidth/375, 0, 0);
    _btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 120*ScreenWidth/375, 0, 0);
    _btnRight.tag = 124;
//    _btnRight.tag = 124;
}

//约球类型点击事件
#pragma mark --赛事审核点击事件
-(void)btnLeftClick
{
    [_btnLeft setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    _isGongkai = YES;
    [_dict setObject:@1 forKey:@"eventIsPrivate"];

}
//约球类型点击事件
-(void)btnRightClick
{
    [_btnLeft setImage:[UIImage imageNamed:@"gou_w"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    _isGongkai = NO;
    [_dict setObject:@2 forKey:@"eventIsPrivate"];
}

-(void)createBtn
{
    _btnCreate = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnCreate.frame = CGRectMake(10*ScreenWidth/375, 44*7*ScreenWidth/375+210*ScreenWidth/375 +84*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    
    [_btnCreate setTitle:@"创建" forState:UIControlStateNormal];
    
    [_btnCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnCreate.backgroundColor = [UIColor orangeColor];
    
    _btnCreate.layer.masksToBounds = YES;
    
    _btnCreate.layer.cornerRadius = 8*ScreenWidth/375;
    
    [_scrollView addSubview:_btnCreate];
    
    [_btnCreate addTarget:self action:@selector(createBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)createBtnClick:(UIButton *)btn{
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.userInteractionEnabled = NO;
    
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHud.mode = MBProgressHUDModeIndeterminate;
    _progressHud.labelText = @"正在刷新...";
    [self.view addSubview:_progressHud];
    [_progressHud show:YES];
    
    [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"eventCreateUserId"];
    [_dict setValue:_textView.text forKey:@"eventContext"];
    if (![Helper isBlankString:_strTime]) {
        [_dict setObject:_strTime forKey:@"eventTimes"];
    }
    [_dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"sender"];
    [_dict setObject:[NSString stringWithFormat:@"%@邀请您参加他的赛事",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]] forKey:@"content"];
    
    
    if (![Helper isBlankString:_strBall]) {
        if (![Helper isBlankString:_strTime]) {
            if (![Helper isBlankString:_textView.text]) {
                if (_arrayPage.count != 0) {
                    if (![Helper isBlankString:_strTitle]) {
                        [[PostDataRequest sharedInstance] postDataAndImageRequest:@"tballevent/save.do" parameter:_dict imageDataArr:_arrayPage success:^(id respondsData) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            btn.backgroundColor = [UIColor orangeColor];
                            btn.userInteractionEnabled = YES;
                            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                ManageFinfishModel *model = [[ManageFinfishModel alloc] init];
                                [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                                
                                [_dataArray addObject:model];
                                
                                if (_isGongkai == NO) {
                                    ManageFinishController* fishVc = [[ManageFinishController alloc]init];
                                    fishVc.model = _dataArray[0];
                                    
                                    [self.navigationController pushViewController:fishVc animated:YES];
                                }else{
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    alertView.tag = 1000;
                                    [alertView show];
                                }
                                [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                                btn.backgroundColor = [UIColor orangeColor];
                                btn.userInteractionEnabled = YES;
                            }
                            else
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                        } failed:^(NSError *error) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            btn.backgroundColor = [UIColor orangeColor];
                            btn.userInteractionEnabled = YES;
                            
                        }];
                    }
                    else{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [Helper alertViewWithTitle:@"请输入赛事标题" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                        btn.backgroundColor = [UIColor orangeColor];
                        btn.userInteractionEnabled = YES;
                        
                    }
                }
                else
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [Helper alertViewWithTitle:@"请选择赛事图标" withBlock:^(UIAlertController *alertView){
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                    btn.backgroundColor = [UIColor orangeColor];
                    btn.userInteractionEnabled = YES;
                    
                }
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [Helper alertViewWithTitle:@"请填写赛事简介" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
                btn.backgroundColor = [UIColor orangeColor];
                btn.userInteractionEnabled = YES;
                
            }
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Helper alertViewWithTitle:@"请选择时间" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
            btn.backgroundColor = [UIColor orangeColor];
            btn.userInteractionEnabled = YES;
            
        }
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [Helper alertViewWithTitle:@"请选择球场" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        btn.backgroundColor = [UIColor orangeColor];
        btn.userInteractionEnabled = YES;
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 1000) {

        ManageForMeController* yueVc = [[ManageForMeController alloc]init];
        yueVc.popViewNumber = 2;
        [self.navigationController pushViewController:yueVc animated:YES];
    }
}



#pragma mark - 调用手机相机和相册
- (void)usePhonePhotoAndCamera {
    UIActionSheet *selestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [selestSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self usePhonCamera];
    }else if (buttonIndex == 1) {
        [self usePhonePhoto];
    }
}
#pragma mark - 调用相机
- (void)usePhonCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 调用相册
- (void)usePhonePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_arrayPage removeAllObjects];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _photoData = UIImageJPEGRepresentation(image, 0.5);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_arrayPage addObject:_photoData];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    //    [_dict setObject:_photoData forKey:@"myPic"];
    
}


#pragma mark --时间选择器


//时间选择器
-(void)createDateClick{
    
    _selectView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        _selectView.frame = CGRectMake(0, ScreenHeight/3*2, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    _selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectView];
    
    
    // 选择框
    _pickerView.frame = CGRectMake(0, 30, ScreenWidth, 100*ScreenWidth/375);
    // 显示选中框
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_selectView addSubview:_pickerView];
    
    _button1.frame = CGRectMake(20*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(buttonAssClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:_button1];
    
    _button2.frame = CGRectMake(ScreenWidth-50, 10*ScreenWidth/375, 30, 30);
    [_button2 setTitle:@"确认" forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(buttonSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:_button2];
    
    
    
}
- (void)buttonAssClick:(UIButton*)button {
    [UIView animateWithDuration:0.5 animations:^{
        _selectView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
}
- (void)buttonSureClick:(UIButton*)button {
    [UIView animateWithDuration:0.5 animations:^{
        _selectView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    _strTime = [NSString stringWithFormat:@"%@:%@",_strHour,_strMinute];
    ////NSLog(@"%@",_strTime);
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



#pragma mark --选择器的代理方法
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _arrHour.count;
    }
    return _arrMinute.count;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 1) {
        return 80;
    }
    return 80;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _strHour = [_arrHour objectAtIndex:row];
    } else {
        _strMinute = [_arrMinute objectAtIndex:row];
    }
    _strTime = [NSString stringWithFormat:@"%@:%@",_strHour,_strMinute];
    
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        _strHour = [_arrHour objectAtIndex:row];
        return [_arrHour objectAtIndex:row];
    } else {
        _strMinute = [_arrMinute objectAtIndex:row];
        return [_arrMinute objectAtIndex:row];
    }
}


@end
