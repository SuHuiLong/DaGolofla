//
//  JGHNewApplyPepoleCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewApplyPepoleCellDelegate <NSObject>

- (void)addApplyerBtn:(UIButton *)addApplyBtn;

@end

@interface JGHNewApplyPepoleCell : UITableViewCell

@property (nonatomic, retain)UIImageView *headerImageView;

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UIButton *addApplyBtn;

@property (weak, nonatomic)id <JGHNewApplyPepoleCellDelegate> delegate;

@end
