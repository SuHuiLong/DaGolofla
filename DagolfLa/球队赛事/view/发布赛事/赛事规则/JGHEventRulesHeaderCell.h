//
//  JGHEventRulesHeaderCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHEventRulesHeaderCellDelegate <NSObject>

- (void)didSelectSaveOrDeleteBtn:(UIButton *)btn;

@end

@interface JGHEventRulesHeaderCell : UITableViewCell

@property (weak, nonatomic)id <JGHEventRulesHeaderCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *saveAndDeleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveAndDeleteBtnRight;
- (IBAction)saveAndDeleteBtn:(UIButton *)sender;

- (void)configJGHEventRulesHeaderCell:(NSInteger)roundId andSelect:(NSInteger)select;


@end
