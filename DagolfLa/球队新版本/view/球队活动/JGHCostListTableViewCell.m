//
//  JGHCostListTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCostListTableViewCell.h"

@implementation JGHCostListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCostData:(NSString *)string{
    self.titles.text = [[string componentsSeparatedByString:@"-"] objectAtIndex:1];
    self.price.text = [[string componentsSeparatedByString:@"-"] objectAtIndex:0];
}


@end
