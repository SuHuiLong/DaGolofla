//
//  JGHSexCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGHSexCellDelegate <NSObject>

- (void)selectSexBtn:(UIButton *)btn;

@end

@interface JGHSexCell : UITableViewCell

@property (nonatomic, weak)id <JGHSexCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableLeft;//20

@property (weak, nonatomic) IBOutlet UIButton *manBtn;

- (IBAction)manBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manBtnLeft;//40

@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
- (IBAction)womanBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *womanLeft;
//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableW;


- (void)configSex:(NSInteger)sex;

@end
