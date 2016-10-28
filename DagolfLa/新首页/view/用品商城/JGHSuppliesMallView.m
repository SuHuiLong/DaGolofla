//
//  JGHSuppliesMallView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSuppliesMallView.h"

@implementation JGHSuppliesMallView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35 * ProportionAdapter, self.frame.size.width, 107 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        _activityImageView.userInteractionEnabled = YES;
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 159 *ProportionAdapter, _activityImageView.frame.size.width, 50 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _name.text = @"ADIDAS阿迪达斯GOLF高尔夫球鞋Q4674男士轻便防水";
        _name.numberOfLines = 2;
        [self addSubview:_name];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(0, 210 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _price.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _price.text = @"¥998";
        _price.textColor = [UIColor colorWithHexString:@"#f2862c"];
        [self addSubview:_price];
        self.backgroundColor = [UIColor orangeColor];
        
        UILabel *ellipsisLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 20 *ProportionAdapter, 205 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
        ellipsisLable.text = @"...";
        ellipsisLable.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        [self addSubview:ellipsisLable];
        
        _drawee = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width -30*ProportionAdapter -80 *ProportionAdapter, 210*ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
        _drawee.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _drawee.text = @"43人付款";
        _drawee.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [self addSubview:_drawee];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configJGHSuppliesMallView:(NSDictionary *)dict{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"imgURL"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _name.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]];
    
    _price.text = [NSString stringWithFormat:@"¥%@", [dict objectForKey:@"money"]];
    
    if ([dict objectForKey:@"viewCount"]) {
        NSString *priceString = @"";
        [[dict objectForKey:@"viewCount"] integerValue] == 0 ? (priceString = @"") : (priceString = [NSString stringWithFormat:@"%@人付款", [dict objectForKey:@"viewCount"]]);
        _drawee.text = priceString;
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
