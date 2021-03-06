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
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3 *ProportionAdapter, 60 *ProportionAdapter, 60 *ProportionAdapter)];
//        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        [self addSubview:_activityImageView];
        _activityImageView.layer.cornerRadius = 6 * ProportionAdapter;
        _activityImageView.contentMode = UIViewContentModeScaleAspectFill;
        _activityImageView.clipsToBounds = YES;
        
//        _isSignUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 *ProportionAdapter, 0, 30 *ProportionAdapter, 30*ProportionAdapter)];
//        _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];
//        [_activityImageView addSubview:_isSignUpImageView];
        
        _activityName = [[UILabel alloc]initWithFrame:CGRectMake(72*ProportionAdapter, 0, self.frame.size.width -72 *ProportionAdapter, 20 *ProportionAdapter)];
        _activityName.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_activityName];
        
        UIImageView *adressImageV = [[UIImageView alloc]initWithFrame:CGRectMake(71 *ProportionAdapter, 26 *ProportionAdapter, 10 *ProportionAdapter, 13 *ProportionAdapter)];
        adressImageV.image = [UIImage imageNamed:@"juli"];
        [self addSubview:adressImageV];
 
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(86 *ProportionAdapter, 23 *ProportionAdapter, 180 *ProportionAdapter, 20*ProportionAdapter)];
        _address.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _address.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_address];
        
        _time =[[UILabel alloc]initWithFrame:CGRectMake(266 *ProportionAdapter, 23 *ProportionAdapter, 70 *ProportionAdapter, 20 *ProportionAdapter)];
        _time.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        _time.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_time];
        
        
        _actDescrib = [[UILabel alloc]initWithFrame:CGRectMake(71 *ProportionAdapter, 47 *ProportionAdapter, 260 * ProportionAdapter, 20*ProportionAdapter)];
        _actDescrib.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
        _actDescrib.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_actDescrib];

    }
    return self;
}

- (void)configJGHShowLiveView:(NSDictionary *)dic{

    [_activityImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[[dic objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    
    
    NSString *timeString = [NSString stringWithFormat:@"%@", [dic objectForKey:@"beginTime"]];
    
    _activityName.text = [NSString stringWithFormat:@"%@（%@人）", [dic objectForKey:@"title"], [dic objectForKey:@"userSum"]];
    _address.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ballName"]];
    _time.text = [NSString stringWithFormat:@"%@月%@号",[timeString substringWithRange:NSMakeRange(5, 2)], [timeString substringWithRange:NSMakeRange(8, 2)]];
    _actDescrib.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"userNames"]];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
