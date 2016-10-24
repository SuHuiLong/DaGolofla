//
//  JGHGameBaseHeaderCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHGameBaseHeaderCellDelegate <NSObject>

- (void)didSelectHelpBtn:(UIButton *)btn;

@end

@interface JGHGameBaseHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//10

@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsBtnRight;//25
- (IBAction)detailsBtn:(UIButton *)sender;

@property (weak, nonatomic)id <JGHGameBaseHeaderCellDelegate> delegate;

- (void)configJGHGameBaseHeaderCell:(NSString *)rulesName;

@end
