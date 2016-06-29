//
//  JGHTradRecordImageCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLBankModel;

@interface JGHTradRecordImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titles;

@property (weak, nonatomic) IBOutlet UILabel *values;

@property (weak, nonatomic) IBOutlet UIImageView *blankImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeft;

- (void)configJGLBankModel:(JGLBankModel *)model;


@end
