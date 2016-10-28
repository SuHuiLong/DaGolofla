//
//  JGHNavListView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNavListView.h"

@implementation JGHNavListView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _teamBtn = [[UIButton alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 6 *ProportionAdapter, 48 *ProportionAdapter, 48 *ProportionAdapter)];
        [_teamBtn setImage:[UIImage imageNamed:@"team"] forState:UIControlStateNormal];
        [_teamBtn addTarget:self action:@selector(teamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_teamBtn];
        
        _teamLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 53 *ProportionAdapter, self.frame.size.width/3, 20 *ProportionAdapter)];
        _teamLable.text = @"球队部落";
        _teamLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _teamLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_teamLable];
        
        _scoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(162 *ProportionAdapter, 6 *ProportionAdapter, 48 *ProportionAdapter, 48*ProportionAdapter)];
        [_scoreBtn setImage:[UIImage imageNamed:@"kaiju"] forState:UIControlStateNormal];
        [_scoreBtn addTarget:self action:@selector(scoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scoreBtn];
        
        _scoreLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 53 *ProportionAdapter, self.frame.size.width/3, 20*ProportionAdapter)];
        _scoreLable.text = @"开局记分";
        _scoreLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _scoreLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_scoreLable];
        
        _resultsBtn = [[UIButton alloc]initWithFrame:CGRectMake(284 *ProportionAdapter, 6 *ProportionAdapter, 48 *ProportionAdapter, 48 *ProportionAdapter)];
        [_resultsBtn setImage:[UIImage imageNamed:@"chengji-"] forState:UIControlStateNormal];
        [_resultsBtn addTarget:self action:@selector(resultsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resultsBtn];
        
        _resultsLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3*2, 53 *ProportionAdapter, self.frame.size.width/3, 20 *ProportionAdapter)];
        _resultsLable.text = @"历史成绩";
        _resultsLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _resultsLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_resultsLable];
        
        UILabel *segLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 95*ProportionAdapter -10*ProportionAdapter, self.frame.size.width, 10 *ProportionAdapter)];
        segLable.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:segLable];
    }
    return self;
}

- (void)teamBtnClick:(UIButton *)btn{
    btn.enabled = NO;
    
    
    if ([self.delegate respondsToSelector:@selector(didSelectMyTeamBtn:)]) {
        [self.delegate didSelectMyTeamBtn:btn];
    }
    
    btn.enabled = YES;
}

- (void)scoreBtnClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(didSelectStartScoreBtn:)]) {
        [self.delegate didSelectStartScoreBtn:btn];
    }
    
    btn.enabled = YES;
}

- (void)resultsBtnClick:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(didSelectHistoryResultsBtn:)]) {
        [self.delegate didSelectHistoryResultsBtn:btn];
    }
    
    btn.enabled = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
