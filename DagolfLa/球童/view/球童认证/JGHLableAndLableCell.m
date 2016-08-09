//
//  JGHLableAndLableCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLableAndLableCell.h"

@implementation JGHLableAndLableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.titleLableLeft.constant = 20 *ProportionAdapter;
    
    self.valueLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.valueLableLeft.constant = 40 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
