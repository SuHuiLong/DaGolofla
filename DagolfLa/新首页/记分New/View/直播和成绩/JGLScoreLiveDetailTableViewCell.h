//
//  JGLScoreLiveDetailTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLScoreLiveModel.h"
@interface JGLScoreLiveDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* labelName;

@property (strong, nonatomic) UILabel* labelScoreName;

@property (strong, nonatomic) UILabel* labelFinish;

@property (strong, nonatomic) UILabel* labelPole;

@property (strong, nonatomic) UILabel* labelAlmost;

@property (strong, nonatomic) UIView* viewCut;

-(void)showData:(JGLScoreLiveModel *)model;


@end
