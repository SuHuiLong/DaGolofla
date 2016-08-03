//
//  JGHOperationScoreCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperationScoreCell.h"

@implementation JGHOperationScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.holeNameTop.constant = 65 *ProportionAdapter;
    self.holeName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.pushNumberLeft.constant = 35 *ProportionAdapter;
    self.pushNumber.font = [UIFont systemFontOfSize:17*ProportionAdapter];

    self.pushScoreTop.constant = 50 *ProportionAdapter;
    self.pushScore.font = [UIFont systemFontOfSize:50*ProportionAdapter];

    self.addScoreBtnRight.constant = 35 *ProportionAdapter;
    self.addScoreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];

    self.redScoreBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.scoreListBtnTop.constant = 25 *ProportionAdapter;
    self.scoreListBtnRight.constant = 30 *ProportionAdapter;
    self.scoreListBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];

    self.propmLabelLeft.constant = 15 *ProportionAdapter;
    self.propmLabelRight.constant = 15 *ProportionAdapter;
    self.propmLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addOperationBtn:sender];
    }
}
- (IBAction)scoreListBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate scoreListBtn];
    }
}
- (IBAction)redScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate redOperationBtn:sender];
    }
}
@end
