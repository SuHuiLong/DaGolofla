//
//  JGTeamActivityWithAddressCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActivityWithAddressCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGTeamActivityWithAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(JGTeamAcitivtyModel *)model{
    //开始
//    self.reamName.text = model.beginDate;
    self.reamName.text = [Helper returnDateformatString:model.beginDate];
    //结束时间
    self.activityTime.text = [Helper returnDateformatString:model.endDate];
    //截止
    self.limits.text = [Helper returnDateformatString:model.signUpEndTime];
}

@end
