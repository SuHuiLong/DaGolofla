//
//  JGLPlayerNameTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPlayerNameTableViewCell.h"

@implementation JGLPlayerNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelTitle.text = @"打球人：";
        _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self addSubview:_labelTitle];
        
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(63*ScreenWidth/375, 40*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelName.text = @"闻醉山清风";
        _labelName.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self addSubview:_labelName];
        
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-110*ScreenWidth/375, 35*ScreenWidth/375, 25*ScreenWidth/375, 25*ScreenWidth/375)];
        _iconImgv.backgroundColor = [UIColor redColor];
        [self addSubview:_iconImgv];
        
        _labelTee = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-100*ScreenWidth/375, 40*ScreenWidth/375, 50*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelTee.text = @"蓝T";
        _labelTee.textAlignment = NSTextAlignmentRight;
        _labelTee.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self addSubview:_labelTee];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
