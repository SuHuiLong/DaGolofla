//
//  JGLPlayerNumberTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGLPlayerNumberTableViewCellDelegate <NSObject>

- (void)didSelectDeleteBtn:(UIButton *)btn;

@end

@interface JGLPlayerNumberTableViewCell : UITableViewCell


@property (strong, nonatomic) UILabel* labelTitle;

@property (strong, nonatomic) UILabel* labelName;


@property (strong, nonatomic) UIButton *deleteBtn;

@property (nonatomic, weak)id <JGLPlayerNumberTableViewCellDelegate> delegate;


@end
