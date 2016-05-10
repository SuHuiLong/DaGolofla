//
//  MallView.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MallView.h"
#import "AppDelegate.h"
@implementation MallView


- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3-2*ScreenWidth/375, (ScreenWidth/3-2*ScreenWidth/375)*3/2)];
        [self addSubview:view];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, ((ScreenWidth/3-2*ScreenWidth/375)*3/2)/2-15*ScreenWidth/375, (ScreenWidth/3-2*ScreenWidth/375)/2-20*ScreenWidth/375, 30*ScreenWidth/375)];
        [view addSubview:label];
        
        UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth/3-2*ScreenWidth/375)/2 + 10*ScreenWidth/375, ((ScreenWidth/3-2*ScreenWidth/375)*3/2)/2-20*ScreenWidth/375, 40*ScreenWidth/375, 40*ScreenWidth/375)];
        
        [view addSubview:imgv];
        
    }
    return self;
}

@end
