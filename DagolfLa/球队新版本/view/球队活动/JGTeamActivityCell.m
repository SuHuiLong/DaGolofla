//
//  JGTeamActivityCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActivityCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGTeamActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJGTeamActivityCellWithModel:(JGTeamAcitivtyModel *)modeel{
    self.activitytitle.text = modeel.name;
    //报名
    if (modeel.isClose == 0) {
        self.Apply.text = @"正在报名";
    }else{
        self.Apply.text = @"活动结束";
        self.Apply.textColor = [UIColor redColor];
    }
    //活动时间
    self.activityName.text = [NSString stringWithFormat:@"活动时间:%ld", (long)modeel.beginDate];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"地点:%@", modeel.ballName];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@"已报名人数(%ld人)", (long)modeel.sumCount];
}

@end
