//
//  JGHScoresHoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresHoleCell.h"

#define BGScoreColor @"#B3E4BF"

@implementation JGHScoresHoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.name.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    NSLayoutConstraint *sConstraint = [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:55.5*ProportionAdapter];
    NSArray *array2 = [NSArray arrayWithObjects:sConstraint, nil];
    [self addConstraints: array2];
    
    self.one.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.oneLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.oneLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.oneLable.textAlignment = NSTextAlignmentCenter;
    self.oneLable.layer.masksToBounds = YES;
    self.oneLable.layer.cornerRadius = self.oneLable.frame.size.width /2;
//    self.oneLable.userInteractionEnabled = YES;
    self.oneLable.backgroundColor = [UIColor orangeColor];
    [self.one addSubview:self.oneLable];
    
    self.two.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.twoLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.twoLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.twoLable.layer.masksToBounds = YES;
    self.twoLable.textAlignment = NSTextAlignmentCenter;
    self.twoLable.layer.cornerRadius = self.twoLable.frame.size.width /2;
//    self.twoLable.userInteractionEnabled = YES;
    [self.two addSubview:self.twoLable];
    
    self.three.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.threeLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.threeLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.threeLable.layer.masksToBounds = YES;
    self.threeLable.textAlignment = NSTextAlignmentCenter;
    self.threeLable.layer.cornerRadius = self.threeLable.frame.size.width /2;
//    self.threeLable.userInteractionEnabled = YES;
    [self.three addSubview:self.threeLable];
    
    self.four.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.fourLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.height - 8 *ProportionAdapter)];
    self.fourLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.fourLable.layer.masksToBounds = YES;
    self.fourLable.textAlignment = NSTextAlignmentCenter;
    self.fourLable.layer.cornerRadius = self.fourLable.frame.size.width /2;
//    self.fourLable.userInteractionEnabled = YES;
    [self.four addSubview:self.fourLable];
    
    self.five.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.fiveLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.fiveLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.fiveLable.layer.masksToBounds = YES;
    self.fiveLable.textAlignment = NSTextAlignmentCenter;
    self.fiveLable.layer.cornerRadius = self.fiveLable.frame.size.width /2;
//    self.fiveLable.userInteractionEnabled = YES;
    [self.five addSubview:self.fiveLable];
    
    self.six.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.sixLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.sixLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.sixLable.layer.masksToBounds = YES;
    self.sixLable.textAlignment = NSTextAlignmentCenter;
    self.sixLable.layer.cornerRadius = self.sixLable.frame.size.width /2;
//    self.sixLable.userInteractionEnabled = YES;
    [self.six addSubview:self.sixLable];
    
    self.seven.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.sevenLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.sevenLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.sevenLable.layer.masksToBounds = YES;
    self.sevenLable.textAlignment = NSTextAlignmentCenter;
    self.sevenLable.layer.cornerRadius = self.sevenLable.frame.size.width /2;
//    self.sevenLable.userInteractionEnabled = YES;
    [self.seven addSubview:self.sevenLable];
    
    self.eight.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.eightLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.eightLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.eightLable.layer.masksToBounds = YES;
    self.eightLable.textAlignment = NSTextAlignmentCenter;
    self.eightLable.layer.cornerRadius = self.eightLable.frame.size.width /2;
//    self.eightLable.userInteractionEnabled = YES;
    [self.eight addSubview:self.eightLable];
    
    self.nine.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.nineLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
    self.nineLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.nineLable.layer.masksToBounds = YES;
    self.nineLable.textAlignment = NSTextAlignmentCenter;
    self.nineLable.layer.cornerRadius = self.nineLable.frame.size.width /2;
//    self.nineLable.userInteractionEnabled = YES;
    [self.nine addSubview:self.nineLable];
}

- (void)configAllViewBgColor:(NSString *)colorString andCellTag:(NSInteger)tag{
    self.name.backgroundColor = [UIColor colorWithHexString:colorString];
    self.one.backgroundColor = [UIColor colorWithHexString:colorString];
    self.two.backgroundColor = [UIColor colorWithHexString:colorString];
    self.three.backgroundColor = [UIColor colorWithHexString:colorString];
    self.four.backgroundColor = [UIColor colorWithHexString:colorString];
    self.five.backgroundColor = [UIColor colorWithHexString:colorString];
    self.six.backgroundColor = [UIColor colorWithHexString:colorString];
    self.seven.backgroundColor = [UIColor colorWithHexString:colorString];
    self.eight.backgroundColor = [UIColor colorWithHexString:colorString];
    self.nine.backgroundColor = [UIColor colorWithHexString:colorString];
    if (self.tag == 0) {
        NSLog(@"sel tag 111 = %td", self.tag);
        UIButton * temp = [self viewWithTag:tag];
        temp.backgroundColor = [UIColor colorWithHexString:BGScoreColor];
    }else{
        NSLog(@"sel tag = %td", self.tag);
        UIButton * temp = [self viewWithTag:tag];
        temp.backgroundColor = [UIColor colorWithHexString:BGScoreColor];
    }
}
- (void)configPoorArray:(NSArray *)array{
    self.name.text = @"HOLE";
    self.oneLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[9]]];
    self.twoLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[10]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[11]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[12]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[13]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[14]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[15]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[16]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[17]]];
}
- (void)configArray:(NSArray *)array{
    self.name.text = @"HOLE";
    self.oneLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[0]]];
    self.twoLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[1]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[2]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[3]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[4]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[5]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[6]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[7]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", array[8]]];
}

- (void)configOneToNine:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray{
    self.name.text = userName;
    
    for (int i=0; i<9; i++) {
        if ([[array objectAtIndex:i] integerValue] == -1) {
            if (i == 0) {
                self.oneLable.backgroundColor = [UIColor clearColor];
            }else if (i==1){
                self.twoLable.backgroundColor = [UIColor clearColor];
            }else if (i==2){
                self.threeLable.backgroundColor = [UIColor clearColor];
            }else if (i==3){
                self.fourLable.backgroundColor = [UIColor clearColor];
            }else if (i==4){
                self.fiveLable.backgroundColor = [UIColor clearColor];
            }else if (i==5){
                self.sixLable.backgroundColor = [UIColor clearColor];
            }else if (i==6){
                self.sevenLable.backgroundColor = [UIColor clearColor];
            }else if (i==7){
                self.eightLable.backgroundColor = [UIColor clearColor];
            }else {
                self.nineLable.backgroundColor = [UIColor clearColor];
            }
        }else{
            if ([[standradArray objectAtIndex:i] floatValue] > [[array objectAtIndex:i] floatValue]) {
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }
            }else if ([[standradArray objectAtIndex:i] floatValue] == [[array objectAtIndex:i] floatValue]){
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }
            }else{
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }
            }
        }
    }
    
    self.oneLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:0] andStandard:[[standradArray objectAtIndex:0] integerValue]]];
                          
    self.twoLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:1] andStandard:[[standradArray objectAtIndex:1] integerValue]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:2] andStandard:[[standradArray objectAtIndex:2] integerValue]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:3] andStandard:[[standradArray objectAtIndex:3] integerValue]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:4] andStandard:[[standradArray objectAtIndex:4] integerValue]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:5] andStandard:[[standradArray objectAtIndex:5] integerValue]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:6] andStandard:[[standradArray objectAtIndex:6] integerValue]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:7] andStandard:[[standradArray objectAtIndex:7] integerValue]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:8] andStandard:[[standradArray objectAtIndex:8] integerValue]]];
}
- (void)configNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray{
    self.name.text = userName;
    
    for (int i=9; i<18; i++) {
        if ([[array objectAtIndex:i] integerValue] == -1) {
            if (i == 9) {
                self.oneLable.backgroundColor = [UIColor clearColor];
            }else if (i==10){
                self.twoLable.backgroundColor = [UIColor clearColor];
            }else if (i==11){
                self.threeLable.backgroundColor = [UIColor clearColor];
            }else if (i==12){
                self.fourLable.backgroundColor = [UIColor clearColor];
            }else if (i==13){
                self.fiveLable.backgroundColor = [UIColor clearColor];
            }else if (i==14){
                self.sixLable.backgroundColor = [UIColor clearColor];
            }else if (i==15){
                self.sevenLable.backgroundColor = [UIColor clearColor];
            }else if (i==16){
                self.eightLable.backgroundColor = [UIColor clearColor];
            }else {
                self.nineLable.backgroundColor = [UIColor clearColor];
            }
        }else{
            if ([[standradArray objectAtIndex:i] floatValue] > [[array objectAtIndex:i] floatValue]) {
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_jian];
                }
            }else if ([[standradArray objectAtIndex:i] floatValue] == [[array objectAtIndex:i] floatValue]){
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_b];
                }
            }else{
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_jia];
                }
            }
        }
    }
    
    self.oneLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:9] andStandard:[[standradArray objectAtIndex:9] integerValue]]];
    
    self.twoLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:10] andStandard:[[standradArray objectAtIndex:10] integerValue]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:11] andStandard:[[standradArray objectAtIndex:11] integerValue]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:12] andStandard:[[standradArray objectAtIndex:12] integerValue]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:13] andStandard:[[standradArray objectAtIndex:13] integerValue]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:14] andStandard:[[standradArray objectAtIndex:14] integerValue]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:15] andStandard:[[standradArray objectAtIndex:15] integerValue]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:16] andStandard:[[standradArray objectAtIndex:16] integerValue]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [self pole:[array objectAtIndex:17] andStandard:[[standradArray objectAtIndex:17] integerValue]]];
}
#pragma mark -- 标准杆
- (void)configNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName{
    self.name.text = userName;
    
    self.oneLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[9]]];
    self.twoLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[10]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[11]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[12]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[13]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[14]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[15]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[16]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[17]]];
}
- (void)configOneToNine:(NSArray *)array andUserName:(NSString *)userName{
    self.name.text = userName;
    
    self.oneLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[0]]];
    self.twoLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[1]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[2]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[3]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[4]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[5]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[6]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[7]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[8]]];
}
- (NSString *)returnValue:(id)value{
    
    if ([value integerValue] == -1) {
        return @"";
    }else{
        return value;
    }
}
#pragma mark -- 计算差杆 －－ 杆数减去标准杆
- (NSString *)pole:(id)pole andStandard:(NSInteger)standrad{
    if ([pole integerValue] == -1) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%ld", labs([pole integerValue] - standrad)];
    }
}

- (void)configPoorOneToNine:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray{
    self.name.text = userName;
    
    for (int i=0; i<9; i++) {
        if ([[array objectAtIndex:i] integerValue] == -1) {
            if (i == 0) {
                self.oneLable.backgroundColor = [UIColor clearColor];
            }else if (i==1){
                self.twoLable.backgroundColor = [UIColor clearColor];
            }else if (i==2){
                self.threeLable.backgroundColor = [UIColor clearColor];
            }else if (i==3){
                self.fourLable.backgroundColor = [UIColor clearColor];
            }else if (i==4){
                self.fiveLable.backgroundColor = [UIColor clearColor];
            }else if (i==5){
                self.sixLable.backgroundColor = [UIColor clearColor];
            }else if (i==6){
                self.sevenLable.backgroundColor = [UIColor clearColor];
            }else if (i==7){
                self.eightLable.backgroundColor = [UIColor clearColor];
            }else {
                self.nineLable.backgroundColor = [UIColor clearColor];
            }
        }else{
            if ([[standradArray objectAtIndex:i] integerValue] == [[array objectAtIndex:i] integerValue]) {
                // Par
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }
            }else if ([[standradArray objectAtIndex:i] integerValue] < [[array objectAtIndex:i] integerValue]){
                //Bogey
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }
            }else if ([[array objectAtIndex:i] integerValue] - [[standradArray objectAtIndex:i] integerValue] == -1){
                //Birble
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }
            }else{
                //Eagle
                if (i == 0) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==1){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==2){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==3){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==4){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==5){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==6){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==7){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }
            }
        }
    }
    
    self.oneLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[0]]];
    self.twoLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[1]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[2]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[3]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[4]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[5]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[6]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[7]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[8]]];
}

- (void)configPoorNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray{
    self.name.text = userName;
    
    for (int i=9; i<18; i++) {
        if ([[array objectAtIndex:i] integerValue] == -1) {
            if (i == 9) {
                self.oneLable.backgroundColor = [UIColor clearColor];
            }else if (i==10){
                self.twoLable.backgroundColor = [UIColor clearColor];
            }else if (i==11){
                self.threeLable.backgroundColor = [UIColor clearColor];
            }else if (i==12){
                self.fourLable.backgroundColor = [UIColor clearColor];
            }else if (i==13){
                self.fiveLable.backgroundColor = [UIColor clearColor];
            }else if (i==14){
                self.sixLable.backgroundColor = [UIColor clearColor];
            }else if (i==15){
                self.sevenLable.backgroundColor = [UIColor clearColor];
            }else if (i==16){
                self.eightLable.backgroundColor = [UIColor clearColor];
            }else {
                self.nineLable.backgroundColor = [UIColor clearColor];
            }
        }else{
            NSLog(@"array - standradArray = %td---%td", [[array objectAtIndex:i] integerValue], [[standradArray objectAtIndex:i] integerValue]);
            if ([[standradArray objectAtIndex:i] integerValue] == [[array objectAtIndex:i] integerValue]) {
                // Par
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Par];
                }
            }else if ([[standradArray objectAtIndex:i] integerValue] < [[array objectAtIndex:i] integerValue]){
                //Bogey
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
                }
            }else if ([[array objectAtIndex:i] integerValue] - [[standradArray objectAtIndex:i] integerValue] == -1){
                //Birble
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
                }
            }else{
                //Eagle
                if (i == 9) {
                    self.oneLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==10){
                    self.twoLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==11){
                    self.threeLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==12){
                    self.fourLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==13){
                    self.fiveLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==14){
                    self.sixLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==15){
                    self.sevenLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else if (i==16){
                    self.eightLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }else {
                    self.nineLable.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
                }
            }
        }
    }
    
    self.oneLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[9]]];
    self.twoLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[10]]];
    self.threeLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[11]]];
    self.fourLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[12]]];
    self.fiveLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[13]]];
    self.sixLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[14]]];
    self.sevenLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[15]]];
    self.eightLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[16]]];
    self.nineLable.text = [NSString stringWithFormat:@"%@", [self returnValue:array[17]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)twoBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)threeBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)fourBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)fiveBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)sixBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)sevenBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)eightBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)nineBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
@end
