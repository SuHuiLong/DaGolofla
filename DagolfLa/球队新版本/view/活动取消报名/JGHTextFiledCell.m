//
//  JGHTextFiledCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTextFiledCell.h"

@implementation JGHTextFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configViewTitles{
    self.titles.text = @"退款理由";
    self.titlefileds.placeholder = @"请输入退款理由";
}

@end
