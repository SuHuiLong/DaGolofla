//
//  JGHOperationScoreCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHOperationScoreCellDelegate <NSObject>

- (void)addOperationBtn:(UIButton *)btn;

- (void)redOperationBtn:(UIButton *)btn;

- (void)scoreListBtn;

@end

@interface JGHOperationScoreCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


@property (nonatomic, weak)id <JGHOperationScoreCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holeNameTop;//65
@property (weak, nonatomic) IBOutlet UILabel *holeName;

@property (weak, nonatomic) IBOutlet UILabel *pushNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushNumberLeft;//35

@property (weak, nonatomic) IBOutlet UILabel *pushScore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushScoreTop;//50

@property (weak, nonatomic) IBOutlet UIButton *addScoreBtn;
- (IBAction)addScoreBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addScoreBtnRight;//35

@property (weak, nonatomic) IBOutlet UIButton *redScoreBtn;
- (IBAction)redScoreBtnClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *scoreListBtn;
- (IBAction)scoreListBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreListBtnTop;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreListBtnRight;//30

@property (weak, nonatomic) IBOutlet UILabel *propmLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmLabelLeft;//15

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmLabelRight;//15

- (void)configStandPar:(NSInteger)par andHole:(NSInteger)hole andPole:(NSInteger)pole;

@property (weak, nonatomic) IBOutlet UIImageView *sildLeft;

@property (weak, nonatomic) IBOutlet UIImageView *sildRight;



@end
