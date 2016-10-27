//
//  JGHAddMoreTeamTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddMoreTeamTableViewCell.h"

@implementation JGHAddMoreTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addTeamBtn.titleLabel.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addTeamBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelectAddMoreBtn:)]) {
        [self.delegate didSelectAddMoreBtn:sender];
    }
    
}
@end
