//
//  MyFootOtherViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/10/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyFootOtherViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation MyFootOtherViewCell

- (void)awakeFromNib {
    // Initialization code
    _logoImage.layer.cornerRadius = _logoImage.frame.size.width/2;
    _logoImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showData:(MyfootModel*)model
{
    [_logoImage sd_setImageWithURL:[Helper imageUrl:model.pic] placeholderImage:[UIImage imageNamed:@"tx4"]];
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.createTime];
    _titleLabel.text = model.golfName;
}

@end
