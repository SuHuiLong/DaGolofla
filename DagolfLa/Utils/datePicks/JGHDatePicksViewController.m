//
//  JGHDatePicksViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHDatePicksViewController.h"
#import "UUDatePicker.h"

@interface JGHDatePicksViewController ()<UUDatePickerDelegate>

{
    NSString *_dateString;
}

@end

@implementation JGHDatePicksViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark --saveClick
- (void)saveClick{
    _returnDateString(_dateString);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateString = [Helper returnCurrentDateString];
    
    NSDate *now = [NSDate date];
    
    //delegate
    UUDatePicker *datePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(10*ProportionAdapter, ((screenHeight-200*ProportionAdapter-64)/2)*ProportionAdapter, screenWidth-20*ProportionAdapter, 200*ProportionAdapter)
                                                        Delegate:self
                                                     PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    datePicker.ScrollToDate = now;
//    datePicker.maxLimitDate = now;
    datePicker.minLimitDate = now;
//    datePicker.minLimitDate = [now dateByAddingTimeInterval:-111111111];
//    datePicker.minLimitDate = [[NSDate date]dateByAddingTimeInterval:-2222];
    [self.view addSubview:datePicker];
}

#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    _dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
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
