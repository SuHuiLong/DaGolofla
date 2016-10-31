//
//  JGHRecomStadiumView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHRecomStadiumView.h"

@implementation JGHRecomStadiumView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 107 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        _activityImageView.userInteractionEnabled = YES;
        _activityImageView.contentMode = UIViewContentModeScaleAspectFill;
        _activityImageView.clipsToBounds = YES;
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 113 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _name.text = @"上海CF球队相册";
        [self addSubview:_name];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(0, 143 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _price.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _price.textColor = [UIColor colorWithHexString:@"#f2862c"];
        _price.text = @"¥998";
        [self addSubview:_price];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configJGHRecomStadiumView:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    _activityImageView.frame = CGRectMake(0, 0, self.frame.size.width, imageH *ProportionAdapter);
    
    _name.frame = CGRectMake(0, (imageH +5) *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter);
    
    _price.frame = CGRectMake(0, (imageH +5 + 30) *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter);
    
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"imgURL"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _name.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]];
    
    _price.text = [NSString stringWithFormat:@"¥%@", [dict objectForKey:@"money"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
