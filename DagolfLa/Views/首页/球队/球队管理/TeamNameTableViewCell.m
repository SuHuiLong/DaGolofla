//
//  TeamNameTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamNameTableViewCell.h"

@implementation TeamNameTableViewCell

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
        
        _textF = [[UITextField alloc]initWithFrame:CGRectMake(206*ScreenWidth/375, 14*ScreenWidth/375, 144*ScreenWidth/375, 21*ScreenWidth/375)];
        _textF.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _textF.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_textF];
        _textF.placeholder = @"请输入球队名";
        _textF.textAlignment = NSTextAlignmentRight;

        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
