//
//  JGDHotTeamView.m
//  DagolfLa
//
//  Created by 東 on 16/11/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDHotTeamView.h"

@interface JGDHotTeamView ()

@property (nonatomic, strong) UIImageView *iconImageV;

@property (nonatomic, strong) UILabel *nameLB;

@property (nonatomic, strong) UILabel *addressLB;

@property (nonatomic, strong) UILabel *detailLB;

@end

@implementation JGDHotTeamView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(11 * ProportionAdapter, 14 * ProportionAdapter, 70 * ProportionAdapter, 70 * ProportionAdapter)];
        [self addSubview: self.iconImageV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(105 * ProportionAdapter, 14 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 25 * ProportionAdapter)];
        self.nameLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
        self.nameLB.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview: self.nameLB];
        
        UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105 *ProportionAdapter, 39     *ProportionAdapter, 10 *ProportionAdapter, 13 *ProportionAdapter)];
        addressImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:addressImageView];
        
        self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 39 * ProportionAdapter, screenWidth - 150 * ProportionAdapter, 20 * ProportionAdapter)];
        self.addressLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.addressLB.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [self addSubview:self.addressLB];
        
        self.detailLB = [[UILabel alloc] initWithFrame:CGRectMake(105 * ProportionAdapter, 60 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 20 * ProportionAdapter)];
        self.detailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.detailLB.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [self addSubview:self.detailLB];
        
        
    }
    return self;
}

- (void)configJGDHotTeamWithDic:(NSDictionary *)dic{
    self.iconImageV.backgroundColor = [UIColor cyanColor];
    self.nameLB.text = @"łłłłłłłłłłłłłłłłłłłłłłł";
    self.addressLB.text = @"łłłłłłłłłłłłłłłłłłłłłł";
    self.detailLB.text = @"łłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłłł";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
