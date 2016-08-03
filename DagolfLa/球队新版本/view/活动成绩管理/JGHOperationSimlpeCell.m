//
//  JGHOperationSimlpeCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperationSimlpeCell.h"

@implementation JGHOperationSimlpeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.bgTop.constant = 5*ProportionAdapter;
    self.bgLeft.constant = 20*ProportionAdapter;
    self.bgRight.constant = 20*ProportionAdapter;
    
    self.onlyScoreTotal.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.onlyScoreTotalTop.constant = 65*ProportionAdapter;

    self.rodLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
    self.rodLabelLeft.constant = 35*ProportionAdapter;

    self.rodVlaue.font = [UIFont systemFontOfSize:50*ProportionAdapter];
    self.rodVlaueTop.constant = 50*ProportionAdapter;

    self.addBtnRight.constant = 35*ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configPoles:(NSInteger)poles{
    self.rodVlaue.text = [NSString stringWithFormat:@"%td", poles];
}

- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addRodBtn];
    }
}
- (IBAction)redBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate redRodBtn];
    }
}
@end
