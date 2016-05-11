//
//  JGMemTitleTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMemTitleTableViewCell.h"

@implementation JGMemTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
        _titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_titleLabel];
        
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(120*screenWidth/375, 0, screenWidth - 160*screenWidth/375, 45*screenWidth/375)];
        _detailLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _detailLabel.textColor = [UIColor blackColor];
        [self addSubview:_detailLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
