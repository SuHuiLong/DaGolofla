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
        _activityImageView.layer.cornerRadius = 6 * ProportionAdapter;
        _activityImageView.clipsToBounds = YES;
        
        _isSignUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 *ProportionAdapter, 0, 30 *ProportionAdapter, 30*ProportionAdapter)];
        _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];
        [_activityImageView addSubview:_isSignUpImageView];
        
        _activityName = [[UILabel alloc]initWithFrame:CGRectMake(72*ProportionAdapter, 0, self.frame.size.width -72 *ProportionAdapter, 20 *ProportionAdapter)];
        _activityName.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _activityName.text = @"上海XX球场活动";
        [self addSubview:_activityName];
        
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(71 *ProportionAdapter, 24 *ProportionAdapter, 12 *ProportionAdapter, 12 *ProportionAdapter)];
        timeImageView.image = [UIImage imageNamed:@"time"];
        [self addSubview:timeImageView];
        
        _time =[[UILabel alloc]initWithFrame:CGRectMake(86 *ProportionAdapter, 20 *ProportionAdapter, self.frame.size.width - 86 *ProportionAdapter, 20 *ProportionAdapter)];
        _time.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _time.text = @"2016年10月25号";
        _time.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_time];
        
        UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(72 *ProportionAdapter, 43 *ProportionAdapter, 10 *ProportionAdapter, 13 *ProportionAdapter)];
        addressImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:addressImageView];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(86 *ProportionAdapter, 40 *ProportionAdapter, _time.frame.size.width, 20*ProportionAdapter)];
        _address.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _address.text = @"上海市浦东辛苦";
        _address.textColor = [UIColor colorWithHexString:@"#636161"];
        [self addSubview:_address];
        
    }
    return self;
}

- (void)configJGHShowActivityView:(NSDictionary *)dataDict{
    if ([dataDict objectForKey:@"timeKey"]) {
        [self.activityImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[[dataDict objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
        NSLog(@"%@", [Helper setImageIconUrl:@"activity" andTeamKey:[[dataDict objectForKey:@"timeKey"] integerValue] andIsSetWidth:YES andIsBackGround:YES]);
        if ([[dataDict objectForKey:@"hasSignup"] integerValue] == 0) {
            _isSignUpImageView.image = nil;//未报名
        }else{
            _isSignUpImageView.image = [UIImage imageNamed:@"baoming"];//已报名
        }
        
        _activityName.text = [dataDict objectForKey:@"title"];
        
        NSString *moneyString = @"0";
        [dataDict objectForKey:@"money"] ? moneyString = [[dataDict objectForKey:@"money"] stringValue] : @"0";
        
        NSString *timeString = [NSString stringWithFormat:@"%@月%@号(已报名%@人)¥: %@元",[[dataDict objectForKey:@"beginTime"] substringWithRange:NSMakeRange(5, 2)], [[dataDict objectForKey:@"beginTime"] substringWithRange:NSMakeRange(8, 2)], [dataDict objectForKey:@"userSum"], moneyString];
        
        NSArray *stringArray = [timeString componentsSeparatedByString:@":"];
        NSInteger userSumLength = [[[dataDict objectForKey:@"userSum"] stringValue] length];
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:timeString];
        
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fb841c"] range:NSMakeRange([stringArray[0] length] - userSumLength - 3, userSumLength)];
        
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ce131d"] range:NSMakeRange([stringArray[0] length] + 2, [moneyString length] + 1)];
        
        _time.attributedText = attriString;
        
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
