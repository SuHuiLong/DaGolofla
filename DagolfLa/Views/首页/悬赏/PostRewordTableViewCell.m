//
//  PostRewordTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "PostRewordTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation PostRewordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showData:(RewordModel *)model
{
    [_titleImage sd_setImageWithURL:[Helper imageIconUrl:model.uPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _titleLabel.text = model.reTitle;
    _nameLabel.text = [NSString stringWithFormat:@"发布人:%@",model.userName];
    _timeLabel.text = model.playTimes;
    _priceLabel.text = [NSString stringWithFormat:@"%@",model.reMoney];
    _areaLabel.text = [NSString stringWithFormat:@"地区:%@",model.address];
    _watchNumber.text = [NSString stringWithFormat:@"浏览人数:%@",model.seeCount];
    _rewordNumber.text = [NSString stringWithFormat:@"应赏:%@",model.joinCount];
    _spaceLabel.text = [NSString stringWithFormat:@"应赏:%@",model.distance];
}

@end
