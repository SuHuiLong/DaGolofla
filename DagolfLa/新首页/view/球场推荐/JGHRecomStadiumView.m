//
//  JGHRecomStadiumView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRecomStadiumView.h"

@implementation JGHRecomStadiumView

- (instancetype)init{
    if (self == [super init]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 107 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 107 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _name.text = @"上海CF球队相册";
        [self addSubview:_name];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(0, 127 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _price.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _price.text = @"¥998";
        [self addSubview:_price];
        self.backgroundColor = [UIColor whiteColor];
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
