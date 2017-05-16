//
//  JGHNewCancelAppListCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewCancelAppListCellDelegate <NSObject>

- (void)chooseCancelApplyClick:(UIButton *)chooseBtn;

@end

@interface JGHNewCancelAppListCell : UITableViewCell

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UIButton *chooseBtn;

@property (weak, nonatomic)id <JGHNewCancelAppListCellDelegate>delegate;


- (void)configCancelApplyDict:(NSMutableDictionary *)dict;

@end
