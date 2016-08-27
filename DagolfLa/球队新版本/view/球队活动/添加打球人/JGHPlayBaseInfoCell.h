//
//  JGHPlayBaseInfoCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHPlayBaseInfoCellDelegate <NSObject>

- (void)selectManBtn:(UIButton *)btn;

- (void)selectWoManBtn:(UIButton *)btn;

@end

@interface JGHPlayBaseInfoCell : UITableViewCell

@property (weak, nonatomic)id <JGHPlayBaseInfoCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;//16
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameW;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTextLeft;//10

@property (weak, nonatomic) IBOutlet UILabel *almost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostTop;//30

@property (weak, nonatomic) IBOutlet UITextField *almostFext;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *almostFextLeft;//10

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumberLeft;//40

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumberTextLeft;//10


@property (weak, nonatomic) IBOutlet UILabel *man;
- (IBAction)manBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;

@property (weak, nonatomic) IBOutlet UILabel *woman;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *womanLeft;//20

- (IBAction)womanBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

- (void)configJGHPlayBaseInfoCell:(NSMutableDictionary *)dict;

@end
