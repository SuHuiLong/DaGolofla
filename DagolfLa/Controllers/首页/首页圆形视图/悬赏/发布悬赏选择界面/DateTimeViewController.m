//
//  DateTimeViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/11.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "DateTimeViewController.h"
#import "FDCalendar.h"
#import "FDCalendarItem.h"
#define WeekNum @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"]

@interface DateTimeViewController ()<FDCalendarItemDelegate>
{
    FDCalendar *_calendar;
}
@end

@implementation DateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择日期";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    
    [self createData];
    
    

}
-(void)barButtonPressed
{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    ////NSLog(@"locationString:%@",locationString);
    
//    NSTimeInterval _todayDate = [senddate timeIntervalSince1970]*1;
    
    //年月日
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:_calendar.formDate];
    ////NSLog(@"%@",strDate);
//    NSTimeInterval _calendatData = [_calendar.formDate timeIntervalSince1970]*1;
    
    NSArray* arrToday = [locationString componentsSeparatedByString:@"-"];
    NSArray* arrChoose = [strDate componentsSeparatedByString:@"-"];
    
    ////NSLog(@"%@  %@  %@",arrChoose[0],arrChoose[1],arrChoose[2]);
    ////NSLog(@"%@  %@  %@",arrToday[0],arrToday[1],arrToday[2]);
    
    
    
    
    if ([_typeIndex integerValue] == 5 || [_typeIndex integerValue] == 11) {

        NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDate *now = _calendar.formDate;
        NSDateComponents *comps;
        comps = [calendarTime components:unitFlags fromDate:now];
        //NSInteger week = [comps week]; // 今年的第几周
        NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
        
        NSString* strWeek = WeekNum[weekday-1];
        
        NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
        [dateFor setDateFormat:@"yyyy-MM-dd"];
        NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
        NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
        
        
        _callback(strDate, str, strDate);
        ////NSLog(@"%@,%@",strDate,strWeek);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([_typeIndex integerValue] == 1)
    {
        if ([arrToday[0] integerValue] >= [arrChoose[0] integerValue]) {
            if ([arrToday[0] integerValue] == [arrChoose[0] integerValue]) {
                if ([arrToday[1] integerValue] >= [arrChoose[1] integerValue]) {
                    if ([arrToday[1] integerValue] == [arrChoose[1] integerValue]) {
                        if ([arrToday[2] integerValue] >= [arrChoose[2] integerValue]) {
                            NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                            NSDate *now = _calendar.formDate;
                            NSDateComponents *comps;
                            comps = [calendarTime components:unitFlags fromDate:now];
                            //NSInteger week = [comps week]; // 今年的第几周
                            NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
                            
                            NSString* strWeek = WeekNum[weekday-1];
                            
                            NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                            [dateFor setDateFormat:@"yyyy-MM-dd"];
                            NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
                            NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
                            
                            
                            _callback(strDate, str, strDate);
                            ////NSLog(@"%@,%@",strDate,strWeek);
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择过去的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    else
                    {
                        NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                        NSDate *now = _calendar.formDate;
                        NSDateComponents *comps;
                        comps = [calendarTime components:unitFlags fromDate:now];
                        //NSInteger week = [comps week]; // 今年的第几周
                        NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
                        
                        NSString* strWeek = WeekNum[weekday-1];
                        
                        NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                        [dateFor setDateFormat:@"yyyy-MM-dd"];
                        NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
                        NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
                        
                        
                        _callback(strDate, str, strDate);
                        ////NSLog(@"%@,%@",strDate,strWeek);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择过去的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                NSDate *now = _calendar.formDate;
                NSDateComponents *comps;
                comps = [calendarTime components:unitFlags fromDate:now];
                //NSInteger week = [comps week]; // 今年的第几周
                NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
                
                NSString* strWeek = WeekNum[weekday-1];
                
                NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                [dateFor setDateFormat:@"yyyy-MM-dd"];
                NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
                NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
                
                
                _callback(strDate, str, strDate);
                ////NSLog(@"%@,%@",strDate,strWeek);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择过去的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        
    }
    else
    {
        if ([arrToday[0] integerValue] <= [arrChoose[0] integerValue]) {
            if ([arrToday[0] integerValue] == [arrChoose[0] integerValue]) {
                if ([arrToday[1] integerValue] <= [arrChoose[1] integerValue]) {
                    if ([arrToday[1] integerValue] == [arrChoose[1] integerValue]) {
                        if ([arrToday[2] integerValue] <= [arrChoose[2] integerValue]) {
                            NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                            NSDate *now = _calendar.formDate;
                            NSDateComponents *comps;
                            comps = [calendarTime components:unitFlags fromDate:now];
                            //NSInteger week = [comps week]; // 今年的第几周
                            NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
                            
                            NSString* strWeek = WeekNum[weekday-1];
                            
                            NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                            [dateFor setDateFormat:@"yyyy-MM-dd"];
                            NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
                            NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
                            
                            
                            _callback(strDate, str, strDate);
                            ////NSLog(@"%@,%@",strDate,strWeek);
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择不早于当前的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    else
                    {
                        NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                        NSDate *now = _calendar.formDate;
                        NSDateComponents *comps;
                        comps = [calendarTime components:unitFlags fromDate:now];
                        //NSInteger week = [comps week]; // 今年的第几周
                        NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
                        
                        NSString* strWeek = WeekNum[weekday-1];
                        
                        NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                        [dateFor setDateFormat:@"yyyy-MM-dd"];
                        NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
                        NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
                        
                        
                        _callback(strDate, str, strDate);
                        ////NSLog(@"%@,%@",strDate,strWeek);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择不早于当前的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                NSCalendar *calendarTime = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                NSDate *now = _calendar.formDate;
                NSDateComponents *comps;
                comps = [calendarTime components:unitFlags fromDate:now];
                //NSInteger week = [comps week]; // 今年的第几周
                NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
                
                NSString* strWeek = WeekNum[weekday-1];
                
                NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                [dateFor setDateFormat:@"yyyy-MM-dd"];
                NSString* dateTime = [dateFor stringFromDate:_calendar.formDate];
                NSString* str = [NSString stringWithFormat:@"%@  %@",dateTime,strWeek];
                
                
                _callback(strDate, str, strDate);
                ////NSLog(@"%@,%@",strDate,strWeek);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择不早于当前的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        

    }
    
    
}
-(void)createData
{
    _calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    ////NSLog(@"%@",[NSDate date]);
    
    
    
    
    
    CGRect frame = _calendar.frame;
    frame.origin.y = 0;
    _calendar.frame = frame;
    [self.view addSubview:_calendar];
//    _callback(strDate,@"");
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
