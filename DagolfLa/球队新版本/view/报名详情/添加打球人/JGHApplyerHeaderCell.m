//
//  JGHApplyerHeaderCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHApplyerHeaderCell.h"

@implementation JGHApplyerHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 8*ProportionAdapter, 220*ProportionAdapter, 25 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        [self addSubview:_name];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, self.frame.size.height -1, screenWidth -20 *ProportionAdapter, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configHeaderName:(NSString *)name{
    _name.text = name;
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
