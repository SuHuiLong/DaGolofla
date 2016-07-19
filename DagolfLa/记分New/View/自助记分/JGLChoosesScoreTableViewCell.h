//
//  JGLChoosesScoreTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLChooseScoreModel.h"
/**
 *  选择记分对象
 */


@interface JGLChoosesScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView*  iconImgv;

@property (strong, nonatomic) UILabel*      labelName;

@property (strong, nonatomic) UILabel*      labelTime;

@property (strong, nonatomic) UIImageView*  distanceImgv;

@property (strong, nonatomic) UILabel*      labelBall;

@property (strong, nonatomic) UIView*       viewLine;


-(void)showData:(JGLChooseScoreModel *)model;

@end
