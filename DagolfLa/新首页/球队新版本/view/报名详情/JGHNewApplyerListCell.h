//
//  JGHNewApplyerListCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHNewApplyerListCellDelegate <NSObject>

- (void)selectApplyDeleteBtn:(UIButton *)btn;

@end

@interface JGHNewApplyerListCell : UITableViewCell

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UIButton *deleteApplyBtn;

@property (weak, nonatomic)id <JGHNewApplyerListCellDelegate> delegate;


- (void)configDict:(NSDictionary *)dict;


@end
