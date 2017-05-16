//
//  JGHNewApplyerHeaderCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewApplyerHeaderCellDelegate <NSObject>

- (void)selectAddContactPlays:(UIButton *)btn;//添加联系人

@end

@interface JGHNewApplyerHeaderCell : UITableViewCell

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UILabel *line;

@property (nonatomic, retain)UIButton *contactBtn;

@property (weak, nonatomic)id <JGHNewApplyerHeaderCellDelegate> delegate;

@end
