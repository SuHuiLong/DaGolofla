//
//  JGHNewScoresPageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/6.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNewScoresPageCell.h"
#import "JGHScoreListModel.h"

@implementation JGHNewScoresPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.nameTop.constant = 35 *ProportionAdapter;
    self.nameLeft.constant = 20 *ProportionAdapter;
    self.nameDown.constant = 16 *ProportionAdapter;
    
    self.scoreCatoryLable.font = [UIFont systemFontOfSize:22 *ProportionAdapter];
    self.scoreCatoryLableRight.constant = 27 *ProportionAdapter;
    
    self.pushRodLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    self.pushRodLabelRight.constant = 20 *ProportionAdapter;
    self.pushRodLabelLeft.constant = 7 *ProportionAdapter;
    
    self.totalRodLabel.font = [UIFont systemFontOfSize:35 *ProportionAdapter];
    
    self.fairwayLabel.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.fairwayLabelLeft.constant = 20 *ProportionAdapter;
    self.fairwayLabelTop.constant = 20 *ProportionAdapter;
    
    self.fairwayBtnTop.constant = 25 *ProportionAdapter;
    
    self.pushNumber.font = [UIFont systemFontOfSize:25 *ProportionAdapter];
    self.pushNumberTop.constant = 16 *ProportionAdapter;
    
    self.pushNumberProLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.pushNumberProLabelTop.constant = 10 *ProportionAdapter;
    
    self.rodNumber.font = [UIFont systemFontOfSize:25 *ProportionAdapter];
    self.rodNumberTop.constant = 41 *ProportionAdapter;
    
    self.rodNumberProLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.rodNumberProLableTop.constant = 10 *ProportionAdapter;
    
    self.pushAddBtnRight.constant = 20 *ProportionAdapter;
    self.pushAddBtnTop.constant = 22 *ProportionAdapter;
    self.pushRedBtnLeft.constant = 16 *ProportionAdapter;
    self.rodAddBtnRight.constant = 20 *ProportionAdapter;
    self.rodRedBtnLeft.constant = 16 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 上球道
- (IBAction)fairwayBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didTotalFairway:sender andCellTage:self.tag];
    }
}
#pragma mark -- 未上球道
- (IBAction)noFairwayBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didTotalNOFairway:sender andCellTage:self.tag];
    }
}
#pragma mark -- + 杆数
- (IBAction)pushAddBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didTotalAddPoleNumber:sender andCellTage:self.tag];
    }
}
#pragma mark -- － 杆数
- (IBAction)pushRedBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didTotalRedPoleNumber:sender andCellTage:self.tag];
    }
}
#pragma mark -- + 推杆
- (IBAction)rodAddBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didTotalAddPushRod:sender andCellTage:self.tag];
    }
}
#pragma mark -- － 推杆
- (IBAction)rodRedBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didTotalRedPushRod:sender andCellTage:self.tag];
    }
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
    self.totalRodLabel.text = [NSString stringWithFormat:@"%td", poleCount];
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
    self.pushRodLabel.text = [NSString stringWithFormat:@"%td", totalPoleCount];
    
    if ([[model.poleNumber objectAtIndex:index] integerValue] == -1) {
        self.pushNumber.text = [NSString stringWithFormat:@"%@", [model.standardlever objectAtIndex:index]];
        self.pushNumber.font = [UIFont systemFontOfSize:25 *ProportionAdapter];
        self.pushNumber.textColor = [UIColor lightGrayColor];
    }else{
        self.pushNumber.text = [NSString stringWithFormat:@"%@", [model.poleNumber objectAtIndex:index]];
        self.pushNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushNumber.textColor = [UIColor blackColor];
    }
    
    if ([[model.pushrod objectAtIndex:index] integerValue] == -1) {
        self.rodNumber.text = @"2";
        self.rodNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.rodNumber.textColor = [UIColor lightGrayColor];
    }else{
        self.rodNumber.text = [NSString stringWithFormat:@"%@", [model.pushrod objectAtIndex:index]];
        self.rodNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.rodNumber.textColor = [UIColor blackColor];
    }
    
    self.name.text = model.userName;
    
    //是否上球道
    if ([[model.onthefairway objectAtIndex:index] integerValue] == 1){
        [self.fairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayYESLight"] forState:UIControlStateNormal];
        [self.noFairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayNO"] forState:UIControlStateNormal];
    }else if ([[model.onthefairway objectAtIndex:index] integerValue] == 0){
        [self.fairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayYES"] forState:UIControlStateNormal];
        [self.noFairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayNOLight"] forState:UIControlStateNormal];
    }else{
        [self.fairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayYES"] forState:UIControlStateNormal];
        [self.noFairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayNO"] forState:UIControlStateNormal];
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
        self.totalRodLabel.text = @"0";
    }else if (standardCount < 0){
        self.totalRodLabel.text = [NSString stringWithFormat:@"%td", standardCount];
    }else{
        self.totalRodLabel.text = [NSString stringWithFormat:@"+%td", standardCount];
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
    self.pushRodLabel.text = [NSString stringWithFormat:@"%td", totalPoleCount];
    
    //差杆
    if ([[model.poleNumber objectAtIndex:index] integerValue] == -1) {
        self.pushNumber.text = @"0";
        self.pushNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushNumber.textColor = [UIColor lightGrayColor];
    }else{
        if ([[model.poleNumber objectAtIndex:index] integerValue] == 0) {
            self.pushNumber.text = @"0";
        }else{
            self.pushNumber.text = [NSString stringWithFormat:@"%td", ([[model.poleNumber objectAtIndex:index] integerValue] - [[model.standardlever objectAtIndex:index] integerValue])];
        }
        
        self.pushNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.pushNumber.textColor = [UIColor blackColor];
    }
    
    if ([[model.pushrod objectAtIndex:index] integerValue] == -1) {
        self.rodNumber.text = @"0";
        self.rodNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.rodNumber.textColor = [UIColor lightGrayColor];
    }else{
        self.rodNumber.text = [NSString stringWithFormat:@"%@", [model.pushrod objectAtIndex:index]];
        self.rodNumber.font = [UIFont systemFontOfSize:25*ProportionAdapter];
        self.rodNumber.textColor = [UIColor blackColor];
    }
    
    self.name.text = model.userName;
    
    //是否上球道
    if ([[model.onthefairway objectAtIndex:index] integerValue] == 1){
        [self.fairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayYESLight"] forState:UIControlStateNormal];
        [self.noFairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayNO"] forState:UIControlStateNormal];
    }else if ([[model.onthefairway objectAtIndex:index] integerValue] == 0){
        [self.fairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayYES"] forState:UIControlStateNormal];
        [self.noFairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayNOLight"] forState:UIControlStateNormal];
    }else{
        [self.fairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayYES"] forState:UIControlStateNormal];
        [self.noFairwayBtn setBackgroundImage:[UIImage imageNamed:@"poorFairwayNO"] forState:UIControlStateNormal];
    }
}


- (void)configTotalPoleViewTitle{
    self.scoreCatoryLable.text = @"总杆";
    self.pushNumberProLabel.text = @"杆数";
}

- (void)configPoleViewTitle{
    self.scoreCatoryLable.text = @"总差杆";
    self.pushNumberProLabel.text = @"差杆";
}

@end
