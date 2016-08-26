//
//  JGHApplyCatoryPriceViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyCatoryPriceViewCell.h"

@implementation JGHApplyCatoryPriceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.catoryLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.catoryLableLeft.constant = 40 *ProportionAdapter;
    
    self.priceLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.priceLableRight.constant = 50 *ProportionAdapter;

    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.selectBtnRight.constant = 30 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
