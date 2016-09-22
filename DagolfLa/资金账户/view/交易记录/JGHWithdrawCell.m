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
    self.backgroundColor = [UIColor whiteColor];
    self.titles.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    self.values.font = [UIFont systemFontOfSize:15.0 * ProportionAdapter];
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

- (void)configSetPassword{
    self.titles.text = @"设置交易密码";
    self.values.hidden = YES;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)configWithdrawBalance:(float)balance{
    self.titles.text = @"提现金额";
    self.values.text = [NSString stringWithFormat:@"%.2f", balance];
    self.values.textAlignment = NSTextAlignmentCenter;
}

@end
