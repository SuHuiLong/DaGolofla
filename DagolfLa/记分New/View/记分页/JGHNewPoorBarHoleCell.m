//
//  JGHNewPoorBarHoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewPoorBarHoleCell.h"

@implementation JGHNewPoorBarHoleCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*ProportionAdapter, self.frame.size.height)];
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _nameLable.textColor = [UIColor colorWithHexString:B31_Color];
        [self addSubview:_nameLable];
        
        _arebtn = [[UIButton alloc]initWithFrame:CGRectMake(_nameLable.frame.origin.x, _nameLable.frame.origin.y, 20*ProportionAdapter, 30*ProportionAdapter)];
        [_arebtn setImage:[UIImage imageNamed:@"icn_show_arrowup"] forState:UIControlStateNormal];
        [self addSubview:_arebtn];
        
        _poorBtn = [[UIButton alloc]initWithFrame:CGRectMake(_nameLable.frame.origin.x, _nameLable.frame.origin.y, _nameLable.frame.size.width +20*ProportionAdapter, 30*ProportionAdapter)];
        [_poorBtn addTarget:self action:@selector(selectAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_poorBtn];
    }
    return self;
}

- (void)selectAreaBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectNewPoorAreaBtnClick: andCurrtitle:)]) {
        [self.delegate selectNewPoorAreaBtnClick:btn andCurrtitle:_nameLable.text];
    }
}

- (void)configJGHNewPoorBarHoleCell:(NSString *)boor{
    _nameLable.text = boor;
    
    float titlesWSize;
    titlesWSize = [Helper textWidthFromTextString:boor height:_nameLable.frame.size.height fontSize:14 *ProportionAdapter];
    
    _nameLable.frame = CGRectMake((screenWidth -20*ProportionAdapter-titlesWSize -15*ProportionAdapter)/2, 0, titlesWSize, 30*ProportionAdapter);
    
    _arebtn.frame = CGRectMake(_nameLable.frame.origin.x +_nameLable.frame.size.width +5*ProportionAdapter, 0, 20*ProportionAdapter, 30*ProportionAdapter);
    
    _poorBtn.frame = CGRectMake(_nameLable.frame.origin.x, 0, titlesWSize +_arebtn.frame.size.width, 30*ProportionAdapter);
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
