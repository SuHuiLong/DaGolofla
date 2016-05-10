//
//  ActiveManageController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ActiveManageController.h"

#import "TeamNameTableViewCell.h"
#import "TeamIntroduceViewCell.h"

#import "Helper.h"
#import "CustomIOSAlertView.h"
#import "DateTimeViewController.h"
#import "BallParkViewController.h"

#import "PostDataRequest.h"

@interface ActiveManageController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomIOSAlertViewDelegate>
{
    UIBarButtonItem* _item;
    UITableView* _tableView;
    NSArray* _arrayTitle;
    
    BOOL _isBianji;
    
    NSMutableDictionary* _dict;
    
    //选择的球场名称
    NSString* _strBall;
    NSNumber* _ballId;
    
    //金额选择器
    CustomIOSAlertView* _alertView;
    UITextField* _textPrice;
    BOOL _isMianYi;
    NSString* _money;
    
    //开始日期和结束日期
    NSString* _strDateBegin;
    NSString* _strDateEnd;
    
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

}

@end

@implementation ActiveManageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"活动管理";
    
    _dict = [[NSMutableDictionary alloc]init];
    _arrHour = [[NSMutableArray alloc]init];
    _arrMinute = [[NSMutableArray alloc]init];
    _item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bianjiClick)];
    _item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _item;
    
    
    _arrayTitle = [[NSArray alloc]init];
    _arrayTitle = @[@"活动标题",@"球场",@"活动人数",@"人均价格",@"联系人",@"联系人电话",@"活动开始时间",@"活动结束日期",@"活动内容"];
    
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

    
    [self uiConfig];
}
-(void)bianjiClick
{
    if (_isBianji == 0) {
        _tableView.userInteractionEnabled = YES;
        _item.title = @"保存";
        _isBianji = YES;
        
    
    }
    else
    {
        _tableView.userInteractionEnabled = NO;
        _item.title = @"编辑";
        _isBianji = NO;
        
        [_dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"activityCreateUser"];
        [_dict setValue:@"活动标题" forKey:@"teamActivityTitle"];
        [_dict setValue:_teamactId forKey:@"teamActivityId"];
        [_dict setValue:@15200000000 forKey:@"contactphone"];
        [_dict setValue:_ballId forKey:@"activityBallId"];
        [_dict setValue:@"清风" forKey:@"contactperson"];
        [_dict setValue:_strTime forKey:@"startTimes"];
        [_dict setValue:_strBall forKey:@"ballName"];
        [_dict setValue:@100 forKey:@"peopleNums"];
        [_dict setValue:_teamId forKey:@"teamId"];

        //    [_dict setValue:@"2012-12-12" forKey:@"beginDates"];
        //    [_dict setValue:@"2015-12-12" forKey:@"endDates"];
        //    [_dict setValue:@-1 forKey:@"onePeooleprices"];
        //        [_dict setValue:_textView.text forKey:@"activityContent"];
        //        if ([Helper testMobileIsTrue:<#(NSString *)#>]) {
        //            <#statements#>
        //        }
        
        [[PostDataRequest sharedInstance] postDataRequest:@"TTeamActivity/update.do" parameter:_dict success:^(id respondsData) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failed:^(NSError *error) {
        }];
    }
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 9*44*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.userInteractionEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[TeamIntroduceViewCell class] forCellReuseIdentifier:@"TeamIntroduceViewCell"];
    [_tableView registerClass:[TeamNameTableViewCell class] forCellReuseIdentifier:@"TeamNameTableViewCell"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 2) {
        TeamNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamNameTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayTitle[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textF.placeholder = @"请输入活动标题";
            cell.textF.delegate = self;
            cell.textF.tag = 1230;
        }
        else if (indexPath.row == 2)
        {
            cell.textF.placeholder = @"请选择活动人数";
            cell.textF.delegate = self;
            cell.textF.tag = 1231;
        }
        else if (indexPath.row == 4)
        {
            cell.textF.placeholder = @"请输入联系人";
            cell.textF.delegate = self;
            cell.textF.tag = 1232;
        }
        
        else
        {
            cell.textF.placeholder = @"请输入联系人电话";
            cell.textF.delegate = self;
            cell.textF.tag = 1233;
        }
        return cell;
    }
    else
    {
        TeamIntroduceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamIntroduceViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = _arrayTitle[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            if ([Helper isBlankString:_strBall]) {
                cell.detroLabel.text = @"请选择球场";
            }
            else
            {
                cell.detroLabel.text = _strBall;
            }
            
        }
        else if (indexPath.row == 3)
        {
            if ([Helper isBlankString:_money]) {
                cell.detroLabel.text = @"请选择价格";
            }
            else{
                cell.detroLabel.text = _money;
            }
            

        }
        else if (indexPath.row == 6)
        {
            if ([Helper isBlankString:_strDateBegin]) {
                cell.detroLabel.text = @"请选择开始日期";
            }
            else
            {
                cell.detroLabel.text = _strDateBegin;
            }
        }
        else if (indexPath.row == 7)
        {
            cell.detroLabel.text = @"请选择时间";
        }
        else
        {
            if ([Helper isBlankString:_strDateEnd]) {
                cell.detroLabel.text = @"请选择开始日期";
            }
            else
            {
                cell.detroLabel.text = _strDateEnd;
            }
        }
        return cell;
    }
    return nil;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row){
        case 1:
        {
            //选择球场
            BallParkViewController* ballVc = [[BallParkViewController alloc]init];
            [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
                _strBall = balltitle;
                _ballId = [NSNumber numberWithInteger:ballid];
                [_dict setValue:[NSNumber numberWithInteger:ballid] forKey:@"golfCourse"];
                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }];
            
            [self.navigationController pushViewController:ballVc animated:YES];
        }
            break;
        case 3:
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
        case 6:
        {
            //日期
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                _strDateBegin = dateStr;
                [_dict setValue:dateStr forKey:@"beginDates"];
                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [self.navigationController pushViewController:dateVc animated:YES];
        }
            break;
        case 7:
        {
            [self createDateClick];
        }
            break;
        case 8:
        {
            DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
            [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
                _strDateEnd = dateStr;
                [_dict setValue:dateStr forKey:@"endDates"];
                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [self.navigationController pushViewController:dateVc animated:YES];
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
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255*ScreenWidth/375, 200*ScreenWidth/375)];
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
    _money = @"面议";
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [_alertView  close];
    [_dict setValue:@-1 forKey:@"onePeooleprices"];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    UITextField * textField=(UITextField*)[self.view viewWithTag:124];
    [textField resignFirstResponder];
    if ((int)buttonIndex == 1) {
        _money = _textPrice.text;
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        if (_isMianYi == YES) {
            [_dict setValue:@-1 forKey:@"onePeooleprices"];
        }
        else
        {
            //判断输入的数字中是否有空格字符
            if (![Helper isBlankString:_textPrice.text]) {
                [_dict setValue:_textPrice.text forKey:@"onePeooleprices"];
            }
        }
    }
    [alertView close];
}



//时间选择器
-(void)createDateClick{
    
    _selectView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        _selectView.frame = CGRectMake(0, ScreenHeight/3*2, ScreenWidth, ScreenHeight/3);
    } completion:nil];
    _selectView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_selectView];
    
    
    // 选择框
    _pickerView.frame = CGRectMake(0, 30, ScreenWidth, 100);
    // 显示选中框
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_selectView addSubview:_pickerView];
    
    _button1.frame = CGRectMake(20*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
    [_button1 setTitle:@"取消" forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(buttonAssClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:_button1];
    
    _button2.frame = CGRectMake(ScreenWidth-50*ScreenWidth/375, 10*ScreenWidth/375, 30, 30);
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
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:7 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}




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
