//
//  JGHWonderfulTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHWonderfulTableViewCellDelegate <NSObject>

- (void)wonderfulSelectClick:(UIButton *)btn;

@end

@interface JGHWonderfulTableViewCell : UITableViewCell

@property (weak, nonatomic)id <JGHWonderfulTableViewCellDelegate> delegate;

- (void)configJGHWonderfulTableViewCell:(NSArray *)wonderfulArray;

@end
