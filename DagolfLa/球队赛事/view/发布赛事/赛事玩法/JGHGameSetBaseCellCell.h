//
//  JGHGameSetBaseCellCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHGameSetBaseCellCellDelegate <NSObject>

- (void)didSelectGameSetBtn:(UIButton *)setBtn;

@end

@interface JGHGameSetBaseCellCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ruleName;//14
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ruleNameLeft;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ruleNameRight;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ruleNameW;//80

@property (weak, nonatomic) IBOutlet UILabel *ruleContectLable;//28

@property (weak, nonatomic) IBOutlet UIButton *rulesSetBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulesSetBtnRight;//10

@property (weak, nonatomic)id <JGHGameSetBaseCellCellDelegate> delegate;

- (IBAction)rulesSetBtn:(UIButton *)sender;

- (void)configJGHGameSetBaseCellCell:(NSDictionary *)dict;

- (void)configJGHGameSetBaseCellCellContext:(NSDictionary *)dict;


@end
