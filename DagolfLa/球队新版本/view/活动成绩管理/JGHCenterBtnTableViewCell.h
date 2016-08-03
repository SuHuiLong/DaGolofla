//
//  JGHCenterBtnTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHCenterBtnTableViewCellDelegate <NSObject>

- (void)addScoreRecord;

@end

@interface JGHCenterBtnTableViewCell : UITableViewCell

@property (nonatomic, weak)id <JGHCenterBtnTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *collectionPointsBtn;

- (IBAction)collectionPointsBtnClick:(UIButton *)sender;

@end
