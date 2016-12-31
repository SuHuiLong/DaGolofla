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
        _teamBtn = [[UIButton alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 15 *ProportionAdapter, 46 *ProportionAdapter, 30 *ProportionAdapter)];
        [_teamBtn setImage:[UIImage imageNamed:@"kaiju"] forState:UIControlStateNormal];
        [_teamBtn addTarget:self action:@selector(scoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_teamBtn];
        
        _teamLable = [[UILabel alloc]initWithFrame:CGRectMake(6*ProportionAdapter, 52 *ProportionAdapter, self.frame.size.width/3 -10 *ProportionAdapter, 20 *ProportionAdapter)];
        _teamLable.text = @"开局记分";
        _teamLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _teamLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_teamLable];
        
        UIButton *teamBtn = [[UIButton alloc] initWithFrame:CGRectMake(12 * ProportionAdapter, 15 * ProportionAdapter, self.frame.size.width/3 -10 *ProportionAdapter, 70 * ProportionAdapter)];
        [teamBtn addTarget:self action:@selector(scoreBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:teamBtn];
        
        UILabel *oneLine = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 15 * ProportionAdapter, 0.5, 60 * ProportionAdapter)];
        oneLine.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:oneLine];
        
        _scoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(165 *ProportionAdapter, 15 *ProportionAdapter, 46 *ProportionAdapter, 30*ProportionAdapter)];
        [_scoreBtn setImage:[UIImage imageNamed:@"team"] forState:UIControlStateNormal];
        [_scoreBtn addTarget:self action:@selector(teamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scoreBtn];
        
        _scoreLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3 +10 *ProportionAdapter, 52 *ProportionAdapter, self.frame.size.width/3 -20*ProportionAdapter, 20*ProportionAdapter)];
        _scoreLable.text = @"球队部落";
        _scoreLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _scoreLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_scoreLable];
        
        UIButton *scoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3 +10 *ProportionAdapter, 15 * ProportionAdapter, self.frame.size.width/3 -20*ProportionAdapter, 70 * ProportionAdapter)];
        [scoreBtn addTarget:self action:@selector(teamBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:scoreBtn];
        
        UILabel *twoLine = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3*2, 15 * ProportionAdapter, 0.5, 60 * ProportionAdapter)];
        twoLine.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:twoLine];
        
        _resultsBtn = [[UIButton alloc]initWithFrame:CGRectMake(290 *ProportionAdapter, 15 *ProportionAdapter, 46 *ProportionAdapter, 30 *ProportionAdapter)];
        [_resultsBtn setImage:[UIImage imageNamed:@"home_icon_booking"] forState:UIControlStateNormal];
        [_resultsBtn addTarget:self action:@selector(resultsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resultsBtn];
        
        _resultsLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3*2 +10*ProportionAdapter, 52 *ProportionAdapter, self.frame.size.width/3 -20*ProportionAdapter, 20 *ProportionAdapter)];
        _resultsLable.text = @"球场预订";
        _resultsLable.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _resultsLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_resultsLable];
        
        UIButton *resultBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3*2, 15 * ProportionAdapter, self.frame.size.width/3 -20*ProportionAdapter, 70 * ProportionAdapter)];
        [resultBtn addTarget:self action:@selector(resultsBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:resultBtn];
        
        UILabel *nakaLable = [[UILabel alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 93 * ProportionAdapter, screenWidth -30*ProportionAdapter, 0.5 *ProportionAdapter)];
        nakaLable.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self addSubview:nakaLable];
        
        NSArray *iconArray = [NSArray arrayWithObjects:@"home_serve", @"home_restore", @"home_icon_package", @"home_icon_score",   nil];
        NSArray *titleArray = [NSArray arrayWithObjects:@"服务定制", @"用品商城", @"高旅套餐", @"历史成绩",   nil];

        for (int i = 0; i < 4; i ++) {
            
            UIButton *shitaBtn = [[UIButton alloc] initWithFrame:CGRectMake(44 * ProportionAdapter * (i + 1) + 39 * ProportionAdapter * i , 111 * ProportionAdapter, 39 * ProportionAdapter, 39 * ProportionAdapter)];
            [shitaBtn setImage:[UIImage imageNamed:iconArray[i]] forState:(UIControlStateNormal)];;
            
            UILabel *shitaLB;
            if (i == 0) {
                shitaLB = [[UILabel alloc] initWithFrame:CGRectMake(33 * ProportionAdapter , 156 * ProportionAdapter, 65 * ProportionAdapter, 20 * ProportionAdapter)];
            }else{
                shitaLB = [[UILabel alloc] initWithFrame:CGRectMake((18 + 65) * ProportionAdapter * i + 33 * ProportionAdapter , 156 * ProportionAdapter, 65 * ProportionAdapter, 20 * ProportionAdapter)];
            }

            shitaLB.text  = titleArray[i];
            shitaLB.textColor = [UIColor colorWithHexString:@"#313131"];
            shitaLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
            
            shitaBtn.tag = 700 + i;
            [shitaBtn addTarget:self action:@selector(shitaAct:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self addSubview:shitaLB];
            [self addSubview:shitaBtn];
            
        }
        
        
        UILabel *segLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 204*ProportionAdapter -10*ProportionAdapter, self.frame.size.width, 10 *ProportionAdapter)];
        segLable.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:segLable];
        
    
        
    }
    return self;
}

- (void)shitaAct:(UIButton *)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(didSelectShitaBtn:)]) {
        [self.delegate didSelectShitaBtn:btn];
    }
    
    btn.enabled = YES;

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
