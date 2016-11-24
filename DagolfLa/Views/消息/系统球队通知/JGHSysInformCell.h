//
//  JGHSysInformCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHInformModel;

@interface JGHSysInformCell : UITableViewCell

//@property (nonatomic, retain)UIImageView *selectImageView;

//@property (nonatomic, retain)UILabel *read;

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UILabel *time;

@property (nonatomic, retain)UILabel *detail;

- (void)configJGHSysInformCell:(JGHInformModel *)model;

@end
