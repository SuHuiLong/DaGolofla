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
    self.backgroundColor = [UIColor whiteColor];
    self.imageview.layer.masksToBounds = YES;
    self.imageview.layer.cornerRadius = CornerRadiu;
    self.imageviewW.constant = 65*ProportionAdapter;
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    self.nameLeft.constant = 10*ProportionAdapter;
    self.timeImageLeft.constant = 10*ProportionAdapter;
    self.addressImageLeft.constant = 10*ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJGTeamActivityCellWithModel:(JGTeamAcitivtyModel *)modeel{
    //头像
    
    [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:modeel.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    //活动名称
    self.activitytitle.text = modeel.name;
    //报名
    self.Apply.text = @"";
    if (modeel.isClose != 1) {
        NSString *str = [Helper returnCurrentDateString];//跟当前时间比较
        if ([str compare:modeel.signUpEndTime] < 0) {
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
        NSLog(@"%@",[Helper setImageIconUrl:@"activity" andTeamKey:[modeel.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] );
        [self.imageview sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[modeel.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    }
    //活动名称
    self.activitytitle.text = modeel.name;
    self.activityStateImage.image = nil;
    self.Apply.text = @"";
    //报名
    if (modeel.isClose != 1) {
        NSString *str = [Helper returnCurrentDateString];//跟当前时间比较
        if ([str compare:modeel.signUpEndTime] >= 0) {
        }else{
            [self.activityStateImage setImage:[UIImage imageNamed:@"activityStateImage"]];
        }
    }
    self.activityTime.text = [Helper stringFromDateString:modeel.beginDate withFormater:@"yyyy.MM.dd"];
    //活动地址
    self.activityAddress.text = [NSString stringWithFormat:@"%@", modeel.ballName];
    //报名人数
    self.applyNumber.text = [NSString stringWithFormat:@"%td", modeel.sumCount];
    NSInteger maxCount = modeel.maxCount;
    if (maxCount==0) {
        self.maxCount.text = @" (人)";
    }else{
        self.maxCount.text = [NSString stringWithFormat:@"/%td (人)", maxCount];
    }
}

@end
