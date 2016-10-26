//
//  JGHSuppliesMallView.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSuppliesMallView.h"

@implementation JGHSuppliesMallView

- (instancetype)init{
    if (self == [super init]) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 107 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 107 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _name.text = @"ADIDAS阿迪达斯GOLF高尔夫球鞋Q4674男士轻便防水";
        _name.numberOfLines = 2;
        [self addSubview:_name];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(0, 127 *ProportionAdapter, _activityImageView.frame.size.width, 20 *ProportionAdapter)];
        _price.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _price.text = @"¥998";
        [self addSubview:_price];
        self.backgroundColor = [UIColor orangeColor];
        
        UILabel *ellipsisLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width -18 *ProportionAdapter, 127 *ProportionAdapter, 12 *ProportionAdapter, 20 *ProportionAdapter)];
        ellipsisLable.text = @"...";
        [self addSubview:ellipsisLable];
        
        _drawee = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width -30*ProportionAdapter -80 *ProportionAdapter, 127*ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
        _drawee.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _drawee.text = @"43人付款";
        [self addSubview:_drawee];
        
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
