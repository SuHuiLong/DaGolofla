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
        _activityImageView.contentMode = UIViewContentModeScaleAspectFill;
        _activityImageView.clipsToBounds = YES;
        _activityImageView.userInteractionEnabled = YES;
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 110 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _name.text = @"上海CF球队相册";
        [self addSubview:_name];
    }
    return self;
}

- (void)configJGHWonderfulView:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    _activityImageView.frame = CGRectMake(0, 0, self.frame.size.width, imageH *ProportionAdapter);
    
    _name.frame = CGRectMake(0, imageH *ProportionAdapter +5*ProportionAdapter, imageW *ProportionAdapter, 20 *ProportionAdapter);
    
    if ([dict objectForKey:@"timeKey"]) {
        [_activityImageView sd_setImageWithURL:[dict objectForKey:@"imgURL"] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
        
        if ([dict objectForKey:@"title"]) {
            _name.text = [dict objectForKey:@"title"];
        }else{
            _name.text = @"";
        }
        
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
