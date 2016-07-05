//
//  JGLPresentAwardTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPresentAwardTableViewCell.h"

@implementation JGLPresentAwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 16*screenWidth/375, 32*screenWidth/375, 32*screenWidth/375)];
        _iconImgv.image = [UIImage imageNamed: @"jiangbei"];
        [self addSubview:_iconImgv];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44*screenWidth/375, 10*screenWidth/375, 250*screenWidth/375, 22*screenWidth/375)];
        _titleLabel.text = @"连双鸟奖";
        _titleLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
        [self addSubview:_titleLabel];
        
        _awardLabel = [[UILabel alloc]initWithFrame:CGRectMake(44*screenWidth/375, 32*screenWidth/375, 250*screenWidth/375, 22*screenWidth/375)];
        _awardLabel.text = @"奖品：纯银奖杯";
        _awardLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
        [self addSubview:_awardLabel];
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/375, 54*screenWidth/375, screenWidth - 20*screenWidth/375, 1*screenWidth/375)];
        _viewLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_viewLine];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 57*screenWidth/375, screenWidth - 60*screenWidth/375, 20*screenWidth/375)];
        _nameLabel.text = @"获奖人：";
        _nameLabel.font = [UIFont systemFontOfSize:16*screenWidth/375];
        [self addSubview:_nameLabel];
        
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.frame = CGRectMake(screenWidth - 50*screenWidth/375, 55*screenWidth/375, 40*screenWidth/375, 28*screenWidth/375);
        [_chooseBtn setTitle:@"选择获奖者" forState:UIControlStateNormal];
        [_chooseBtn setTintColor:[UIColor orangeColor]];
        [self addSubview:_chooseBtn];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
