//
//  JGHGameSetCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameSetCell.h"

@implementation JGHGameSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gameSet.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    self.gameSetLeft.constant = 25 *ProportionAdapter;
    
    self.imageW.constant = 35 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
