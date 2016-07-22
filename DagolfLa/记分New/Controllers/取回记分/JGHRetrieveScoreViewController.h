//
//  JGHRetrieveScoreViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHRetrieveScoreViewController : ViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;//10


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyRight;//10

@property (weak, nonatomic) IBOutlet UITextField *failKey;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *failKeyTop;//25

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBtnTop;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBtnDwon;//15

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmtLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmtTop;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmtRight;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propmtDown;//10
@property (weak, nonatomic) IBOutlet UILabel *propmtLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noViewLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noViewRight;//10
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noViewDown;//10

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noDataLabelTop;//8
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noDataLabelDown;//10


@property (weak, nonatomic) IBOutlet UIView *noView;

//
@property (weak, nonatomic) IBOutlet UIView *eventView;

@property (weak, nonatomic) IBOutlet UIView *inScoresView;

//赛事名称
@property (weak, nonatomic) IBOutlet UILabel *eventName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventViewTop;//18

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;//8

@property (weak, nonatomic) IBOutlet UILabel *nameAndTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameAndTimeTop;//6

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTop;//6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressDown;//8

@property (weak, nonatomic) IBOutlet UIButton *inScoress;
- (IBAction)inScoressBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inScoressBtnTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inScoressBtnDwon;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inScoressViewTop;//10

@end
