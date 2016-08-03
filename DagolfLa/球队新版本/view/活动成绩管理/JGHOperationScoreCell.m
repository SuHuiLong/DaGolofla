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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addOperationBtn];
    }
}
- (IBAction)scoreListBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate scoreListBtn];
    }
}
- (IBAction)redScoreBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate redOperationBtn];
    }
}
@end
