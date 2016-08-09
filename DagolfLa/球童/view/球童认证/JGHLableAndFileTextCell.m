//
//  JGHLableAndFileTextCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLableAndFileTextCell.h"

@implementation JGHLableAndFileTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.titleLableLeft.constant = 20 *ProportionAdapter;
    
    self.fielText.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.fielTextLeft.constant = 40 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
