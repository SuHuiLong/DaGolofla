//
//  JGHLableAndGouCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHBallAreaModel;

@interface JGHLableAndGouCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//42


@property (weak, nonatomic) IBOutlet UIImageView *gouImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouImageViewRight;//40


//- (void)configImageGouRegist1:(NSInteger)regist1 andRegist2:(NSInteger)regist2;

- (void)configJGHBallAreaModel:(JGHBallAreaModel *)model;

@end
