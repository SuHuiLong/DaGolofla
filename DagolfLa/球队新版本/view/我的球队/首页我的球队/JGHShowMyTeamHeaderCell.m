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
    
    self.lineLeft.constant = 0;
    self.lineRight.constant = 0;
}

- (void)configJGHShowMyTeamHeaderCell:(NSString *)name andSection:(NSInteger)section{
    
    self.name.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
