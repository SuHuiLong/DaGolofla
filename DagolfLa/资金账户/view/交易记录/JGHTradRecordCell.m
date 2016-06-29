//
//  JGHTradRecordCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTradRecordCell.h"

@implementation JGHTradRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, 32*ProportionAdapter, 32*ProportionAdapter)];
        [self addSubview:_iconImageView];
        
        _bankName = [[UILabel alloc]initWithFrame:CGRectMake(52 *ProportionAdapter, _iconImageView.frame.origin.y, screenWidth - _iconImageView.frame.size.width*ProportionAdapter - 30*ProportionAdapter, 17 *ProportionAdapter)];
        [self addSubview:_bankName];
        
        _tradTime = [[UILabel alloc]initWithFrame:CGRectMake(52 *ProportionAdapter, 27 *ProportionAdapter, _bankName.frame.size.width, 15 *ProportionAdapter)];
        [self addSubview:_tradTime];
    }
    return self;
}

- (void)configModel{
    _bankName.text = @"中国工商银行";
    
    _tradTime.text = @"2016-06-30";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
