//
//  JGHScoreCalculateCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHScoreCalculateCellDelegate <NSObject>

//- (void)selectAddOperationBtn;
//
//- (void)selectRedOperationBtn;

- (void)selectScoreListBtn:(UIButton *)btn;

@end

@interface JGHScoreCalculateCell : UITableViewCell

@property (nonatomic, weak)id <JGHScoreCalculateCellDelegate> delegate;

@property (nonatomic, strong)NSMutableArray *poleNumberArray;

@property (nonatomic, copy)void (^returnScoresCalculateDataArray)(NSMutableArray *dataArray);

@property (nonatomic, strong)NSMutableArray *parArray;

@property (nonatomic, assign)NSInteger holeId;

@property (nonatomic, strong)NSString *ballName;//球场名称

@property (nonatomic, strong)NSString *loginpic;//图片路径

@end
