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
    //活动列表标题
//    @property (weak, nonatomic) IBOutlet UILabel *activitytitle;
    self.activitytitle.text = modeel.activitytitle;
    //报名
    if (modeel.Apply == 0) {
        self.Apply.text = @"正在报名";
    }else{
        self.Apply.text = @"活动结束";
        self.Apply.textColor = [UIColor redColor];
    }
    //活动时间
    self.activityName.text = [NSString stringWithFormat:@"活动时间:%@", modeel.activityTime];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"地点:%@", modeel.activityAddress];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@"已报名人数(%@人)", modeel.applyNumber];
}

@end
