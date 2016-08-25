//
//  JGHCostListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCostListCell.h"

@implementation JGHCostListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.titleLableLeft.constant = 10 *ProportionAdapter;
    
    self.valueTextField.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.valueTextFieldRight.constant = 10 *ProportionAdapter;
    self.valueTextFieldW.constant = 90 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCostListCell:(NSMutableDictionary *)dict{
    self.titleLable.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    
}

@end
