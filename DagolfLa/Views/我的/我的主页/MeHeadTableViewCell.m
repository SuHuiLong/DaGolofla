//
//  MeHeadTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/4/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "MeHeadTableViewCell.h"

@implementation MeHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
        _iconImgv.layer.cornerRadius = 8*ScreenWidth/375;
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.image = [UIImage imageNamed:@"moren"];
        [self addSubview:_iconImgv];
        
        _imgvSex = [[UIImageView alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 24*ScreenWidth/375, 13*ScreenWidth/375, 13*ScreenWidth/375)];
        _imgvSex.image = [UIImage imageNamed:@"xb_nn"];
        [self addSubview:_imgvSex];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(108*ScreenWidth/375, 15*ScreenWidth/375, 200*ScreenWidth/375, 30*ScreenWidth/375)];
        _nameLabel.text = @"你是对方水电费地方大幅度发放到大幅度发大幅度发";
        _nameLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*ScreenWidth/375, 45*ScreenWidth/375, 250*ScreenWidth/375, 40*ScreenWidth/375)];
        _detailLabel.text = @"sdfsdfsdfsdfsdfsd徐晓晨徐晓晨V徐晓晨V说的我方式发送方式是对方的说法是访问 ";
        _detailLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.numberOfLines = 2;
        [self addSubview:_detailLabel];
        
//        _imgvJt = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20*ScreenWidth/375, 35*ScreenWidth/375, 13*ScreenWidth/375, 21*ScreenWidth/375)];
//        _imgvJt.image = [UIImage imageNamed:@"left_jt"];
//        [self addSubview:_imgvJt];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
