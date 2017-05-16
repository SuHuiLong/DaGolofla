//
//  JGHActivityAllCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHActivityAllCell.h"

@implementation JGHActivityAllCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 11 *ProportionAdapter, 22 *ProportionAdapter, 22 *ProportionAdapter)];
        [self addSubview:_headerImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 50*ProportionAdapter, 24 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_name];
        
        _clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44*ProportionAdapter)];
        [_clickBtn addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickBtn];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, screenWidth, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didSelectBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(newdidselectActivityClick:)]) {
        [self.delegate newdidselectActivityClick:btn];
    }
}

- (void)configImageName:(NSString *)imageName withName:(NSString *)name{
    _headerImageView.image = [UIImage imageNamed:imageName];
    
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
