//
//  JGDDatePicker.m
//  DagolfLa
//
//  Created by 東 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDDatePicker.h"

@implementation JGDDatePicker

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 290 * ProportionAdapter, screenWidth, 57 * ProportionAdapter)];
        btnView.backgroundColor = [UIColor whiteColor];
        [self addSubview:btnView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 18 * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];
        [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        [cancelBtn addTarget:self action:@selector(cancelAct) forControlEvents:(UIControlEventTouchUpInside)];
        [btnView addSubview:cancelBtn];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(310 * ProportionAdapter, 18 * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];
        [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        [confirmBtn addTarget:self action:@selector(confirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        [btnView addSubview:confirmBtn];
        
        
        self.dataPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 233 * ProportionAdapter, screenWidth, 233 * ProportionAdapter)];
        self.dataPickerView.datePickerMode = UIDatePickerModeDate;
        self.dataPickerView.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        self.dataPickerView.backgroundColor = [UIColor whiteColor];
        self.dataPickerView.maximumDate = [NSDate date];
        [self addSubview:self.dataPickerView];
    }
    return self;
}

- (void)setLastDate:(NSDate *)lastDate{
    self.dataPickerView.date = lastDate;
}

- (void)cancelAct{
    [self removeFromSuperview];
}

- (void)confirmAct{
    NSLog(@"%@" , self.dataPickerView.date);
    NSString *date = [NSString stringWithFormat:@"%@" , self.dataPickerView.date];
    self.blockStr([date substringWithRange:NSMakeRange(0, 10)]);
    [self removeFromSuperview];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
