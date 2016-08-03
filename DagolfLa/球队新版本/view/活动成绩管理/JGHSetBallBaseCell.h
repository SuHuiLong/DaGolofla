//
//  JGHSetBallBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHSetBallBaseCellDelegate <NSObject>

- (void)oneAndNineBtn;

- (void)twoAndNineBtn;

- (void)startScoreBtn;

@end

@interface JGHSetBallBaseCell : UITableViewCell

@property (nonatomic, weak)id <JGHSetBallBaseCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTop;//5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgRight;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewTop;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewLeft;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewWith;//40

@property (weak, nonatomic) IBOutlet UILabel *ballName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballNameLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineRight;//30

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
- (IBAction)oneBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneBtnTop;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneBtnLeft;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneBtnRight;//30

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
- (IBAction)twoBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)startBtnClick:(UIButton *)sender;

- (void)configRegist1:(NSString *)regist1 andRegist2:(NSString *)regist2;

@end
