//
//  RedpacketAlertView.m
//  DagolfLa
//
//  Created by SHL on 2017/6/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "RedpacketAlertView.h"

@implementation RedpacketAlertView

-(instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewWithText:text];
    }
    return self;
}

-(void)createViewWithText:(NSString *)text{
    //背景
    UIView *alpaView = [Factory createViewWithBackgroundColor:RGB(0,0,0) frame:CGRectMake(0, 0, screenWidth , screenHeight)];
    alpaView.alpha = 0.6;
    [self addSubview:alpaView];
    //红包
    UIImageView *circleView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(22), kHvertical(168), screenWidth - kWvertical(44), screenWidth - kWvertical(44)) Image:[UIImage imageNamed:@"redpackket_share"]];
    [self addSubview:circleView];
    //文字
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(0, circleView.height/2, circleView.width, kHvertical(20)) textColor:RGB(254,239,0) fontSize:kHorizontal(20) Title:text];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [circleView addSubview:descLabel];
    
    _circleView = circleView;
    _circleView.userInteractionEnabled = true;
    self.userInteractionEnabled = true;
    
    //关闭按钮
    UIButton *closeBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(56), kHvertical(130), kWvertical(23), kWvertical(23)) image:[UIImage imageNamed:@"date_close"] target:self selector:@selector(closeView) Title:nil];
    [self addSubview:closeBtn];
    
}

-(void)closeView{
    [MobClick event:@"redpacket_close_share"];
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = true;
}


@end
