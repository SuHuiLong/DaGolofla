//
//  JGDPickerView.m
//  DagolfLa
//
//  Created by 東 on 17/2/20.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDPickerView.h"

@implementation JGDPickerView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];

        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 290 * ProportionAdapter, screenWidth, 290 * ProportionAdapter)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        if (self.selectRow) {
            [self.pickerView selectRow:self.selectRow inComponent:0 animated:NO];
        }else{
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
        }
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerView];
        
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
        

        
    }
    
    return self;
}


//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//    
//    
//    return [UIView new];
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@", self.dataArray[row]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectString = self.dataArray[row];
}

- (void)cancelAct{
    [self removeFromSuperview];
}

- (void)confirmAct{

    self.blockStr(self.selectString ? self.selectString : self.dataArray[0]);
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
