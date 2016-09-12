//
//  JGLChooseBallTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLChooseBallTableViewCell.h"

@implementation JGLChooseBallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 15*ScreenWidth/375, 30*ScreenWidth/375, 30*ScreenWidth/375)];
        _iconImg.image = [UIImage imageNamed:IconLogo];
        [self.contentView addSubview:_iconImg];
        
        
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(60*ScreenWidth/375, 10*ScreenWidth/375, 250*ScreenWidth/375, 40*ScreenWidth/375)];
        _labelTitle.text = @"请选择球场";
        _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_labelTitle];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
