//
//  JGLPlayerNumberTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPlayerNumberTableViewCell.h"

@implementation JGLPlayerNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, 115*screenWidth/375, 40*screenWidth/375)];
        _labelTitle.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_labelTitle];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(50*screenWidth/375, 0, 150*screenWidth/375, 40*screenWidth/375)];
        _labelName.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_labelName];
        
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 40*screenWidth/375, 10*screenWidth/375, 20*screenWidth/375, 20*screenWidth/375)];
        [_deleteBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)deleteBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didSelectDeleteBtn:)]) {
        [self.delegate didSelectDeleteBtn:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
