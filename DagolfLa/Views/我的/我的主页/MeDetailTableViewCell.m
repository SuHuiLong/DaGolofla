//
//  MeDetailTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/4/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "MeDetailTableViewCell.h"

@implementation MeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 7*ScreenWidth/375, 28*ScreenWidth/375, 28*ScreenWidth/375)];
        [self addSubview:_iconImgv];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44*ScreenWidth/375, 7*ScreenWidth/375, 200*ScreenWidth/375, 30*ScreenWidth/375)];
        _titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
        [self addSubview:_titleLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
