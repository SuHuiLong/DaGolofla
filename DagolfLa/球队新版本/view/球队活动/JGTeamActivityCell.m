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
    
//    self.imageview.frame = CGRectMake(self.imageview.frame.origin.x, self.imageview.frame.origin.y, 60 * screenWidth/375, 60 * screenWidth/375);
    self.imageview.layer.masksToBounds = YES;
    self.imageview.layer.cornerRadius = CornerRadiu;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJGTeamActivityCellWithModel:(JGTeamAcitivtyModel *)modeel{
    //头像
//    [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:modeel.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    
    [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:modeel.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    //活动名称
    self.activitytitle.text = modeel.name;
    //报名
    self.Apply.text = @"";
//    self.Apply.textColor = [UIColor blackColor];
    if (modeel.isClose == 1) {
//        self.Apply.text = @"";
//        self.Apply.textColor = [UIColor lightGrayColor];
    }else{
        NSString *str = [Helper returnCurrentDateString];//跟当前时间比较
        if ([str compare:modeel.signUpEndTime] >= 0) {
//            self.Apply.text = @"";
//            self.Apply.textColor = [UIColor lightGrayColor];
        }else{
//            self.Apply.text = @"报名中";
//            self.Apply.textColor = [UIColor orangeColor];
            [self.activityStateImage setImage:[UIImage imageNamed:@"activityStateImage"]];
        }
    }
    //活动时间componentsSeparatedByString
    NSString *timeString = [[modeel.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    self.activityTime.text = [NSString stringWithFormat:@"%@月%@日", monthTimeString, dataTimeString];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"%@", modeel.ballName];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@" %ld", (long)modeel.sumCount];
}

- (void)setJGTeamActivityCellWithModel:(JGTeamAcitivtyModel *)modeel fromCtrl:(NSInteger)ctrlId{
    if (ctrlId == 1) {
        //球队活动all 和活动大厅
        [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:modeel.teamActivityKey andIsSetWidth:NO andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        
    }else{
        //近期活动 -- 把活动的头像做cell的头像
        [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[modeel.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    }
    
//    self.imageview.frame = CGRectMake(self.imageview.frame.origin.x, self.imageview.frame.origin.y, 60 * screenWidth/375, 60 * screenWidth/375);
    //活动名称
    self.activitytitle.text = modeel.name;
    self.activityStateImage.image = nil;
    self.Apply.text = @"";
//    self.Apply.textColor = [UIColor blackColor];
    //报名
    if (modeel.isClose == 1) {
//        self.Apply.text = @"活动结束";
//        self.Apply.textColor = [UIColor lightGrayColor];
    }else{
        NSString *str = [Helper returnCurrentDateString];//跟当前时间比较
        if ([str compare:modeel.signUpEndTime] >= 0) {
//            self.Apply.text = @"报名结束";
//            self.Apply.textColor = [UIColor lightGrayColor];
        }else{
//            self.Apply.text = @"报名中";
//            self.Apply.textColor = [UIColor orangeColor];
            [self.activityStateImage setImage:[UIImage imageNamed:@"activityStateImage"]];
        }
    }
    //活动时间componentsSeparatedByString
    NSString *timeString = [[modeel.beginDate componentsSeparatedByString:@" "]firstObject];
    NSString *monthTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:1];
    NSString *dataTimeString = [[timeString componentsSeparatedByString:@"-"]objectAtIndex:2];
    self.activityTime.text = [NSString stringWithFormat:@"%@月%@日", monthTimeString, dataTimeString];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"%@", modeel.ballName];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@"%td", modeel.sumCount];
    self.maxCount.text = [NSString stringWithFormat:@"/%td(人)", modeel.maxCount];
}

@end
