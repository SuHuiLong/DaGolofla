//
//  JGHNewAreaListCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewAreaListCell.h"

@implementation JGHNewAreaListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _tilte = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth -170*ProportionAdapter)/2, 1, 170*ProportionAdapter, 40*ProportionAdapter -2)];
        _tilte.textAlignment = NSTextAlignmentCenter;
        _tilte.font = [UIFont systemFontOfSize:13*ProportionAdapter];
        _tilte.textColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_tilte];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth -170*ProportionAdapter)/2, 40*ProportionAdapter -1, 170*ProportionAdapter, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:Ba0_Color];
        [self addSubview:_line];
    }
    return self;
}

- (void)configJGHNewAreaListCell:(NSString *)are{
    _tilte.text = are;
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
