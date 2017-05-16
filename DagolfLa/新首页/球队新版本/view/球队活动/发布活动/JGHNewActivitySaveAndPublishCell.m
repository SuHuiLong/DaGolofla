//
//  JGHNewActivitySaveAndPublishCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivitySaveAndPublishCell.h"

@implementation JGHNewActivitySaveAndPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:BG_color];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth -20*ProportionAdapter, 45*ProportionAdapter)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _saceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2 -10*ProportionAdapter, 45*ProportionAdapter)];
        [_saceBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saceBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
        [_saceBtn setBackgroundColor:[UIColor colorWithHexString:@"#F39800"]];
        [_saceBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_saceBtn];
        
        _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2 -10*ProportionAdapter, 0, screenWidth/2 -10*ProportionAdapter, 45*ProportionAdapter)];
        [_publishBtn setTitle:@"提交" forState:UIControlStateNormal];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
        [_publishBtn setBackgroundColor:[UIColor colorWithHexString:@"#EB6100"]];
        [_publishBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_publishBtn];
        
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 6.0*ProportionAdapter;
    }
    return self;
}

- (void)saveBtn:(UIButton *)saveBtn{
    if ([self.delegate respondsToSelector:@selector(SaveBtnClick:)]) {
        [self.delegate SaveBtnClick:saveBtn];
    }
}

- (void)submitBtn:(UIButton *)submitBtn{
    if ([self.delegate respondsToSelector:@selector(SubmitBtnClick:)]) {
        [self.delegate SubmitBtnClick:submitBtn];
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
