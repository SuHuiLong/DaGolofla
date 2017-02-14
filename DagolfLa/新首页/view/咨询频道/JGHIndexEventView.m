//
//  JGHIndexEventView.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHIndexEventView.h"

@implementation JGHIndexEventView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, 80 * ProportionAdapter, 60 * ProportionAdapter)];
        [self addSubview:self.iconImageV];
        
        self.titleNewsLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:16 text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self addSubview:self.titleNewsLB];
        
        self.deltailLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 30 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#7f7f7f"] labelFont:13 text:@"" textAlignment:(NSTextAlignmentLeft)];
        self.deltailLB.numberOfLines = 0;
        [self addSubview:self.deltailLB];
        
        UILabel *lineLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 79 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#e5e5e5"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self addSubview:lineLB];
    }
    return self;
}
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

- (void)configJGHIndexEventView:(NSDictionary *)dict{

    [self.iconImageV sd_setImageWithURL:[dict objectForKey:@"picURL"] placeholderImage:[UIImage imageNamed:TeamBGImage]];
    
    if ([dict objectForKey:@"title"]) {
        self.titleNewsLB.text = [dict objectForKey:@"title"];
    }
    
    if ([dict objectForKey:@"summary"]) {
        self.deltailLB.text = [dict objectForKey:@"summary"];
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
