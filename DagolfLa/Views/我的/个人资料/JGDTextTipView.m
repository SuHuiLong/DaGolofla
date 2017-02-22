//
//  JGDTextTipView.m
//  DagolfLa
//
//  Created by 東 on 17/2/21.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDTextTipView.h"

@implementation JGDTextTipView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 250 * ProportionAdapter, screenWidth, 195 * ProportionAdapter)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        self.titleLB = [Helper lableRect:CGRectMake(0, 25 * ProportionAdapter, screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:15 * ProportionAdapter text:@"差点" textAlignment:(NSTextAlignmentCenter)];
        [backView addSubview:self.titleLB];
        
        self.detailLB = [Helper lableRect:CGRectMake(18 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 36 * ProportionAdapter, 80 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:13 * ProportionAdapter text:@"现在的我一无所有，某种意义上来说，我也差一点加入那些傻子和英年死掉的行列，我拿着最后的一张底牌，对着手机，拍了拍衣服的灰尘，回想起一个个身影，开始记录一个个人间喜剧或是悲惨故事。" textAlignment:(NSTextAlignmentLeft)];
        self.detailLB.numberOfLines = 0;
        [backView addSubview:self.detailLB];
        
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 40 * ProportionAdapter, 18 * ProportionAdapter, 25 * ProportionAdapter, 25 * ProportionAdapter)];
        [self.closeBtn setImage:[UIImage imageNamed:@"date_close"] forState:(UIControlStateNormal)];
        [self.closeBtn addTarget:self action:@selector(closeAct) forControlEvents:(UIControlEventTouchUpInside)];
        [backView addSubview:self.closeBtn];
        
        self.systemBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 * ProportionAdapter, 220 * ProportionAdapter - 80 * ProportionAdapter, 70 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.systemBtn setTitle:@"系统设置" forState:(UIControlStateNormal)];
        [self.systemBtn setTitleColor:[UIColor colorWithHexString:@"#f39800"] forState:(UIControlStateNormal)];
        [backView addSubview:self.systemBtn];
        
        self.ManualBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 130 * ProportionAdapter, 220 * ProportionAdapter - 80 * ProportionAdapter, 70 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.ManualBtn setTitle:@"手动输入" forState:(UIControlStateNormal)];
        [self.ManualBtn setTitleColor:[UIColor colorWithHexString:@"#f39800"] forState:(UIControlStateNormal)];
        [backView addSubview:self.ManualBtn];
        
    }
    return self;
}

- (void)closeAct{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
