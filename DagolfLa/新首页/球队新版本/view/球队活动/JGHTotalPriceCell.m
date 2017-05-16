//
//  JGHTotalPriceCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTotalPriceCell.h"

@implementation JGHTotalPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configTotalPrice:(float)total{
    self.totalPrice.text = [NSString stringWithFormat:@"¥%.2f", total];
}

@end
