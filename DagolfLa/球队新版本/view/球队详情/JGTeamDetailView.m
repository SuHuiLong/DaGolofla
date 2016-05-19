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
        
        self.topBackImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150 * screenWidth / 320)];
        self.topBackImageV.image = [UIImage imageNamed:@"jianbian"];
        self.topBackImageV.userInteractionEnabled = YES;
        [self addSubview:self.topBackImageV];
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 80 * screenWidth / 320, 60 * screenWidth / 320, 60 * screenWidth / 320)];
        self.iconImageV.backgroundColor = [UIColor whiteColor];
        [self.topBackImageV addSubview: self.iconImageV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * screenWidth / 320, 110 * screenWidth / 320, screenWidth - 100 * screenWidth / 320, 30 * screenWidth / 320)];
        self.nameLB.backgroundColor = [UIColor whiteColor];
        [self.topBackImageV addSubview:self.nameLB];
        
        self.addressAndTimeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 160 * screenWidth / 320, screenWidth, 70 * screenWidth / 320)];
        self.addressAndTimeImageV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.addressAndTimeImageV];
        
        UILabel *teamLd = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80 * screenWidth / 320, 30 * screenWidth / 320)];
        teamLd.text = @"球队队长";
        teamLd.textColor = [UIColor lightGrayColor];
        [self.addressAndTimeImageV addSubview:teamLd];
        
        self.teamLeaderNameLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * screenWidth / 320, 0, 100 * screenWidth / 320, 30 * screenWidth / 320)];
//        self.teamLeaderNameLB.text = @"小泽玛丽亚";
        [self.addressAndTimeImageV addSubview:_teamLeaderNameLB];
        
        self.leaderIconV = [[UIImageView alloc] initWithFrame:CGRectMake(200 * screenWidth / 320, 2 * screenWidth / 320, 28 * screenWidth / 320, 28 * screenWidth / 320)];
        self.leaderIconV.image = [UIImage imageNamed:@"tu1"];
        self.leaderIconV.layer.cornerRadius = 14 * screenWidth / 320;
        self.leaderIconV.clipsToBounds = YES;
        [self.addressAndTimeImageV addSubview:self.leaderIconV];
        
        UILabel *addresL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
        addresL.text = @"所在地区";
        addresL.textColor = [UIColor lightGrayColor];
        [self.addressAndTimeImageV addSubview:addresL];
        
        self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * screenWidth / 320, 40 * screenWidth / 320, screenWidth / 2 - 80 * screenWidth / 320, 30 * screenWidth / 320)];
        self.addressLB.font = [UIFont systemFontOfSize:13 * screenWidth / 320];
//        self.addressLB.text = @"🇯🇵";
        [self.addressAndTimeImageV addSubview:_addressLB];
        
        UILabel *setUpLB = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 2, 40 * screenWidth / 320, 70 * screenWidth / 320, 30 * screenWidth / 320)];
        setUpLB.text = @"成立时间";
        setUpLB.textColor = [UIColor lightGrayColor];
        [self.addressAndTimeImageV addSubview:setUpLB];
        
        self.setUpLbalel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 2 + 70 * screenWidth / 320, 40 * screenWidth / 320, screenWidth / 2 - 70 * screenWidth / 320, 30 * screenWidth / 320)];
//        self.setUpLbalel.text = @"2016/02/16";
        self.setUpLbalel.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self.addressAndTimeImageV addSubview:self.setUpLbalel];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 34 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 2 * screenWidth / 320)];
        view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.addressAndTimeImageV addSubview:view];
        
        self.teamIntroductionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 240 * screenWidth / 320, screenWidth, 0)];
        self.teamIntroductionBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.teamIntroductionBackView];
        
        UILabel *teamIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30 * screenWidth / 320)];
        teamIntroduction.text = @"球队简介";
        teamIntroduction.backgroundColor = [UIColor whiteColor];
        [self.teamIntroductionBackView addSubview:teamIntroduction];
        
        self.teamIntroductionLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 * screenWidth / 320, screenWidth, 0)];
        self.teamIntroductionLB.numberOfLines = 0;
        self.teamIntroductionLB.backgroundColor = [UIColor whiteColor];
        self.teamIntroductionLB.font = [UIFont systemFontOfSize:15];
        [self.teamIntroductionBackView addSubview:self.teamIntroductionLB];
       
        
        self.buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.teamIntroductionLB.frame.size.height + 280 * screenWidth / 320 + 10 * screenWidth / 320, screenWidth, 70 * screenWidth / 320)];
        self.buttonBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buttonBackView];
        UIView *btnLineView = [[UIView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 34 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 2 * screenWidth / 320)];
        btnLineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.buttonBackView addSubview:btnLineView];
        
        NSArray *buttonArray = [NSArray arrayWithObjects:@"球队活动", @"球队相册", nil];
        for (int i = 0; i < 2; i ++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(0, i * 40 * screenWidth / 320, screenWidth, 30 * screenWidth / 320);
            button.tag = 200 + i;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:buttonArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [self.buttonBackView addSubview:button];
        }
    }
    
    self.applyJoin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.applyJoin.frame = CGRectMake(10 * screenWidth / 320, self.teamIntroductionLB.frame.size.height + 280 * screenWidth / 320 + 90 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320);
    self.applyJoin.backgroundColor = [UIColor orangeColor];
//    [self.applyJoin setTitle:@"申请加入" forState:(UIControlStateNormal)];
    [self.applyJoin setTitle:@"保存" forState:(UIControlStateNormal)];
    [self addSubview:self.applyJoin];
    
    self.applyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.applyBtn.frame = CGRectMake(10 * screenWidth / 320, self.teamIntroductionLB.frame.size.height + 280 * screenWidth / 320 + 130 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320);
    self.applyBtn.backgroundColor = [UIColor orangeColor];
    [self.applyBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [self addSubview:self.applyBtn];
    
    
    return self;
}

- (void)resetUI{
    [self.teamIntroductionLB sizeToFit];
    [self.teamIntroductionBackView setFrame:CGRectMake(0, 240 * screenWidth / 320, screenWidth, self.teamIntroductionLB.frame.size.height + 30 * screenWidth / 320)];

    [self.buttonBackView setFrame:CGRectMake(0, self.teamIntroductionBackView.frame.size.height + 250 * screenWidth / 320, screenWidth, 70 * screenWidth / 320)];
    
    [self.applyJoin setFrame:CGRectMake(10 * screenWidth / 320, self.buttonBackView.frame.origin.y + 80 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320)];
    [self.applyBtn setFrame:CGRectMake(10 * screenWidth / 320, self.buttonBackView.frame.origin.y + 120 * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320)];

}

- (void)setTeamDetailModel:(JGTeamDetail *)teamDetailModel{
    self.nameLB.text = teamDetailModel.name;
    self.teamIntroductionLB.text = teamDetailModel.info;
    self.addressLB.text = teamDetailModel.crtyName;
    self.setUpLbalel.text = [Helper dateConversionToString:teamDetailModel.establishTime];

    
    
    // 时间
//    NSDate *dateNew = [NSDate dateWithTimeIntervalSince1970:teamDetailModel.establishTime];
//    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
//    [dm setDateFormat:@"yyyy-MM-dd"];
//    NSString * datestring2 = [dm stringFromDate:dateNew];
//    self.setUpLbalel.text = datestring2;

    /*
     @property (nonatomic, strong)UIImageView *iconImageV;
     @property (nonatomic, strong)UIImageView *teamLeaderIcon;
     @property (nonatomic, strong)UILabel *teamLeaderNameLB;
     @property (nonatomic, strong)UIButton *applyJoin;// 申请加入
     @property (nonatomic, strong)UIImageView *leaderIconV;  // 队长头像
     @property (nonatomic, strong)UILabel *setUpLbalel; // 成立时间
     */
}
/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
