//
//  JGHGameBaseHeaderCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameBaseHeaderCell.h"

@implementation JGHGameBaseHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameLeft.constant = 10 *ProportionAdapter;
    
    self.detailsBtnRight.constant = 25 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailsBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectHelpBtn:sender];
    }
}

- (void)configJGHGameBaseHeaderCell:(NSString *)rulesName{
    self.name.text = rulesName;
}

@end
