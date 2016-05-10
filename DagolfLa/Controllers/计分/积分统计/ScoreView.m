//
//  ScoreView.m
//  DaGolfla
//
//  Created by bhxx on 15/8/19.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoreView.h"
#import "ViewController.h"
#import "ScoreWriteProController.h"
@implementation ScoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
//        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        btn.frame = CGRectMake(0, 0, 50*ScreenWidth/375, 50*ScreenWidth/375);
//        [self addSubview:btn];
        self.userInteractionEnabled = YES;
        _viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50*ScreenWidth/375, 50*ScreenWidth/375)];
        [self addSubview:_viewBase];
//        [_btnBase addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        
//        _btnUp = [UIButton buttonWithType:UIButtonTypeSystem];
        _labelUp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*ScreenWidth/375, 25*ScreenWidth/375)];
        [_viewBase addSubview:_labelUp];
//        _labelUp.text = @"3";
        _labelUp.font = [UIFont systemFontOfSize:18*ScreenWidth/375];
        _labelUp.textColor = [UIColor blueColor];
        _labelUp.textAlignment = NSTextAlignmentCenter;
        
        _labelLeft = [[UILabel alloc]initWithFrame: CGRectMake(0, 25*ScreenWidth/375, 25*ScreenWidth/375, 25*ScreenWidth/375)];
        [_viewBase addSubview:_labelLeft];
//        _labelLeft.text = @"5";
        _labelLeft.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _labelLeft.textColor = [UIColor lightGrayColor];
        _labelLeft.textAlignment = NSTextAlignmentCenter;
       
        
        _labelRight = [[UILabel alloc]initWithFrame: CGRectMake(25*ScreenWidth/375, 25*ScreenWidth/375, 25*ScreenWidth/375, 25*ScreenWidth/375)];
        [_viewBase addSubview:_labelRight];
//        _labelRight.text = @"5";
        _labelRight.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _labelRight.textColor = [UIColor orangeColor];
        _labelRight.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}



@end
