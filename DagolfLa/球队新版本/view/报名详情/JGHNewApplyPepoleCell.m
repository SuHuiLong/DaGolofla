//
//  JGHNewApplyPepoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewApplyPepoleCell.h"

@implementation JGHNewApplyPepoleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 11 *ProportionAdapter, 22 *ProportionAdapter, 22 *ProportionAdapter)];
        _headerImageView.image = [UIImage imageNamed:@"icn_event_group"];
        [self addSubview:_headerImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 10 *ProportionAdapter, 120, 24 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _name.text = @"报名人";
        [self addSubview:_name];
        
        _addApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -100*ProportionAdapter, 8*ProportionAdapter, 90*ProportionAdapter, 25 *ProportionAdapter)];
        _addApplyBtn.layer.masksToBounds = YES;
        _addApplyBtn.layer.cornerRadius = 3.0 *ProportionAdapter;
        [_addApplyBtn setTitleColor:[UIColor colorWithHexString:Bar_Segment] forState:UIControlStateNormal];
        _addApplyBtn.layer.borderWidth = 1;
        _addApplyBtn.layer.borderColor = [UIColor colorWithHexString:Bar_Segment].CGColor;
        [_addApplyBtn setTitle:@"添加打球人" forState:UIControlStateNormal];
        _addApplyBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [_addApplyBtn addTarget:self action:@selector(addApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addApplyBtn];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addApplyBtn:(UIButton *)addApplyBtn{
    if ([self.delegate respondsToSelector:@selector(addApplyerBtn:)]) {
        [self.delegate addApplyerBtn:addApplyBtn];
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
