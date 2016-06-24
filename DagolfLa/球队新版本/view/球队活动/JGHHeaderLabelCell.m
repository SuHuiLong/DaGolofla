//
//  JGHHeaderLabelCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHHeaderLabelCell.h"

@implementation JGHHeaderLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)congiftitles:(NSString *)titles{
    self.titles.text = titles;
}

- (void)congifContact:(NSString *)contact andNote:(NSString *)note{
    self.contact.text = [NSString stringWithFormat:@"¥%@", contact];
    self.noteLbael.text = @"(线上支付平台共补贴";
    self.subsidies.text = note;
    self.yuan.text = @"元)";
}
//报名总人数
- (void)congifCount:(NSInteger)count andSum:(NSInteger)sum{
    self.noteLbael.text = [NSString stringWithFormat:@" (%td/%td)", count, sum];
}

- (void)configInvoiceIfo:(NSString *)str{
    self.noteLbael.text = str;
}

- (void)configRefoundMonay:(float)monay{
    self.contact.text = [NSString stringWithFormat:@"¥%.2f", monay];
    self.noteLbael.hidden = YES;
    self.subsidies.hidden = YES;
    self.yuan.hidden = YES;
}

@end
