//
//  JGHWonderfulView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWonderfulView.h"

@implementation JGHWonderfulView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 107 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 115 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _name.text = @"上海CF球队相册";
        [self addSubview:_name];
    }
    return self;
}

- (void)configJGHWonderfulView:(NSDictionary *)dict{
    if ([dict objectForKey:@"timeKey"]) {
        [_activityImageView sd_setImageWithURL:[dict objectForKey:@"imgURL"] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
        
        _name = [dict objectForKey:@"title"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
