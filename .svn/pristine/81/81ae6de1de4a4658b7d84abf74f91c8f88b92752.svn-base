//
//  TabBarItem.m
//  爱限免
//
//  Created by huangdl on 15-5-4.
//  Copyright (c) 2015年 黄驿. All rights reserved.
//

#import "TabBarItem.h"
#import "ViewController.h"
@implementation TabBarItem



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundImage:[UIImage imageNamed:@"tab_bg1"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"tab_bg2"] forState:UIControlStateSelected];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 22 ) / 2 , 5, 25, 25);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(2, 32, contentRect.size.width, 15);
}



@end
