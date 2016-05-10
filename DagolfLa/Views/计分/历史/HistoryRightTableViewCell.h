//
//  HistoryRightTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/12/2.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCardModel.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface HistoryRightTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView* baseView;
@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UILabel* areaLabel;
@property (strong, nonatomic) UILabel* stateLabel;

@property (strong, nonatomic) UIView* viewShu;
@property (strong, nonatomic) UIView* viewHen;

-(void)showData:(ScoreCardModel *)model;


@end
