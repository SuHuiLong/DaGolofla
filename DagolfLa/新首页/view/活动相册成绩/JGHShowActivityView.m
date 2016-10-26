//
//  JGHShowActivityView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowActivityView.h"

@implementation JGHShowActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60 *ProportionAdapter, 60 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        [self addSubview:_activityImageView];
        
        _isSignUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 *ProportionAdapter, 0, 30 *ProportionAdapter, 30*ProportionAdapter)];
        _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];
        [_activityImageView addSubview:_isSignUpImageView];
        
        _activityName = [[UILabel alloc]initWithFrame:CGRectMake(72*ProportionAdapter, 0, self.frame.size.width -72 *ProportionAdapter, 20 *ProportionAdapter)];
        _activityName.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _activityName.text = @"上海XX球场活动";
        [self addSubview:_activityName];
        
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(72 *ProportionAdapter, 25 *ProportionAdapter, 10 *ProportionAdapter, 10 *ProportionAdapter)];
        timeImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:timeImageView];
        
        _time =[[UILabel alloc]initWithFrame:CGRectMake(86 *ProportionAdapter, 20 *ProportionAdapter, self.frame.size.width - 86 *ProportionAdapter, 20 *ProportionAdapter)];
        _time.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _time.text = @"2016年10月25号";
        [self addSubview:_time];
        
        UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(72 *ProportionAdapter, 45 *ProportionAdapter, 10 *ProportionAdapter, 10 *ProportionAdapter)];
        addressImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:addressImageView];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(72 *ProportionAdapter, 40 *ProportionAdapter, _time.frame.size.width, 20*ProportionAdapter)];
        _address.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _address.text = @"上海市浦东辛苦";
        [self addSubview:_address];
        
    }
    return self;
}

- (void)configJGHShowActivityView:(NSDictionary *)dataDict{
    if ([dataDict objectForKey:@"timeKey"]) {
        [self.activityImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[[dataDict objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        
        if ([[dataDict objectForKey:@"hasSignup"] integerValue] == 0) {
            _isSignUpImageView.image = nil;//未报名
        }else{
            _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];//已报名
        }
        
        _activityName.text = [dataDict objectForKey:@"title"];
        
        _time.text = [dataDict objectForKey:@"beginTime"];
        
        _address.text = [dataDict objectForKey:@"ballName"];
    }
    
    
    _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
