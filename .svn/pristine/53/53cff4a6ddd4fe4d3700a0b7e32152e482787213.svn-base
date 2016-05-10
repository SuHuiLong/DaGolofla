//
//  TeamLogoHeadCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamLogoHeadCell.h"

@implementation TeamLogoHeadCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 9*ScreenWidth/375, 67*ScreenWidth/375, 67*ScreenWidth/375)];
        [self.contentView addSubview:_iconImage];
        _iconImage.image = [UIImage imageNamed:@"logo"];
        
        
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 35*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:_jtImage];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*ScreenWidth/375, 31*ScreenWidth/375, 245*ScreenWidth/375, 21*ScreenWidth/375)];
        _detailLabel.text = @"修改球队的logo";
        _detailLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
//        _detailLabel.textColor =
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
