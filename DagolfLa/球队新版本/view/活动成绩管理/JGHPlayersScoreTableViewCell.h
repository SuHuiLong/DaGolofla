//
//  JGHPlayersScoreTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLScoreLiveModel.h"

@protocol JGHPlayersScoreTableViewCellDelegate <NSObject>

- (void)selectMembers:(UIButton *)btn;

@end

@interface JGHPlayersScoreTableViewCell : UITableViewCell

@property (nonatomic, weak)id <JGHPlayersScoreTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageScore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScoreLeft;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScoreRight;//30

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScoreWith;//18

@property (weak, nonatomic) IBOutlet UILabel *fristLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;

-(void)showData:(JGLScoreLiveModel *)model;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;


@end
