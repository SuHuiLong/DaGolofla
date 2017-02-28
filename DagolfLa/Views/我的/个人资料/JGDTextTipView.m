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

        self.backDView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 250 * ProportionAdapter, screenWidth, 195 * ProportionAdapter)];
        self.backDView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backDView];
        
        self.titleLB = [Helper lableRect:CGRectMake(0, 25 * ProportionAdapter, screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:15 * ProportionAdapter text:@"差点" textAlignment:(NSTextAlignmentCenter)];
        [self.backDView addSubview:self.titleLB];
        
        self.detailLB = [Helper lableRect:CGRectMake(18 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 36 * ProportionAdapter, 80 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:13 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        // 启用君高差点管理系统后，系统会根据每场完整记分成绩，计算出当次球场差点值，然后将该值与个人历史差点进行计算，实时算出您的新差点并自动更新。该系统可在“系统设置”中开启或关闭。
        self.detailLB.numberOfLines = 0;
        [self.backDView addSubview:self.detailLB];
        
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 40 * ProportionAdapter, 18 * ProportionAdapter, 20 * ProportionAdapter, 20 * ProportionAdapter)];
        [self.closeBtn setImage:[UIImage imageNamed:@"date_close"] forState:(UIControlStateNormal)];
        [self.closeBtn addTarget:self action:@selector(closeAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.backDView addSubview:self.closeBtn];
        
        self.systemBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 * ProportionAdapter, 220 * ProportionAdapter - 80 * ProportionAdapter, 70 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.systemBtn setTitle:@"启动系统" forState:(UIControlStateNormal)];
        self.systemBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.systemBtn setTitleColor:[UIColor colorWithHexString:@"#f39800"] forState:(UIControlStateNormal)];
        [self.systemBtn addTarget:self action:@selector(sysAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.backDView addSubview:self.systemBtn];
        
        self.ManualBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 130 * ProportionAdapter, 220 * ProportionAdapter - 80 * ProportionAdapter, 70 * ProportionAdapter, 30 * ProportionAdapter)];
        [self.ManualBtn setTitle:@"手动输入" forState:(UIControlStateNormal)];
        self.ManualBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.ManualBtn addTarget:self action:@selector(manualAct) forControlEvents:(UIControlEventTouchUpInside)];
        [self.ManualBtn setTitleColor:[UIColor colorWithHexString:@"#f39800"] forState:(UIControlStateNormal)];
        
    }
    return self;
}

- (void)setIsUseJG:(BOOL)isUseJG{

    if (!isUseJG) {
        self.titleLB.text = @"是否启用君高差点系统";
        self.detailLB.text = @"启用君高差点管理系统后，系统会根据每场完整记分成绩，计算出当次球场差点值，然后将该值与个人历史差点进行计算，实时算出您的新差点并自动更新。该系统可在“系统设置”中开启君高差点管理系统。";
        [self.backDView addSubview:self.ManualBtn];
    }else{
        self.titleLB.text = @"已启用君高差点系统";
        [self.systemBtn setTitle:@"系统设置" forState:(UIControlStateNormal)];
        self.detailLB.text = @"系统会根据每场完整记分成绩，自动计算出当次球场差点值，然后将该值与个人历史差点进行计算，实时算出您的新差点并自动更新。该系统可在“系统设置”中开启或关闭。";
        self.systemBtn.frame = CGRectMake(0, 220 * ProportionAdapter - 80 * ProportionAdapter, screenWidth, 30 * ProportionAdapter);
    }
}

//手动输入
- (void)manualAct{
    self.blockManual();
    [self removeFromSuperview];
}

- (void)sysAct{
    self.blocksys();
    [self removeFromSuperview];
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
