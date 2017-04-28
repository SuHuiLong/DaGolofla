//
//  JGDActivityHeadView.m
//  DagolfLa
//
//  Created by 東 on 2017/4/25.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDActivityHeadView.h"

@implementation JGDActivityHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(80))];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        self.headImageView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(6), kWvertical(69), kHvertical(69)) Image:[UIImage imageNamed:ActivityBGImage]];
         self.headImageView.layer.masksToBounds = YES;
         self.headImageView.layer.cornerRadius = kWvertical(8);
        [backView addSubview:self.headImageView];
        
        self.activityTitleLB = [Helper lableRect:CGRectMake(kWvertical(92), kHvertical(10), screenWidth - kWvertical(100), kHvertical(20)) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:kHorizontal(17) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [backView addSubview:self.activityTitleLB];
        
        
        UIImageView* timeImgv = [Factory createImageViewWithFrame:CGRectMake(kWvertical(89), kHvertical(37), kWvertical(13), kHvertical(14)) Image:[UIImage imageNamed:@"time"]];
        [backView addSubview:timeImgv];
        
        self.dateLB = [Helper lableRect:CGRectMake(kWvertical(109), kHorizontal(35), kWvertical(200), kHvertical(15)) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:kHorizontal(13) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [backView addSubview:self.dateLB];
        
        UIImageView* distanceImgv = [Factory createImageViewWithFrame:CGRectMake(kWvertical(90), kHvertical(58), kWvertical(9), kHvertical(14)) Image:[UIImage imageNamed:@"juli"]];
        [backView addSubview:distanceImgv];
        
        self.addressLB = [Helper lableRect:CGRectMake(kWvertical(109), kHorizontal(55), kWvertical(200), kHvertical(15)) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:kHorizontal(14) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [backView addSubview:self.addressLB];
        
    }
    return self;
}

- (void)setModel:(JGTeamAcitivtyModel *)model{

    if (model.teamActivityKey == 0) {
        [self.headImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:[model.timeKey integerValue] andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    }else{
        [self.headImageView sd_setImageWithURL:[Helper setImageIconUrl:@"activity" andTeamKey:model.teamActivityKey andIsSetWidth:YES andIsBackGround:YES] placeholderImage:[UIImage imageNamed:ActivityBGImage]];
    }
    //活动名称
    self.activityTitleLB.text = model.name;

    
    self.dateLB.text = [Helper stringFromDateString:model.beginDate withFormater:@"MM月dd日"];
    //活动地址
    self.addressLB.text = [NSString stringWithFormat:@"%@", model.ballName];
    
    
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
