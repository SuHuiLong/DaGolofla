//
//  MessageShareAlert.m
//  DagolfLa
//
//  Created by SHL on 2017/6/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "MessageShareAlert.h"

@implementation MessageShareAlert

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
#pragma mark - CreateView
-(void)createView{
    //背景
    UIView *alpaView = [Factory createViewWithBackgroundColor:RGB(0,0,0) frame:CGRectMake(0, 0, screenWidth , screenHeight)];
    alpaView.alpha = 0.6;
    [self addSubview:alpaView];

    NSArray *titleArray = @[@"微信好友",@"微信朋友圈",@"短信"];
    NSArray *iconArray = @[@"weixin-1",@"pengyouquan",@"share_message"];

    UIView *buttonView = [Factory createViewWithBackgroundColor:RGB(255,255,255) frame:CGRectMake(kWvertical(10), screenHeight - kHvertical(210), screenWidth - kWvertical(20), kHvertical(140))];
    buttonView.layer.masksToBounds = true;
    buttonView.layer.cornerRadius = kHvertical(8);
    [self addSubview:buttonView];
    for (int i = 0; i < 3; i++) {
        //按钮
        UIButton *indexBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(4) + (buttonView.width/3 - kWvertical(8))*i, kHvertical(13), buttonView.width/3 - kWvertical(8), kHvertical(84)) image:[UIImage imageNamed:iconArray[i]] target:self selector:@selector(btnSelect:) Title:nil];
        indexBtn.tag = 100+i;
        [buttonView addSubview:indexBtn];
        //文字
        UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(indexBtn.x, kHvertical(90), indexBtn.width, kHvertical(21)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:titleArray[i]];
        [descLabel setTextAlignment:NSTextAlignmentCenter];
        [buttonView addSubview:descLabel];
    }
    
    
    UIButton *cancel = [Factory createButtonWithFrame:CGRectMake(buttonView.x, buttonView.y_height + kHvertical(10), buttonView.width, kHvertical(50)) titleFont:kHorizontal(20) textColor:RGB(49,49,49) backgroundColor:WhiteColor target:self selector:@selector(btnSelect:) Title:@"取消"];
    cancel.layer.cornerRadius = kHvertical(8);
    cancel.layer.masksToBounds = true;
    [self addSubview:cancel];
}

-(void)btnSelect:(UIButton *)sender{
    NSString *btnTitle = sender.titleLabel.text;
    NSInteger index = 0;
    if ([btnTitle isEqualToString:@"取消"]) {
        self.hidden = true;
        [self removeAllSubviews];
        [self removeFromSuperview];
        index = 0;
    }else {
        NSInteger tag = sender.tag;
        index = tag - 99;
    }
    
    if (self.selectIndex) {
        self.selectIndex(index);
    }
    
}


@end
