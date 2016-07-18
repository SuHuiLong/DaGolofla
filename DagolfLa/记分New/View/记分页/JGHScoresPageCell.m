//
//  JGHScoresPageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresPageCell.h"

@implementation JGHScoresPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.totalPoleLeft.constant = 20*ProportionAdapter;
    self.totalPoleRight.constant = 10*ProportionAdapter;
    
    self.totalPole.font = [UIFont systemFontOfSize:17*ProportionAdapter];
    
    self.totalPoleValue.font = [UIFont systemFontOfSize:24*ProportionAdapter];
    
    self.rodTop.constant = 23*ProportionAdapter;
    self.rodtoTotalPoleTop.constant = -4*ProportionAdapter;
    
    self.userNameLeft.constant = 20*ProportionAdapter;
    self.userNameDown.constant = 23*ProportionAdapter;
    self.upperTrackDown.constant = 8*ProportionAdapter;
    
    NSLayoutConstraint *addScoresConstraint = [NSLayoutConstraint constraintWithItem:self.addScoresBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50*ProportionAdapter];

    NSArray *addScoreArray = [NSArray arrayWithObjects:addScoresConstraint, nil];
    [self addConstraints: addScoreArray];
    
    self.onballRight.constant = 8*ProportionAdapter;
//    [self.upperTrackBtn.layer setBorderColor:[UIColor redColor].CGColor];
//    [self.upperTrackBtn.layer setBorderWidth:1];
//    [self.upperTrackBtn.layer setMasksToBounds:YES];
    
    self.upperTrackNoBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
//    [self.upperTrackNoBtn.layer setBorderColor:[UIColor redColor].CGColor];
//    [self.upperTrackNoBtn.layer setBorderWidth:1];
//    [self.upperTrackNoBtn.layer setMasksToBounds:YES];
    
    self.poleValue.font = [UIFont systemFontOfSize:21*ProportionAdapter];
    self.pushPoleValueRight.constant = 21*ProportionAdapter;
    self.poleTop.constant = 2*ProportionAdapter;
    
    self.pushPoleValue.font = [UIFont systemFontOfSize:21*ProportionAdapter];
    self.pushPoleTop.constant = 2*ProportionAdapter;
    
    
    self.addScoresBtnRight.constant = 21*ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 是 上道球
- (IBAction)upperTrackBtnClick:(UIButton *)sender {
}
#pragma mark -- 否 上道球
- (IBAction)upperTrackNoBtnClick:(UIButton *)sender {
}

#pragma mark -- -
- (IBAction)reduntionScoresBtnClicK:(UIButton *)sender {
    if (sender.tag == 50) {
        NSLog(@"- 杆数");
    }else{
        NSLog(@"- 推杆");
    }
}
#pragma mark -- +
- (IBAction)addScoresBtnClick:(UIButton *)sender {
    if (sender.tag == 60) {
        NSLog(@"+ 杆数");
    }else{
        NSLog(@"+ 推杆");
    }
}
@end
