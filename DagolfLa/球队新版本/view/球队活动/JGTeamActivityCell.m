//
//  JGTeamActivityCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActivityCell.h"
#import "JGTeamAcitivtyModel.h"
#import "UIImageView+WebCache.h"

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
    //头像
    [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:modeel.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:@"tu2"]];
    //活动名称
    self.activitytitle.text = modeel.name;
    //报名
    if (modeel.isClose == 0) {
        self.Apply.text = @"正在报名";
    }else{
        self.Apply.text = @"活动结束";
        self.Apply.textColor = [UIColor redColor];
    }
    //活动时间componentsSeparatedByString
    NSString *timeString = [[modeel.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    self.activityTime.text = [NSString stringWithFormat:@"活动时间:%@月%@日", monthTimeString, dataTimeString];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"地点:%@", modeel.ballName];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@" %ld", (long)modeel.sumCount];
}

- (void)setJGTeamActivityCellWithModel:(JGTeamAcitivtyModel *)modeel fromCtrl:(NSInteger)ctrlId{
    if (ctrlId == 1) {
        [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[modeel.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:@"tu2"]];
    }else{
        [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:modeel.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:@"tu2"]];
    }
    
    //活动名称
    self.activitytitle.text = modeel.name;
    //报名
    if (modeel.isClose == 1) {
        self.Apply.text = @"活动结束";
        self.Apply.textColor = [UIColor redColor];
    }else{
        NSString *str = [Helper returnCurrentDateString];//跟当前时间比较
        if ([str compare:modeel.endDate] > 0) {
            self.Apply.text = @"活动结束";
            self.Apply.textColor = [UIColor redColor];
        }else{
            self.Apply.text = @"正在报名";
        }
    }
    //活动时间componentsSeparatedByString
    NSString *timeString = [[modeel.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    self.activityTime.text = [NSString stringWithFormat:@"活动时间:%@月%@日", monthTimeString, dataTimeString];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"地点:%@", modeel.ballName];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@" %ld", (long)modeel.sumCount];
}

@end
