//
//  JGTeamDetailView.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamDetailView.h"

@implementation JGTeamDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.topBackImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150)];
        self.topBackImageV.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.topBackImageV];
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 60, 60)];
        self.iconImageV.backgroundColor = [UIColor whiteColor];
        [self.topBackImageV addSubview: self.iconImageV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(80, 110, screenWidth - 100, 30)];
        self.nameLB.backgroundColor = [UIColor whiteColor];
        [self.topBackImageV addSubview:self.nameLB];
        
        self.addressAndTimeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 160, screenWidth, 70)];
        self.addressAndTimeImageV.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.addressAndTimeImageV];
        
        UILabel *teamLd = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        teamLd.text = @"球队队长";
        [self.addressAndTimeImageV addSubview:teamLd];
        
        self.teamLeaderNameLB = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, screenWidth - 80, 30)];
        self.teamLeaderNameLB.text = @"小泽玛丽亚";
        [self.addressAndTimeImageV addSubview:_teamLeaderNameLB];
        
        UILabel *addresL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, screenWidth, 30)];
        addresL.text = @"所在地区";
        [self.addressAndTimeImageV addSubview:addresL];
        
        self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, screenWidth - 80, 30)];
        self.addressLB.text = @"🇯🇵";
        [self.addressAndTimeImageV addSubview:_addressLB];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 34, screenWidth - 20, 2)];
        view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.addressAndTimeImageV addSubview:view];
        
//        UIView *introducBV = [[UIView alloc] initWithFrame:CGRectMake(0, 240, screenWidth, 100)];
//        introducBV.backgroundColor = [UIColor orangeColor];
//        [self addSubview:introducBV];
        
        UILabel *teamIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, screenWidth, 30)];
        teamIntroduction.text = @"球队简介";
        teamIntroduction.backgroundColor = [UIColor whiteColor];
        [self addSubview:teamIntroduction];
        
        self.teamIntroductionLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, screenWidth, 0)];
        self.teamIntroductionLB.numberOfLines = 0;
        self.teamIntroductionLB.backgroundColor = [UIColor whiteColor];
        self.teamIntroductionLB.font = [UIFont systemFontOfSize:15];
        self.teamIntroductionLB.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人，所以我总是意犹未尽地想起你。在每个星光坠落的晚上，一遍一遍，数我的寂寞。火车上的第一个晚上，我沉沉地睡去，梦境中，我看到了13岁的齐铭，眼睛大大的，头发柔软，漂亮得如同女孩子。他孤单地站在站台上，猜着火车，他问我哪列火车可以到北京去，可是我动不了，说不出话，于是他蹲在地上哭了。我想走过去抱着他，可是我却动不了，齐铭望着我，一直哭不肯停。可是我连话都说不出来，我难过得像要死掉了。梦中开过了一列火车，轰隆隆，轰隆隆，碾碎了齐铭的面容，碾碎了我留在齐铭身上的青春，碾碎了那几个明媚的夏天，碾碎了那面白色的墙，碾碎了齐铭那辆帅气的单车，碾碎了他的素描，碾碎了我最后的梦境。";
        [self.teamIntroductionLB sizeToFit];
        [self addSubview:self.teamIntroductionLB];
       
        
        self.buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.teamIntroductionLB.frame.size.height + 280 + 10, screenWidth, 70)];
        self.buttonBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buttonBackView];
        UIView *btnLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 34, screenWidth - 20, 2)];
        btnLineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.buttonBackView addSubview:btnLineView];
        
        NSArray *buttonArray = [NSArray arrayWithObjects:@"球队活动", @"球队相册", nil];
        for (int i = 0; i < 2; i ++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(0, i * 40, screenWidth, 30);
            button.tag = 200 + i;
            button.backgroundColor = [UIColor whiteColor];
//            [button addTarget:self action:@selector(team:) forControlEvents:(UIControlEventTouchUpInside)];
            [button setTitle:buttonArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 300, 0, 0);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [self.buttonBackView addSubview:button];
        }
    }
    
    return self;
}



/*
 
 @property (nonatomic, strong)UIImageView *addressAndTimeImageV;
 @property (nonatomic, strong)UIImageView *teamLeaderIcon;
 @property (nonatomic, strong)UILabel *teamLeaderNameLB;
 @property (nonatomic, strong)UILabel *addressLB;
 @property (nonatomic, strong)UILabel *timeLB;
 
 @property (nonatomic, strong)UILabel *teamIntroductionLB;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
