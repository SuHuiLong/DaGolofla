//
//  JGPhotoTimeReusableView.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGPhotoTimeReusableView.h"

@implementation JGPhotoTimeReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 0, screenWidth, 25*screenWidth/375)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        [self addSubview:_timeLabel];
        
        
    }
    return self;
}


@end
