//
//  JGHNewCancelAppListCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewCancelAppListCell.h"

@implementation JGHNewCancelAppListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(77*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 35*ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_name];
        
        _chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -30*ProportionAdapter, 0, 20*ProportionAdapter, 35*ProportionAdapter)];
        [_chooseBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chooseBtn];
    }
    return self;
}

- (void)chooseBtn:(UIButton *)choose{
    if ([self.delegate respondsToSelector:@selector(chooseCancelApplyClick:)]) {
        [self.delegate chooseCancelApplyClick:choose];
    }
}


- (void)configCancelApplyDict:(NSMutableDictionary *)dict{
    //名字
    
    if ([dict objectForKey:@"name"]) {
        self.name.text = [dict objectForKey:@"name"];
    }

    if ([[dict objectForKey:@"select"]isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
    }else{
        [self.chooseBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
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
