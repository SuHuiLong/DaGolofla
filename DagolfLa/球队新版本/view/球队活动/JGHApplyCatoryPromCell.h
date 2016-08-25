//
//  JGHApplyCatoryPromCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHApplyCatoryPromCellDelegate <NSObject>

- (void)ApplyCatoryPromCellCommitBtn:(UIButton *)btn;

@end

@interface JGHApplyCatoryPromCell : UITableViewCell

@property (nonatomic, weak)id <JGHApplyCatoryPromCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//10

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBtnTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBtnRight;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBtnDown;//10

- (IBAction)commitBtn:(UIButton *)sender;

@end
