//
//  JGHNewScoresPageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/6.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNewScoresPageCell.h"

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
        [self.delegate didTotalRedPoleNumber:sender andCellTage:sender.tag];
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

- (void)configTotalPoleViewTitle{
    self.scoreCatoryLable.text = @"总杆";
    self.pushNumberProLabel.text = @"杆数";
}

- (void)configPoleViewTitle{
    self.scoreCatoryLable.text = @"总差杆";
    self.pushNumberProLabel.text = @"差杆";
}

@end
