//
//  JGHChancelTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHChancelTableViewCellDelegate <NSObject>

- (void)didSelectChancelClick:(UIButton *)btn;

- (void)didSelectChancelMoreClick:(UIButton *)btn;

@end

@interface JGHChancelTableViewCell : UITableViewCell

- (void)configJGHChancelTableViewCellMatchList:(NSArray *)matchList;

@property (weak, nonatomic)id <JGHChancelTableViewCellDelegate> delegate;

@end
