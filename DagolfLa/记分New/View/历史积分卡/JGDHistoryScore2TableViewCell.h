//
//  JGDHistoryScore2TableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGDHistoryScoreModel.h"

@interface JGDHistoryScore2TableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIImageView *imageLB;

@property (nonatomic, strong) UILabel *numberLB;

@property (nonatomic, strong) UIImageView *lineLimageV;

@property (nonatomic, strong) JGDHistoryScoreModel *model;

@end
