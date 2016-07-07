//
//  JGHActivityBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@interface JGHActivityBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityimageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityimageViewLeft;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeDown;

@property (weak, nonatomic) IBOutlet UILabel *timevlaue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timevalueLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeft;
@property (weak, nonatomic) IBOutlet UILabel *addressVlaue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressVlaueLeft;


- (void)configJGTeamActivityModel:(JGTeamAcitivtyModel *)model;

@end
