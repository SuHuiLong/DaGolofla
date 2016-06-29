//
//  JGHTradRecordCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHWithDrawModel;

@interface JGHTradRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *monay;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monayRight;

@property (weak, nonatomic) IBOutlet UILabel *linelabel;

- (void)congifData:(JGHWithDrawModel *)model;

- (void)configJGHWithDrawModelWithDraw:(JGHWithDrawModel *)model;

@end
