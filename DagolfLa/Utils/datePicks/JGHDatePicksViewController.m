//
//  JGHDatePicksViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHDatePicksViewController.h"

@interface JGHDatePicksViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

{
    NSString *_dateString;
    
    UIPickerView *_dataPickView;
    
    NSMutableArray *_yearArray;
    NSArray *_monthArray;
    NSMutableArray *_daysArray;
    NSMutableArray *_hoursArray;
    NSMutableArray *_minutesArray;
    
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    NSInteger selectedHoursRow;
    NSInteger selectedMinutesRow;
    
    
    NSString *currentMonthString;
}

@end

@implementation JGHDatePicksViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark --saveClick
- (void)saveClick{
    [self.navigationController popViewControllerAnimated:YES];
    _returnDateString(_dateString);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择时间";

    
    [self createDatePicker];
}

#pragma mark 显示UiPickView
- (void)createDatePicker
{
    _dataPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, (screenHeight -264*ProportionAdapter)/2, self.view.frame.size.width, 200 *ProportionAdapter)];
    _dataPickView.delegate = self;
    _dataPickView.dataSource = self;
    
    [self.view addSubview:_dataPickView];

    NSDate *loadDate = [Helper getNowDateFromatAnDate:[NSDate date]];
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:loadDate]];
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:loadDate] integerValue]];
    if (currentMonthString.length == 1) {
        currentMonthString = [NSString stringWithFormat:@"0%@", currentMonthString];
    }
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:loadDate]];
    
    //HH
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:loadDate]];
    //mm
    [formatter setDateFormat:@"mm"];
    NSString *currentMinString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:loadDate]];
    
    _yearArray = [[NSMutableArray alloc]init];
    for (int i = [currentyearString intValue]; i <= [currentyearString intValue]+3 ; i++)
    {
        [_yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    // PickerView -  Months data
    _monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    // PickerView -  days data
    _daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 31; i++)
    {
        [_daysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    //点
    _hoursArray = [NSMutableArray array];
    for (int i=1; i<=24; i++) {
        if (i < 10) {
            [_hoursArray addObject:[NSString stringWithFormat:@"0%d", i]];
        }else{
            [_hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    //分钟
    _minutesArray = [NSMutableArray array];
    for (int i=1; i<=60; i++) {
        if (i < 10) {
            [_minutesArray addObject:[NSString stringWithFormat:@"0%d", i]];
        }else{
            [_minutesArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    // PickerView - Default Selection as per current Date
    selectedYearRow = [_yearArray indexOfObject:currentyearString];
    selectedMonthRow = [_monthArray indexOfObject:currentMonthString];
    selectedDayRow = [_daysArray indexOfObject:currentDateString] -1;
    selectedHoursRow = [_hoursArray indexOfObject:currentHourString];
    selectedMinutesRow = [_minutesArray indexOfObject:currentMinString];
    
    [_dataPickView selectRow:selectedYearRow inComponent:0 animated:YES];
    
    [_dataPickView selectRow:selectedMonthRow inComponent:1 animated:YES];
    
    [_dataPickView selectRow:selectedDayRow inComponent:2 animated:YES];
    
    [_dataPickView selectRow:selectedHoursRow inComponent:3 animated:YES];
    
    [_dataPickView selectRow:selectedMinutesRow inComponent:4 animated:YES];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedYearRow = row;
        [_dataPickView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        
        currentMonthString = _monthArray[row];
        [_dataPickView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [_dataPickView reloadAllComponents];
    }else if (component == 2)
    {
        selectedHoursRow = row;
        
        [_dataPickView reloadAllComponents];
    }else if (component == 2)
    {
        selectedMinutesRow = row;
        
        [_dataPickView reloadAllComponents];
    }
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:FontSize_Normal]];
    }
    
    if (component == 0)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@年",[_yearArray objectAtIndex:row]];  // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@月",[_monthArray objectAtIndex:row]];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@日",[_daysArray objectAtIndex:row]]; // Date
    }
    else if (component == 3)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@点",[_hoursArray objectAtIndex:row]]; // Date
    }else if (component == 4)
    {
        pickerLabel.text =  [NSString stringWithFormat:@"%@分",[_minutesArray objectAtIndex:row]]; // Date
    }
    
    NSString *newMonth;
    if ([[_monthArray objectAtIndex:selectedMonthRow] intValue] > 9) {
        newMonth = [NSString stringWithFormat:@"%@", [_monthArray objectAtIndex:selectedMonthRow]];
    }else{
        newMonth = [NSString stringWithFormat:@"0%@", [_monthArray objectAtIndex:selectedMonthRow]];
    }
    
    NSString *newDay;
    if ([[_daysArray objectAtIndex:selectedMonthRow] intValue] > 9) {
        newDay = [NSString stringWithFormat:@"%@", [_daysArray objectAtIndex:selectedDayRow]];
    }else{
        newDay = [NSString stringWithFormat:@"0%@", [_daysArray objectAtIndex:selectedDayRow]];
    }
    
    _dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00", _yearArray[selectedYearRow], newMonth, newDay, _hoursArray[selectedHoursRow], _minutesArray[selectedMinutesRow]];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

#pragma mark --  returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [_yearArray count];
    }
    else if (component == 1)
    {
        return [_monthArray count];
    }
    else if (component == 2)
    { // day
        
        if ([currentMonthString intValue] == 1 || [currentMonthString intValue] == 3 || [currentMonthString intValue] == 5 || [currentMonthString intValue] == 7 || [currentMonthString intValue] == 8 || [currentMonthString intValue] == 10 || [currentMonthString intValue] == 12)
        {
            return 31;
        }
        else if ([currentMonthString intValue] == 2)
        {
            int yearint = [[_yearArray objectAtIndex:selectedYearRow]intValue ];
            
            if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                
                return 29;
            }
            else
            {
                return 28; // or return 29
            }
        }
        else
        {
            return 30;
        }
        
    }else if (component == 3)
    {
        return [_hoursArray count];
    }else
    {
        return [_minutesArray count];
    }
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
