//
//  YueHallTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YueHallModel.h"

#import "YuePeopleModel.h"

@interface YueHallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *parkImage;
@property (weak, nonatomic) IBOutlet UILabel *clupLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (weak, nonatomic) IBOutlet UIView *viewLine;


@property (strong, nonatomic) NSMutableArray* IconAgreeArr;
@property (strong, nonatomic) NSNumber* ballId;

@property (strong, nonatomic) NSMutableDictionary* dict, * aboutDict;
@property (strong, nonatomic) YueHallModel* selfModel;
-(void)showYueData:(YueHallModel *)model;
@end
