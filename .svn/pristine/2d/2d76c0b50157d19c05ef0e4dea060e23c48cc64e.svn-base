//
//  MineTeamActiveCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MineTeamActiveCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation MineTeamActiveCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showData:(TeamActiveModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.treamPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _titleLabel.text = [NSString stringWithFormat:@"活动名称:%@",model.teamActivityTitle];
    _nameLabel.text = [NSString stringWithFormat:@"发起人:%@",model.userName];
    _timeLabel.text = [NSString stringWithFormat:@"时间:%@",model.startTime];
    _areaLabel.text = [NSString stringWithFormat:@"地址:%@",model.ballName];
    if ([model.forrelevant integerValue] == 1) {
        _stateLabel.text = @"我创建的";
        _stateLabel.textColor = [UIColor redColor];
    }
    else
    {
        _stateLabel.text = @"我参与的";
        _stateLabel.textColor = [UIColor orangeColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
