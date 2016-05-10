//
//  TeamIntroduceViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamIntroduceViewCell.h"

@implementation TeamIntroduceViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 14*ScreenWidth/375, 135*ScreenWidth/375, 21*ScreenWidth/375)];
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.text = @"标题";
        
        _detroLabel = [[UILabel alloc]initWithFrame:CGRectMake(206*ScreenWidth/375, 14*ScreenWidth/375, 144*ScreenWidth/375, 21*ScreenWidth/375)];
        _detroLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _detroLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detroLabel];
        _detroLabel.text = @"介绍";
        _detroLabel.textAlignment = NSTextAlignmentRight;
        
        
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 17*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:_jtImage];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
