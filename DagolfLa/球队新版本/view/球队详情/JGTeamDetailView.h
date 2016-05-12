//
//  JGTeamDetailView.h
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGTeamDetailView : UIScrollView

@property (nonatomic, strong)UIImageView *topBackImageV;
@property (nonatomic, strong)UIImageView *iconImageV;
@property (nonatomic, strong)UILabel *nameLB;
@property (nonatomic, strong)UIImageView *addressAndTimeImageV;
@property (nonatomic, strong)UIImageView *teamLeaderIcon;
@property (nonatomic, strong)UILabel *teamLeaderNameLB;
@property (nonatomic, strong)UILabel *addressLB;
@property (nonatomic, strong)UILabel *teamIntroductionLB;
@property (nonatomic, strong)UIView *buttonBackView;
@property (nonatomic, strong)UIView *teamIntroductionBackView;
@property (nonatomic, strong)UIButton *applyJoin;// 申请加入
@property (nonatomic, strong)UIImageView *leaderIconV;  // 队长头像
@property (nonatomic, strong)UILabel *setUpLbalel; // 成立时间
//@property (nonatomic, strong)UILabel *timeLB;

- (void)resetUI;

@end
