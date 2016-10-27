//
//  JGHShowRecomStadiumTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHShowRecomStadiumTableViewCellDelegate <NSObject>

- (void)recomStadiumSelectClick:(UIButton *)btn;

@end

@interface JGHShowRecomStadiumTableViewCell : UITableViewCell

@property (weak, nonatomic)id <JGHShowRecomStadiumTableViewCellDelegate> delegate;

- (void)configJGHShowRecomStadiumTableViewCell:(NSArray *)array;

@end
