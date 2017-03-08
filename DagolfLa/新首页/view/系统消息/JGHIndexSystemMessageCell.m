//
//  JGHIndexSystemMessageCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHIndexSystemMessageCell.h"

@implementation JGHIndexSystemMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _systemImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 25*ProportionAdapter, 30*ProportionAdapter, 30*ProportionAdapter)];
        [_systemImageBtn setImage:[UIImage imageNamed:@"home_icn_message"] forState:UIControlStateNormal];
        [self addSubview:_systemImageBtn];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(50*ProportionAdapter, 21*ProportionAdapter, 0.5, 35*ProportionAdapter)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(60 *ProportionAdapter, 18*ProportionAdapter, screenWidth -76*ProportionAdapter, 20*ProportionAdapter)];
        _titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _titleLable.textColor = [UIColor colorWithHexString:B31_Color];
        _titleLable.text = @"你就开始那地方看见你的开发机构贷款纠纷";
        [self addSubview:_titleLable];
        
        _directionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth -16*ProportionAdapter, 23*ProportionAdapter, 6*ProportionAdapter, 10*ProportionAdapter)];
        _directionImageView.image = [UIImage imageNamed:@")"];
        [self addSubview:_directionImageView];
        
        _detailLable = [[UILabel alloc]initWithFrame:CGRectMake(60*ProportionAdapter, 42*ProportionAdapter, screenWidth -60*ProportionAdapter, 15*ProportionAdapter)];
        _detailLable.textColor = [UIColor colorWithHexString:Ba0_Color];
        _detailLable.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _detailLable.text = @"福斯护肤 i 和 iu 风格和丢法国 i的风格你觉得法国 i 多功能的咖啡机股份";
        [self addSubview:_detailLable];
        
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
