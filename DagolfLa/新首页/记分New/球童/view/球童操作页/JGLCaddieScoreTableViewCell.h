//
//  JGLCaddieScoreTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLCaddieModel.h"
@interface JGLCaddieScoreTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *checkBtn;


-(void)showData:(JGLCaddieModel *)model;

@end
