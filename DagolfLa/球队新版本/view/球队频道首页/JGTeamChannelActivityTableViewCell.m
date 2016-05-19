//
//  JGTeamChannelActivityTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelActivityTableViewCell.h"

@implementation JGTeamChannelActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 5 * screenWidth / 320, screenWidth - 10 * screenWidth / 320, 20 * screenWidth / 320)];
        self.nameLabel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self.contentView addSubview:self.nameLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 30 * screenWidth / 320, screenWidth / 2 - 10 * screenWidth / 320, 20 * screenWidth / 320)];
        self.dateLabel.font = [UIFont systemFontOfSize:13 * screenWidth / 320];
        [self.contentView addSubview:self.dateLabel];
        
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * screenWidth / 320 + screenWidth / 2, 30 * screenWidth / 320, screenWidth / 2 - 20 * screenWidth / 320, 20 * screenWidth / 320)];
        self.adressLabel.font = [UIFont systemFontOfSize:13 * screenWidth / 320];
        [self.contentView addSubview:self.adressLabel];

        self.describLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 55 * screenWidth / 320, screenWidth - 10 * screenWidth / 320, 20 * screenWidth / 320)];
        self.describLabel.font = [UIFont systemFontOfSize:13 * screenWidth / 320];
        [self.contentView addSubview:self.describLabel];
        
        UIView *lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 * screenWidth / 320, screenWidth, 3 * screenWidth / 320)];
        lightGrayView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.contentView addSubview:lightGrayView];
    }
    
    return self;
}

- (void)setActivityModel:(JGTeamAcitivtyModel *)activityModel{
    self.nameLabel.text = activityModel.name;
//    self.dateLabel.text = activityModel.createTime;
    self.adressLabel.text = [NSString stringWithFormat:@"地点：%@", activityModel.ballName];
    self.describLabel.text = [NSString stringWithFormat:@"已报名人数：%zd", activityModel.sumCount] ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
