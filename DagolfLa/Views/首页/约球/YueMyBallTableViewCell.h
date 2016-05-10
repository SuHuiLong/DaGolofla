//
//  YueMyBallTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YueHallModel.h"

@interface YueMyBallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *labelField;
@property (weak, nonatomic) IBOutlet UILabel *labelDaaress;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelState;


-(void)showData:(YueHallModel *)model;

@end
