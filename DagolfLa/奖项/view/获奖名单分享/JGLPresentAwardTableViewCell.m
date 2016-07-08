//
//  JGLPresentAwardTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPresentAwardTableViewCell.h"
#import "JGHAwardModel.h"

@implementation JGLPresentAwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/320, 14*screenWidth/320, 32*screenWidth/320, 32*screenWidth/320)];
        _iconImgv.image = [UIImage imageNamed:@"jbyuan"];
        [self addSubview:_iconImgv];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50*screenWidth/320, 9*screenWidth/320, 250*screenWidth/320, 20*screenWidth/320)];
        _titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_titleLabel];
        
        _awardLabel = [[UILabel alloc]initWithFrame:CGRectMake(50*screenWidth/320, 31*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
        _awardLabel.text = @"奖品：纯银奖杯";
        _awardLabel.font = [UIFont systemFontOfSize:14*screenWidth/320];
        [self addSubview:_awardLabel];
        
        
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(210*screenWidth/320, 31*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
        _countLabel.font = [UIFont systemFontOfSize:14*screenWidth/320];
        _countLabel.textColor = [UIColor lightGrayColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_countLabel];
        
        
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(10*screenWidth/320, 60*screenWidth/320, screenWidth - 20*screenWidth/320, 1*screenWidth/375)];
        _viewLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_viewLine];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 60*screenWidth/320, screenWidth - 60*screenWidth/320, 45*screenWidth/320)];
        _nameLabel.text = @"获奖人：";
        _nameLabel.font = [UIFont systemFontOfSize:15*screenWidth/320];
        [self addSubview:_nameLabel];
        
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.frame = CGRectMake(screenWidth - 80*screenWidth/320, 65*screenWidth/320, 70*screenWidth/320, 35*screenWidth/320);
        [_chooseBtn setTitle:@"选择获奖者" forState:UIControlStateNormal];
        _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0*screenWidth/320];
        [_chooseBtn setTintColor:[UIColor orangeColor]];
        [_chooseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_chooseBtn];
    }
    return self;
}

- (void)configJGHAwardModel:(JGHAwardModel *)model{
    _titleLabel.text = model.name;
    _countLabel.text = [NSString stringWithFormat:@"奖品数量：%@",model.prizeSize];
    _awardLabel.text = [NSString stringWithFormat:@"奖品：%@", model.prizeName];
    
    if (model.userInfo) {
        _nameLabel.text = [NSString stringWithFormat:@"获奖人：%@", model.userInfo];
    }else{
         _nameLabel.text = @"获奖人：";
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
