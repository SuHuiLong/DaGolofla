//
//  JGHCabbieAwaredCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHTransDetailListModel;

@interface JGHCabbieAwaredCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *awaredLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awaredLableLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awaredLableTop;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLableLeft;

@property (weak, nonatomic) IBOutlet UILabel *monyLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monyLableRight;

- (void)configJGHTransDetailListModel:(JGHTransDetailListModel *)model;

@end
