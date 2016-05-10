//
//  ScoreSimpleTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/12/3.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ScoreSimpleTableViewCell.h"

@implementation ScoreSimpleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 0*ScreenWidth/375, 100*ScreenWidth/375, 44*ScreenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_labelTitle];
        
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(130*ScreenWidth/375, 0, ScreenWidth-146*ScreenWidth/375, 44*ScreenWidth/375)];
        _labelDetail.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_labelDetail];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
