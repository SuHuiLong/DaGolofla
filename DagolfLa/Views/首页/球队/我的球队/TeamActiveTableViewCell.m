//
//  TeamActiveTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamActiveTableViewCell.h"

#import "Helper.h"
#import "UIImageView+WebCache.h"


@implementation TeamActiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 15*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
        _iconImage.image = [UIImage imageNamed:@"tu1"];
        _iconImage.layer.cornerRadius = 8*ScreenWidth/375;
        _iconImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*ScreenWidth/375, 15*ScreenWidth/375, 250*ScreenWidth/375, 20*ScreenWidth/375)];
        _titleLabel.text = @"活动名称:皇家第一高尔夫";
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_titleLabel];
        
        _createTime = [[UILabel alloc]initWithFrame:CGRectMake(238*ScreenWidth/375, 0, 129*ScreenWidth/375, 20)];
        _createTime.text = @"12小时之前";
        _createTime.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
        _createTime.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_createTime];
        _createTime.textAlignment = NSTextAlignmentRight;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*ScreenWidth/375, 40*ScreenWidth/375, 250*ScreenWidth/375, 20*ScreenWidth/375)];
        _nameLabel.text = @"发起人:闻醉山清风";
        _nameLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_nameLabel];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*ScreenWidth/375, 60*ScreenWidth/375, 190*ScreenWidth/375, 20*ScreenWidth/375)];
        _timeLabel.text = @"时间:2014-12-12";
        _timeLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
        
        _areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*ScreenWidth/375, 80*ScreenWidth/375, 190*ScreenWidth/375, 20*ScreenWidth/375)];
        _areaLabel.text = @"地址:上海佘山高尔夫球场";
        _areaLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _areaLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
        
        //300 68 67 20
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(300*ScreenWidth/375, 68*ScreenWidth/375, 67*ScreenWidth/375, 20*ScreenWidth/375)];
        _stateLabel.text = @"正在进行";
        _stateLabel.textColor = [UIColor orangeColor];
        _stateLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_stateLabel];
        
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 42*ScreenWidth/375, 12*ScreenWidth/375, 15*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"jt_left"];
        [self.contentView addSubview:_jtImage];
        
        
    }
    return self;
}
-(void)showData:(TeamActiveModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.userPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    _titleLabel.text = [NSString stringWithFormat:@"活动名称:%@",model.teamActivityTitle];
    _createTime.text = model.elapseDate;
    _nameLabel.text = [NSString stringWithFormat:@"发起人:%@",model.userName];
    _timeLabel.text = [NSString stringWithFormat:@"时间:%@",model.startTime];
    _areaLabel.text = [NSString stringWithFormat:@"地址:%@",model.ballName];
    if ([model.isendTime integerValue] == 1) {
        _stateLabel.text = @"正在进行";
        _stateLabel.textColor = [UIColor redColor];
    }
    else if ([model.isendTime integerValue] == 2)
    {
        _stateLabel.text = @"未开始";
        _stateLabel.textColor = [UIColor orangeColor];
    }
    else
    {
        _stateLabel.text = @"已结束";
        _stateLabel.textColor = [UIColor lightGrayColor];
    }
//
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
