//
//  JGHAddPlaysButtonCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddPlaysButtonCell.h"

@implementation JGHAddPlaysButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addPlaysBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)addPlaysBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addPlaysButtonCellClick:sender];
    }
}

@end
