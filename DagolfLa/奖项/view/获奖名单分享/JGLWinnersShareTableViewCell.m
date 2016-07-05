//
//  JGLWinnersShareTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLWinnersShareTableViewCell.h"

@implementation JGLWinnersShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 10*screenWidth/375, 24*screenWidth/375, 24*screenWidth/375)];
        _iconImgv.image = [UIImage imageNamed: @"jiangbei"];
        [self addSubview:_iconImgv];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44*screenWidth/375, 10*screenWidth/375, 250*screenWidth/375, 24*screenWidth/375)];
        _titleLabel.text = @"连双鸟奖";
        _titleLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
        [self addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(44*screenWidth/375, 44*screenWidth/375, screenWidth - 54*screenWidth/375, 20*screenWidth/375)];
        _nameLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        [self addSubview:_nameLabel];
        _nameLabel.numberOfLines = 0;
        _nameLabel.text = @"获奖人：奥查呀/奥查亚/查得-坎贝尔/宫里圣志/杰欧夫-奥格威/古斯塔娜";
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
