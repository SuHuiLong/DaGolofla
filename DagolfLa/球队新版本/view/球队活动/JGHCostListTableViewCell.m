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

- (void)configCostData:(NSMutableDictionary *)dict{
    self.titles.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"costName"]];
    self.price.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"money"]];
}


@end
