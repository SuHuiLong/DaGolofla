//
//  JGHEventRulesContentCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEventRulesContentCell.h"

@implementation JGHEventRulesContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLable.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    self.titleLableLeft.constant = 25 *ProportionAdapter;
    self.titleLableW.constant = 80 *ProportionAdapter;
    
    self.contentLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.contentLableLeft.constant = 10 *ProportionAdapter;
    self.contentLableRight.constant = 10 *ProportionAdapter;
}

- (void)configJGHEventRulesContentCellTitle:(NSString *)title{
    self.titleLable.text = title;
}
- (void)configJGHEventRulesContentCellContext:(NSString *)context{
    self.contentLable.text = context;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
