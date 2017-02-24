//
//  JGHNewFourScoresPageCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewFourScoresPageCell.h"
#import "JGHScoreListModel.h"

@implementation JGHNewFourScoresPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 20*ProportionAdapter, 115*ProportionAdapter, 20*ProportionAdapter)];
        _userName.text = @"笨笨－播客";
        _userName.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.textColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_userName];
        
        _fairway = [[UILabel alloc]initWithFrame:CGRectMake(135*ProportionAdapter, 20*ProportionAdapter, 46*ProportionAdapter, 15*ProportionAdapter)];
        _fairway.text = @"上球道";
        _fairway.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        _fairway.textAlignment = NSTextAlignmentCenter;
        _fairway.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:_fairway];
        
        _totalName = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 85*ProportionAdapter, 45*ProportionAdapter, 20*ProportionAdapter)];
        _totalName.text = @"总杆";
        _totalName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _totalName.textAlignment = NSTextAlignmentLeft;
        _totalName.textColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_totalName];
        
        //总杆值
        _totalPoleValue = [[UILabel alloc]initWithFrame:CGRectMake(_totalName.frame.origin.x +_totalName.frame.size.width, 85*ProportionAdapter, 40*ProportionAdapter, 20*ProportionAdapter)];
        _totalPoleValue.text = @"25";
        _totalPoleValue.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _totalPoleValue.textAlignment = NSTextAlignmentLeft;
        _totalPoleValue.textColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_totalPoleValue];
        
        //总推杆
        _totalPushValue = [[UILabel alloc]initWithFrame:CGRectMake(_totalPoleValue.frame.origin.x +_totalPoleValue.frame.size.width, 75*ProportionAdapter, 40*ProportionAdapter, 20*ProportionAdapter)];
        _totalPushValue.text = @"25";
        _totalPushValue.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        _totalPushValue.textAlignment = NSTextAlignmentLeft;
        _totalPushValue.textColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_totalPushValue];
        
        //是
        _upperTrackBtn = [[UIButton alloc]initWithFrame:CGRectMake(140*ProportionAdapter, 40*ProportionAdapter, 36*ProportionAdapter, 30*ProportionAdapter)];
        [_upperTrackBtn setImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [_upperTrackBtn addTarget:self action:@selector(upperTrackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upperTrackBtn];
        
        //否
        _upperTrackNoBtn = [[UIButton alloc]initWithFrame:CGRectMake(140*ProportionAdapter, 70*ProportionAdapter, 36*ProportionAdapter, 30*ProportionAdapter)];
        [_upperTrackNoBtn setImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
        [_upperTrackNoBtn addTarget:self action:@selector(upperTrackNoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upperTrackNoBtn];
        
        //-杆数
        _reduntionScoresBtn = [[UIButton alloc]initWithFrame:CGRectMake(210*ProportionAdapter, 20*ProportionAdapter, 50*ProportionAdapter, 32*ProportionAdapter)];
        [_reduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScores"] forState:UIControlStateNormal];
        _reduntionScoresBtn.tag = 50;
        [_reduntionScoresBtn addTarget:self action:@selector(reduntionScoresBtnClicK:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reduntionScoresBtn];
        
        //-推杆
        _downReduntionScoresBtn = [[UIButton alloc]initWithFrame:CGRectMake(210*ProportionAdapter, 69*ProportionAdapter, 50*ProportionAdapter, 32*ProportionAdapter)];
        [_downReduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScores"] forState:UIControlStateNormal];
        _downReduntionScoresBtn.tag = 51;
        [_downReduntionScoresBtn addTarget:self action:@selector(reduntionScoresBtnClicK:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downReduntionScoresBtn];
        
        //+杆数
        _addScoresBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -60*ProportionAdapter, 20*ProportionAdapter, 50*ProportionAdapter, 32*ProportionAdapter)];
        [_addScoresBtn setImage:[UIImage imageNamed:@"addScores"] forState:UIControlStateNormal];
        _addScoresBtn.tag = 60;
        [_addScoresBtn addTarget:self action:@selector(addScoresBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addScoresBtn];
        
        //+推杆
        _downAddScoresBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -60*ProportionAdapter, 69*ProportionAdapter, 50*ProportionAdapter, 32*ProportionAdapter)];
        [_downAddScoresBtn setImage:[UIImage imageNamed:@"addScores"] forState:UIControlStateNormal];
        _downAddScoresBtn.tag = 61;
        [_downAddScoresBtn addTarget:self action:@selector(addScoresBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downAddScoresBtn];
        
        //杆数
        _poleValue = [[UILabel alloc]initWithFrame:CGRectMake(260*ProportionAdapter, 18*ProportionAdapter, 55*ProportionAdapter, 22*ProportionAdapter)];
        _poleValue.font = [UIFont systemFontOfSize:20*ProportionAdapter];
        _poleValue.textAlignment = NSTextAlignmentCenter;
        _poleValue.textColor = [UIColor colorWithHexString:@"#999999"];
        _poleValue.text = @"3";
        [self addSubview:_poleValue];
        
        _poleValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(260*ProportionAdapter, 40*ProportionAdapter, 55*ProportionAdapter, 12*ProportionAdapter)];
        _poleValueLabel.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        _poleValueLabel.textAlignment = NSTextAlignmentCenter;
        _poleValueLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _poleValueLabel.text = @"杆数";
        [self addSubview:_poleValueLabel];
        
        //推杆
        _pushPoleValue = [[UILabel alloc]initWithFrame:CGRectMake(260*ProportionAdapter, 67*ProportionAdapter, 55*ProportionAdapter, 22*ProportionAdapter)];
        _pushPoleValue.font = [UIFont systemFontOfSize:20*ProportionAdapter];
        _pushPoleValue.textAlignment = NSTextAlignmentCenter;
        _pushPoleValue.textColor = [UIColor colorWithHexString:@"#999999"];
        _pushPoleValue.text = @"3";
        [self addSubview:_pushPoleValue];
        
        _pushPoleLable = [[UILabel alloc]initWithFrame:CGRectMake(260*ProportionAdapter, 89*ProportionAdapter, 55*ProportionAdapter, 12*ProportionAdapter)];
        _pushPoleLable.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        _pushPoleLable.textAlignment = NSTextAlignmentCenter;
        _pushPoleLable.textColor = [UIColor colorWithHexString:@"#999999"];
        _pushPoleLable.text = @"推杆";
        [self addSubview:_pushPoleLable];
        
    }
    return self;
}
#pragma mark -- 是 上道球
- (IBAction)upperTrackBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectUpperTrackBtnClick:sender andCellTage:self.tag];
    }
}
#pragma mark -- 否 上道球
- (void)upperTrackNoBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectUpperTrackNoBtnClick:sender andCellTage:self.tag];
    }
}

#pragma mark -- -
- (void)reduntionScoresBtnClicK:(UIButton *)sender {
    if (sender.tag == 50) {
        [self.self.reduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScoresPress"] forState:UIControlStateNormal];
        [self performSelector:@selector(updateReduntionScoresBtnImage) withObject:self afterDelay:0.7];
    }else{
        [self.downReduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScoresPress"] forState:UIControlStateNormal];
        [self performSelector:@selector(updateDownReduntionScoresBtnImage) withObject:self afterDelay:0.7];
    }
    
    if (self.delegate) {
        [self.delegate selectReduntionScoresBtnClicK:sender andCellTage:self.tag];
    }
}
#pragma mark -- +
- (void)addScoresBtnClick:(UIButton *)sender {
    if (sender.tag == 60) {
        [self.addScoresBtn setImage:[UIImage imageNamed:@"addScoresPress"] forState:UIControlStateNormal];
        [self performSelector:@selector(updateAddScoresBtnImage) withObject:self afterDelay:0.7];
    }else{
        [self.downAddScoresBtn setImage:[UIImage imageNamed:@"addScoresPress"] forState:UIControlStateNormal];
        [self performSelector:@selector(updateDownAddScoresBtnImage) withObject:self afterDelay:0.7];
    }
    
    if (self.delegate) {
        [self.delegate selectAddScoresBtnClick:sender andCellTage:self.tag];
    }
}
#pragma mark -- 更换图片背景  + 上
- (void)updateAddScoresBtnImage{
    [self.addScoresBtn setImage:[UIImage imageNamed:@"addScores"] forState:UIControlStateNormal];
}
- (void)updateDownAddScoresBtnImage{
    [self.downAddScoresBtn setImage:[UIImage imageNamed:@"addScores"] forState:UIControlStateNormal];
}
#pragma mark -- 更换图片背景  - 上
- (void)updateReduntionScoresBtnImage{
    [self.reduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScores"] forState:UIControlStateNormal];
}
- (void)updateDownReduntionScoresBtnImage{
    [self.downReduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScores"] forState:UIControlStateNormal];
}

- (void)configJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index{
    //poleNumber.count  总杆数
    self.totalName.text = @"总杆";
    self.poleValueLabel.text = @"杆数";
    
    NSInteger poleCount = 0;
    for (int i=0; i<model.poleNumber.count; i++) {
        NSInteger pole = [[model.poleNumber objectAtIndex:i] integerValue];
        NSLog(@"pole == %td", pole);
        if (pole != -1) {
            poleCount += pole;
        }
        
        NSLog(@"poleCount == %td", poleCount);
    }
    self.totalPoleValue.text = [NSString stringWithFormat:@"%td", poleCount];
    //
    NSInteger totalPoleCount = 0;
    for (int i=0; i<model.pushrod.count; i++) {
        NSInteger pole = [[model.pushrod objectAtIndex:i] integerValue];
        NSLog(@"pole == %td", pole);
        if (pole != -1) {
            totalPoleCount += pole;
        }
        
        NSLog(@"totalPoleCount == %td", totalPoleCount);
    }
    self.totalPushValue.text = [NSString stringWithFormat:@"%td", totalPoleCount];
    
    if ([[model.poleNumber objectAtIndex:index] integerValue] == -1) {
        self.poleValue.text = [NSString stringWithFormat:@"%@", [model.standardlever objectAtIndex:index]];
        self.poleValue.font = [UIFont systemFontOfSize:23 *ProportionAdapter];
        self.poleValue.textColor = [UIColor lightGrayColor];
    }else{
        self.poleValue.text = [NSString stringWithFormat:@"%@", [model.poleNumber objectAtIndex:index]];
        self.poleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.poleValue.textColor = [UIColor blackColor];
    }
    
    if ([[model.pushrod objectAtIndex:index] integerValue] == -1) {
        self.pushPoleValue.text = @"2";
        self.pushPoleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor lightGrayColor];
    }else{
        self.pushPoleValue.text = [NSString stringWithFormat:@"%@", [model.pushrod objectAtIndex:index]];
        self.pushPoleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor blackColor];
    }
    
    self.userName.text = model.userName;
    
    //计算位置
    [self calculateViewSize];

    
    //是否上球道
    if ([[model.onthefairway objectAtIndex:index] integerValue] == 1){
        [self.upperTrackBtn setImage:[UIImage imageNamed:@"onballG"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }else if ([[model.onthefairway objectAtIndex:index] integerValue] == 0){
        [self.upperTrackBtn setImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setImage:[UIImage imageNamed:@"noballG"] forState:UIControlStateNormal];
    }else{
        [self.upperTrackBtn setImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }
}

- (void)calculateViewSize{
    float totalNameWSize;
    totalNameWSize = [Helper textWidthFromTextString:_totalName.text height:_totalName.frame.size.height fontSize:15 *ProportionAdapter];
    self.totalName.frame = CGRectMake(20*ProportionAdapter, 85*ProportionAdapter, totalNameWSize +10*ProportionAdapter, 20*ProportionAdapter);
    
    //总杆值
    float totalPoleValueWSize;
    totalPoleValueWSize = [Helper textWidthFromTextString:_totalPoleValue.text height:_totalPoleValue.frame.size.height fontSize:15 *ProportionAdapter];
    _totalPoleValue.frame = CGRectMake(_totalName.frame.origin.x +_totalName.frame.size.width, 85*ProportionAdapter, totalPoleValueWSize, 20*ProportionAdapter);
    
    //总推杆
    float totalPushValueWSize;
    totalPushValueWSize = [Helper textWidthFromTextString:_totalPushValue.text height:_totalPushValue.frame.size.height fontSize:13 *ProportionAdapter];
    _totalPushValue.frame = CGRectMake(_totalPoleValue.frame.origin.x +_totalPoleValue.frame.size.width, 75*ProportionAdapter, 40*ProportionAdapter, 20*ProportionAdapter);
}
- (void)configPoorJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index{
    //standardlever  总差杆数
    self.totalName.text = @"总差杆";
    self.poleValueLabel.text = @"差杆";
    
    NSInteger standardCount = 0;
    for (int i=0; i<model.poleNumber.count; i++) {
        NSInteger pole = [[model.poleNumber objectAtIndex:i] integerValue];
        NSInteger standard = [[model.standardlever objectAtIndex:i] integerValue];
        NSLog(@"pole == %td", standard);
        if (pole != -1) {
            standardCount += (pole - standard);
        }
        
        NSLog(@"poleCount == %td", standardCount);
    }
    if (standardCount == 0) {
        self.totalPoleValue.text = @"0";
    }else if (standardCount < 0){
        self.totalPoleValue.text = [NSString stringWithFormat:@"%td", standardCount];
    }else{
        self.totalPoleValue.text = [NSString stringWithFormat:@"+%td", standardCount];
    }
    
    //总推杆
    NSInteger totalPoleCount = 0;
    for (int i=0; i<model.pushrod.count; i++) {
        NSInteger pole = [[model.pushrod objectAtIndex:i] integerValue];
        NSLog(@"pole == %td", pole);
        if (pole != -1) {
            totalPoleCount += pole;
        }
        
        NSLog(@"totalPoleCount == %td", totalPoleCount);
    }
    self.totalPushValue.text = [NSString stringWithFormat:@"%td", totalPoleCount];
    
    //差杆
    if ([[model.poleNumber objectAtIndex:index] integerValue] == -1) {
        self.poleValue.text = @"0";
        self.poleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.poleValue.textColor = [UIColor lightGrayColor];
    }else{
        if ([[model.poleNumber objectAtIndex:index] integerValue] == 0) {
            self.poleValue.text = @"0";
        }else{
            if ([[model.poleNumber objectAtIndex:index] integerValue] - [[model.standardlever objectAtIndex:index] integerValue] > 0) {
                self.poleValue.text = [NSString stringWithFormat:@"+%td", ([[model.poleNumber objectAtIndex:index] integerValue] - [[model.standardlever objectAtIndex:index] integerValue])];
            }else{
                self.poleValue.text = [NSString stringWithFormat:@"%td", ([[model.poleNumber objectAtIndex:index] integerValue] - [[model.standardlever objectAtIndex:index] integerValue])];
            }
        }
        
        self.poleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.poleValue.textColor = [UIColor blackColor];
    }
    
    if ([[model.pushrod objectAtIndex:index] integerValue] == -1) {
        self.pushPoleValue.text = @"2";
        self.pushPoleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor lightGrayColor];
    }else{
        self.pushPoleValue.text = [NSString stringWithFormat:@"%@", [model.pushrod objectAtIndex:index]];
        self.pushPoleValue.font = [UIFont systemFontOfSize:23*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor blackColor];
    }
    
    self.userName.text = model.userName;
    
    //计算位置
    [self calculateViewSize];
    
    //是否上球道
    if ([[model.onthefairway objectAtIndex:index] integerValue] == 1){
        [self.upperTrackBtn setImage:[UIImage imageNamed:@"onballG"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }else if ([[model.onthefairway objectAtIndex:index] integerValue] == 0){
        [self.upperTrackBtn setImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setImage:[UIImage imageNamed:@"noballG"] forState:UIControlStateNormal];
    }else{
        [self.upperTrackBtn setImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
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
