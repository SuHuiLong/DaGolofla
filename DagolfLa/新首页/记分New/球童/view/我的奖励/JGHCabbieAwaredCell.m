//
//  JGHCabbieAwaredCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieAwaredCell.h"
#import "JGHTransDetailListModel.h"

@implementation JGHCabbieAwaredCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.awaredLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.awaredLableLeft.constant = 10 *ProportionAdapter;
    self.awaredLableTop.constant = 16 *ProportionAdapter;

    self.timeLable.font = [UIFont systemFontOfSize:14*ProportionAdapter];
    self.timeLableTop.constant = 12 *ProportionAdapter;
    self.timeLableLeft.constant = 10 *ProportionAdapter;
    
    self.monyLable.font = [UIFont systemFontOfSize:18*ProportionAdapter];
    self.monyLableRight.constant = 10 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGHTransDetailListModel:(JGHTransDetailListModel *)model{
    self.awaredLable.text = model.name;
    
    self.timeLable.text = [Helper distanceTimeWithBeforeTime:model.exchangeTime];
    
    if ([model.amount integerValue] < 0) {
        self.monyLable.text = [NSString stringWithFormat:@"%@", model.amount];
    }else{
        self.monyLable.text = [NSString stringWithFormat:@"+%@", model.amount];
    }
}

@end
