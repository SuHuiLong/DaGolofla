//
//  segementBtnView.m
//  DagolfLa
//
//  Created by SHL on 2017/5/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "segementBtnView.h"

@implementation segementBtnView
//两个按钮形式
-(instancetype)initWithFrame:(CGRect)frame leftTile:(NSString *)left rightTile:(NSString *)right{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewLeft:left Right:right];
    }
    return self;
}

-(void)createViewLeft:(NSString *)left Right:(NSString *)right{
    //按钮背景
    UIView *whiteBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(65))];
    [self addSubview:whiteBackView];
    //退出活动
    UIButton *registerBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(10), 0, screenWidth/2 - kWvertical(10), kHvertical(45)) titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:RGB(241, 151, 37) target:nil selector:nil Title:left];
    UIBezierPath *registerBtnMaskPath = [UIBezierPath bezierPathWithRoundedRect:registerBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(kWvertical(6),kWvertical(6))];
    CAShapeLayer *registerBtnMaskLayer = [[CAShapeLayer alloc] init];
    registerBtnMaskLayer.frame = registerBtn.bounds;
    registerBtnMaskLayer.path = registerBtnMaskPath.CGPath;
    registerBtn.layer.mask = registerBtnMaskLayer;
    [whiteBackView addSubview:registerBtn];
    _leftBtn = registerBtn;
    //替朋友报名
    UIButton *registerFriendBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2 - kWvertical(10), kHvertical(45)) titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:RGB(233, 97, 29) target:nil selector:nil Title:right];
    UIBezierPath *registerFriendBtnMaskPath = [UIBezierPath bezierPathWithRoundedRect:registerFriendBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(kWvertical(6),kWvertical(6))];
    CAShapeLayer *registerFriendBtnMaskLayer = [[CAShapeLayer alloc] init];
    registerFriendBtnMaskLayer.frame = registerFriendBtn.bounds;
    registerFriendBtnMaskLayer.path = registerFriendBtnMaskPath.CGPath;
    registerFriendBtn.layer.mask = registerFriendBtnMaskLayer;
    [whiteBackView addSubview:registerFriendBtn];
    _rightBtn = registerFriendBtn;
}

//一个按钮
-(instancetype)initWithFrame:(CGRect)frame Tile:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewTitle:title];
    }
    return self;
}
-(void)createViewTitle:(NSString *)title{
    //按钮背景
    UIView *whiteBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, screenWidth, kHvertical(65))];
    [self addSubview:whiteBackView];
    _indexBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(10), kHvertical(10), screenWidth - kWvertical(20), kHvertical(46)) titleFont:kHorizontal(18) textColor:WhiteColor backgroundColor:RGB(243,152,0) target:self selector:nil Title:title];
    _indexBtn.layer.cornerRadius = kWvertical(6);
    [whiteBackView addSubview:_indexBtn];


}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
