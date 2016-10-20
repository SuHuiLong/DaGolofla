//
//  JGHPublicLevelCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/17.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHPublicLevelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeftRight;//10

@property (weak, nonatomic) IBOutlet UIImageView *gouImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouImageViewW;//15


- (void)configJGHPublicLevelCell:(NSString *)titleString andSelect:(NSInteger)select;

- (void)configEditorLevelCell:(NSString *)titleString andSelect:(NSInteger)select;

@end
