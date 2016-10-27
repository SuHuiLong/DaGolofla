//
//  JGDShowLiveView.m
//  DagolfLa
//
//  Created by 東 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDShowLiveView.h"

@implementation JGDShowLiveView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60 *ProportionAdapter, 60 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        [self addSubview:_activityImageView];
        _activityImageView.layer.cornerRadius = 6 * ProportionAdapter;
        _activityImageView.clipsToBounds = YES;
        
        _isSignUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 *ProportionAdapter, 0, 30 *ProportionAdapter, 30*ProportionAdapter)];
        _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];
        [_activityImageView addSubview:_isSignUpImageView];
        
        _activityName = [[UILabel alloc]initWithFrame:CGRectMake(72*ProportionAdapter, 0, self.frame.size.width -72 *ProportionAdapter, 20 *ProportionAdapter)];
        _activityName.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _activityName.text = @"上海XX球场活动";
        [self addSubview:_activityName];
        
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(71 *ProportionAdapter, 43 *ProportionAdapter, 12 *ProportionAdapter, 12 *ProportionAdapter)];
        timeImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:timeImageView];
 
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(86 *ProportionAdapter, 40 *ProportionAdapter, _time.frame.size.width, 20*ProportionAdapter)];
        _address.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _address.text = @"上海市浦东辛苦";
        _address.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_address];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
