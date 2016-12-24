//
//  JGHActicityScoreDictCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLChooseScoreModel;

@interface JGHActicityScoreDictCell : UITableViewCell


@property (nonatomic, retain)UIImageView *headerImageView;

@property (nonatomic, retain)UILabel *title;

@property (nonatomic, retain)UILabel *startScore;

@property (nonatomic, retain)UIImageView *directionImageView;

@property (nonatomic, retain)UIImageView *addressImageView;

@property (nonatomic, retain)UILabel *address;

@property (nonatomic, retain)UILabel *time;

@property (nonatomic, retain)UILabel *line;


- (void)configJGLChooseScoreModel:(JGLChooseScoreModel *)model;

@end
