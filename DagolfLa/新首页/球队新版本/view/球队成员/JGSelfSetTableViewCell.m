//
//  JGSelfSetTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGSelfSetTableViewCell.h"

@implementation JGSelfSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 150*screenWidth/375, 45*screenWidth/375)];
        _titleLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor lightGrayColor];

        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(170*screenWidth/375, 0, screenWidth-190*screenWidth/375, 45*screenWidth/375)];
        _detailLabel.textColor = [UIColor blackColor];
        [self addSubview:_detailLabel];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:14*screenWidth/375];
        
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
