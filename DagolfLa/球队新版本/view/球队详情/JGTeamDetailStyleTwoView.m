//
//  JGTeamDetailStyleTwoView.m
//  DagolfLa
//
//  Created by 東 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamDetailStyleTwoView.h"

@implementation JGTeamDetailStyleTwoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.topBackImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150 * screenWidth / 320)];
        self.topBackImageV.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.topBackImageV];
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 80 * screenWidth / 320, 60 * screenWidth / 320, 60 * screenWidth / 320)];
        self.iconImageV.backgroundColor = [UIColor whiteColor];
        [self.topBackImageV addSubview: self.iconImageV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * screenWidth / 320, 110 * screenWidth / 320, screenWidth - 100 * screenWidth / 320, 30 * screenWidth / 320)];
        self.nameLB.backgroundColor = [UIColor whiteColor];
        [self.topBackImageV addSubview:self.nameLB];
        
        
        self.teamIntroductionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 160 * screenWidth / 320, screenWidth, 0)];
        self.teamIntroductionBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.teamIntroductionBackView];
        
        UILabel *teamIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30 * screenWidth / 320)];
        teamIntroduction.text = @"球队动态";
        teamIntroduction.backgroundColor = [UIColor whiteColor];
        [self.teamIntroductionBackView addSubview:teamIntroduction];
        
        self.teamIntroductionLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 * screenWidth / 320, screenWidth, 0)];
        self.teamIntroductionLB.numberOfLines = 0;
        self.teamIntroductionLB.backgroundColor = [UIColor whiteColor];
        self.teamIntroductionLB.font = [UIFont systemFontOfSize:15];
        [self.teamIntroductionBackView addSubview:self.teamIntroductionLB];
        
        
        self.buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.teamIntroductionLB.frame.size.height + 280 * screenWidth / 320 + 10 * screenWidth / 320, screenWidth, 110 * screenWidth / 320)];
        self.buttonBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buttonBackView];
        
        for (int i = 1 ; i < 3; i ++) {
           
            UIView *btnLineView = [[UIView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, (40 * i - 6) * screenWidth / 320, screenWidth - 20 * screenWidth / 320, 2 * screenWidth / 320)];
            btnLineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
            [self.buttonBackView addSubview:btnLineView];
        }

        
        NSArray *buttonArray = [NSArray arrayWithObjects:@"球队成员", @"球队活动", @"球队相册", nil];
        for (int i = 0; i < 3; i ++) {
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
    
    self.setButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.setButton.frame = CGRectMake(0, self.buttonBackView.frame.origin.y + 120 * screenWidth / 320, screenWidth, 30 * screenWidth / 320);
    self.setButton.backgroundColor = [UIColor whiteColor];
    [self.setButton setTitle:@"个人设置" forState:(UIControlStateNormal)];
    [self.setButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [self.setButton setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
    self.setButton.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
    self.setButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self addSubview:self.setButton];
    
    
    self.applyJoin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.applyJoin.frame = CGRectMake(10 * screenWidth / 320, self.buttonBackView.frame.origin.y + 120 * screenWidth / 320 + 40, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320);
    self.applyJoin.backgroundColor = [UIColor orangeColor];
    [self.applyJoin setTitle:@"邀请好友" forState:(UIControlStateNormal)];
    [self addSubview:self.applyJoin];
    
    return self;
}

- (void)resetUI{
    [self.teamIntroductionLB sizeToFit];
    [self.teamIntroductionBackView setFrame:CGRectMake(0, 160 * screenWidth / 320, screenWidth, self.teamIntroductionLB.frame.size.height + 30 * screenWidth / 320)];
    
    [self.buttonBackView setFrame:CGRectMake(0, self.teamIntroductionBackView.frame.size.height + 170 * screenWidth / 320, screenWidth, 110 * screenWidth / 320)];
    [self.setButton setFrame:CGRectMake(0, self.buttonBackView.frame.origin.y + 120 * screenWidth / 320, screenWidth, 30 * screenWidth / 320)];
    [self.applyJoin setFrame:CGRectMake(10 * screenWidth / 320, self.buttonBackView.frame.origin.y + 120 * screenWidth / 320 + 40, screenWidth - 20 * screenWidth / 320, 30 * screenWidth / 320)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
