//
//  ManageMainTableCell.h
//  DagolfLa
//
//  Created by bhxx on 15/11/19.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
@interface ManageMainTableCell : UITableViewCell




/*
 
 @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
 @property (weak, nonatomic) IBOutlet UILabel *timeLabel;
 @property (weak, nonatomic) IBOutlet UILabel *stateLabel;
 @property (weak, nonatomic) IBOutlet UIButton *setButton;
 @property (weak, nonatomic) IBOutlet UILabel *placeLabel;
 @property (weak, nonatomic) IBOutlet UIImageView *juliImage;
 @property (weak, nonatomic) IBOutlet UILabel *juliLabel;
 @property (weak, nonatomic) IBOutlet UIImageView *jiantouLabel;
 */
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UILabel* stateLabel;
@property (strong, nonatomic) UILabel* placeLabel;
@property (strong, nonatomic) UIImageView* jiantouImgv;
@property (strong, nonatomic) UIImageView* lockImgv;
@property (strong, nonatomic) UIImageView* juliImgv;
@property (strong, nonatomic) UILabel* areaLabel;

@property (strong, nonatomic) UIImageView* imgvSuo;


-(void)showData:(GameModel *)model;

@end
