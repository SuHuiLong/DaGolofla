//
//  JGHAddCostButtonCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddCostButtonCell.h"

@implementation JGHAddCostButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.addCostBtn.titleLabel.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addCostBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addCostList:sender];
    }
}
@end
