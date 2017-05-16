//
//  JGHOptionCaddieOrPalyView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOptionCaddieOrPalyView.h"


@interface JGHOptionCaddieOrPalyView ()

@property (nonatomic, retain)UIImageView *bgImageView;

@property (nonatomic, retain)UIButton *palyerBtn;

@property (nonatomic, retain)UIButton *caddieBtn;

@end

@implementation JGHOptionCaddieOrPalyView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, self.frame.size.height)];
        _bgImageView.image = [UIImage imageNamed:@"caddiestart"];
        _bgImageView.userInteractionEnabled = YES;
        [self addSubview:_bgImageView];
        
        _palyerBtn = [[UIButton alloc]initWithFrame:CGRectMake(40*ProportionAdapter, self.frame.size.height -130*ProportionAdapter, (screenWidth -155*ProportionAdapter)/2, 55*ProportionAdapter)];
        _palyerBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
        [_palyerBtn setTitle:@"我是打球人" forState:UIControlStateNormal];
        [_palyerBtn setBackgroundImage:[UIImage imageNamed:@"caddiebg"] forState:UIControlStateNormal];
        [_palyerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10 *ProportionAdapter, 0)];
        [_palyerBtn addTarget:self action:@selector(palyerBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_palyerBtn];
        
        _caddieBtn = [[UIButton alloc]initWithFrame:CGRectMake(40*ProportionAdapter +_palyerBtn.frame.size.width +75*ProportionAdapter, self.frame.size.height -130*ProportionAdapter, (screenWidth -155*ProportionAdapter)/2, 55*ProportionAdapter)];
        _caddieBtn.titleLabel.font = [UIFont systemFontOfSize:18*ProportionAdapter];
        [_caddieBtn setTitle:@"我是球童" forState:UIControlStateNormal];
        [_caddieBtn setBackgroundImage:[UIImage imageNamed:@"caddiebg"] forState:UIControlStateNormal];
        [_caddieBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10 *ProportionAdapter, 0)];
        [_caddieBtn addTarget:self action:@selector(caddieBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_caddieBtn];
    }
    return self;
}

#pragma mark -- 我是打球人
- (void)palyerBtn:(UIButton *)palyerBtn{
    palyerBtn.userInteractionEnabled = NO;
    _blockSelectPalyer();
    palyerBtn.userInteractionEnabled = YES;
}

#pragma mark -- 我是打球人
- (void)caddieBtn:(UIButton *)caddieBtn{
    caddieBtn.userInteractionEnabled = NO;
    _blockSelectCaddie();
    caddieBtn.userInteractionEnabled = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
