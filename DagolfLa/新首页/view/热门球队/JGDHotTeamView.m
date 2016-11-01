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

@property (nonatomic, strong) UIImageView *addressImageView;

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
        
        self.addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(105 *ProportionAdapter, 44     *ProportionAdapter, 11 *ProportionAdapter, 15 *ProportionAdapter)];
        self.addressImageView.image = [UIImage imageNamed:@"juli"];
        [self addSubview:self.addressImageView];
        
        self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(120 * ProportionAdapter, 39 * ProportionAdapter, screenWidth - 150 * ProportionAdapter, 20 * ProportionAdapter)];
        self.addressLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.addressLB.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [self addSubview:self.addressLB];
        
        self.detailLB = [[UILabel alloc] initWithFrame:CGRectMake(105 * ProportionAdapter, 62 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 20 * ProportionAdapter)];
        self.detailLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.detailLB.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [self addSubview:self.detailLB];
        
        
    }
    return self;
}

- (void)configJGHShowFavouritesCell:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    
    
    self.iconImageV.frame = CGRectMake(11 * ProportionAdapter, 14 * ProportionAdapter, imageW * ProportionAdapter, imageH * ProportionAdapter);
    
    self.nameLB.frame = CGRectMake(self.iconImageV.frame.origin.x + (imageW + 24) * ProportionAdapter, 14 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 25 * ProportionAdapter);
    
    self.addressImageView.frame = CGRectMake(self.iconImageV.frame.origin.x + (imageW + 24) * ProportionAdapter, 44     *ProportionAdapter, 11 *ProportionAdapter, 15 *ProportionAdapter);
    
    self.addressLB.frame = CGRectMake(self.iconImageV.frame.origin.x + (imageW + 39) * ProportionAdapter, 39 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 25 * ProportionAdapter);

    self.detailLB.frame = CGRectMake(self.iconImageV.frame.origin.x + (imageW + 24) * ProportionAdapter, 62 * ProportionAdapter, screenWidth - 110 * ProportionAdapter, 20 * ProportionAdapter);
    
    if ([dict objectForKey:@"timeKey"]) {
        [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"imgURL"]]] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
        
        NSString * name = [dict objectForKey:@"title"];
        NSString * sum = [[dict objectForKey:@"viewCount"] stringValue];
        
        NSMutableAttributedString *nameAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", name,  sum]];
        [nameAttrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange([name length], [sum length] + 2)];
        self.nameLB.attributedText = nameAttrib;
//        self.nameLB.text = [NSString stringWithFormat:@"%@（%@）", [dict objectForKey:@"title"],  [dict objectForKey:@"viewCount"]];
        
        self.addressLB.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"position"]];
        
        self.detailLB.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"desc"]];
        
//        if ([dict objectForKey:@"viewCount"]) {
//            _activityNumber.text = [NSString stringWithFormat:@"(%@)", [dict objectForKey:@"viewCount"]];
//        }else{
//            _activityNumber.text = @"";
//        }
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
