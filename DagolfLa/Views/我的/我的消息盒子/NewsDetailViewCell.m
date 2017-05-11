//
//  NewsDetailViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/30.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "NewsDetailViewCell.h"

@implementation NewsDetailViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showData:(NewsDetailModel *)model
{
    _timeLabel.text = model.createTime;
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.senderPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _titleLabel.text = model.content;
}

-(void)showPeople:(NewsDetailModel *)model
{
    _timeLabel.text = model.content;
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.senderPic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _titleLabel.text = model.uName;
}

@end
