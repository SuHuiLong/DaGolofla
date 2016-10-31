//
//  JGHShowMyTeamHeaderCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowMyTeamHeaderCell.h"

@implementation JGHShowMyTeamHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // ---
    self.bgLbaleH.constant = 20 *ProportionAdapter;
    self.bgLableLeft.constant = 10 *ProportionAdapter;
    
    self.name.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.nameLeft.constant = 10 *ProportionAdapter;
    
    self.GuestsBtn.titleLabel.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    
    self.arrowRight.constant = 10 *ProportionAdapter;
    
    self.lineLeft.constant = 10 *ProportionAdapter;
    self.lineRight.constant = 10 *ProportionAdapter;
}

- (void)configJGHShowMyTeamHeaderCell:(NSString *)name andSection:(NSInteger)section{
    if (section == 0) {
        self.GuestsBtn.hidden = YES;
        self.arrowImageView.hidden = YES;
    }else{
        self.GuestsBtn.hidden = NO;
        self.arrowImageView.hidden = NO;
    }
    
    self.name.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)GuestsBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectGuestsBtn:)]) {
        [self.delegate didSelectGuestsBtn:sender];
    }
}
@end
