//
//  LGLCalenderModel.m
//  LGLProgress
//
//  Created by 李国良 on 2016/10/11.
//  Copyright © 2016年 李国良. All rights reserved.
//  https://github.com/liguoliangiOS/LGLCalender.git

#import "LGLCalenderModel.h"
#import "LGLCalendarDate.h"
#import "LGLCalenderSubModel.h"

@implementation LGLCalenderModel

+ (void)getCalenderDataWithDate:(NSDate *)date block:(CallBackBlock)block {
    
    NSMutableArray * array = [NSMutableArray array];
    NSDate * cdate = date;
    NSInteger firstday = [LGLCalendarDate firstWeekdayInThisMonth:cdate]; // 本月的第一天是周几
    NSInteger totalDay = [LGLCalendarDate totaldaysInMonth:cdate];  //月份的所有天数
    NSInteger year = [LGLCalendarDate year:cdate];
    NSInteger month = [LGLCalendarDate month:cdate];
    
    NSInteger yearMax;
    if (month < 11) {
        yearMax = 1;
    }else{
        yearMax = 2;
    }
    
    NSInteger _currentYearArrayCount = 0;
    
    for (NSInteger y = year; y < year + yearMax; y ++) {
        if (yearMax == 1) {
            for (NSInteger i = month; i < month +3; i++) {
                LGLCalenderModel * model = [[LGLCalenderModel alloc] init];
                model.year = y;
                model.month = i;
                model.firstday = firstday;
                for (NSInteger j = 1; j < totalDay  +1; j ++) {
                    LGLCalenderSubModel * subModel = [[LGLCalenderSubModel alloc] init];
                    subModel.day = j;
//                    subModel.price = [NSString stringWithFormat:@"%td", 100 + j];
                    [model.details addObject:subModel];
                }
                totalDay = [LGLCalendarDate totaldaysInMonth:[LGLCalendarDate nextMonth:cdate]];
                cdate = [LGLCalendarDate nextMonth:cdate];
                firstday = [LGLCalendarDate firstWeekdayInThisMonth:cdate];
                
                [array addObject:model];
            }
        }else{
            if (y != year) {
                //下一年
                
                for (NSInteger i = 1; i < 4 -_currentYearArrayCount; i++) {
                    LGLCalenderModel * model = [[LGLCalenderModel alloc] init];
                    model.year = y;
                    model.month = i;
                    model.firstday = firstday;
                    for (NSInteger j = 1; j < totalDay  +1; j ++) {
                        LGLCalenderSubModel * subModel = [[LGLCalenderSubModel alloc] init];
                        subModel.day = j;
//                        subModel.price = [NSString stringWithFormat:@"%td", 100 + j];
                        [model.details addObject:subModel];
                    }
                    totalDay = [LGLCalendarDate totaldaysInMonth:[LGLCalendarDate nextMonth:cdate]];
                    cdate = [LGLCalendarDate nextMonth:cdate];
                    firstday = [LGLCalendarDate firstWeekdayInThisMonth:cdate];
                    
                    [array addObject:model];
                }
            }else{
                //当年
                for (NSInteger i = month; i < 13; i++) {
                    LGLCalenderModel * model = [[LGLCalenderModel alloc] init];
                    model.year = y;
                    model.month = i;
                    model.firstday = firstday;
                    for (NSInteger j = 1; j < totalDay  +1; j ++) {
                        LGLCalenderSubModel * subModel = [[LGLCalenderSubModel alloc] init];
                        subModel.day = j;
//                        subModel.price = [NSString stringWithFormat:@"%td", 100 + j];
                        [model.details addObject:subModel];
                    }
                    totalDay = [LGLCalendarDate totaldaysInMonth:[LGLCalendarDate nextMonth:cdate]];
                    cdate = [LGLCalendarDate nextMonth:cdate];
                    firstday = [LGLCalendarDate firstWeekdayInThisMonth:cdate];
                    
                    [array addObject:model];
                }
                
                _currentYearArrayCount = array.count;
            }
        }
        
        month = 1;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@"10" forKey:@"ballKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%ddagolfla.com", 10]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getBallPriceDate" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        block(array);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        NSLog(@"%@", array);
        NSDate * curcdate = date;
//        NSInteger curfirstday = [LGLCalendarDate firstWeekdayInThisMonth:curcdate]; // 本月的第一天是周几
//        NSInteger curtotalDay = [LGLCalendarDate totaldaysInMonth:cdate];  //月份的所有天数
//        NSInteger curyear = [LGLCalendarDate year:cdate];
//        NSInteger curmonth = [LGLCalendarDate month:cdate];
        NSInteger currentMonth = [LGLCalendarDate month:curcdate];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //分配价格数组
            NSMutableArray *dataArray = [NSMutableArray array];
            if ([data objectForKey:[NSString stringWithFormat:@"%td", currentMonth]]) {
                [dataArray addObject:[data objectForKey:[NSString stringWithFormat:@"%td", currentMonth]]];
            }
            
            if ([data objectForKey:[NSString stringWithFormat:@"%td", currentMonth +1]]) {
                [dataArray addObject:[data objectForKey:[NSString stringWithFormat:@"%td", currentMonth +1]]];
                if ([data objectForKey:[NSString stringWithFormat:@"%td", currentMonth +2]]) {
                    [dataArray addObject:[data objectForKey:[NSString stringWithFormat:@"%td", currentMonth +2]]];
                }else{
                    [dataArray addObject:[data objectForKey:@"1"]];
                }
            }else{
                [dataArray addObject:[data objectForKey:@"1"]];
                [dataArray addObject:[data objectForKey:@"2"]];
            }
            
            //配置新数据
            for (int i=0; i<array.count; i++) {
                LGLCalenderModel *model = [[LGLCalenderModel alloc]init];
                model = array[i];
                
                NSArray *priceArray = [dataArray objectAtIndex:i];
                //设置价格
                for (int j=0; j<model.details.count; j++) {
                    LGLCalenderSubModel *priceModel = [[LGLCalenderSubModel alloc]init];
                    //价格字典
                    NSDictionary *priceDict = [NSDictionary dictionary];
                    priceDict = priceArray[j];
                    
                    priceModel = model.details[j];
                    if ([priceDict objectForKey:@"money"]) {
                        priceModel.price = [NSString stringWithFormat:@"%@", [priceDict objectForKey:@"money"]];
                    }else{
                        priceModel.price = @"";
                    }
                }
            }
            
            block(array);
        }else{
            block(array);
            [LQProgressHud showMessage:@"获取价格信息失败！"];
        }
    }];
}

- (NSMutableArray *)details {
    if (!_details) {
        _details = [NSMutableArray array];
    }
    return _details;
}

#pragma mark -- 获取球场日期价格 getBallPriceDate 10

@end
