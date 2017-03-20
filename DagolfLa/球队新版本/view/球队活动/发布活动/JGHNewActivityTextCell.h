//
//  JGHNewActivityTextCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHNewActivityTextCell : UITableViewCell

@property (nonatomic, strong)UIImageView *iconImageView;

@property (nonatomic, strong)UILabel *titleLable;

@property (nonatomic, strong)UITextField *contentText;

@property (nonatomic, strong)UILabel *line;

- (void)configJGHNewActivityTextCellTitle:(NSString *)title andImageName:(NSString *)imageName andContent:(NSString *)content;

@end
