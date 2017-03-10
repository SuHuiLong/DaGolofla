//
//  VipCardHeaderCollectionReusableView.m
//  DagolfLa
//
//  Created by SHL on 2017/3/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardHeaderCollectionReusableView.h"

@implementation VipCardHeaderCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


-(void)createUI{

    //没卡提示图片
    _alertImageView = [Factory createImageViewWithFrame:CGRectMake(screenWidth/2-kWvertical(53.5), kHvertical(110), kWvertical(107), kWvertical(107)) Image:[UIImage imageNamed:@"bg-shy"]];
    [self   addSubview:_alertImageView];

    //文字描述
    _descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(22), _alertImageView.y_height+kHvertical(30), screenWidth - kWvertical(44), kHvertical(80)) textColor:LightGrayColor fontSize:kHorizontal(15) Title:nil];
    _descLabel.numberOfLines = 0;
    
    [self   addSubview:_descLabel];
    
    //立即添加
    _addNowBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(10), kHvertical(390), screenWidth - kWvertical(20), kHvertical(45)) titleFont:kHorizontal(16) textColor:WhiteColor backgroundColor:RedColor target:self selector:nil Title:@"立即添加"];
    _addNowBtn.layer.cornerRadius = kHvertical(3);
    [self addSubview:_addNowBtn];
    
    
    //不可用卡片提示分割线
    _line = [Factory createViewWithBackgroundColor:RGBA(213, 213, 213, 1) frame:CGRectMake(0, kHvertical(40), screenWidth, kHvertical(1))];
    [self addSubview:_line];

    //不可用提示文字
    _nocanDescLabel = [Factory createLabelWithFrame:CGRectMake((screenWidth - kWvertical(150))/2, kHvertical(30), kWvertical(150), kHvertical(20)) textColor:RGBA(160, 160, 160, 1) fontSize:kHorizontal(13) Title:@"以下为不可用卡片"];
    _nocanDescLabel.backgroundColor = RGBA(238, 238, 238, 1);
    _nocanDescLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nocanDescLabel];

    
    
    
}

@end
