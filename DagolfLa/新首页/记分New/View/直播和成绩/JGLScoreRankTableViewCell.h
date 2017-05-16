//
//  JGLScoreRankTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLScoreRankModel.h"
@interface JGLScoreRankTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* labelRank;//排名

@property (strong, nonatomic) UILabel* labelName;

@property (strong, nonatomic) UILabel* labelAll;//总杆

@property (strong, nonatomic) UILabel* labelAlmost;//差点

@property (strong, nonatomic) UILabel* labelTee;//净杆

-(void)showData:(JGLScoreRankModel* )model;

@end
