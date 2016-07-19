//
//  JGHScoresPageCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHScoresPageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPoleLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPoleRight;//10
@property (weak, nonatomic) IBOutlet UILabel *totalPole;

@property (weak, nonatomic) IBOutlet UILabel *totalPoleValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodTop;//23
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodtoTotalPoleTop;//-4

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameDown;//23
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upperTrackDown;//8

@property (weak, nonatomic) IBOutlet UIButton *upperTrackBtn;
- (IBAction)upperTrackBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *upperTrackNoBtn;
- (IBAction)upperTrackNoBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *poleValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poleTop;//2

@property (weak, nonatomic) IBOutlet UILabel *pushPoleValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushPoleValueRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushPoleTop;//2
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onballRight;

@property (weak, nonatomic) IBOutlet UIButton *reduntionScoresBtn;
- (IBAction)reduntionScoresBtnClicK:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *addScoresBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addScoresBtnRight;

- (IBAction)addScoresBtnClick:(UIButton *)sender;


@end
