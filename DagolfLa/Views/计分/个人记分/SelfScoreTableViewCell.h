//
//  SelfScoreTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/8/19.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreView.h"
#import "ScoreProListModel.h"
#import "ScoreProModel.h"
#import "ScoreProStandedModel.h"
@interface SelfScoreTableViewCell : UITableViewCell



@property (strong ,nonatomic) UILabel* labelHole;
@property (strong ,nonatomic) UILabel* labelPar;
@property (strong ,nonatomic) ScoreView* scoreVFirst;
@property (strong ,nonatomic) ScoreView* scoreVSecond;
@property (strong ,nonatomic) ScoreView* scoreVThird;
@property (strong ,nonatomic) ScoreView* scoreVFourth;

@property (strong, nonatomic) UIImageView* imgvStreet1;
@property (strong, nonatomic) UIImageView* imgvStreet2;
@property (strong, nonatomic) UIImageView* imgvStreet3;
@property (strong, nonatomic) UIImageView* imgvStreet4;



//标准杆的数据
-(void)showStanded:(ScoreProStandedModel *)model;
//得分的数据1-- 第一个人的得分
-(void)showScoreData:(ScoreProListModel *)model;
//得分的数据2-- 第二个人的得分
-(void)showScore1Data:(ScoreProListModel *)model;
//得分的数据3-- 第仨个人的得分
-(void)showScore2Data:(ScoreProListModel *)model;
//得分的数据4-- 第四个人的得分
-(void)showScore3Data:(ScoreProListModel *)model;


@end
