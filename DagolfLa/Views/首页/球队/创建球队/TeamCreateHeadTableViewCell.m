//
//  TeamCreateHeadTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/22.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamCreateHeadTableViewCell.h"

@implementation TeamCreateHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 26*ScreenWidth/375, 160*ScreenWidth/375, 21*ScreenWidth/375)];
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_titleLabel];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-85*ScreenWidth/375, 6*ScreenWidth/375, 60*ScreenWidth/375, 60*ScreenWidth/375)];
        _iconImage.image = [UIImage imageNamed:@"logo"];
        [self.contentView addSubview:_iconImage];
        
        UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20*ScreenWidth/375, 29*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        imgv.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:imgv];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
