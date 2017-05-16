//
//  JGMemHalfTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMemHalfTableViewCell.h"

@implementation JGMemHalfTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
        _titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_titleLabel];
        
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(120*screenWidth/375, 0, 150*screenWidth/375, 45*screenWidth/375)];
        _detailLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
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
