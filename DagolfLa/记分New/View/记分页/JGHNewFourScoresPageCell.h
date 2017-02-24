//
//  JGHNewFourScoresPageCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/23.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHScoreListModel;

@protocol JGHNewFourScoresPageCellDelegate <NSObject>

- (void)selectUpperTrackBtnClick:(UIButton *)btn andCellTage:(NSInteger)cellTag;//上球道

- (void)selectUpperTrackNoBtnClick:(UIButton *)btn andCellTage:(NSInteger)cellTag;//未上球道

- (void)selectReduntionScoresBtnClicK:(UIButton *)btn andCellTage:(NSInteger)cellTag;//减

- (void)selectAddScoresBtnClick:(UIButton *)btn andCellTage:(NSInteger)cellTag;//加

@end

@interface JGHNewFourScoresPageCell : UITableViewCell

@property (nonatomic, weak)id <JGHNewFourScoresPageCellDelegate> delegate;

@property (nonatomic, strong)UILabel *userName;

@property (nonatomic, strong)UILabel *fairway;

@property (nonatomic, strong)UILabel *totalName;

@property (nonatomic, strong)UILabel *totalPoleValue;//总杆值

@property (nonatomic, strong)UILabel *totalPushValue;//总推杆

@property (nonatomic, strong)UIButton *upperTrackBtn;//是

@property (nonatomic, strong)UIButton *upperTrackNoBtn;//否

@property (nonatomic, strong)UILabel *poleValue;//杆数
@property (nonatomic, strong)UILabel *poleValueLabel;

@property (nonatomic, strong)UIButton *reduntionScoresBtn;//-杆数
@property (nonatomic, strong)UIButton *addScoresBtn;//+杆数

@property (nonatomic, strong)UILabel *pushPoleValue;//推杆
@property (nonatomic, strong)UILabel *pushPoleLable;

@property (nonatomic, strong)UIButton *downReduntionScoresBtn;//-推杆
@property (nonatomic, strong)UIButton *downAddScoresBtn;//+推杆

- (void)configJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index;

- (void)configPoorJGHScoreListModel:(JGHScoreListModel *)model andIndex:(NSInteger)index;


@end
