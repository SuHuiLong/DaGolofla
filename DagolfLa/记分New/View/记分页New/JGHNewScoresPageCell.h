//
//  JGHNewScoresPageCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/6.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHScoreListModel;

@protocol JGHNewScoresPageCellDelegate <NSObject>

- (void)didTotalFairway:(UIButton *)btn andCellTage:(NSInteger)cellTag;//上球道

- (void)didTotalNOFairway:(UIButton *)btn andCellTage:(NSInteger)cellTag;//未上球道

- (void)didTotalAddPoleNumber:(UIButton *)btn andCellTage:(NSInteger)cellTag;//+ 杆数

- (void)didTotalRedPoleNumber:(UIButton *)btn andCellTage:(NSInteger)cellTag;//- 杆数

- (void)didTotalAddPushRod:(UIButton *)btn andCellTage:(NSInteger)cellTag;//+ 推杆

- (void)didTotalRedPushRod:(UIButton *)btn andCellTage:(NSInteger)cellTag;//- 推杆

@end

@interface JGHNewScoresPageCell : UITableViewCell

@property (weak, nonatomic)id <JGHNewScoresPageCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;//17
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameDown;//16

@property (weak, nonatomic) IBOutlet UILabel *scoreCatoryLable;//22
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreCatoryLableRight;//27

@property (weak, nonatomic) IBOutlet UILabel *pushRodLabel;//17
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushRodLabelRight;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushRodLabelLeft;//7

@property (weak, nonatomic) IBOutlet UILabel *totalRodLabel;//35

@property (weak, nonatomic) IBOutlet UILabel *fairwayLabel;//18
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fairwayLabelLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fairwayLabelTop;//20

@property (weak, nonatomic) IBOutlet UIButton *fairwayBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fairwayBtnTop;//25
- (IBAction)fairwayBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fairwayBtnH;


@property (weak, nonatomic) IBOutlet UIButton *noFairwayBtn;
- (IBAction)noFairwayBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *pushNumber;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushNumberTop;//16

@property (weak, nonatomic) IBOutlet UILabel *pushNumberProLabel;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushNumberProLabelTop;//10

@property (weak, nonatomic) IBOutlet UILabel *rodNumber;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodNumberTop;//41
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodNumberW;//60


@property (weak, nonatomic) IBOutlet UILabel *rodNumberProLable;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodNumberProLableTop;//10

@property (weak, nonatomic) IBOutlet UIButton *pushAddBtn;
- (IBAction)pushAddBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushAddBtnRight;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushAddBtnTop;//22

@property (weak, nonatomic) IBOutlet UIButton *pushRedBtn;
- (IBAction)pushRedBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushRedBtnLeft;//16

@property (weak, nonatomic) IBOutlet UIButton *rodAddBtn;
- (IBAction)rodAddBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodAddBtnRight;//20

@property (weak, nonatomic) IBOutlet UIButton *rodRedBtn;
- (IBAction)rodRedBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodRedBtnLeft;//16
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodRedBtnW;//60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rodAddBtnTop;//48



- (void)configJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index;

- (void)configPoorJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index;


- (void)configTotalPoleViewTitle;

- (void)configPoleViewTitle;

@end
