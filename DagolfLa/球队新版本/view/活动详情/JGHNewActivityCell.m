//
//  JGHNewActivityCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityCell.h"

@implementation JGHNewActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 11 *ProportionAdapter, 44 *ProportionAdapter, 44 *ProportionAdapter)];
        [self addSubview:_headerImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(62 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 80*ProportionAdapter, 24 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_name];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 *ProportionAdapter -0.5, screenWidth, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
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
