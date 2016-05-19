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
    //球场名称
    self.reamName.text = model.ballName;
    //活动时间
    self.activityTime.text = [NSString stringWithFormat:@"%ld", (long)model.beginDate];
    //人员限制
    self.limits.text = [NSString stringWithFormat:@"限制球队(%ld)人", (long)model.maxCount];
}

@end
