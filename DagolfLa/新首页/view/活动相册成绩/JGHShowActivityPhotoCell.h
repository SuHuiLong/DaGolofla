//
//  JGHShowActivityPhotoCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHShowActivityPhotoCellDelegate <NSObject>

- (void)activityListSelectClick:(UIButton *)btn;

@end

@interface JGHShowActivityPhotoCell : UITableViewCell

@property (weak, nonatomic)id <JGHShowActivityPhotoCellDelegate> delegate;

@property (nonatomic, strong)UIImageView *headerImageView;

- (void)configJGHShowActivityPhotoCell:(NSArray *)activtiyList;

- (void)configJGHShowLiveCell:(NSArray *)activtiyList;

@end
