//
//  JGHActivityAllCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHActivityAllCellDelegate <NSObject>

- (void)newdidselectActivityClick:(UIButton *)btn;

@end

@interface JGHActivityAllCell : UITableViewCell

@property (nonatomic, retain)UIImageView *headerImageView;

@property (nonatomic, retain)UILabel *name;

@property (nonatomic, retain)UILabel *line;

@property (nonatomic, retain)UIButton *clickBtn;

- (void)configImageName:(NSString *)imageName withName:(NSString *)name;

@property (nonatomic, weak)id <JGHActivityAllCellDelegate> delegate;

@end
