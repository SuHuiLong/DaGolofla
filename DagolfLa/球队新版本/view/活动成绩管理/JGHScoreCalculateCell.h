//
//  JGHScoreCalculateCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHScoreCalculateCellDelegate <NSObject>

- (void)selectAddOperationBtn;

- (void)selectRedOperationBtn;

- (void)selectScoreListBtn;

@end

@interface JGHScoreCalculateCell : UITableViewCell

@property (nonatomic, weak)id <JGHScoreCalculateCellDelegate> delegate;

@end
