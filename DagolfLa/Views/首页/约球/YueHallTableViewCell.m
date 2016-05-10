//
//  YueHallTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueHallTableViewCell.h"
#import "ViewController.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "Helper.h"

#import "PostDataRequest.h"

@implementation YueHallTableViewCell

- (void)awakeFromNib {

    
    _timeLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    _distanceLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    
    _viewLine.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];

    
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)showYueData:(YueHallModel *)model
{
    if (![Helper isBlankString:model.ballPic]) {
        [_parkImage sd_setImageWithURL:[Helper imageIconUrl:model.ballPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    }
    if (![Helper isBlankString:model.ballName]) {
        _clupLabel.text = [NSString stringWithFormat:@"%@",model.ballName];
    }
    else
    {
        _clupLabel.text = [NSString stringWithFormat:@"暂无球场"];
    }
    if (![Helper isBlankString:model.address]) {
        _areaLabel.text = [NSString stringWithFormat:@"地区:%@",model.address];
    }
    else
    {
        _areaLabel.text = [NSString stringWithFormat:@"地区:暂无地区"];
    }
    if (![Helper isBlankString:model.playTimes]) {
        _timeLabel.text = [NSString stringWithFormat:@"时间:%@",model.playTimes];
    }
    else
    {
        _timeLabel.text = [NSString stringWithFormat:@"时间:暂无时间"];
    }

    if (model.distance != nil) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里",[model.distance floatValue]];
    }
    else
    {
        _distanceLabel.text = [NSString stringWithFormat:@"暂无距离"];
    }

}


@end
