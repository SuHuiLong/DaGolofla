//
//  JGLPayHeaderTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGTeamAcitivtyModel.h"
@interface JGLPayHeaderTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel* titleLabel;

@property (strong, nonatomic) UILabel* timeLabel;

@property (strong, nonatomic) UIImageView* stateImgv;
//@property (strong, nonatomic) UILabel* stateLabel;

@property (strong, nonatomic) UILabel* peopleLabel;

@property (strong, nonatomic) UILabel* addressLabel;

@property (strong, nonatomic) UIImageView* timeImag;

@property (strong, nonatomic) UIImageView* addressImag;

-(void)showData:(JGTeamAcitivtyModel *)model;

@end
