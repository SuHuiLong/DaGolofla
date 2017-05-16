//
//  JGHSetBallBaseCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHSetBallBaseCellDelegate <NSObject>

//- (void)oneAndNineBtn;
//
//- (void)twoAndNineBtn;

- (void)startScoreBtn;

- (void)returnAreaArray:(NSArray *)areaArray andAreaId:(NSInteger)areaId;

@end

@interface JGHSetBallBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLineLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLineRigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twolineLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twolineRight;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twolineDown;//15


@property (weak, nonatomic) IBOutlet UITableView *setBallAreaTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setBallAreaTableViewTop;//16
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setBallAreaTableViewLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setBallAreaTableViewDown;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setBallAreaTableViewRight;//20


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBtnDown;//15
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)startBtnClick:(UIButton *)sender;

//- (void)configRegist1:(NSInteger)regist1 andRegist2:(NSInteger)regist2;

- (void)configViewBallName:(NSString *)ballName andLoginpic:(NSString *)loginpic;

- (void)configJGHSetBallBaseCellArea:(NSArray *)areaArray;

@property (nonatomic, strong)NSArray *areaArray;



@end
