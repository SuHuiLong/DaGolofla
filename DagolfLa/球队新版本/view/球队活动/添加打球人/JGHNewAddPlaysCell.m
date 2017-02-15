//
//  JGHNewAddPlaysCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewAddPlaysCell.h"

@implementation JGHNewAddPlaysCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _teamPalyerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/16*3 , 20*screenWidth/375, screenWidth/9, screenWidth/9)];
        _teamPalyerImageView.image = [UIImage imageNamed:@"palylianxil"];
        [self addSubview:_teamPalyerImageView];
        
        _teamPalyer = [[UILabel alloc]initWithFrame:CGRectMake(0, 65*screenWidth/375, screenWidth/2, 30*screenWidth/375)];
        _teamPalyer.text = @"添加队员";
        _teamPalyer.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _teamPalyer.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_teamPalyer];
        
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneBtn.frame = CGRectMake(0, 0, screenWidth/2, 100*screenWidth/375);
        [self addSubview:_oneBtn];
        
        [_oneBtn addTarget:self action:@selector(chooseTeamPalyerClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _palyerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 +screenWidth/16*3 , 20*screenWidth/375, screenWidth/9, screenWidth/9)];
        _palyerImageView.image = [UIImage imageNamed:@"palylianxiq"];
        [self addSubview:_palyerImageView];
        
        _palyer = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 65*screenWidth/375, screenWidth/2, 30*screenWidth/375)];
        _palyer.text = @"添加球友";
        _palyer.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _palyer.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_palyer];
        
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoBtn.frame = CGRectMake(screenWidth/2, 0, screenWidth/2, 100*screenWidth/375);
        [self addSubview:_twoBtn];
        
        [_twoBtn addTarget:self action:@selector(choosePalyerClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 -1, 25*ProportionAdapter, 1, 55*ProportionAdapter)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
    }
    return self;
}
#pragma mark -- 添加队员
- (void)chooseTeamPalyerClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectAddPlays:)]) {
        [self.delegate selectAddPlays:btn];
    }
}
#pragma mark -- 添加球友
- (void)choosePalyerClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectAddBallPlays:)]) {
        [self.delegate selectAddBallPlays:btn];
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
