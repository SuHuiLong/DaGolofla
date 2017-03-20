//
//  JGHNewActivityImageAndTitleCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityImageAndTitleCell.h"

@implementation JGHNewActivityImageAndTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10*ProportionAdapter, 22*ProportionAdapter, 22*ProportionAdapter)];
        [self addSubview:_iconImageView];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(40*ProportionAdapter, 10*ProportionAdapter, screenWidth -70*ProportionAdapter, 22*ProportionAdapter)];
        _titleLable.text = @"";
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        [self addSubview:_titleLable];
        
        _direImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -18*ProportionAdapter, 14 *ProportionAdapter, 8*ProportionAdapter, 14 *ProportionAdapter)];
        _direImageView.image = [UIImage imageNamed:@")"];
        [self addSubview:_direImageView];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*ProportionAdapter -0.5, screenWidth, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
    }
    
    return self;
}

- (void)configJGHNewActivityTextCellTitle:(NSString *)title andImageName:(NSString *)imageName{
    _iconImageView.image = [UIImage imageNamed:imageName];
    
    _titleLable.text = title;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
