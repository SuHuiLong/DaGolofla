//
//  JGHbalanceView.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHbalanceView.h"

@implementation JGHbalanceView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1.0;
        self.delebtn = [[UIButton alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 15*ProportionAdapter, 16*ProportionAdapter, 16*ProportionAdapter)];
        [self.delebtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self.delebtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.delebtn];
        
        UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 0, self.frame.size.width -80*ProportionAdapter, 44 *ProportionAdapter)];
        proLable.text = @"请输入支付密码";
        proLable.textAlignment = NSTextAlignmentCenter;
        proLable.font = [UIFont systemFontOfSize:19 *ProportionAdapter];
        [self addSubview:proLable];
        
        UILabel *onleLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 44*ProportionAdapter, self.frame.size.width, 1)];
        onleLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
        [self addSubview:onleLine];
        
        UILabel *dagolfla = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 *ProportionAdapter, self.frame.size.width, 18 *ProportionAdapter)];
        dagolfla.textAlignment = NSTextAlignmentCenter;
        dagolfla.text = @"打高尔夫啦";
        dagolfla.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:dagolfla];
        
        self.price = [[UILabel alloc]initWithFrame:CGRectMake(0, 105 *ProportionAdapter, self.frame.size.width, 35 *ProportionAdapter)];
        self.price.textAlignment = NSTextAlignmentCenter;
        self.price.text = @"¥100";
        self.price.font = [UIFont systemFontOfSize:35 *ProportionAdapter];
        [self addSubview:self.price];
        
        UILabel *twoLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 158*ProportionAdapter, self.frame.size.width, 1)];
        twoLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
        [self addSubview:twoLine];
        
        UIImageView *blankImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 169 *ProportionAdapter, 32 *ProportionAdapter, 32*ProportionAdapter)];
        blankImageView.image = [UIImage imageNamed:@""];
        [self addSubview:blankImageView];
        
        self.balance = [[UILabel alloc]initWithFrame:CGRectMake(57 *ProportionAdapter, 169 *ProportionAdapter, self.frame.size.width -72*ProportionAdapter, 32*ProportionAdapter)];
        self.balance.text = @"余额199";
        self.balance.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.balance];
        
        UILabel *threeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 209 *ProportionAdapter, self.frame.size.width, 1)];
        threeLine.backgroundColor = [UIColor colorWithHexString:Line_Color];
        [self addSubview:threeLine];
        
    }
    return self;
}

- (void)deleteBtn:(UIButton *)btn{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
