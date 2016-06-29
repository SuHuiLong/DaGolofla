//
//  JGHWithdrawCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawCell.h"

@implementation JGHWithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGHWithdrawModelTime:(NSString *)time{
    self.titles.text = @"创建时间";
    self.values.text = time;
}

- (void)configJGHWithdrawModelSerialNumber:(NSString *)serialNumber{
    self.titles.text = @"流水号";
    self.values.text = serialNumber;
}

- (void)configJGHWithdrawModelBlankName:(NSString *)blankName{
    self.titles.text = @"提现到";
    self.values.text = blankName;
}


@end
