//
//  HorButtonSet.m
//  DaGolfla
//
//  Created by bhxx on 15/8/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "HorButtonSet.h"
#import "ViewController.h"
@implementation HorButtonSet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTintColor:[UIColor lightGrayColor]];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20*ScreenWidth/375 , 15*ScreenWidth/375, contentRect.size.width/2-40*ScreenWidth/375, 20*ScreenWidth/375);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width/2-20*ScreenWidth/375, 10*ScreenWidth/375, contentRect.size.width/2+30*ScreenWidth/375, 30*ScreenWidth/375);
}
@end