//
//  JGHEventRulesContentCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGHEventRulesContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//14
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableW;//90

@property (weak, nonatomic) IBOutlet UILabel *contentLable;//13
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableLeft;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLableRight;//10

- (void)configJGHEventRulesContentCellTitle:(NSString *)title;

- (void)configJGHEventRulesContentCellContext:(NSString *)context;

@end
