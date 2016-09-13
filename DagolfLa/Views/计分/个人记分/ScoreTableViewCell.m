//
//  ScoreTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/3.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 12*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_labelTitle];
        
        _imgvState = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 50*ScreenWidth/375, 15*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
        [self addSubview:_imgvState];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
