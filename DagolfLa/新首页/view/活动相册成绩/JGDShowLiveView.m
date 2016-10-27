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
        
//        _isSignUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 *ProportionAdapter, 0, 30 *ProportionAdapter, 30*ProportionAdapter)];
//        _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];
//        [_activityImageView addSubview:_isSignUpImageView];
        
        _activityName = [[UILabel alloc]initWithFrame:CGRectMake(72*ProportionAdapter, 0, self.frame.size.width -72 *ProportionAdapter, 20 *ProportionAdapter)];
        _activityName.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _activityName.text = @"上海XX球场活动";
        [self addSubview:_activityName];
        
        UIImageView *adressImageV = [[UIImageView alloc]initWithFrame:CGRectMake(71 *ProportionAdapter, 24 *ProportionAdapter, 10 *ProportionAdapter, 13 *ProportionAdapter)];
        adressImageV.image = [UIImage imageNamed:@"juli"];
        [self addSubview:adressImageV];
 
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(86 *ProportionAdapter, 20 *ProportionAdapter, 200 *ProportionAdapter, 20*ProportionAdapter)];
        _address.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _address.text = @"上海市浦东辛苦";
        _address.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_address];
        
        _time =[[UILabel alloc]initWithFrame:CGRectMake(286 *ProportionAdapter, 20 *ProportionAdapter, 70 *ProportionAdapter, 20 *ProportionAdapter)];
        _time.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        _time.text = @"10月25号";
        _time.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_time];
        
        
        _actDescrib = [[UILabel alloc]initWithFrame:CGRectMake(71 *ProportionAdapter, 40 *ProportionAdapter, 280 * ProportionAdapter, 20*ProportionAdapter)];
        _actDescrib.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _actDescrib.text = @"哈哈 嘿嘿 吼猴 喵喵";
        _actDescrib.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_actDescrib];

    }
    return self;
}

- (void)configJGHShowLiveView:(NSDictionary *)dic{
    NSLog(@"configJGHShowLiveView---");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
