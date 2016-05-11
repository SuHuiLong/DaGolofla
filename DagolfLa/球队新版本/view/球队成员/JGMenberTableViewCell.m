//
//  JGMenberTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMenberTableViewCell.h"

@implementation JGMenberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*screenWidth/375, 5*screenWidth/375, 40*screenWidth/375, 40*screenWidth/375)];
        [self addSubview:_iconImgv];
        [_iconImgv setImage:[UIImage imageNamed:@"tx3"]];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*screenWidth/375, 5*screenWidth/375, 200*screenWidth/375, 20*screenWidth/375)];
        _nameLabel.text = @"没什么特长就名字特长";
        _nameLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor blackColor];
        
        
        _sexImgv = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/375, 30*screenWidth/375, 12*screenWidth/375, 16*screenWidth/375)];
        [_sexImgv setImage: [UIImage imageNamed:@"xb_n"]];
        [self addSubview:_sexImgv];
        
        _almostLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*screenWidth/375, 30*screenWidth/375, 80*screenWidth/375, 20*screenWidth/375)];
        _almostLabel.textColor = [UIColor blackColor];
        _almostLabel.text = @"差点 39";
        [self addSubview:_almostLabel];
        _almostLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
        _poleLabel = [[UILabel alloc]initWithFrame:CGRectMake(170*screenWidth/375, 30*screenWidth/375, 130*screenWidth/375, 20*screenWidth/375)];
        _poleLabel.textColor = [UIColor blackColor];
        _poleLabel.text = @"平均杆数 102杆";
        [self addSubview:_poleLabel];
        _poleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
