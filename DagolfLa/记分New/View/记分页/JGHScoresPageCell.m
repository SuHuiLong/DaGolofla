//
//  JGHScoresPageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresPageCell.h"
#import "JGHScoreListModel.h"

@implementation JGHScoresPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.totalPoleLeft.constant = 10*ProportionAdapter;
    self.totalPoleRight.constant = 6*ProportionAdapter;
    
    self.totalPole.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    self.totalPoleValue.font = [UIFont systemFontOfSize:27*ProportionAdapter];
    
    self.rodTop.constant = 23*ProportionAdapter;
    self.rodtoTotalPoleTop.constant = -4*ProportionAdapter;
    
    self.userNameLeft.constant = 10*ProportionAdapter;
    self.userNameDown.constant = 23*ProportionAdapter;
    
    self.addPoleRight.constant = 10*ProportionAdapter;
    self.addPushRight.constant = 10*ProportionAdapter;
    
    NSLayoutConstraint *addScoresConstraint = [NSLayoutConstraint constraintWithItem:self.addScoresBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50*ProportionAdapter];
    
    NSArray *addScoreArray = [NSArray arrayWithObjects:addScoresConstraint, nil];
    [self addConstraints: addScoreArray];
    
    self.onballRight.constant = 8*ProportionAdapter;
    
    self.upperTrackNoBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    
    self.pushPoleValueRight.constant = 21*ProportionAdapter;
    self.poleTop.constant = 2*ProportionAdapter;
    
    self.pushPoleValue.font = [UIFont systemFontOfSize:21*ProportionAdapter];
    self.pushPoleTop.constant = 2*ProportionAdapter;
    
    
    self.addScoresBtnRight.constant = 21*ProportionAdapter;
    
    self.userName.font = [UIFont systemFontOfSize:15.0 *ProportionAdapter];
//    self.userName.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    
    self.totalPromLabel.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.pushPromLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 是 上道球
- (IBAction)upperTrackBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectUpperTrackBtnClick:sender andCellTage:self.tag];
    }
}
#pragma mark -- 否 上道球
- (IBAction)upperTrackNoBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectUpperTrackNoBtnClick:sender andCellTage:self.tag];
    }
}

#pragma mark -- -
- (IBAction)reduntionScoresBtnClicK:(UIButton *)sender {
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
- (IBAction)addScoresBtnClick:(UIButton *)sender {
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
    [self.self.reduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScores"] forState:UIControlStateNormal];
}
- (void)updateDownReduntionScoresBtnImage{
    [self.downReduntionScoresBtn setImage:[UIImage imageNamed:@"reductionScores"] forState:UIControlStateNormal];
}

- (void)configJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index{
    //poleNumber.count  总杆数
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
        self.poleValue.font = [UIFont systemFontOfSize:25 *ProportionAdapter];
        self.poleValue.textColor = [UIColor lightGrayColor];
    }else{
        self.poleValue.text = [NSString stringWithFormat:@"%@", [model.poleNumber objectAtIndex:index]];
        self.poleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.poleValue.textColor = [UIColor blackColor];
    }
    
    if ([[model.pushrod objectAtIndex:index] integerValue] == -1) {
        self.pushPoleValue.text = @"2";
        self.pushPoleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor lightGrayColor];
    }else{
        self.pushPoleValue.text = [NSString stringWithFormat:@"%@", [model.pushrod objectAtIndex:index]];
        self.pushPoleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor blackColor];
    }
    
    self.userName.text = model.userName;
    
    //是否上球道
    if ([[model.onthefairway objectAtIndex:index] integerValue] == 1){
        [self.upperTrackBtn setBackgroundImage:[UIImage imageNamed:@"onballG"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setBackgroundImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }else if ([[model.onthefairway objectAtIndex:index] integerValue] == 0){
        [self.upperTrackBtn setBackgroundImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setBackgroundImage:[UIImage imageNamed:@"noballG"] forState:UIControlStateNormal];
    }else{
        [self.upperTrackBtn setBackgroundImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setBackgroundImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }
}

- (void)configPoorJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index{
    //standardlever  总差杆数
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
        self.poleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.poleValue.textColor = [UIColor lightGrayColor];
    }else{
        if ([[model.poleNumber objectAtIndex:index] integerValue] == 0) {
            self.poleValue.text = @"0";
        }else{
            self.poleValue.text = [NSString stringWithFormat:@"%td", ([[model.poleNumber objectAtIndex:index] integerValue] - [[model.standardlever objectAtIndex:index] integerValue])];
        }
        
        self.poleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.poleValue.textColor = [UIColor blackColor];
    }
    
    if ([[model.pushrod objectAtIndex:index] integerValue] == -1) {
        self.pushPoleValue.text = @"2";
        self.pushPoleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor lightGrayColor];
    }else{
        self.pushPoleValue.text = [NSString stringWithFormat:@"%@", [model.pushrod objectAtIndex:index]];
        self.pushPoleValue.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushPoleValue.textColor = [UIColor blackColor];
    }
    
    self.userName.text = model.userName;
    
    //是否上球道
    if ([[model.onthefairway objectAtIndex:index] integerValue] == 1){
        [self.upperTrackBtn setBackgroundImage:[UIImage imageNamed:@"onballG"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setBackgroundImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }else if ([[model.onthefairway objectAtIndex:index] integerValue] == 0){
        [self.upperTrackBtn setBackgroundImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setBackgroundImage:[UIImage imageNamed:@"noballG"] forState:UIControlStateNormal];
    }else{
        [self.upperTrackBtn setBackgroundImage:[UIImage imageNamed:@"onballL"] forState:UIControlStateNormal];
        [self.upperTrackNoBtn setBackgroundImage:[UIImage imageNamed:@"noballL"] forState:UIControlStateNormal];
    }
    
}

- (void)configTotalPoleViewTitle{
    self.totalPole.text = @"";
    self.totalPromLabel.text = @"";
    self.totalPole.text = @"总杆";
    self.totalPromLabel.text = @"杆数";
}

- (void)configPoleViewTitle{
    self.totalPole.text = @"";
    self.totalPromLabel.text = @"";
    self.totalPole.text = @"总差杆";
    self.totalPromLabel.text = @"差杆";
}

@end
