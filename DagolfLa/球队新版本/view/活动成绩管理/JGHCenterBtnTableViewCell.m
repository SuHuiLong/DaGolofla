//
//  JGHCenterBtnTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCenterBtnTableViewCell.h"

@implementation JGHCenterBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionPointsBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)collectionPointsBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addScoreRecord];
    }
}

@end
