//
//  JGLWinnersShareTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLWinnerShareModel.h"
@interface JGLWinnersShareTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel* titleLabel;

@property (strong, nonatomic) UILabel* nameLabel;

-(void)showData:(JGLWinnerShareModel *)model;

@end
