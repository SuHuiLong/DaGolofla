//
//  JGHNewScoresHoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewScoresHoleCell.h"

#define BGScoreColor @"#B3E4BF"

@implementation JGHNewScoresHoleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _bgLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_bgLable];

        //------------名字-----
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth -(30*9*ProportionAdapter +9), 30*ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
        _name.textColor = [UIColor colorWithHexString:B31_Color];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.text = @"name";
        [self addSubview:_name];
        
        //---------T台------
        _Taiwan = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter, 10*ProportionAdapter)];
        _Taiwan.hidden = YES;
        [self addSubview:_Taiwan];
        
        //----------第1洞--------------
        _one = [[UIButton alloc]initWithFrame:CGRectMake(_name.frame.origin.x +_name.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _one.tag = 1;
        [_one addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_one];

        self.oneLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, 30*ProportionAdapter - 8 *ProportionAdapter, 30*ProportionAdapter - 8 *ProportionAdapter)];
        self.oneLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.oneLable.textAlignment = NSTextAlignmentCenter;
        self.oneLable.layer.masksToBounds = YES;
        self.oneLable.layer.cornerRadius = self.oneLable.frame.size.width /2;
        self.oneLable.text = @"1";
        [self.one addSubview:self.oneLable];
        
        //----------第2洞--------------
        _two = [[UIButton alloc]initWithFrame:CGRectMake(_one.frame.origin.x +_one.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _two.tag = 2;
        [_two addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_two];

        self.twoLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.twoLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.twoLable.layer.masksToBounds = YES;
        self.twoLable.textAlignment = NSTextAlignmentCenter;
        self.twoLable.layer.cornerRadius = self.twoLable.frame.size.width /2;
        self.twoLable.text = @"2";
        [self.two addSubview:self.twoLable];
        
        //----------第3洞--------------
        _three = [[UIButton alloc]initWithFrame:CGRectMake(_two.frame.origin.x +_two.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _three.tag = 3;
        [_three addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_three];

        self.threeLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.threeLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.threeLable.layer.masksToBounds = YES;
        self.threeLable.textAlignment = NSTextAlignmentCenter;
        self.threeLable.layer.cornerRadius = self.threeLable.frame.size.width /2;
        self.threeLable.text = @"3";
        [self.three addSubview:self.threeLable];
        
        //----------第4洞--------------
        _four = [[UIButton alloc]initWithFrame:CGRectMake(_three.frame.origin.x +_three.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _four.tag = 4;
        [_four addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_four];

        self.fourLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.height - 8 *ProportionAdapter)];
        self.fourLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.fourLable.layer.masksToBounds = YES;
        self.fourLable.textAlignment = NSTextAlignmentCenter;
        self.fourLable.layer.cornerRadius = self.fourLable.frame.size.width /2;
        self.fourLable.text = @"4";
        [self.four addSubview:self.fourLable];
        
        //----------第5洞--------------
        _five = [[UIButton alloc]initWithFrame:CGRectMake(_four.frame.origin.x +_four.frame.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _five.tag = 5;
        [_five addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_five];

        self.fiveLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.fiveLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.fiveLable.layer.masksToBounds = YES;
        self.fiveLable.textAlignment = NSTextAlignmentCenter;
        self.fiveLable.layer.cornerRadius = self.fiveLable.frame.size.width /2;
        self.fiveLable.text = @"5";
        [self.five addSubview:self.fiveLable];
        
        //----------第6洞--------------
        _six = [[UIButton alloc]initWithFrame:CGRectMake(_five.frame.origin.x +_five.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _six.tag = 6;
        [_six addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_six];

        self.sixLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.sixLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.sixLable.layer.masksToBounds = YES;
        self.sixLable.textAlignment = NSTextAlignmentCenter;
        self.sixLable.layer.cornerRadius = self.sixLable.frame.size.width /2;
        self.sixLable.text = @"6";
        [self.six addSubview:self.sixLable];
        
        //----------第7洞--------------
        _seven = [[UIButton alloc]initWithFrame:CGRectMake(_six.frame.origin.x +_six.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _seven.tag = 7;
        [_seven addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_seven];

        self.sevenLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.sevenLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.sevenLable.layer.masksToBounds = YES;
        self.sevenLable.textAlignment = NSTextAlignmentCenter;
        self.sevenLable.layer.cornerRadius = self.sevenLable.frame.size.width /2;
        self.sevenLable.text = @"7";
        [self.seven addSubview:self.sevenLable];
        
        //----------第8洞--------------
        _eight = [[UIButton alloc]initWithFrame:CGRectMake(_seven.frame.origin.x +_seven.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _eight.tag = 8;
        [_eight addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_eight];

        self.eightLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.eightLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.eightLable.layer.masksToBounds = YES;
        self.eightLable.textAlignment = NSTextAlignmentCenter;
        self.eightLable.layer.cornerRadius = self.eightLable.frame.size.width /2;
        self.eightLable.text = @"8";
        [self.eight addSubview:self.eightLable];
        
        //----------第8洞--------------
        _nine = [[UIButton alloc]initWithFrame:CGRectMake(_eight.frame.origin.x +_eight.bounds.size.width +1, 0, 30*ProportionAdapter, 30*ProportionAdapter)];
        _nine.tag = 9;
        [_nine addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nine];

        self.nineLable = [[UILabel alloc]initWithFrame:CGRectMake(4 *ProportionAdapter, 4 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter, self.one.frame.size.width - 8 *ProportionAdapter)];
        self.nineLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        self.nineLable.layer.masksToBounds = YES;
        self.nineLable.textAlignment = NSTextAlignmentCenter;
        self.nineLable.layer.cornerRadius = self.nineLable.frame.size.width /2;
        self.nineLable.text = @"9";
        [self.nine addSubview:self.nineLable];
        
    }
    return self;
}


- (void)configAllViewBgColor:(NSString *)colorString andCellTag:(NSInteger)tag{
    self.bgLable.backgroundColor = [UIColor colorWithHexString:colorString];
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
    
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
}
- (void)configOneToNine:(NSArray *)array andUserName:(NSString *)userName{
    self.name.text = userName;
    self.Taiwan.hidden = YES;
    
//    self.nameLeft.constant = 0;
    self.name.textAlignment = NSTextAlignmentCenter;
    
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
#pragma mark -- 标准杆
- (void)configNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName{
    self.name.text = userName;
    self.Taiwan.hidden = YES;
    
//    self.nameLeft.constant = 0;
    self.name.textAlignment = NSTextAlignmentCenter;
    
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
- (void)configArray:(NSArray *)array{
    self.name.text = @"HOLE";
    
    self.Taiwan.hidden = YES;
    
    self.name.textAlignment = NSTextAlignmentCenter;
    
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

- (void)configOneToNine:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan{
    self.name.text = userName;
    
    [self configTaiwan:taiwan];
    
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
- (void)configNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan{
    self.name.text = userName;
    [self configTaiwan:taiwan];
    
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
- (void)configPoorArray:(NSArray *)array{
    self.name.text = @"HOLE";
    self.Taiwan.hidden = YES;
    
    self.name.textAlignment = NSTextAlignmentCenter;
    
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
- (void)configPoorOneToNine:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan{
    self.name.text = userName;
    
    [self configTaiwan:taiwan];
    
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
- (void)configPoorNineToEighteenth:(NSArray *)array andUserName:(NSString *)userName andStandradArray:(NSArray *)standradArray andTaiwan:(NSString *)taiwan{
    self.name.text = userName;
    [self configTaiwan:taiwan];
    
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
- (void)configTaiwan:(NSString *)taiwan{
    self.Taiwan.hidden = NO;
    self.name.textAlignment = NSTextAlignmentLeft;
    
    self.bgLable.frame = CGRectMake(0, 0, 25*ProportionAdapter, 30*ProportionAdapter);
    self.name.frame = CGRectMake(25*ProportionAdapter, 0, screenWidth -(30*9*ProportionAdapter +9 +25*ProportionAdapter), 30*ProportionAdapter);
    
    if ([taiwan isEqualToString:@"红T"] == YES) {
        _Taiwan.backgroundColor = [UITool colorWithHexString:@"e21f23" alpha:1];
    }
    else if ([taiwan isEqualToString:@"蓝T"] == YES)
    {
        _Taiwan.backgroundColor = [UITool colorWithHexString:@"2474ac" alpha:1];
    }
    else if ([taiwan isEqualToString:@"黑T"] == YES)
    {
        _Taiwan.backgroundColor = [UITool colorWithHexString:@"000000" alpha:1];
    }
    else if ([taiwan isEqualToString:@"黄T"] == YES || [taiwan isEqualToString:@"金T"] == YES)
    {
        _Taiwan.backgroundColor = [UITool colorWithHexString:@"bedd00" alpha:1];
    }
    else
    {
        _Taiwan.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
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

- (void)oneBtnClick:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:btn.tag andCellTag:self.tag];
    }
}

- (NSString *)returnValue:(id)value{
    
    if ([value integerValue] == -1) {
        return @"";
    }else{
        return value;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
