//
//  Setbutton.m
//  DaGolfla
//
//  Created by bhxx on 15/8/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "Setbutton.h"
#import "ViewController.h"

#import "UIImageView+WebCache.h"
#import "Helper.h"
@implementation Setbutton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 40*ScreenWidth/375 ) / 2 , 3*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 45*ScreenWidth/375, contentRect.size.width, 15*ScreenWidth/375);
}

-(void)showData:(YueDetailModel *)model
{
    self.titleLabel.text = model.userName;
}

@end
