

//
//  ManageCreateLogoTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/30.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ManageCreateLogoTableViewCell.h"

@implementation ManageCreateLogoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 19*ScreenWidth/375, 120*ScreenWidth/375, 21*ScreenWidth/375)];
        _titleLabel.text = @"赛事标志";
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(297*ScreenWidth/375, 5*ScreenWidth/375, 50*ScreenWidth/375, 50*ScreenWidth/375)];
        _iconImage.image = [UIImage imageNamed:@"logo"];
        [self.contentView addSubview:_iconImage];
        
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 22*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:_jtImage];
        
        _view = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 1*ScreenWidth/375)];
        [self.contentView addSubview:_view];
        _view.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
