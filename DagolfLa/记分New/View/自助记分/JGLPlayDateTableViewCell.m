//
//  JGLPlayDateTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPlayDateTableViewCell.h"

@implementation JGLPlayDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelTitle.text = @"打球日期";
        _labelTitle.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_labelTitle];
        
        
        _labelDate = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 120*ScreenWidth/375, 10*ScreenWidth/375, 110*ScreenWidth/375, 20*ScreenWidth/375)];
        _labelDate.textAlignment = NSTextAlignmentRight;
        _labelDate.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [self.contentView addSubview:_labelDate];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
