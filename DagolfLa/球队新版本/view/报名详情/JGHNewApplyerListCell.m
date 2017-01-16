//
//  JGHNewApplyerListCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewApplyerListCell.h"

@implementation JGHNewApplyerListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 5*ProportionAdapter, 220*ProportionAdapter, 25 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_name];
        
        _deleteApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -35*ProportionAdapter, 5 *ProportionAdapter, 25 *ProportionAdapter, 25*ProportionAdapter)];
        [_deleteApplyBtn setImage:[UIImage imageNamed:@"deleteplay"] forState:UIControlStateNormal];
        [_deleteApplyBtn addTarget:self action:@selector(selectDeleteApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteApplyBtn];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)selectDeleteApplyBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectApplyDeleteBtn:)]) {
        [self.delegate selectApplyDeleteBtn:btn];
    }
}

- (void)configDict:(NSDictionary *)dict{
    //名字
    if ([dict objectForKey:@"name"]) {
        self.name.text = [dict objectForKey:@"name"];
    }else{
        self.name.text = @"";
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
