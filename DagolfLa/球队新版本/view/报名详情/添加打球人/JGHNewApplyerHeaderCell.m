//
//  JGHNewApplyerHeaderCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewApplyerHeaderCell.h"

@implementation JGHNewApplyerHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 8*ProportionAdapter, 220*ProportionAdapter, 25 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _name.text = @"基本信息";
        [self addSubview:_name];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, self.frame.size.height -1, screenWidth -20 *ProportionAdapter, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
        
        _contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -60 *ProportionAdapter, 2*ProportionAdapter, 40*ProportionAdapter, 40*ProportionAdapter)];
        [_contactBtn setImage:[UIImage imageNamed:@"btn_add_contact"] forState:UIControlStateNormal];
        [_contactBtn addTarget:self action:@selector(contactBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_contactBtn];
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)contactBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectAddContactPlays:)]) {
        [self.delegate selectAddContactPlays:btn];
    }
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
