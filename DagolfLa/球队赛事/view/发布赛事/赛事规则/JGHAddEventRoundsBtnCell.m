//
//  JGHAddEventRoundsBtnCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddEventRoundsBtnCell.h"

@implementation JGHAddEventRoundsBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ruleaddBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ruleaddBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectAddEventRoundsBtn:sender];
    }
}
@end
