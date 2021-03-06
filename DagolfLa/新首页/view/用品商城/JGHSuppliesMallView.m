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
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12 * ProportionAdapter, 138 *ProportionAdapter, 138 *ProportionAdapter)];
        _activityImageView.image = [UIImage imageNamed:@"activityStateImage"];
        _activityImageView.userInteractionEnabled = YES;
        [self addSubview:_activityImageView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(8*ProportionAdapter, 150 *ProportionAdapter, _activityImageView.frame.size.width -16*ProportionAdapter, 40 *ProportionAdapter)];
        _name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _name.text = @"ADIDAS阿迪达斯GOLF高尔夫球鞋Q4674男士轻便防水";
        _name.numberOfLines = 2;
        [self addSubview:_name];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(8*ProportionAdapter, 210 *ProportionAdapter, _activityImageView.frame.size.width -16*ProportionAdapter, 20 *ProportionAdapter)];
        _price.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
        _price.text = @"¥998";
        _price.textColor = [UIColor colorWithHexString:SY_PriceColor];
        _price.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_price];
        
        _ellipsisLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 20 *ProportionAdapter, 205 *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter)];
        _ellipsisLable.text = @"...";
        _ellipsisLable.textColor = [UIColor lightGrayColor];
        _ellipsisLable.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        [self addSubview:_ellipsisLable];
        
        _drawee = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width -26*ProportionAdapter -80 *ProportionAdapter, 210*ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter)];
        _drawee.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
        _drawee.text = @"0 人付款";
        _drawee.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        _drawee.textAlignment = NSTextAlignmentRight;
        [self addSubview:_drawee];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height -1, self.frame.size.width, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:@"#dadada"];
        [self bringSubviewToFront:_line];
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configJGHSuppliesMallView:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    NSInteger allX = ((screenWidth -4*ProportionAdapter)/2 -imageW)/2 *ProportionAdapter;
    
    _activityImageView.frame = CGRectMake(allX, 12 * ProportionAdapter, imageW *ProportionAdapter, imageH *ProportionAdapter);
    
    _name.frame = CGRectMake(8 *ProportionAdapter, (imageH + 24)*ProportionAdapter, self.frame.size.width -16*ProportionAdapter, 40 *ProportionAdapter);
    
    _price.frame = CGRectMake(8*ProportionAdapter, (imageH +50 +24) *ProportionAdapter, self.frame.size.width - 100 *ProportionAdapter, 20 *ProportionAdapter);
    
    _ellipsisLable.frame = CGRectMake(self.frame.size.width - 20 *ProportionAdapter, (imageH +50 +24 -5) *ProportionAdapter, 20 *ProportionAdapter, 20 *ProportionAdapter);
    
    _drawee.frame = CGRectMake(self.frame.size.width -26*ProportionAdapter -80 *ProportionAdapter, (imageH +50 +24) *ProportionAdapter, 80 *ProportionAdapter, 20 *ProportionAdapter);
    
    _line.frame = CGRectMake(0, self.frame.size.height -1, self.frame.size.width, 1);
    [self bringSubviewToFront:_line];
    
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"imgURL"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    _name.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]];
    
    _price.text = [NSString stringWithFormat:@"¥%.2f", [[dict objectForKey:@"money"] floatValue]];
    
    if ([dict objectForKey:@"viewCount"]) {

        _drawee.text = [NSString stringWithFormat:@"%@ 人付款", [dict objectForKey:@"viewCount"]];
    }else{
        _drawee.text = @"0 @人付款";
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
