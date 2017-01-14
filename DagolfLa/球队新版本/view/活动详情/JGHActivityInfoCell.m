//
//  JGHActivityInfoCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHActivityInfoCell.h"

@implementation JGHActivityInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.infoLableLeft.constant = 10 *ProportionAdapter;
    self.infoLableTop.constant = 10 *ProportionAdapter;
    self.infoLableRight.constant = 10 *ProportionAdapter;
    self.infoLableDown.constant = 10 *ProportionAdapter;
    
    self.infoLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
